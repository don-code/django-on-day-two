#!/bin/bash

# Migrate the database
python manage.py migrate

# Create a superuser (this will fail if it already exists, but continue)
DJANGO_SUPERUSER_PASSWORD=password \
  DJANGO_SUPERUSER_USERNAME=admin \
  DJANGO_SUPERUSER_EMAIL=foo@foo.com \
  python manage.py createsuperuser --noinput

# Run the server
python manage.py runserver 0.0.0.0:8000
