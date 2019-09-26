# Alpine Gophernicus Docker Image

(unofficial) Docker image for the [Gophernicus](https://github.com/kimholviala/gophernicus) Gopher server.

This image is built from the Alpine:latest image, and fetches the Gophernicus source from the master Github branch. Images are automatically built from my [GitHub repo](https://github.com/sedunne/docker-gophernicus).

### Use via Docker Hub

`docker pull sedunne/gophernicus`

### Building Locally

```
git clone https://github.com/sedunne/docker-gophernicus.git
cd docker-gophernicus && docker build -t gophernicus .
```

### Notes

In gophernicus, the hostname argument is very important, and anything beyond the root menu won't work unless set correctly. By default, this is set to 'localhost', which should work when running the container locally, and connecting via `gopher://localhost`. You can override this by passing `-e 'HOSTNAME=<your_hostname>'` in the `docker run` command you use to start the container.

Previous verisions of the image used netcat as a stream listener to invoke Gophernicus on request (as it's not a daemon). This has been switched to s6-tcpserver to be a bit less hacky, and also provide some degree of log output.

Gophernicus will also log to /var/log/gophernicus.log in the container, but since it's spawned from s6-tcpserver, I wasn't able to get the logs merged into the fd that `docker logs` uses to make them viewable from the outside.

### License

This project is licensed under the MIT license.

By using this image, you agree to the license and terms set by the original author, found under [ATTRIBUTION](https://github.com/sedunne/docker-gophernicus/blob/master/ATTRIBUTION).

