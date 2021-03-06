include <../settings.scad>;
use <../include/keycap.scad>;

inner_slop = .1;

stemdia = 6.6;
switch_stem_height = 8;
switch_stem_base = 3.5;
switch_stem_clearance = .5;

switch_offset = switch_stem_base + switch_stem_clearance;
holedepth = switch_stem_height - switch_offset;

stemheight = effective_height - height_offset() - switch_offset;
holeside_raw = 3.2;
// adjust for FDM imprecision
holeside = holeside_raw + inner_slop;

assert(stemheight >= thickness, str(stemheight, " is less than ", thickness));

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
  // NOTE - this allows the hole to extend into the keycap
  difference() {
    union() {
      stemouter();
      translate([0,0,stemheight]) rotate(keycap_rotation) cap();
    }
    translate([0,0,holedepth/2]) cube([holeside,holeside,holedepth], true);
  }
}


// preview
translate([0,0,switch_offset]) assembled($fn=24);

// see README for the gf*mm calcuation from the SQKU datasheet values
echo(str("  Estimated operating force is ", 1410 / effective_height, " gf"));
