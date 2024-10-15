# Step 4

This step demonstrates how to upgrade the Django application from
Python 3.12 to Python 3.13, and run it side-by-side with the 3.12
application for testing. There are several reasons why this may
be desirable, including:

1. **Canary deployments.** A small portion of containers may be
   updated to start with. If unexpected behavior is encountered, it's
   trivial to remove those containers, and/or point back at the
   last known good image.
2. **Testing (safely) in production.** By standing up a container
   without sending traffic to it, it's possible to test that a
   feature works with production data, without customers finding
   out first. Of course, it's also possible that your change
   _modifies_ production data in a backwards-incompatible way,
   so watch out!
3. **Operational simplicity.** This is the kind of change that would
   normally require an operations team to spend time upgrading
   VMs in place, replacing servers entirely with newly-configured
   ones, or standing up a new pool of servers to run the
   application on and then failing over to them. With our
   container, this is a one-line change.

## The one line change

Note that the first line of the Dockerfile:
```
FROM python:3.12
```

...became:
```
FROM python:3.13
```

That's it! This image will now be built with Python 3.13.

## Running the one-line change in parallel

Remember that Steps 1 through 3 forwarded Django, on port 8000 inside
the container, to port 8000 on your local machine. In this case, we'll
stand Python 3.13 up on port 8001 on your local machine, but keep it
pointed at port 8000 inside the container.

```
docker build -t django-on-day-two:step4 .
docker run -p 8001:8000 -it --rm --network django-on-day-two django-on-day-two:step4
```

Now go to
[http://localhost:8001/polls/](http://localhost:8001/polls/) in your Web browser, and
vote in your poll. You should now have three responses.

Incidentally, you've just functionally tested your poll on Python 3.13, all while
keeping the Python 3.12 version undisturbed, but working with the same data.

## Conclusion

Paired with a load balancer, this is an incredibly powerful tool for making upgrades,
scaling applications to run many instances, or even just quickly deploying something
under test on your local machine!
