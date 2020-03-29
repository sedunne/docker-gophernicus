FROM alpine:latest AS builder
LABEL maintainer='sedunne@icanhazmail.net'
LABEL version='3.0'
## gophernicus has switched to tags now, but the release tag is different than the dir name
##  in the sources, so it causes issues during image build. using the commit ref fixes this.
ENV VERSION 'e1f1bae2ea5d269de658153b78b335e42fcca338'
WORKDIR /tmp

RUN apk --no-cache add -t build-deps build-base gcc abuild binutils make
ADD https://github.com/gophernicus/gophernicus/archive/${VERSION}.zip /tmp/
RUN unzip "${VERSION}.zip" && \
    cd gophernicus-${VERSION}/ && make


FROM alpine:latest
ENV VERSION 'e1f1bae2ea5d269de658153b78b335e42fcca338'
ENV HOSTNAME 'localhost'

RUN apk --no-cache add  s6-networking
COPY --from=builder /tmp/gophernicus-${VERSION}/gophernicus /sbin/gophernicus
COPY --from=builder /tmp/gophernicus-${VERSION}/gophermap /var/gopher/gophermap

EXPOSE 70
CMD s6-tcpserver -4 -v 0.0.0.0 70 /sbin/gophernicus -h ${HOSTNAME} -p 70 -l /var/log/gophernicus.log -nr -nu -r /var/gopher/
