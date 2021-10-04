include <../settings.scad>;
use <../include/keycap.scad>;

stemdia = 6.6;
switch_stem_base = 2.9 - 2.3; // from datasheet
switch_stem_height = 4.45 - 2.3; // from datasheet

switch_stem_clearance = 0.3 + 2*vertical_slop; // from datasheet

switch_offset = switch_stem_base + switch_stem_clearance;
holedepth = switch_stem_height - switch_offset;

stemheight = effective_height - height_offset() - switch_offset;
holeside_raw = 2.0; // from datasheet

// adjust for FDM imprecision
holeside = holeside_raw + inner_slop;

//assert(stemheight >= holedepth, str(stemheight, " is less than ", holedepth));

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

// see README for the gf*mm calculation from the RKJXS datasheet values
echo(str("  Estimated operating force is ", 550 / effective_height, " gf"));
