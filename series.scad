include <settings.scad>;
use <include/stem.scad>;

//translate([-10,-10,0]) assembled($fn=120, $inner_slop_x=-.05, $inner_slop_y=-.05);
//assembled($fn=120);
//translate([10,10,0]) assembled($fn=120, $inner_slop_x=.05, $inner_slop_y=.05);

x_range = [-10:0];
y_range = x_range;

spacing= 7;
tolerance = .01;

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
