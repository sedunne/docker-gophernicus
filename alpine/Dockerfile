FROM alpine:3.12 as buildtime

## gophernicus has switched to tags now, but the release tag is different than the dir name
##  in the sources, and this causes issues during image build. using the commit ref seems to fix this.
ENV VERSION '3.1.1'
WORKDIR /build

RUN apk --no-cache add -t build-deps build-base gcc abuild binutils make
RUN curl -sLO https://github.com/gophernicus/gophernicus/releases/download/${VERSION}/gophernicus-${VERSION}.tar.gz && \
    tar xf "gophernicus-${VERSION}.tar.gz" && \
    cd gophernicus-${VERSION}/ && ./configure --listener=s6-tcpserver --prefix=/ && make && mkdir -p /build/artifacts && \
    mv src/gophernicus gophermap.sample /build/artifacts && rm -rf /build/gophernicus* && \
    apk del build-deps


FROM alpine:3.12 as runtime
ENV VERSION '3.1.1'
ENV HOSTNAME 'localhost'
WORKDIR /var/gopher

## OCI label spec: https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.title='sedunne/gophernicus:alpine'
LABEL org.opencontainers.image.description='Unofficial gophernicus Alpine Docker container.'
LABEL org.opencontainers.image.url='https://github.com/sedunne/docker-gophernicus'
LABEL org.opencontainers.image.authors='Stephen Dunne <stephen@f914.net>'
LABEL org.opencontainers.image.version=${VERSION}

RUN apk --no-cache add s6-networking

COPY --from=buildtime /build/artifacts/gophernicus /usr/local/bin/gophernicus
COPY --from=buildtime /build/artifacts/gophermap.sample /var/gopher/gophermap

EXPOSE 70
ENTRYPOINT s6-tcpserver -4 -v 0.0.0.0 70 /usr/local/bin/gophernicus -h ${HOSTNAME} -p 70 -l /var/log/gophernicus.log -nr -nu -r /var/gopher
