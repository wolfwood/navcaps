/*
 *  A ring segment the thumb can wrap around for up-down and push against for left-right
 */

include <../settings.scad>;
use <../common/util.scad>;
use <../common/chord.scad>;

function height_offset() = minimum_thickness;

module dome(){
  d = minimum_thickness;

  // spheres get constructed like a globe, so in order to make the longitudes line up with the cylinder faces,
  // we make the bar vertically then rotate the whole thing
  translate([0,0,minimum_thickness/2]) sphere(d=d);
}

module cap() {
  dome();
}

cap($fn=48);
