/*
 *  A ring segment the thumb can wrap around for up-down and push against for left-right
 */

include <../settings.scad>;
use <../common/util.scad>;
use <../common/chord.scad>;

function height_offset() = minimum_thickness;

angle = 30;

module banana(){
  h = total_width - minimum_thickness;
  d = minimum_thickness;
  a = 45;
  chord = normalize_chord([h,a,0]);
  r = chord[2];

  // spheres get constructed like a globe, so in order to make the longitudes line up with the cylinder faces,
  // we make the bar vertically then rotate the whole thing
  translate([0,0,minimum_thickness/2]) rotate([angle,0,0]) rotate([0,90,0]) translate([-r,0,0]) union(){
    rotate([90,0,0]) rotate(-a/2) rotate_extrude(angle=a) translate([r,0,0]) circle(d=d);
    rotate([0,-a/2,0]) translate([r,0,0]) sphere(d=d);
    rotate([0,a/2,0]) translate([r,0,0]) sphere(d=d);
  }
}

module cap() {
  banana();
}

cap($fn=48);
