import torch
import torch.nn as nn
import torch.nn.functional as F
from torch import optim
from typing import Mapping, Any, Optional
from collections import defaultdict
from textworld import EnvInfos
import numpy as np
import re
from rl_ac import ActorCritic

torch.manual_seed(22)

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
class NeuralAgent:
    """ Simple Neural Agent for playing TextWorld games. """

    MAX_VOCAB_SIZE = 1000
    UPDATE_FREQUENCY = 10
    LOG_FREQUENCY = 1000
    GAMMA = 0.9

    def __init__(self) -> None:
        self.id2word = ["<PAD>", "<UNK>"]
        self.word2id = {w: i for i, w in enumerate(self.id2word)}

        self.model = ActorCritic(input_size=self.MAX_VOCAB_SIZE, hidden_size=128)
        self.optimizer = optim.Adam(self.model.parameters(), 0.00003)

    def train(self):
        self.mode = "train"
        self.method = "random"
        self.transitions = []
        self.last_score = 0
        self.no_train_step = 0
        self.stats = {"max": defaultdict(list), "mean": defaultdict(list)}
        self.memo = {"max": defaultdict(list), "mean": defaultdict(list), "mem": defaultdict(list)}
        self.model.reset_hidden(1)

    def test(self, method):
        self.mode = "test"
        self.method = method
        self.model.reset_hidden(1)

    @property
    def infos_to_request(self) -> EnvInfos:
        return EnvInfos(description=True, inventory=True, admissible_commands=True, won=True, lost=True, facts = True)

    def act(self, obs: str, score: float, nb_moves:int, nb_episode:int, done: bool, infos: Mapping[str, Any]) -> Optional[str]:
        # Build agent's observation: feedback + look + inventory.
        # facts = get_facts(infos)
        input_ = "{}\n{}\n{}".format(obs, infos["description"], infos["inventory"])

        # Tokenize and pad the input and the commands to chose from.
        input_tensor = self._process([input_])
        admissible_commands = infos["admissible_commands"]
        commands_tensor = self._process(admissible_commands)
        #print("admissible_commands: ", admissible_commands)

        # Get our next action and value prediction.
        outputs, indexes, values = self.model(input_tensor, commands_tensor, mode=self.mode, method=self.method, current_step = nb_episode)
        action = admissible_commands[indexes[0]]

        if self.mode == "test":
            if done:
                self.model.reset_hidden(1)
            return action

        self.no_train_step += 1

        if self.transitions:
            reward = score - self.last_score  # Reward is the gain/loss in score.
            self.last_score = score
            if infos["won"]:
                print("won")
                reward += 2
            if infos["lost"]:
                print("lost: ", infos["lost"], infos["won"], done)
                reward -= 2

            self.transitions[-1][0] = reward  # Update reward information.

        self.stats["max"]["score"].append(score)
        self.memo["max"]["score"].append(score)

        if self.no_train_step % self.UPDATE_FREQUENCY == 0:
            # Update model
            returns, advantages = self._discount_rewards(values)

            loss = 0
            for transition, ret, advantage in zip(self.transitions, returns, advantages):
                reward, indexes_, outputs_, values_ = transition

                advantage = advantage.detach()  # Block gradients flow here.
                probs = F.softmax(outputs_, dim=2)
                log_probs = torch.log(probs)
                log_action_probs = log_probs.gather(2, indexes_)
                policy_loss = (log_action_probs * advantage).sum()
                value_loss = ((values_ - ret) ** 2.).sum()
                entropy = (-probs * log_probs).sum()
                loss += 0.5 * value_loss - policy_loss - 0.001 * entropy

                self.memo["mem"]["selected_action_index"].append(indexes_.item())
                self.memo["mem"]["state_val_func"].append(values_.item())
                self.memo["mem"]["advantage"].append(advantage.item())
                self.memo["mem"]["return"].append(ret.item())
                self.memo["mean"]["reward"].append(reward)
                self.memo["mean"]["policy_loss"].append(policy_loss.item())
                self.memo["mean"]["value_loss"].append(value_loss.item())

                self.stats["mean"]["reward"].append(reward)
                self.stats["mean"]["policy_loss"].append(policy_loss.item())
                self.stats["mean"]["value_loss"].append(value_loss.item())
                self.stats["mean"]["entropy"].append(entropy.item())
                self.stats["mean"]["confidence"].append(torch.exp(log_action_probs).item())

            if self.no_train_step % self.LOG_FREQUENCY == 0:
                msg = "{}. ".format(self.no_train_step)
                msg += "  ".join("{}: {:.3f}".format(k, np.mean(v)) for k, v in self.stats["mean"].items())
                msg += "  " + "  ".join("{}: {}".format(k, np.max(v)) for k, v in self.stats["max"].items())
                msg += "  vocab: {}".format(len(self.id2word))
                print(msg)
                self.stats = {"max": defaultdict(list), "mean": defaultdict(list)}

            self.optimizer.zero_grad()
            loss.backward()
            nn.utils.clip_grad_norm(self.model.parameters(), 10)
            self.optimizer.step()
            self.optimizer.zero_grad()

            self.transitions = []
            self.model.reset_hidden(1)
        else:
            # Keep information about transitions for Truncated Backpropagation Through Time.
            self.transitions.append([None, indexes, outputs, values])  # Reward will be set on the next call

        if done:
            self.last_score = 0  # Will be starting a new episode. Reset the last score.

        return action

    def _process(self, texts):
        texts = list(map(self._tokenize, texts))
        max_len = max(len(l) for l in texts)
        padded = np.ones((len(texts), max_len)) * self.word2id["<PAD>"]

        for i, text in enumerate(texts):
            padded[i, :len(text)] = text

        padded_tensor = torch.from_numpy(padded).type(torch.long).to(device)
        padded_tensor = padded_tensor.permute(1, 0)  # Batch x Seq => Seq x Batch
        return padded_tensor

    def _tokenize(self, text):
        # Simple tokenizer: strip out all non-alphabetic characters.
        text = re.sub("[^a-zA-Z0-9\- ]", " ", text)
        word_ids = list(map(self._get_word_id, text.split()))
        return word_ids

    def _get_word_id(self, word):
        if word not in self.word2id:
            if len(self.word2id) >= self.MAX_VOCAB_SIZE:
                return self.word2id["<UNK>"]

            self.id2word.append(word)
            self.word2id[word] = len(self.word2id)

        return self.word2id[word]

    def _discount_rewards(self, last_values):
        returns, advantages = [], []
        R = last_values.data
        for t in reversed(range(len(self.transitions))):
            rewards, _, _, values = self.transitions[t]
            R = rewards + self.GAMMA * R
            adv = R - values
            returns.append(R)
            advantages.append(adv)

        return returns[::-1], advantages[::-1]