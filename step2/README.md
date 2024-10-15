# Step 2

This step demonstrates rebuilding the container after adding a simple
polling app to the Django site. 

## The entrypoint.sh file

The tutorial requested that we run migrations and create a superuser
account. Rather than attempt to express all of this in the `ENTRYPOINT`
statement of the Dockerfile, the file `entrypoint.sh` was created.
`ENTRYPOINT` is then changed to run the shell script, rather than
`python` directly.

The superuser username and password are `admin:password`. They are
hard-coded in the shells cript, for convenience and demonstration
purposes. In a more proper application, these should be sourced from
environment variables, or some other source of truth: passwords should
never be checked into source control! In step 3, we'll dig further into
specifying environment variables to a container.

## Building, running, and voting in a poll

To build and run the container, run:
```
docker build -t django-on-day-two:step2 .
docker run -p 8000:8000 -it --rm django-on-day-two:step2
```

You'll notice that migrations and superuser creation now run as part of startup:
```
[don@zeus ~/git/django-on-day-two/step2:master*] docker run -it --rm django-on-day-two:step2
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, polls, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying auth.0012_alter_user_first_name_max_length... OK
  Applying polls.0001_initial... OK
  Applying sessions.0001_initial... OK
Superuser created successfully.
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).
October 15, 2024 - 03:40:25
Django version 5.1.2, using settings 'mysite.settings'
Starting development server at http://0.0.0.0:8000/
Quit the server with CONTROL-C.
```

The admin interface will now be available at
[http://localhost:8080/admin](http://localhost:8080/admin), and the
polling app will be available at
[http://localhost:8080/polls](http://localhost:8080/polls).

Use the admin interface to add at least one question, then do likewise
with at least one choice. When complete, go vote in your poll!

## Persistence challenges

When you have voted, hit Ctrl+C. This will terminate Django and stop
the container. Now, rerun the start command:

```
docker run -p 8000:8000 -it --rm django-on-day-two:step1
```

If you navigate to
[http://localhost:8080/polls](http://localhost:8080/polls), you'll notice
that there are no polls available! The default storage backend for Django
is to use a [sqlite](https://www.sqlite.org/index.html) database, backed
by the local filesystem. Remember that containers have their own filesystem,
so by termianting the original container and starting a new one, the data
was wiped out!

In the next example, we'll add persistence by running a MySQL database.
