include <../settings.scad>;
use <../keycaps/trackpoint-lp.scad>;
// must come second so it overrides cap()
use <../include/keycap.scad>;

use <../common/util.scad>;

print_width = .4;

extra_layers = 4*print_width*2;

switch_stem_base = 0;
switch_stem_clearance = 0.2; //.2;

switch_offset = switch_stem_base + switch_stem_clearance;

stemheight = effective_height - height_offset() - switch_offset;


inner_slop = .2;

stem_dia=4;

max_dia = 4.9;

min_clearance = 3 + 2*1;

module stemouter() {
  topdia = stem_dia;
  bottom_h=4;
  top_h = stemheight-bottom_h;
  difference() {
    union() {
      translate([0,0,bottom_h]) cylinder(d=topdia,h=top_h); //cube([topdia,topdia,top_h],true);
      translate([0,0,bottom_h+top_h]) rotate([180,0,0]) cylinder(d2=topdia,d1=max_dia,h=top_h-min_clearance);
    }

    if(!is_undef($inner_slop_x)) {
      translate([-1.5,topdia/2-.4,.1+bottom_h]) rotate([0,-90,-90]) linear_extrude(.5) text(str($inner_slop_x), 3);
    }
    if(!is_undef($inner_slop_y)) {
      translate([-topdia/2+.4,-1.5,.1+bottom_h]) rotate([0,-90,0]) linear_extrude(.5) text(str($inner_slop_y), 3);
    }

    *let(x=2*.85/sqrt(2),z=x)
    translate([0,0,bottom_h])
      rotate([0,45,45]) cube([x,20,z],true);
  }

  stemdia_x = 10;//adjusted_side_x(true) + extra_layers;
  stemdia_y = stemdia_x; //adjusted_side_y(true) + extra_layers;

  cylinder(d=stemdia_x,h=bottom_h);
  *difference() {
    translate([0,0,bottom_h/2]) cube([stemdia_x,stemdia_y,bottom_h],true);
    //translate([0,stemdia_y/2 -.4,bottom_h-.4]) cube([.8,.8,.8],center=true);
  }
}

module stem() {
  difference() {
    clampify() stemouter();

    let(d1=3.12+inner_slop, h=2.6-.2, gap=0,//.5,
	h2=h-switch_offset, d2=2*gap+d1/*, d3=1.1*/) difference() {
      *translate([0,0,-switch_offset]) cylinder($fn=60,d=d2,h=h);
      translate([0,0,-switch_offset]) cap_tplp();

      if(gap > 0) {
	rows = 2;
	columns = 6;
	a = gap;
	b = h2/rows/2;
	c = sqrt(a^2 + b^2);
	theta1 = atan(b/a);
	theta2 = 180 - 2 * theta1;
	d3 = c/(sin(theta2/2));
	//echo(a, b, c,  theta1, theta2, d3 );

	//#translate([0,0,-switch_offset]) cylinder($fn=60,d=d1,h=h);

	for(i=[0:rows-1])
	  rotational_clone(columns) rotate([0,0,45]) translate([(d1+d3)/2,0,b/2+b*i*2]) sphere($fn=120,d=d3);
      }
    }
  }
}

module mirrortate(samesides=true,m=[0,1,0]){
  if(samesides){
    children();
    mirror(m) children();
  }else{
    rotational_clone() children();
  }
}

module clampify(nowashers=true, samesides=true) {
  washerdia=3.8+.2;
  nutdia=3.5+.2;// + .05;
  screwhead=3+.2;
  screwdia=1.9;
  tabwidth=nowashers ? 6 : 6; //5.5;
  tablen=nowashers? 4 : 3.6;
  tabsep = 3.3;
  tabheight=washerdia;
  screwsep = 3;

  difference(){
    union() {
      children();
      *if(nowashers){
	extra_nut_cup = 0;//.65;
	rotate([0,0,45]) mirrortate(samesides) translate([-tabwidth/2-extra_nut_cup,tabsep/2,0]) cube([tabwidth+extra_nut_cup,tablen,tabheight]);
      }else{
	rotate([0,0,45]) mirrortate(samesides) translate([-tabwidth/2,tabsep/2,0]) cube([tabwidth,tablen,tabheight]);
      }
    }
    let(width=.85) {
      rotate([0,0,45]) mirrortate(samesides) translate([-width/2,-1,-.1]) cube([width,2*tablen,tabheight+.11]);
    }

    if(nowashers){
      	extra_nut_cup = .5;
	rotate([0,0,45])
	mirrortate(samesides) translate([0,screwsep,tabheight/2]) {
	rotate([0,90,0]) cylinder(d=screwdia,h=10,center=true);
	translate([-tabwidth/2,0,0]) rotate([0,-90,0]) cylinder(d=screwhead,h=10);
	translate([tabwidth/2-extra_nut_cup,-screwsep*2,0]) rotate([0,90,0]) rotate([0,0,90]) cylinder($fn=6,d=nutdia,h=10);
      }
    }else{
      rotate([0,0,45]) mirrortate(samesides) translate([0,screwsep,tabheight/2]) {
	rotate([0,90,0]) cylinder(d=screwdia,h=10,center=true);
	rotational_clone() translate([tabwidth/2,0,0]) rotate([0,90,0]) cylinder(d=tabheight,h=10);
      }
    }
  }
}

module assembled() {
  //echo(stemheight);
  //difference () {
    union() {
      stem();
      translate([0,0,stemheight]) rotate(keycap_rotation)
        intersection() {
        cap();
        cylinder(d=stem_dia,h=10);
      }
    }
    //translate([-5,-5,5]) cube([10,10,9]);
    //}
}


// preview
translate([0,0,switch_offset]) assembled($fn=24);
