/*
 *  A bar the thumb can wrap around for up-down and push flat on for left-right
 */

include <../settings.scad>;
use <../common/util.scad>;

function height_offset() = minimum_thickness;

module bar(){
  h=total_width - minimum_thickness;
  d = minimum_thickness;
  // spheres get constructed like a globe, so in order to make the longitudes line up with the cylinder faces,
  // we make the bar vertically then rotate the whole thing
  translate([0,0,d/2]) rotate([0,90,0]) {
    cylinder(d=d, h=h, center=true);
    translate([0,0,h/2]) sphere(d=d);
    translate([0,0,-h/2]) sphere(d=d);
  }
}

module cap() {
  bar();
}

cap($fn=48);
