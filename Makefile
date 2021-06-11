#TARGETS=SKQU.stl
#all: ${TARGETS}

KEYCAP != perl -n -e'/^keycap_style\s*=\s*"(\S+)"/ && print $$1' < settings.scad
STEM != perl -n -e'/^stem_model\s*=\s*"(\S+)"/ && print $$1' < settings.scad

current: things/${STEM}-${KEYCAP}.stl things/${STEM}_mx-adapter.stl

update: include/keycap.scad include/stem.scad

include/keycap.scad : keycaps/${KEYCAP}.scad settings.scad
	ln -srf $< $@

include/stem.scad : stems/${STEM}.scad settings.scad
	ln -srf $< $@

things/%.stl : final.scad settings.scad include/keycap.scad include/stem.scad
	openscad -q --hardwarnings --render -o $@ $<

things/%_mx-adapter.stl: adapters/%.scad settings.scad adapters/util.scad adapters/mx-adapter.stl
	openscad -q --hardwarnings --render -o $@ $<

clean:
	rm ${TARGETS}
