# Step 3

This step demonstrates adding a MySQL database to the Django application,
for persistence. Luckily, there is a
[community MySQL image](https://hub.docker.com/_/mysql)
that we'll use to deploy a local database, just for this example.

## Containerizing databases?

Running databases in containers is a hotly debated topic. On one hand,
it's convenient and consistent to deploy them - running a MySQL container
is fundamentally no different than running a Python container. On the
other hand, Docker shines when running stateless workloads that may update
frequently - neither of which typically applies to a database.

This tutorial makes no recommendation on whether to containerize your
databases - it's merely done this way as a convenience, and to further
demonstrate use of Docker. Consider consulting other resources before
making a judgment call on whether to containerize a database.

## A quick detour into container networking

The desired flow is:

1. A user, in a Web browser, requests the poll interface from the
   Django container, using their web browser on the host.
2. The Django container then reaches out to MySQL, in a different
   container.

While this could be done by hard-coding forwarded IP addresses and
ports, there is luckily a better way - **named networks**! When two
containers exist on the same network, it's possible to refer to
them using the container's name as a DNS name. So, for example, a
container named `mysql` will also be reachable using the DNS hostname
`mysql`.

Create a Docker network to enable this:

```
docker network create django-on-day-two
```

## Installing MySQL client libraries in the Dockerfile

Note that the Dockerfile contains the new statement:

```
RUN apt-get update && \
    apt-get install -y python3-dev default-libmysqlclient-dev build-essential pkg-config && \
    pip install -r requirements.txt
```

The [MySQL client library for Python](https://pypi.org/project/mysqlclient/) depends on
a native MySQL client already being installed - and indeed, you can find this exact `apt-get`
statement in its README. Remember that this is exactly the purpose of a container - to
encapsulate the running environment needed by an application!

## Running MySQL in a separate container

The following command will run the aforementioned image:

```
docker run -it --rm --name mysql --network django-on-day-two -e MYSQL_DATABASE=mysite -e MYSQL_USER=mysqluser -e MYSQL_PASSWORD=mysqlpass -e MYSQL_RANDOM_ROOT_PASSWORD=true mysql:9.0
```

The parameters to this command are:
* `-it` and `--rm` serve the same purpose as from step 2.
* `--name mysql` gives the container the name `mysql`, so that it can be
  referred to from the DNS hostname `mysql` by other services on the
  same network.
* `--network django-on-day-two` places the container on our named network.
* `-e MYSQL_DATABASE=mysite`, literally, sets the `MYSQL_DATABASE` environment
  variable to the value `mysite`. Contextually, it tells the image to
  create a database named `mysite` when it starts up.
* `-e MYSQL_USER` tells the image to create a user named `mysqluser`
  when it starts up.
* `-e MYSQL_PASSWORD=mysqlpass` tells the image to give the user in
  `MYSQL_USER` the password `mysqlpass`.
* `-e MYSQL_RANDOM_ROOT_PASSWORD=true` tells the image to set the root password
  for the database to a random value. We are not using the root user in
  this example.
* `mysql:9.0` is the name and version of the image on Dockerhub to use.

Notice that `-p` was not used to forward any ports. This is okay! `-p` is used
to forward ports from the container, to the host. We have no desire to use the
database from the host - only from the Django container.

In a production-grade environment, these environment variables might be set by
an orchestrator like [Kubernetes](https://kubernetes.io/), or may be derived
from a secrets manager like [Vault](https://www.hashicorp.com/products/vault).
Again - don't hard-code passwords in production! It's done here solely for
demonstration purposes.

## The settings.py

Note that the Django settings.py can refer to the database by the hostname
`mysql`. This is convenient, as there's no need to hard-code an IP address
or port. In a production-grade environment, this would be set by environment
variable, in a similar manner as was done by MySQL above.

## Running Django

Build and run the Step 3 image using:

```
docker build -t django-on-day-two:step3 .
docker run -p 8000:8000 -it --rm --network django-on-day-two django-on-day-two:step3
```

You'll notice that it takes longer to run migrations than it did in Step 2. This is because
migrations are now running against a real, live SQL database, not SQLite on the disk.

## Voting in your persistent poll

Navigate to the admin interface at 
[http://127.0.0.1:8000/admin](http://127.0.0.1:8000/admin), and add back your question
and choice. Then go back to the polls at
[http://127.0.0.1:8000/polls](http://127.0.0.1:8000/polls), and vote in your poll.

Hit Ctrl+C to stop Django. **Do not hit Ctrl+C on MySQL yet!**

Rerun the `docker run` statement above, and try voting again. You should now see your
poll question preserved, and two votes! Your questions and votes are now persistent.
