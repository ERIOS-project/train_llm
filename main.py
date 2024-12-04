import os
from torch import mps
from autotrain.params import LLMTrainingParams
from autotrain.project import AutoTrainProject

# Modifier les paramètres pour un test rapide
params = LLMTrainingParams(
    model="meta-llama/Llama-3.2-1B-Instruct",
    data_path="HuggingFaceH4/no_robots",
    chat_template="tokenizer",
    text_column="messages",
    train_split="train",
    trainer="sft",
    epochs=3,
    batch_size=1,
    lr=1e-5,
    peft=True,
    quantization="int4",
    target_modules="all-linear",
    padding="right",
    optimizer="paged_adamw_8bit",
    scheduler="cosine",
    gradient_accumulation=8,
    mixed_precision="bf16",
    merge_adapter=True,
    project_name="autotrain-llama32-1b-finetune",
    log="tensorboard",
    push_to_hub=False,  # Pas de push vers Hub
    token=os.environ.get("HF_TOKEN")
)

# Backend local pour le test
backend = "local"
project = AutoTrainProject(params=params, backend=backend, process=True)
project.create()
