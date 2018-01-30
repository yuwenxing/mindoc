FROM golang:1.9.3-alpine3.7

RUN apk add --update bash git make gcc g++ 
# install calibre
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/calibre/lib
ENV PATH $PATH:/opt/calibre/bin
RUN apk update && \
    apk add --no-cache --upgrade \
    ca-certificates \
    mesa-gl \
    python \
    qt5-qtbase-x11 \
    wget \
    xdg-utils \
    xz && \
    wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()" 

ADD . /go/src/github.com/lifei6671/mindoc

WORKDIR /go/src/github.com/lifei6671/mindoc

RUN chmod +x start.sh

RUN  go get -d ./... && \ 
    go get github.com/mitchellh/gox && \
    gox -os "windows linux darwin" -arch amd64
CMD ["./start.sh"]

