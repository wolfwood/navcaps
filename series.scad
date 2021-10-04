include <settings.scad>;
use <include/stem.scad>;

translate([-10,-10,0]) assembled($fn=120, $inner_slop_x=-.05, $inner_slop_y=-.05);
assembled($fn=120);
translate([10,10,0]) assembled($fn=120, $inner_slop_x=.05, $inner_slop_y=.05);
