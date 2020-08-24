FROM swift:5.2

# Installing make , curl and git
RUN apt-get -y update
RUN apt-get -y install build-essential
RUN apt-get -y install curl
RUN apt-get install -y git

# Installing golang
RUN curl -O https://dl.google.com/go/go1.14.6.linux-amd64.tar.gz
RUN sha256sum go1.14.6.linux-amd64.tar.gz
RUN tar xvf go1.14.6.linux-amd64.tar.gz
RUN chown -R root:root ./go

# Setting export path
RUN mv go /usr/local
ENV PATH=$PATH:/usr/local/go/bin

