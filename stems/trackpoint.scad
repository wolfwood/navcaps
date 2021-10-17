include <../settings.scad>;
// used for cap_trackpoint()
use <../keycaps/trackpoint.scad>;
// must come second so it overrides cap() from trackpoint
use <../include/keycap.scad>;


stemdia = 6.5;
switch_stem_base = 0;
switch_stem_clearance = .1;

switch_offset = switch_stem_base + switch_stem_clearance;

stemheight = effective_height - height_offset() - switch_offset;

assert(stemheight >= 2.5 + minimum_thickness);

module stemouter() {
  cylinder(stemheight, d=stemdia);
}

module stem() {
  difference() {
    stemouter();
    translate([0,0,-switch_offset]) cap_trackpoint();
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
