FROM python:3.10-slim

WORKDIR /app

COPY backend-service/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend-service /app

EXPOSE 5000

CMD ["python", "app.py"]