# Utilisez une image CUDA 12.7 compatible
FROM nvidia/cuda:12.7.0-cudnn8-devel-ubuntu22.04

# Installer les dépendances système requises
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    python3 \
    python3-pip \
    libopenblas-dev \
    liblapack-dev \
    libx11-dev \
    && rm -rf /var/lib/apt/lists/*

# Mettre à jour pip et installer setuptools, wheel, packaging
RUN pip install --upgrade pip setuptools wheel packaging

# Installer torch, torchvision, et torchaudio compatibles avec CUDA 12.7
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu127

# Copier le fichier requirements.txt
WORKDIR /app
COPY requirements.txt .

# Installer les dépendances Python restantes
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste du projet dans le conteneur
COPY . .


# Commande par défaut pour exécuter la commande
CMD ["autotrain", "llm", "--train", "--model", "microsoft/Phi-3-mini-4k-instruct", "--data-path", "timdettmers/openassistant-guanaco", "--lr", "2e-4", "--batch-size", "2", "--epochs", "1", "--trainer", "sft", "--peft", "--project-name", "my-own-phi-3-on-mac"]
