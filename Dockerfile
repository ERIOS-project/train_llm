# Utilisez une image officielle Python comme base
FROM python:3.10-slim

# Installer les dépendances système requises
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    libopenblas-dev \
    liblapack-dev \
    libx11-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Installer CUDA 12.7 et ses outils
RUN wget https://developer.download.nvidia.com/compute/cuda/12.7.0/local_installers/cuda-repo-ubuntu2204-12-7-local_12.7.0-530.30.02-1_amd64.deb && \
    dpkg -i cuda-repo-ubuntu2204-12-7-local_12.7.0-530.30.02-1_amd64.deb && \
    cp /var/cuda-repo-ubuntu2204-12-7-local/cuda-*.keyring /usr/share/keyrings/ && \
    apt-get update && apt-get install -y cuda && \
    rm cuda-repo-ubuntu2204-12-7-local_12.7.0-530.30.02-1_amd64.deb

# Mettre CUDA dans le PATH et configurer CUDA_HOME
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV CUDA_HOME="/usr/local/cuda"

# Installer PyTorch avec support CUDA
RUN pip install --upgrade pip setuptools wheel packaging && \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu127

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier requirements.txt
COPY requirements.txt .

# Installer les dépendances Python restantes
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste du projet dans le conteneur
COPY . .



# Commande par défaut pour exécuter la commande
CMD ["autotrain", "llm", "--train", "--model", "microsoft/Phi-3-mini-4k-instruct", "--data-path", "timdettmers/openassistant-guanaco", "--lr", "2e-4", "--batch-size", "2", "--epochs", "1", "--trainer", "sft", "--peft", "--project-name", "my-own-phi-3-on-mac"]
