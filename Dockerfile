# Pull base image
FROM python:3.9-slim-buster

# Install psql so that "python manage.py dbshell" works
RUN apt-get update && \
apt-get install -y libpq-dev gcc

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# install dependencies
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# copy project
COPY . .

# add and run as non-root user
RUN adduser --disabled-login myuser
USER myuser

# run gunicorn
CMD gunicorn hello_django.wsgi:application --bind 0.0.0.0:$PORT