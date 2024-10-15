# Start from the known state of having Python 3.12 installed, from Docker Hub.
FROM python:3.12

# Copy the contents of the current directory into the container at the path /app.
COPY . /app

# Make it so that all commands execute, by default, in the /app directory.
WORKDIR /app

# Install our dependencies (just Django).
RUN pip install -r requirements.txt

# Say that this container listens on port 8000.
EXPOSE 8000

# Start the server when the container starts
ENTRYPOINT ["/app/entrypoint.sh"]
