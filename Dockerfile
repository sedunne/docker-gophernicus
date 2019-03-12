FROM alpine:latest
LABEL maintainer='sedunne@icanhazmail.net'
LABEL version='2.0'
## gophernicus /used/ to be only on the authors site, but now is hosted on Github, and uses rolling release version numbers.
## for now, just use the commit ref as a 'version' marker, since no tags or actual releases currently exist.
ENV VERSION 'fc293e8202c58089f61345edb75d33cd246ca5d3'

## dat image size tho
RUN apk --no-cache add -t build-deps build-base gcc abuild binutils make s6-networking
RUN cd /tmp && curl -sLO https://github.com/kimholviala/gophernicus/archive/${VERSION}.zip && \
    unzip "${VERSION}.zip" && \
    cd gophernicus-${VERSION}/ && make && \
    mv /tmp/gophernicus-${VERSION}/in.gophernicus /sbin/in.gophernicus && \
    mkdir -p /var/gopher/ && cp /tmp/gophernicus-${VERSION}/gophermap /var/gopher/gophermap && \
    rm -rf /tmp/gophernicus-${VERSION} && \
    apk del build-deps

EXPOSE 70
CMD s6-tcpserver -4 -v 0.0.0.0 70 /sbin/in.gophernicus -h $(hostname) -p 70 -l /var/log/gophernicus.log -nr -nu -r /var/gopher/
