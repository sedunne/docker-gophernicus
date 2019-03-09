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

Gophernicus is intended to be used as a stream listener, and is not a daemon. Because of this, the Alpine-native version of `nc` (netcat) is used as the 'listener', executing Gophernicus on request.

### License

This project is licensed under the MIT license.

By using this image, you agree to the license and terms set by the original author, found under [ATTRIBUTION](https://github.com/sedunne/docker-gophernicus/blob/master/ATTRIBUTION).

