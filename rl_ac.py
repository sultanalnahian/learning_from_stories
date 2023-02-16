import torch
import torch.nn as nn
import torch.nn.functional as F
# from torch import optim

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
class ActorCritic(nn.Module):

    eps = 0.01

    def __init__(self, input_size, hidden_size):
        super(ActorCritic, self).__init__()
        torch.manual_seed(42)  # For reproducibility
        self.embedding = nn.Embedding(input_size, hidden_size)
        self.encoder_gru = nn.GRU(hidden_size, hidden_size)
        self.cmd_encoder_gru = nn.GRU(hidden_size, hidden_size)
        self.state_gru = nn.GRU(hidden_size, hidden_size)

        self.linear_1 = nn.Linear(2 * hidden_size, 2 * hidden_size)
        self.critic = nn.Linear(hidden_size, 1)
        self.actor = nn.Linear(hidden_size * 2, 1)

        # Parameters
        self.state_hidden = torch.zeros(1, 1, hidden_size, device=device)
        self.hidden_size = hidden_size
        self.eps = 0.7
        self.total_training_steps = 3000

    def forward(self, obs, commands, mode, method, current_step):
        input_length, batch_size = obs.size(0), obs.size(1)
        nb_cmds = commands.size(1)

        embedded = self.embedding(obs)
        encoder_output, encoder_hidden = self.encoder_gru(embedded)

        state_output, state_hidden = self.state_gru(encoder_hidden, self.state_hidden)
        self.state_hidden = state_hidden
        state_value = self.critic(state_output)

        # Attention network over the commands.
        cmds_embedding = self.embedding.forward(commands)
        _, cmds_encoding_last_states = self.cmd_encoder_gru.forward(cmds_embedding)  # 1*cmds*hidden

        # Same observed state for all commands.
        cmd_selector_input = torch.stack([state_hidden] * nb_cmds, 2)  # 1*batch*cmds*hidden

        # Same command choices for the whole batch.
        cmds_encoding_last_states = torch.stack([cmds_encoding_last_states] * batch_size, 1)  # 1*batch*cmds*hidden

        # Concatenate the observed state and command encodings.
        input_ = torch.cat([cmd_selector_input, cmds_encoding_last_states], dim=-1)

        # One FC layer
        x = F.relu(self.linear_1(input_))

        # Compute state-action value (score) per command.
        action_state = F.relu(self.actor(x)).squeeze(-1)  # 1 x Batch x cmds

        probs = F.softmax(action_state, dim=2)  # 1 x Batch x cmds

        if mode == "train":
            if method == 'random':
                action_index = probs[0].multinomial(num_samples=1).unsqueeze(0)  # 1 x batch x indx
            elif method == 'arg-max':
                action_index = probs[0].max(1).indices.unsqueeze(-1).unsqueeze(-1)  # 1 x batch x indx
            elif method == 'eps-soft':
                index = probs[0].max(1).indices.unsqueeze(-1).unsqueeze(-1)
                p = np.random.random()
                if p < (1 - (self.eps - (self.eps / self.total_training_steps) * current_step)):
                    action_index = index
                else:
                    action_index = torch.randint(0, nb_cmds, (1,)).unsqueeze(-1).unsqueeze(-1)

        elif mode == "test":
            if method == 'random':
                action_index = probs[0].multinomial(num_samples=1).unsqueeze(0)  # 1 x batch x indx
            elif method == 'arg-max':
                action_index = probs[0].max(1).indices.unsqueeze(-1).unsqueeze(-1)  # 1 x batch x indx
            elif method == 'eps-soft':
                index = probs[0].max(1).indices.unsqueeze(-1).unsqueeze(-1)
                p = np.random.random()
                if p < (1 - self.eps + self.eps / nb_cmds):
                    action_index = index
                else:
                    while True:
                        tp = np.random.choice(probs[0][0].detach().numpy())
                        if (probs[0][0] == tp).nonzero().unsqueeze(-1) != index:
                            action_index = (probs[0][0] == tp).nonzero().unsqueeze(-1)
                            break

        return action_state, action_index, state_value

    def reset_hidden(self, batch_size):
        self.state_hidden = torch.zeros(1, batch_size, self.hidden_size, device=device)