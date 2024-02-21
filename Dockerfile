# pull official base image
FROM python:3.9-alpine

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DEBUG 0

# install psycopg2
RUN apk update \
    && apk add --virtual build-essential gcc python3-dev musl-dev libffi-dev openssl-dev g++ \
    && apk add postgresql-dev libevent-dev make

RUN pip3 install --upgrade pip && pip3 install --upgrade setuptools

# install dependencies
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# copy project
COPY . .

# add and run as non-root user
RUN adduser -D myuser
USER myuser

# run gunicorn
CMD gunicorn hello_django.wsgi:application --bind 0.0.0.0:$PORT