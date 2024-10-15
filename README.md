# Django on Day Two

## Introduction

This repository contains code used at the
[2024/10/15 event at the Boston Python meetup](https://www.meetup.com/bostonpython/events/303827700)
to introduce the concept of containers through the lens of
making changes locally, then building and running them in Docker.

The introduction slides for this talk are available
[on my website](https://hardwarehacks.org/lt/boston-python-20241015.odp).
A recording of the entire presentation may be posted at a later
date.

Since the code is a snapshot of what was presented at the event,
contributions to this repository are not accepted - feel free
to fork and continue development!

## About the event

### What will we do?

We will learn what sorts of things may happen after a user commits
code to a Django project. It may, for instance, be packaged into
a container image using Docker, then also run in a live environment
using Docker. We'll use the metaphor of a container ship, hauling
standardized [twenty-foot equivalent units](https://en.wikipedia.org/wiki/Twenty-foot_equivalent_unit),
to rationalize what's happening when we package and run a container.

This talk assumes some basic working knowledge of both the Python
ecosystem (e.g. tools like `pip`), as well as with
a Unix shell like `bash` or `zsh`.

### What tools and concepts will we learn about?

* **Pre-packaged containers on Docker Hub** - we'll deploy MySQL from the
  [community Docker image](https://hub.docker.com/_/mysql).
* **Self-built containers** - we'll deploy Django using a Dockerfile,
  building off of the [community Python image](https://hub.docker.com/_/python).
* **Container networking** - we'll use a network to make Django and MySQL
  talk to each other.
* **Day-two operations** - we'll upgrade from Python
  3.12 to 3.13 in a safe and redundant manner.

### Agenda

1. We'll start by packaging the output of the command `django-admin startproject mysite`
   into a container, then verify that we can launch it, and see its output in a local
   Web browser.
2. We'll then add a poll app to our Django site, using the default sqlite3 backend. While
   we'll be able to vote in our poll, the results will go away whenever Django shuts down.
3. We'll then launch MySQL, and point Django at it. Our votes will now be preserved
   across individual running instances of Django.
4. Finally, we'll run Django side-by-side on both Python 3.12 and Python 3.13, and verify
   that the polling functionality works on 3.13 without affecting the running 3.12 site.

## Format of the Subdirectories

Each individual step is packaged into a subdirectory, and is a separately-consumable
entity. Included is an example of how to run the code, a discussion of what the code
does, and a discussion on what was left out (to make the demo more easily consumable)
that should be considered in a "real" system.

## Acknowledgments

The Django code presented is heavily derived from
[Writing your first Django app](https://docs.djangoproject.com/en/5.1/intro/tutorial01/)
in the Django documentation. These portions are
copyright (c) Django Software Foundation and individual contributors,
who make their documentation available under the BSD license.
This guide is made available under the same license.

Special thanks to [Ned](https://nedbatchelder.com/) for inviting me to deliver
this talk.
