/*
 *  A mount for a low profile Trackpoint rubber cap
 */

// ignores minimum_thickness, chamfer_style, etc so this isn't really needed atm
include <../settings.scad>;
use <../common/util.scad>

$inner_slop_x = 0.0;
$inner_slop_y = -0.0;
outer_slop = 0.1;
print_width = .4;
layer_height=.2;
first_layer=.2;

// it may vary somewhat, but the height of my rubber cap is 5mm
function height_offset() = 5;

side = 2.5;
raw_height=2.5;
function height(stem=true) = (stem?first_layer:0) + floor((raw_height-(stem?first_layer:0))/layer_height)*layer_height;

function adjusted_side_x(stem=true) = stem ? side + $inner_slop_x : side - outer_slop;
function adjusted_side_y(stem=true) = stem ? side + $inner_slop_y : side - outer_slop;
// this alias is for using when making a hole for a stem
module cap_tplp(stem=true) {
  //adjusted_side = adjusted_side();
  adjusted_height = height(stem) + (stem?0*layer_height:0);

  translate([0,0,adjusted_height/2]) cube([adjusted_side_x(stem=stem),adjusted_side_y(stem=stem),adjusted_height],true);
  if(stem) {
    let(inside=.2,outside=print_width,s=inside+outside) {
      translate([adjusted_side_x(stem=stem)/2-inside,adjusted_side_y(stem=stem)/2-inside,0]) cube([s,s,adjusted_height]);
      translate([-adjusted_side_x(stem=stem)/2-outside,-adjusted_side_y(stem=stem)/2-outside,0]) cube([s,s,adjusted_height]);
      translate([adjusted_side_x(stem=stem)/2-inside,-adjusted_side_y(stem=stem)/2-outside,0]) cube([s,s,adjusted_height]);
      translate([-adjusted_side_x(stem=stem)/2-outside,adjusted_side_y(stem=stem)/2-inside,0]) cube([s,s,adjusted_height]);
    }
  }
}

// this is for using as a cap
module cap() {
  cap_tplp(stem=false);
}

cap($fn=12);
