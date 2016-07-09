FROM ruby
RUN gem install fpm
WORKDIR /work
ARG VERSION
ADD https://releases.hashicorp.com/vault/${VERSION}/vault_${VERSION}_linux_amd64.zip amd64.zip
RUN apt-get update && apt-get install -yq unzip
RUN unzip amd64.zip
RUN fpm -s dir -t deb -n vault -v $VERSION --prefix usr/bin/ vault
RUN dpkg --contents *.deb
RUN mkdir /dist && mv *.deb /dist/

