VERSION ?= $(shell git describe --tags `git rev-list --tags --max-count=1` | sed -e 's/^v//')
RELEASES = patch minor major

build:
	docker build -t sqlwwx/ffmpeg:$(VERSION) -t sqlwwx/ffmpeg:latest .
	docker build -f Dockerfile.alinode -t sqlwwx/ffmpeg-alinode:$(VERSION) -t sqlwwx/ffmpeg-alinode:latest .

publish:
	docker push sqlwwx/ffmpeg:$(VERSION)
	docker push sqlwwx/ffmpeg:latest
	docker push sqlwwx/ffmpeg-alinode:$(VERSION)
	docker push sqlwwx/ffmpeg-alinode:latest

all: build publish

.PHONY: $(RELEASES)
$(RELEASES):
	$(PWD)/node_modules/.bin/standard-version --release-as $@
	git push --follow-tags origin master

.PHONY: build publish
