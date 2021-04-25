#TARGETS=SKQU.stl
#all: ${TARGETS}

KEYCAP != perl -n -e'/^keycap_style\s*=\s*"(\S+)"/ && print $$1' < settings.scad
STEM != perl -n -e'/^stem_model\s*=\s*"(\S+)"/ && print $$1' < settings.scad

update: include/keycap.scad include/stem.scad

include/keycap.scad : keycaps/${KEYCAP}.scad settings.scad Makefile
	ln -srf $< $@

include/stem.scad : stems/${STEM}.scad settings.scad Makefile
	ln -srf $< $@

%.stl : final.scad settings.scad include/keycap.scad include/stem.scad
	openscad -q --hardwarnings --render -o $@ $<

clean:
	rm ${TARGETS}
