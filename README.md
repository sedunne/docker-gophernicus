# Gophernicus Docker Images
(unofficial) Docker images for the [Gophernicus](https://github.com/kimholviala/gophernicus) gopher server.

Currently there are two different options for this image:
1. (default) Minideb-based platform, compiled with gcc/glibc
2. Alpine-based platform, compiled with gcc/muslc

### Use via Docker Hub

`docker pull sedunne/gophernicus`

Or to use the Alpine images:

`docker pull sedunne/gophernicus:alpine`

### Building Locally

```
git clone https://github.com/sedunne/docker-gophernicus.git
cd docker-gophernicus && docker build -t gophernicus .
```

### Usage
In gophernicus, the hostname argument is very important, and anything beyond the root menu won't work unless set correctly. By default, this is set to 'localhost', which should work when running the container locally, and connecting via `gopher://localhost`. You can override this by passing `-e 'HOSTNAME=<your_hostname>'` in the `docker run` command you use to start the container.

Previous verisions of the image used netcat as a stream listener to invoke Gophernicus on request (as it's not a daemon). This has been switched to s6-tcpserver to be a bit less hacky, and also provide some degree of log output.

Gophernicus will also log to /var/log/gophernicus.log in the container, but I wasn't able to get the logs working in a way that `docker logs` can make them viewable from the outside. Currently, `docker logs` will show the output from s6-tcpserver.

### License

This project is licensed under the MIT license.

By using this image, you agree to the license and terms set by the original author, found under [ATTRIBUTION](https://github.com/sedunne/docker-gophernicus/blob/master/ATTRIBUTION).
