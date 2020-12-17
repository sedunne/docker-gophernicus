FROM alpine:3.12 as buildtime

## gophernicus has switched to tags now, but the release tag is different than the dir name
##  in the sources, and this causes issues during image build. using the commit ref seems to fix this.
ENV VERSION 'e1f1bae2ea5d269de658153b78b335e42fcca338'
WORKDIR /build

RUN apk --no-cache add -t build-deps build-base gcc abuild binutils make
RUN curl -sLO https://github.com/gophernicus/gophernicus/archive/${VERSION}.zip && \
    unzip "${VERSION}.zip" && \
    cd gophernicus-${VERSION}/ && make && \
    apk del build-deps


FROM alpine:3.12 as runtime
ENV VERSION 'e1f1bae2ea5d269de658153b78b335e42fcca338'
ENV HOSTNAME 'localhost'
WORKDIR /var/gopher

## OCI label spec: https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.title='sedunne/gophernicus'
LABEL org.opencontainers.image.description='Unofficial gophernicus Docker container.'
LABEL org.opencontainers.image.url='https://github.com/sedunne/docker-gophernicus'
LABEL org.opencontainers.image.authors='Stephen Dunne <stephen@f914.net>'
LABEL org.opencontainers.image.version=${VERSION}

RUN apk --no-cache add s6-networking

COPY --from=buildtime /build/gophernicus-${VERSION}/gophernicus /usr/local/bin/gophernicus
COPY --from=buildtime /build/gophernicus-${VERSION}/gophermap /var/gopher/gophermap

EXPOSE 70
ENTRYPOINT s6-tcpserver -4 -v 0.0.0.0 70 /usr/local/bin/gophernicus -h ${HOSTNAME} -p 70 -l /var/log/gophernicus.log -nr -nu -r /var/gopher
