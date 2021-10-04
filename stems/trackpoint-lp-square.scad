include <../settings.scad>;
use <../keycaps/trackpoint-lp.scad>;
// must come second so it overrides cap()
use <../include/keycap.scad>;

print_width = .4;

extra_layers =4*print_width*2;
stemdia_x = adjusted_side_x(true) + extra_layers;
stemdia_y = adjusted_side_y(true) + extra_layers;

switch_stem_base = 0;
switch_stem_clearance = 0.001; //.2;

switch_offset = switch_stem_base + switch_stem_clearance;

stemheight = effective_height - height_offset() - switch_offset;


module stemouter() {
  topdia = 4;
  bottom_h=4;
  top_h = stemheight-bottom_h;
  difference() {
    translate([0,0,top_h/2+bottom_h]) cube([topdia,topdia,top_h],true);
    if(!is_undef($inner_slop_x)) {
      translate([-1.5,topdia/2-.4,.1+bottom_h]) rotate([0,-90,-90]) linear_extrude(.5) text(str($inner_slop_x), 3);
    }
    if(!is_undef($inner_slop_y)) {
      translate([-topdia/2+.4,-1.5,.1+bottom_h]) rotate([0,-90,0]) linear_extrude(.5) text(str($inner_slop_y), 3);
    }

  }

  difference() {
    translate([0,0,bottom_h/2]) cube([stemdia_x,stemdia_y,bottom_h],true);
    translate([0,stemdia_y/2 -.4,bottom_h-.4]) cube([.8,.8,.8],center=true);
  }
}

module stem() {
  difference() {
    stemouter();
    translate([0,0,-switch_offset]) cap_tplp();

  }
}

module assembled() {
  //difference () {
    union() {
      stem();
      translate([0,0,stemheight]) rotate(keycap_rotation) cap();
    }
    //translate([-5,-5,5]) cube([10,10,9]);
    //}
}


// preview
translate([0,0,switch_offset]) assembled($fn=24);
