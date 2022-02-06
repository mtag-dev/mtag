FROM python:3.9

WORKDIR /app

COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --upgrade -r requirements.txt

CMD ["esg", "app:app", "--host", "0.0.0.0", "--port", "81", "--reload", "--ws-ping-interval", "2"]
