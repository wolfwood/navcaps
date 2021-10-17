/*
 *  A subtractive approach to producing a saddle kepcap
 */

include <../settings.scad>;

thumbdeflection = 15;
saddle_sheet = false;

cham_sphere_dia = auto_chamfer() ? minimum_thickness : 0;
thumbthickness = (saddle_sheet ? (minimum_thickness / cos(thumbdeflection)) : minimum_thickness) - cham_sphere_dia;
thumbdia = total_width - cham_sphere_dia;


module chamfercutter(arc=360/8, rotation=[0,0,0], center=true){
  //radius = (totalwidth/2)-(thumbthickness/2);

  //if (rotation != [0,0,0]) {
  radius = ((1/cos(rotation.y))*((total_width/2)/*-(thumbthickness/2)*/))-(thumbthickness/2);
  //}

  centering = [rotation.x,0,rotation.z - (arc/2)];
  if (!center) {
    centering = [rotation.x,0,rotation.z];
  }

  /*translate([0,0,tan(rotation.y)*totalwidth/2])*/ rotate(centering) rotate_extrude(angle=arc) {
    rotate([0,0,rotation.y]) translate([radius,0,0]) difference(){
      rotate([0,0,-rotation.y]) square(thumbthickness);
      circle(d=thumbthickness);
    }
  }
}

panel_width = total_width/3;
spacer=tan(thumbdeflection)*panel_width;
offset=panel_width/2;
depth= thumbthickness+(2*spacer);

function height_offset() = minimum_thickness + (saddle_sheet ? 0 : spacer);

// subtractive approach to 'carve' a saddle cap
module subtractivecap(chamfer=false, ridge=false){
  //translate([0,0,-spacer])
  union () {
  difference() {
    // workpiece
    cylinder(h=depth,d=total_width);

    //center
    translate([-offset,-offset,spacer+thumbthickness]) cube([panel_width, panel_width,depth]);

    // downslopes
    translate([offset,-offset,spacer+thumbthickness]) rotate([0,thumbdeflection,0])
      translate([-offset, 0,0]) cube([total_width, panel_width,depth]);
    translate([-offset,-offset,spacer+thumbthickness]) mirror([1,0,0]) rotate([0,thumbdeflection,0])
      translate([-offset,0,0]) cube([total_width, panel_width,depth]);

    if (chamfer) {
      translate([0,0,thumbthickness]) chamfercutter(41,[0,-thumbdeflection,0]);
      translate([0,0,thumbthickness]) mirror([1,0,0]) chamfercutter(41, [0,-thumbdeflection,0]);
    }
    // upslopes
    translate([-total_width/2,offset,spacer+thumbthickness]) rotate([thumbdeflection,0,0])  cube([total_width, total_width,depth]);
    translate([-total_width/2,-offset,spacer+thumbthickness]) mirror([0,1,0]) rotate([thumbdeflection,0,0]) cube([total_width, total_width,depth]);

    if (chamfer) {
      translate([0,0,thumbthickness]) chamfercutter(43, [0,thumbdeflection,90]);
      translate([0,0,thumbthickness]) mirror([0,1,0]) chamfercutter(43, [0,thumbdeflection,90]);
    }

    // quarters
    translate([offset, offset,spacer+thumbthickness])
      rotate([thumbdeflection,thumbdeflection,0])
      translate([-offset, 0,0]) cube([total_width, total_width,depth]);
    translate([-offset, offset,spacer+thumbthickness]) mirror([1,0,0])
      rotate([thumbdeflection,thumbdeflection,0])
      translate([-offset, 0,0]) cube([total_width, total_width,depth]);
    translate([offset, -offset,spacer+thumbthickness]) mirror([0,1,0])
      rotate([thumbdeflection,thumbdeflection,0])
      translate([-offset, 0,0]) cube([total_width, total_width,depth]);
    translate([-offset, -offset,spacer+thumbthickness]) rotate([0,0,180])
      rotate([thumbdeflection,thumbdeflection,0])
      translate([-offset, 0,0]) cube([total_width, total_width,depth]);


    //translate([0,0,thumbthickness]) rotate([0,0,-45]) chamfercutter(53, [-thumbdeflection,-thumbdeflection,0]);
    //translate([0,0,thumbthickness]) rotate([0,0,-45-180]) chamfercutter(53, [-thumbdeflection,-thumbdeflection,0]);


    //translate([0,0,thumbthickness]) rotate([0,0,45]) mirror([1,0,0]) chamfercutter(53, [-thumbdeflection,-thumbdeflection,0]);
    //translate([0,0,thumbthickness]) rotate([0,0,45+180]) mirror([1,0,0]) chamfercutter(53, [-thumbdeflection,-thumbdeflection,0]);



    // bottom chamfer
    if (chamfer) {
      translate([0,0,thumbthickness/2]) mirror([0,0,1]) chamfercutter(360);
    }
    //translate([0,0,thumbthickness/2]) chamfercutter(360);

      /*rotate_extrude(angle=360) {
      translate([(totalwidth/2)-(thumbthickness/2),0,0]) difference(){
      square(thumbthickness);
	circle(d=thumbthickness);
      }
      }*/
  }
  //translate([offset,0,spacer+thumbthickness+cham_sphere_dia-.5]) rotate([90,0,0]) cylinder(h=panel_width+4, d=.5, center=true);
  }
}

module saddle_sheet() {
  translate([0,0,-spacer]) difference() {
    subtractivecap(false);
    translate([0,0,-thumbthickness]) subtractivecap();
  }
}

module cap() {
  union () {
    if (auto_chamfer()) {
      minkowski(){
	if (saddle_sheet) {
	  saddle_sheet();
	}else{
	  subtractivecap(false);
	}
	// sphere is off-center so we don't grow in the -z direction and the cap stays positioned with the bottom on the origin
	translate([0,0,cham_sphere_dia/2]) sphere(d=cham_sphere_dia);
      }
    } else {
      if (saddle_sheet) {
	// XXX: implement manual chamfer?
	saddle_sheet();
      }else{
	subtractivecap(manual_chamfer());
      }
    }

    if (saddle_sheet) {
      translate([-(offset+.1),0,thumbthickness+cham_sphere_dia-.2]) rotate([90,0,0]) cylinder(h=panel_width+4, d=.75, center=true);
    } else {
      translate([-(offset+.1),0,spacer+thumbthickness+cham_sphere_dia-.2]) rotate([90,0,0]) cylinder(h=panel_width+4, d=.75, center=true);
    }
  }
}

cap($fn=48);
