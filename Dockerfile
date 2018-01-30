FROM golang:1.9.3-alpine3.6

RUN apk add --update bash git make gcc g++
# install calibre
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/calibre/lib
ENV PATH $PATH:/opt/calibre/bin
ENV CALIBRE_INSTALLER_SOURCE_CODE_URL https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py
RUN apk update && \
    apk add --no-cache --upgrade \
    ca-certificates \
    mesa-gl \
    python \
    qt5-qtbase-x11 \
    wget \
    xdg-utils \
    xz && \
    wget -O- ${CALIBRE_INSTALLER_SOURCE_CODE_URL} | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main(install_dir='/opt', isolated=True)" && \
    rm -rf /tmp/calibre-installer-cache

ADD . /go/src/github.com/lifei6671/mindoc

WORKDIR /go/src/github.com/lifei6671/mindoc

RUN chmod +x start.sh

RUN  go get -d ./... && \ 
    go get github.com/mitchellh/gox && \
    gox -os "windows linux darwin" -arch amd64
CMD ["./start.sh"]

