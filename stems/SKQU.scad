include <../settings.scad>;
use <../include/keycap.scad>;


stemdia = 6.5;
switch_stem_height = 8;
switch_stem_base = 4.5;
switch_stem_clearance = .5;

switch_offset = switch_stem_base + switch_stem_clearance;
holedepth = switch_stem_height - switch_offset;

stemheight = effective_height - height_offset() - switch_offset;
holeside = 3.2;


module stemouter() {
  cylinder(stemheight, d=stemdia);
}

module stem() {
  difference() {
    stemouter();
    translate([0,0,holedepth/2]) cube([holeside,holeside,holedepth], true);
  }
}

module assembled() {
  union() {
    stem();
    translate([0,0,stemheight]) rotate(keycap_rotation) cap();
  }
}


// preview
translate([0,0,switch_offset]) assembled($fn=24);

// see README for the gf*mm calcuation from the SQKU datasheet values
echo(str("  Estimated operating force is ", 1410 / effective_height, " gf"));
