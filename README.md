# Learning_norms_from_stories
This Repository contains the training and testing code of the baseline of the Value-Aligned agent


## pre-requisite

python = 3.10.4, pytorch >= 1.11.0, transformers >= 4.3.0, textworld = 1.5.2

## Agent Training

train.py contains the training script to train the agent. 

Example train command:
```
python train_baseline.py --nb_episodes 1500
```
Other parameters we can set:

* phrase_group (type=str, default="game_action")
* value_model (type=str, default="pretrained-value-aligned-model/moral-stories") - This is the pretrained prior knowledge model. Please contact the author to get the access of the pretrained prior knowledge model.
* game_path (type=str, default="tw_games/stealing_food.ulx") - Custom designed textworld game to test the value aligned agent.
* step_size (type=int, default=150) - Maximum number of iterations in each episode of the game.
* save_path (type=str, default="./model/baseline.npy") - Directory to save the trained model

## Test Environment
To test the performance of the trained Value-Aligned agent, we have implemented text-based simulation environments using TextWorld. We have created new custom game entities to implement the environments. "textworld_data" contains the logic and grammer files of theses new entities. Code examples to design text-based games using these entities is given in the tw_game_design.ipynb notebook.
