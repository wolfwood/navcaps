include <../settings.scad>;
use <../keycaps/trackpoint-lp.scad>;
// must come second so it overrides cap()
use <../include/keycap.scad>;


basedia = 5;
stemdia = 4;
stemdia_inner = 2;

switch_stem_base = 0;
switch_stem_clearance = .2;

switch_offset = switch_stem_base + switch_stem_clearance;

stemheight = effective_height - height_offset() - switch_offset;


module stemouter() {
  neckheight = 2;
  baseheight = 2.5;

  if (stemheight < baseheight+(2*neckheight)) {
    union() {
      cylinder(stemheight, d=stemdia);
      cylinder(stemheight, d=basedia);
    }
  } else {
    cylinder(baseheight, d=basedia);
    translate([0,0,baseheight]) cylinder(neckheight, d1=basedia, d2=stemdia_inner);
    translate([0,0,baseheight+neckheight]) cylinder(stemheight-baseheight-(2*neckheight), d=stemdia_inner);

    if (keycap_style == "trackpoint-lp") {
      /* instead of another cone (which would leave a platform with a crisp edge sticking out beyond the keycap)
	 this tries to support a trackpoint-lp keycap with no overhang */
      translate([0,0,stemheight-neckheight]) intersection() {
	cap();
	//pick a shallower diameter so the cone is more flush with the cap
	cylinder(neckheight, d2=stemdia-.45, d1=stemdia_inner);
      }
    } else {
      translate([0,0,stemheight-neckheight]) cylinder(neckheight, d2=stemdia, d1=stemdia_inner);
    }
  }
}

module stem() {
  difference() {
    stemouter();
    translate([0,0,-switch_offset]) cap_tplp();
  }
}

module assembled() {
  union() {
    stem();
    translate([0,0,stemheight]) rotate(keycap_rotation) cap();
  }
}


// preview
translate([0,0,switch_offset]) assembled($fn=24);
