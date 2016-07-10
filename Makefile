VERSION ?= 0.6.0
ARCHITECTURES = amd64 armhf
ALL_PACKAGES = $(patsubst %,dist/vault_$(VERSION)_%.deb,$(ARCHITECTURES))
PACKAGE_PATTERN := dist/vault_$(VERSION)_%.deb

$(PACKAGE_PATTERN):
	$(eval DEB_ARCH:=$(@:$(PACKAGE_PATTERN)=%))
	$(eval HASHI_ARCH := $(DEB_ARCH:arm%=arm))
	docker rmi blurp; docker build -t blurp --build-arg VERSION="$(VERSION)" --build-arg DEB_ARCH="$(DEB_ARCH)" --build-arg HASHI_ARCH="$(HASHI_ARCH)" .
	docker rm blurp; docker run --name blurp -d blurp
	docker cp blurp:/dist/ ./
	docker rm blurp; docker rmi blurp

bintray.json: bintray.json.in Makefile $(ALL_PACKAGES)
	jq 'setpath(["version", "name"]; "$(VERSION)")' $< > $@

