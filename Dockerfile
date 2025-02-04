FROM python:3.12

WORKDIR /app

COPY app/* estuda/

WORKDIR /app/estuda

RUN pip install -r requirements.txt

EXPOSE 5000
