from flask import Flask, request, jsonify
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
from pathlib import Path

app = Flask(__name__)

device = "cuda" if torch.cuda.is_available() else "cpu"
model_dir = Path(__file__).parent / "trained_model"

tokenizer = AutoTokenizer.from_pretrained(str(model_dir))
model = AutoModelForCausalLM.from_pretrained(str(model_dir)).to(device)
model.eval()

if tokenizer.pad_token is None:
    tokenizer.pad_token = tokenizer.eos_token
model.config.pad_token_id = tokenizer.pad_token_id

@app.route('/generate', methods=['POST'])
def generate():
    data = request.json
    faction = data.get("faction", "public")
    prompt = f"Faction: {faction}. Headline:"

    inputs = tokenizer(
        prompt,
        return_tensors="pt",
        padding=True,
        truncation=True,
        max_length=32,
        add_special_tokens=True
    )
    inputs = {k: v.to(device) for k, v in inputs.items()}
    with torch.no_grad():
        outputs = model.generate(
            input_ids=inputs["input_ids"],
            attention_mask=inputs["attention_mask"],
            max_new_tokens=16,
            temperature=0.9,
            top_k=50,
            top_p=0.95,
            pad_token_id=tokenizer.pad_token_id,
            eos_token_id=tokenizer.eos_token_id
        )
    text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    text = text.replace(prompt, "").strip()
    lines = text.split('\n')
    headline = lines[0].strip() if lines else text.strip()
    description = ' '.join(lines[1:3]).strip() if len(lines) > 1 else ""
    result = {
        'headline': headline or 'Breaking News',
        'description': description or ''
    }
    return jsonify(result)

if __name__ == '__main__':
    app.run(port=5000)