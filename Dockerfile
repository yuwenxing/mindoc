FROM golang:1.8.3-alpine3.6

RUN apk add --update --no-cache \
libgcc libstdc++ libx11 glib libxrender libxext libintl \
libcrypto1.0 libssl1.0 \
ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family

# on alpine static compiled patched qt headless wkhtmltopdf (47.2 MB)
# compilation takes 4 hours on EC2 m1.large in 2016 thats why binary
COPY wkhtmltopdf /bin
RUN chmod +x /bin/wkhtmltopdf

RUN apk add --update bash git make gcc g++

ADD . /go/src/github.com/lifei6671/mindoc

WORKDIR /go/src/github.com/lifei6671/mindoc

RUN chmod +x start.sh

RUN  go get -d ./... && \ 
    go get github.com/mitchellh/gox && \
    gox -os "windows linux darwin" -arch amd64
CMD ["./start.sh"]
