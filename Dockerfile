FROM gcc:9 as buildtime

ENV VERSION '3.1.1'
WORKDIR /build

RUN curl -sLO https://github.com/gophernicus/gophernicus/releases/download/${VERSION}/gophernicus-${VERSION}.tar.gz && \
    tar xf "gophernicus-${VERSION}.tar.gz" && \
    cd gophernicus-${VERSION}/ && ./configure --listener=s6-tcpserver --prefix=/ && make && mkdir -p /build/artifacts && \
    mv src/gophernicus gophermap.sample /build/artifacts && rm -rf /build/gophernicus*


FROM sedunne/s6-networking as runtime
ENV VERSION '3.1.1'
ENV HOSTNAME 'localhost'
WORKDIR /var/gopher

## OCI label spec: https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.title='sedunne/gophernicus'
LABEL org.opencontainers.image.description='Unofficial gophernicus Docker container.'
LABEL org.opencontainers.image.url='https://github.com/sedunne/docker-gophernicus'
LABEL org.opencontainers.image.authors='Stephen Dunne <stephen@f914.net>'
LABEL org.opencontainers.image.version=${VERSION}

COPY --from=buildtime /build/artifacts/gophernicus /bin/gophernicus
COPY --from=buildtime /build/artifacts/gophermap.sample /var/gopher/gophermap

EXPOSE 70
CMD s6-tcpserver -4 -v 0.0.0.0 70 /bin/gophernicus -h ${HOSTNAME} -p 70 -l /var/log/gophernicus.log -nr -nu -r /var/gopher
