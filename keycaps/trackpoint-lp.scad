/*
 *  A mount for a low profile Trackpoint rubber cap
 */

// ignores minimum_thickness, chamfer_style, etc so this isn't really needed atm
include <../settings.scad>;

// it may vary somewhat, but the height of my rubber cap is 5mm
function height_offset() = 5;

side = 2.5;
height = 2.5;

// this alias is for using when making a hole for a stem
module cap_tplp() {
  translate([0,0,height/2]) cube([side,side,height],true);
}

// this is for using as a cap
module cap() {
  cap_tplp();
}

cap($fn=12);
