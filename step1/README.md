# Step 1

This step demonstrates the base case of running Django inside a container.

The Python code contained within is simply the result of running
`django-admin startproject mysite`, locally, outside of a container. It
can be started using the standard `python manage.py runserver` command
to start a local webserver.

The included `Dockerfile` describes how to package this project into a
container:

1. Start from the pre-existing state described in the
   [community image on Docker Hub for Python 3.12](https://hub.docker.com/_/python).
   This image provides just enough of an environment to run most Python code.
2. Copy the contents of this directory (the dot references the current
   directory) into the path `/app` inside the container. Containers have
   separate filesystems, so it's necessary to copy any files we want to
   work on, into the container.
3. Add some metadata saying that any commands run in the container should,
   by default, run from inside the `/app` directory.
4. Install the project's dependencies, which are just Django.
5. Add some metadata saying that a network service runs on port 8000, and
   should be exposed outside the container.
6. Finally, specify that when the container starts, it should run the
   command `python manage.py runserver 0.0.0.0:8000`. This is similar to
   the standard `python manage.py runserver`, but the latter will only
   listen for connections on localhost (127.0.0.1). Containers also have
   separate networks, so it's necessary to listen on the public interface
   as well - not just the container-local one.

To build this container image, simply run:
```
docker build -t django-on-day-two:step1 .
```

A step like this would normally be run by a CI system, like Github Actions
or a Jenkins job. It's rare that you may run it yourself, unless you're
working on the image itself. In this command:

* The `-t` flag specifies a tag for the image. This helps us not lose track
  of it, as the default name is a hash in hexadecimal.
* The `.` refers to the _context_ in which the image should be built - in this
  case, the current directory.

To run the built image:
```
docker run -p 8000:8000 -it --rm django-on-day-two:step1
```

In this command:

* `-p` forwards the container's port 8000 to your local machine - again, because
  containers have separate networks from their host. But also remember that
  `EXPOSE` was specified in the Dockerfile. When publishing ports to the host,
  Docker selects a random port - for instance 33000 - to forward to. This forces
  port 8000 on the host to map to port 8000 in the container, for convenience.
* `-it` attaches the currently running terminal to this container, so that you can
  interact with its standard input and output as if you were running Django locally.
* `--rm` is a housekeeping feature that tells Docker to remove the container when
  it quits. This prevents stopped containers from piling up.
* Finally, the tag to run is what was specified in the `-t` in the build step.

The output should be:
```
[don@zeus ~/git/django-on-day-two/step1:master*] docker run -it --rm django-on-day-two:step1
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).

You have 18 unapplied migration(s). Your project may not work properly until you apply the migrations for app(s): admin, auth, contenttypes, sessions.
Run 'python manage.py migrate' to apply them.
October 15, 2024 - 03:27:35
Django version 5.1.2, using settings 'mysite.settings'
Starting development server at http://0.0.0.0:8000/
Quit the server with CONTROL-C.
```

The Django start page should be visible in a Web browser on your local machine.
When you are finished, simply hit Ctrl+C.

Congratulations! You have successfully built and run a Django app inside a container with Docker.
