include <settings.scad>;
use <include/stem.scad>;


x_range = [-2:0];
y_range = x_range;

spacing= 8;
tolerance = .025;

combine_tolerances = true;

if (combine_tolerances) {
  for(i = x_range) {
    translate([i*spacing, i*spacing,0]) assembled($fn=120, $inner_slop_x=i*tolerance, $inner_slop_y=i*tolerance);
  }
} else {
  for(i = x_range) {
    for(j = y_range) {
      translate([i*spacing, j*spacing,0]) assembled($fn=120, $inner_slop_x=i*tolerance, $inner_slop_y=j*tolerance);
    }
  }
 }
