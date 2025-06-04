FROM python:3.11-slim

WORKDIR /app

# Instalar dependências do sistema necessárias para as bibliotecas Python
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiar arquivos de requisitos primeiro para aproveitar o cache do Docker
COPY requirements.txt .

# Instalar dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o restante do código
COPY . .

# Configurar variáveis de ambiente
ENV FLASK_APP=app.py
ENV FLASK_ENV=production
ENV PYTHONUNBUFFERED=1

# Expor a porta que o aplicativo usará
EXPOSE 5000

# Comando para iniciar o aplicativo
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "wsgi:app"]
