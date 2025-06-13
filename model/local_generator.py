import sys
import json
import logging
from pathlib import Path
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

logging.basicConfig(
    filename='model_errors.log',
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

try:
    device = "cuda" if torch.cuda.is_available() else "cpu"
    logging.info(f"Using device: {device}")

    model_path = Path(__file__).parent / 'trained_model'
    logging.info(f"Loading model from: {model_path}")

    model = AutoModelForCausalLM.from_pretrained(str(model_path))
    tokenizer = AutoTokenizer.from_pretrained(str(model_path))

    model = model.to(device)

    tokenizer.pad_token = tokenizer.eos_token
    model.config.pad_token_id = tokenizer.eos_token_id
    
    input_data = sys.stdin.read()
    data = json.loads(input_data)
    faction = data.get('faction', '')
    
    prompt = f"Faction: {faction}\nHeadline:"
    inputs = tokenizer(
        prompt,
        return_tensors="pt",
        padding=True,
        truncation=True,
        max_length=512,
        add_special_tokens=True
    )
    
    inputs = {k: v.to(device) for k, v in inputs.items()}
    
    with torch.no_grad():
        outputs = model.generate(
            input_ids=inputs["input_ids"],
            attention_mask=inputs["attention_mask"],
            max_new_tokens=100,
            temperature=0.9,
            do_sample=True,
            top_k=50,
            top_p=0.95,
            pad_token_id=tokenizer.pad_token_id,
            eos_token_id=tokenizer.eos_token_id
        )
    
    text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    text = text.replace(prompt, "").strip()
    
    lines = text.split('\n')
    headline = lines[0].strip()
    description = ' '.join(lines[1:7]).strip()
    
    result = {
        'headline': headline or 'Breaking News',
        'description': description or 'City situation develops.'
    }
    print(json.dumps(result))

except Exception as e:
    logging.error(f"Error occurred: {str(e)}", exc_info=True)
    print(json.dumps({
        'headline': 'System Error',
        'description': 'News generation temporarily unavailable.'
    }))