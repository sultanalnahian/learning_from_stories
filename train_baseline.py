from os.path import join as pjoin
from time import time
import os
import gym
import textworld.gym
from gg_pretrained import ggModel
import random
from neural_agent import NeuralAgent
import argparse

nutral_command_list = ["wait", "look", "examine", "go north", "go west", "go south", "put", "take", "go east"]
altruism_command_list = []
task_command_list = []
commands_gg_score_map = dict()

def get_command_score(command):
    score = 0
    if command in commands_gg_score_map:
        score = commands_gg_score_map[command]
    else:
        gg_result = gg_model.get_score(command)
        score = gg_result[0][1] - gg_result[0][0]
        commands_gg_score_map[command] = score
    
    return score

def is_nutral_command(command):
    nutral = False
    for n_command in nutral_command_list:
        if n_command in command:
            nutral = True
            break
    return nutral

def is_altruistic_command(command):
    altruistic = False
    for n_command in altruism_command_list:
        if n_command in command:
            altruistic = True
            break
    return altruistic

def is_task_specific_command(command):
    task_cmd = True
    for n_command in task_command_list:
        if n_command in command:
            task_cmd = True
            break
    return task_cmd

def play(phrase_mode, agent, gg_premodel, path, max_step=50, nb_episodes=30, verbose=True):

    infos_to_request = agent.infos_to_request
    infos_to_request.max_score = True  # Needed to normalize the scores.

    gamefiles = [path]
    if os.path.isdir(path):
        gamefiles = glob(os.path.join(path, "*.ulx"))

    env_id = textworld.gym.register_games(gamefiles,
                                          request_infos=infos_to_request,
                                          max_episode_steps=max_step)
    env = gym.make(env_id)  # Create a Gym environment to play the text game.

    if verbose:
        if os.path.isdir(path):
            print(os.path.dirname(path), end="")
        else:
            print(os.path.basename(path), end="")

    # Collect some statistics: nb_steps, final reward.
    avg_moves, avg_scores, avg_norm_scores, seed_h = [], [], [], 4567
    policy_list = [] 
    task_specific_command_list = [0]
    altruistic_command_list = [0]
    no_moves_list = []
    total_no_task_command = 0
    total_no_altruistic_command = 0
    alt_interval = 1
    for no_episode in range(nb_episodes):
        print("episode: ", no_episode)
        obs, infos = env.reset()  # Start new episode.

        env.env.textworld_env._wrapped_env.seed(seed=seed_h)
        seed_h += 1

        score = 0
        gg_score = 0
        done = False
        nb_moves = 0
        actions_list = []
        no_task_command = 0
        no_altruistic_command = 0
        while not done:
            command = agent.act(obs, score, nb_moves, no_episode, done, infos)
            actions_list.append(command)        
            obs, t_score, done, infos = env.step(command)
            _gscore = 0
            if is_nutral_command(command) == False:
                # modified_command = get_description(infos["description"]) + " "+command.strip() +"."
                command = command.strip()
                _gscore = get_command_score(command)
                gg_score = gg_score + _gscore
            score = t_score + gg_score

            print(" no_episode: ",no_episode," steps: ",nb_moves, " command -> ", command, " _gscore: ", _gscore, " gg_score: ", gg_score, " score: ", score, " t_score: ", t_score)
            nb_moves += 1
        agent.act(obs, score, nb_moves, no_episode, done, infos)  # Let the agent know the game is done.
        no_moves_list.append(nb_moves)
        total_no_task_command += no_task_command
        total_no_altruistic_command += no_altruistic_command
        if no_episode%alt_interval == 0:
            task_specific_command_list.append(total_no_task_command)
            altruistic_command_list.append(total_no_altruistic_command)
            total_no_task_command = 0
            total_no_altruistic_command = 0

        if verbose:
            print(".", end="")
        avg_moves.append(nb_moves)
        avg_scores.append(t_score)
        avg_norm_scores.append(t_score / infos["max_score"])
        print("episode_score: ",score)
        print("episode_game_score: ",t_score)
        if agent.mode == "test":
            policy_list.append(actions_list)

    env.close()
    msg = "  \tavg. steps: {:5.1f}; avg. score: {:4.1f} / {}."
    
    if verbose:
        if os.path.isdir(path):
            print(msg.format(np.mean(avg_moves), np.mean(avg_norm_scores), 1))
        else:
            print(avg_scores)
            print(msg.format(np.mean(avg_moves), np.mean(avg_scores), infos["max_score"]))

    return avg_scores, policy_list, task_specific_command_list, altruistic_command_list

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--phrase_group", type=str, default="game_action")
    parser.add_argument("--nb_episodes", type=int, default=2000)
    parser.add_argument("--value_model", type=str, default="pretrained-value-aligned-model/moral-stories")
    parser.add_argument("--game_path", type=str, default="tw_games/stealing_food.ulx")
    parser.add_argument("--step_size", type=int, default=150)
    parser.add_argument("--save_path", type=str, default="./model/baseline.npy")
    
    return parser.parse_args()

if __name__ == "__main__":

    args = parse_args()
    game_path = args.game_path
    phrase_mode = args.phrase_group

    training_scores = []
    testing_scores = []
    test_policy_list = []
    all_task_specific_command_list = []
    all_altruistic_command_list = []
    all_nb_moves_list = []
    all_alpha_parameter_list = []
    
    gg_model = ggModel(args.value_model)
    agent = NeuralAgent()
    
    print(" =====  Training  ===================================================== ")
    agent.train()  # Tell the agent it should update its parameters.
    start_time = time()
    print(os.path.realpath(game_path))
    tr_avg_scores, _, task_command_no_list, altruistic_command_no_list = play(phrase_mode, agent, gg_model, game_path, max_step=args.step_size, nb_episodes=args.nb_episodes, verbose=False)
    training_scores.append(tr_avg_scores)
    all_task_specific_command_list.append(task_command_no_list)
    all_altruistic_command_list.append(altruistic_command_no_list)

    print("Trained in {:.2f} secs".format(time() - start_time))

    print(' =====  Test  ========================================================= ')
    agent.test(method='random')
    test_avg_scores, policy_list, _, _ = play(phrase_mode, agent, gg_model, game_path, max_step=args.step_size, nb_episodes=50)  # Medium level game.
    test_policy_list.append(policy_list)
    testing_scores.append(test_avg_scores)
    save_path = args.save_path
    if not os.path.exists(os.path.dirname(save_path)):
        os.mkdir(os.path.dirname(save_path))

    np.save(save_path, agent)