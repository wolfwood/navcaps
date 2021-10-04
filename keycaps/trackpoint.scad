/*
 *  A mount for a full-sized Trackpoint rubber cap
 */

// ignores minimum_thickness, chamfer_style, etc so this isn't really needed atm
include <../settings.scad>;

vertical_slop = 0.1;
inner_slop = 0.1;
outer_slop = 0.1;


// I've seen both 6mm and 5mm tall caps, but the 6mm tend to come off when used as a thumbstick
function height_offset() = 5;

side = 4.5;
height = 2.5;

// this alias is for using when making a hole for a stem
module cap_trackpoint(stem=true) {
  adjusted_side = stem ? side + inner_slop : side - outer_slop;
  translate([0,0,height/2]) cube([adjusted_side,adjusted_side,height],true);
}

// this is for using as a cap
module cap() {
  cap_trackpoint(stem=false);
}

cap($fn=12);
