JPG := $(shell find 20*/ -type f -name '*.jpg' | grep -v \\.300\\. | grep -v \\.1200\\.)
JPG_300 = $(patsubst %.jpg,%.300.jpg,$(JPG))
#JPG_1200 = $(patsubst %.jpg,%.1200.jpg,$(JPG))
JPG_1200 =
WEBP_ALL = $(patsubst %.jpg,%.webp,$(JPG) $(JPG_300) $(JPG_1200))
IMAGES_ALL = $(JPG_300) $(JPG_1200) $(WEBP_ALL)

build: img _data/images.json pswp
	jekyll b

img: $(IMAGES_ALL)

%.300.jpg: %.jpg
	convert $< -gravity center -thumbnail '400x400>' -thumbnail 300x300^ $@

#%.1200.jpg: %.jpg
#	convert $< -thumbnail 1200x1200^ $@

%.webp: %.jpg
	cwebp $< -o $@

_data/images.json: $(JPG) $(JPG_1200)
	mkdir -p _data
	echo "[" > $@
	identify -format "{ 'file': '/%d/%f', 'width': %w, 'height': %h },\n" $< >> $@
	echo "{ 'file': 'stub' }" >> $@
	echo "]" >> $@

pswp:
	svn checkout https://github.com/dimsemenov/PhotoSwipe/trunk/dist $@

.PHONY: img build
