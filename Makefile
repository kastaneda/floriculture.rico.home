# To install the build environment:
# apt install make jekyll imagemagick advancecomp

ROOT := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

-include .env

JEKYLL ?= jekyll
HTMLPROOFER ?= htmlproofer

# To run dockerized version of build tools, '.env' file should be like:
#
# JEKYLL = docker run --rm -v $(ROOT):/srv/jekyll jekyll/jekyll jekyll
# HTMLPROOFER = docker run --rm -v $(ROOT):/src klakegg/html-proofer

DOMAIN := flo.de.co.ua
TEXTFILES := '.*\.\(html\|css\|js\|txt\|xml\|ico\)$$'

SRC_JPG := $(shell find 20*/ -type f -name '*.jpg' | grep -v \\.300\\. | grep -v \\.1200\\.)
GEN_JPG_300 = $(patsubst %.jpg,%.300.jpg,$(SRC_JPG))
#GEN_JPG_1200 = $(patsubst %.jpg,%.1200.jpg,$(SRC_JPG))
GEN_JPG_1200 =
GEN_WEBP_ALL = $(patsubst %.jpg,%.webp,$(SRC_JPG) $(GEN_JPG_300) $(GEN_JPG_1200))
GEN_IMAGES_ALL = $(GEN_JPG_300) $(GEN_JPG_1200) $(GEN_WEBP_ALL)

ASSETS := $(GEN_IMAGES_ALL) pswp _data/images.json

all: build test

build: $(ASSETS)
	$(JEKYLL) build

up: $(ASSETS)
	$(JEKYLL) build --drafts --watch

%.300.jpg: %.jpg
	convert $< -gravity center -thumbnail '400x400>' -thumbnail 300x300^ $@

#%.1200.jpg: %.jpg
#	convert $< -thumbnail 1200x1200^ $@

%.webp: %.jpg
	cwebp $< -o $@

_data/images.json: $(SRC_JPG)
	mkdir -p _data
	echo "[" > $@
	identify -format "{ 'file': '/%d/%f', 'width': %w, 'height': %h },\n" $(SRC_JPG) >> $@
	echo "{ 'file': 'stub' }" >> $@
	echo "]" >> $@

pswp:
	svn checkout https://github.com/dimsemenov/PhotoSwipe/trunk/dist $@

test: test-local

test-local: build
	$(HTMLPROOFER) ./_site \
		--disable-external \
		--internal-domains https://$(DOMAIN) \
		--check-html \
		--check-favicon \
		--check-opengraph \
		--report-missing-names \
		--report-missing-doctype \
		--report-invalid-tags \
		--report-eof-tags \
		--report-mismatched-tags \
		--check-sri \
		--enforce_https

test-external: build
	$(HTMLPROOFER) ./_site \
		--internal-domains https://$(DOMAIN) \
		--check-html \
		--check-favicon \
		--check-opengraph \
		--report-missing-names \
		--report-missing-doctype \
		--report-invalid-tags \
		--report-eof-tags \
		--report-mismatched-tags \
		--check-sri \
		--enforce_https \
		--only-4xx

clean:
	rm -frv $(ASSETS)
	rm -frv _site/
	rm -fv $(DOMAIN).tar.gz

compress:
	find _site -regex $(TEXTFILES) | xargs zopfli --i20
	find _site -regex $(TEXTFILES) | xargs brotli -fZ

package: build compress $(DOMAIN).tar.gz

$(DOMAIN).tar.gz:
	tar zcf $@ -C _site/ .

.PHONY: all build up test test-local test-external clean compress package $(DOMAIN).tar.gz

.PHONY: img build
