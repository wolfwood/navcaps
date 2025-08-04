SCAD=openscad
SCADFLAGS = -q --hardwarnings

# stl or 3mf are most common
FORMAT = stl


MANIFOLD_FEATURE := $(shell $(SCAD) --version --enable manifold > /dev/null 2>&1; echo $$?)
MANIFOLD_BACKEND := $(shell $(SCAD) --version --backend manifold > /dev/null 2>&1; echo $$?)

ifeq ($(MANIFOLD_BACKEND), 0)
    SCADFLAGS += --backend manifold
else
ifeq ($(MANIFOLD_FEATURE), 0)
    SCADFLAGS += --enable manifold
endif
endif


KEYCAP != perl -n -e'/^keycap_style\s*=\s*"(\S+)"/ && print $$1' < settings.scad
STEM != perl -n -e'/^stem_model\s*=\s*"(\S+)"/ && print $$1' < settings.scad
LENGTH != perl -n -e'/^effective_height\s*=\s*([\d\.]+)/ && print $$1' < settings.scad


current: update things/${STEM}-${KEYCAP}_${LENGTH}-mm.$(FORMAT)

update: include/keycap.scad include/stem.scad

adapter: things/${STEM}_mx-adapter.$(FORMAT)

series: things/series%.$(FORMAT)


include/keycap.scad : keycaps/${KEYCAP}.scad settings.scad
	ln -srf $< $@

include/stem.scad : stems/${STEM}.scad settings.scad
	ln -srf $< $@

things/series%.$(FORMAT): series.scad settings.scad
	${SCAD} ${SCADFLAGS} --render -o $@ $<

things/%_${LENGTH}-mm.$(FORMAT): final.scad settings.scad
	${SCAD} ${SCADFLAGS} --render -o $@ $<

things/%_mx-adapter.$(FORMAT): adapters/%.scad settings.scad adapters/util.scad adapters/mx-adapter.stl
	${SCAD} ${SCADFLAGS} --render -o $@ $<

image:
	exiftool -overwrite_original -recurse -EXIF= images
	cd images; find . -iname '*.png' -print0 | xargs -0 optipng -o7 -preserve
	cd images; find . -iname '*.jpg' -print0 | xargs -0 jpegoptim --max=90 --strip-all --preserve --totals --all-progressive

clean:
	rm ${TARGETS}
