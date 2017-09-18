FROM ubuntu:14.04

# setup ubuntu repository
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# install go
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV LANG en_US.UTF-8
ENV GOVERSION 1.6.2
ENV GOROOT /opt/go
ENV GOPATH /root/.go
ARG DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US en_US.UTF-8 hu_HU hu_HU.UTF-8 && dpkg-reconfigure locales

RUN apt-get install -y wget && cd /opt && wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
    tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz && \
    ln -s /opt/go/bin/go /usr/bin/ && \
    mkdir $GOPATH

# Download and install wkhtmltopdf

# prevent services from being started automatically when you install packages with dpkg
RUN echo exit 101 > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d 

RUN apt-get install -y build-essential xorg libssl-dev libxrender-dev wget gdebi
RUN wget http://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
RUN gdebi --n wkhtmltox-0.12.2.1_linux-trusty-amd64.deb

# install windoc
RUN apt-get install -y bash git make gcc g++
ADD . /go/src/github.com/lifei6671/mindoc
WORKDIR /go/src/github.com/lifei6671/mindoc
RUN chmod +x start.sh
RUN  go get -d ./... && \
    go get github.com/mitchellh/gox && \
    gox -os "windows linux darwin" -arch amd64
CMD ["./start.sh"]

