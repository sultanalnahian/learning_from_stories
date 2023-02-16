import torch
from transformers import BertTokenizer
from transformers import BertForSequenceClassification, AdamW, BertConfig
import pandas as pd

class ggModel():

    def __init__(self, model ='bert-base-uncased'):
        
        self.tokenizer = BertTokenizer.from_pretrained(model, do_lower_case=True)
        self.model = BertForSequenceClassification.from_pretrained(model)
        

    def get_score(self, sentence):
        
        # Tokenize all of the sentences and map the tokens to thier word IDs.
        input_ids = []
        attention_masks = []

        encoded_dict = self.tokenizer.encode_plus(
                            sentence,                      # Sentence to encode.
                            add_special_tokens = True, # Add '[CLS]' and '[SEP]'
                            max_length = 64,           # Pad & truncate all sentences.
                            pad_to_max_length = True,
                            return_attention_mask = True,   # Construct attn. masks.
                            return_tensors = 'pt',     # Return pytorch tensors.
                    )
        
        # Add the encoded sentence to the list.    
        input_ids.append(encoded_dict['input_ids'])
        
        # And its attention mask (simply differentiates padding from non-padding).
        attention_masks.append(encoded_dict['attention_mask'])
        
        # Convert the lists into tensors.
        input_ids = torch.cat(input_ids, dim=0)
        attention_masks = torch.cat(attention_masks, dim=0)

        # Put model in evaluation mode
        self.model.eval()
    
        # Telling the model not to compute or store gradients, saving memory and 
        # speeding up prediction
        with torch.no_grad():
            # Forward pass, calculate logit predictions.
            result = self.model(input_ids, 
                        token_type_ids=None, 
                        attention_mask=attention_masks,
                        return_dict=True)

        logits = result.logits

        logits = logits.detach().cpu().numpy()
        
        return logits

# gg_Model = ggModel()
# score = gg_Model.get_score("cut the line")
# print(score)