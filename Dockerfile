# Utilisez une image officielle de Python comme base
FROM python:3.10-slim

# Installer les dépendances système requises
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libopenblas-dev \
    liblapack-dev \
    libx11-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier requirements.txt
COPY requirements.txt .

# Installer les dépendances Python
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copier le reste du projet dans le conteneur
COPY . .



# Commande par défaut pour exécuter le script
CMD ["python", "main.py"]
