FROM python:3.14.0a7-alpine3.21

WORKDIR /app

# Copier les fichiers requirements et app dans le conteneur
COPY site/requirements.txt requirements.txt
COPY site/app.py app.py

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80

CMD ["python", "app.py"]