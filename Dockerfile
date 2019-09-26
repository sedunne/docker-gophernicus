FROM alpine:latest
LABEL maintainer='sedunne@icanhazmail.net'
LABEL version='3.0'
## gophernicus has switched to tags now, but the release tag is different than the dir name
##  in the sources, so it causes issues during image build. using the commit ref fixes this.
ENV VERSION 'e1f1bae2ea5d269de658153b78b335e42fcca338'
ENV HOSTNAME 'localhost'

RUN apk --no-cache add -t build-deps build-base gcc abuild binutils make
## this package needs to exist after building
RUN apk --no-cache add  s6-networking
RUN cd /tmp && curl -sLO https://github.com/gophernicus/gophernicus/archive/${VERSION}.zip && \
    unzip "${VERSION}.zip" && \
    cd gophernicus-${VERSION}/ && make && \
    mv /tmp/gophernicus-${VERSION}/gophernicus /sbin/gophernicus && \
    mkdir -p /var/gopher/ && cp /tmp/gophernicus-${VERSION}/gophermap /var/gopher/gophermap && \
    rm -rf /tmp/gophernicus-${VERSION} && rm -rf /tmp/"${VERSION}.zip" \
    apk del build-deps

EXPOSE 70
CMD s6-tcpserver -4 -v 0.0.0.0 70 /sbin/gophernicus -h ${HOSTNAME} -p 70 -l /var/log/gophernicus.log -nr -nu -r /var/gopher/
