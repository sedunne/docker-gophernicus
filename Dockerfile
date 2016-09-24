FROM alpine:latest
MAINTAINER Stephen Dunne III <sedunne@icanhazmail.net>

## dat image size tho
RUN apk --no-cache --update add -t build-deps build-base gcc abuild binutils make && \
    cd /tmp && curl -sL http://gophernicus.org/software/gophernicus/gophernicus-2.0.tar.gz |tar -zx && \
    cd gophernicus-2.0/ && make && mv /tmp/gophernicus-2.0/in.gophernicus /sbin/in.gophernicus && \
    mkdir -p /var/gopher/ && cp /tmp/gophernicus-2.0/gophermap /var/gopher/gophermap && \
    rm -rf /tmp/gophernicus-2.0 && apk del build-deps

EXPOSE 70
CMD nc -lk -p 70 -e /sbin/in.gophernicus -h $(hostname) -p 70 -nr -r /var/gopher/
