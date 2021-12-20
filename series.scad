include <settings.scad>;
use <include/stem.scad>;

//translate([-10,-10,0]) assembled($fn=120, $inner_slop_x=-.05, $inner_slop_y=-.05);
//assembled($fn=120);
//translate([10,10,0]) assembled($fn=120, $inner_slop_x=.05, $inner_slop_y=.05);

x_range = [6:17];
y_range = [-6:6];


spacing= total_width+2;
x_tolerance = .02;
y_tolerance = x_tolerance;

combine_tolerances = true;

if (combine_tolerances) {
  vec = [each x_range];
  num = len(vec);
  root = ceil(sqrt(num));

  for(j = [0:root-1]) {
    for(k = [0:root-1]) {
      if (j*root + k < num) {
	i = vec[j*root + k];

	translate([j*spacing, k*spacing,0]) rotate([0, stem_model == "trackpoint-lp" ? 180 : 0, 0])
	  assembled($fn=120,
		    $inner_slop_x=i*x_tolerance,
		    $inner_slop_y=i*y_tolerance);
      }
    }
  }
} else {
  for(i = x_range) {
    for(j = y_range) {
      translate([i*spacing, j*spacing,0]) rotate([0, stem_model == "trackpoint-lp" ? 180 : 0, 0]) assembled($fn=120, $inner_slop_x=i*x_tolerance, $inner_slop_y=j*y_tolerance);
    }
  }
}
