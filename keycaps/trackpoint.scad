/*
 *  A mount for a full-sized Trackpoint rubber cap
 */

// ignores minimum_thickness, chamfer_style, etc so this isn't really needed atm
include <../settings.scad>;

// it may vary somewhat, but the height of my rubber cap is 6mm
function height_offset() = 6;

side = 4.5;
height = 2.5;

// this alias is for using when making a hole for a stem
module cap_trackpoint() {
  translate([0,0,height/2]) cube([side,side,height],true);
}

// this is for using as a cap
module cap() {
  cap_trackpoint();
}

cap($fn=12);
