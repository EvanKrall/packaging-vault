FROM ruby
RUN gem install fpm
RUN apt-get update && apt-get install -yq unzip
WORKDIR /work

ARG VERSION
ARG DEB_ARCH
ARG HASHI_ARCH

ADD https://releases.hashicorp.com/vault/${VERSION}/vault_${VERSION}_linux_${HASHI_ARCH}.zip vault.zip
RUN unzip vault.zip
RUN fpm -s dir -t deb -n vault -v $VERSION --prefix usr/bin/ -a $DEB_ARCH vault
RUN mkdir /dist && mv *.deb /dist/

