 /*
 *  A subtractive approach to producing a cup keycap
 */

include <../settings.scad>;
use <../common/util.scad>;

chin_ratio = 1.25;
chin_angle = 20;
thumbdeflection = 20;
cup_sheet = false;

cham_sphere_dia = auto_chamfer() ? minimum_thickness : 0;
thumbthickness = (cup_sheet ? (minimum_thickness / cos(thumbdeflection)) : minimum_thickness) - cham_sphere_dia;
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

function height_offset() = minimum_thickness + (cup_sheet ? 0 : spacer);

// subtractive approach to 'carve' a cup cap
module subtractivecap(chamfer=false, ridge=false, angle=0){
  //translate([0,0,-spacer])
  union () {
  difference() {
    // workpiece
    union(){
      cylinder(h=depth+1,d=total_width);
      difference() {
	scale([1,chin_ratio,1]) cylinder(h=2+depth,d=total_width);
	x= 100;
	translate([-x/2,0,0]) cube([x,x,x]);
      }
    }

    //center
    translate([-offset,-offset,spacer+thumbthickness]) cube([panel_width, panel_width,depth]);

    if (chamfer) {
      translate([0,0,thumbthickness]) chamfercutter(41,[0,-thumbdeflection,0]);
      translate([0,0,thumbthickness]) mirror([1,0,0]) chamfercutter(41, [0,-thumbdeflection,0]);
    }
    // upslopes
    translate([-panel_width/2,offset,spacer+thumbthickness]) rotate([thumbdeflection,0,0])  cube([panel_width, total_width, 2*depth]);
    rotate([0,0,90]) translate([-panel_width/2,offset,spacer+thumbthickness]) rotate([thumbdeflection,0,0])  cube([panel_width, total_width,2*depth]);
    rotate([0,0,-90]) translate([-panel_width/2,offset,spacer+thumbthickness]) rotate([thumbdeflection,0,0])  cube([panel_width, total_width,2*depth]);
    rotate([0,0,180]) translate([-panel_width/2,offset,spacer+thumbthickness]) rotate([thumbdeflection,0,0])  cube([panel_width, panel_width,2*depth]);

    //  chin
    //rotate([0,0,180]) translate([-panel_width/2,offset,spacer+thumbthickness]) rotate([thumbdeflection,0,0])
    //  rotate([chin_angle,0,0]) translate([0,panel_width,0]) cube([panel_width, total_width,depth]);
    rotate([0,0,180]) translate([-panel_width/2,offset,spacer+thumbthickness]) rotate([thumbdeflection,0,0]) translate([0,panel_width,0])  rotate([angle,0,0]) cube([panel_width, total_width,2*depth]);

    if (chamfer) {
      translate([0,0,thumbthickness]) chamfercutter(43, [0,thumbdeflection,90]);
      translate([0,0,thumbthickness]) mirror([0,1,0]) chamfercutter(43, [0,thumbdeflection,90]);
    }

    // quarters
    rotational_clone(4)
      translate([offset, offset,spacer+thumbthickness])
      hull() {
        rotate([thumbdeflection,0,0])  translate([-.1,0,0]) cube([.1, total_width, depth]);
        rotate([0,-thumbdeflection,0]) translate([0,-.1,0]) cube([total_width, .1, depth]);
      }



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

module cup_sheet() {
  translate([0,0,-spacer]) difference() {
    subtractivecap(false, angle=chin_angle);
    translate([0,0,-thumbthickness]) subtractivecap();
  }
}

module cap() {
  union () {
    if (auto_chamfer()) {
      minkowski(){
	if (cup_sheet) {
	  cup_sheet();
	}else{
	  subtractivecap(false, angle=chin_angle);
	}
	// sphere is off-center so we don't grow in the -z direction and the cap stays positioned with the bottom on the origin
	translate([0,0,cham_sphere_dia/2]) sphere(d=cham_sphere_dia);
      }
    } else {
      if (cup_sheet) {
	// XXX: implement manual chamfer?
	cup_sheet();
      }else{
	subtractivecap(manual_chamfer());
      }
    }

    *if (cup_sheet) {
      translate([-(offset+.1),0,thumbthickness+cham_sphere_dia-.2]) rotate([90,0,0]) cylinder(h=panel_width+4, d=.75, center=true);
    } else {
      translate([-(offset+.1),0,spacer+thumbthickness+cham_sphere_dia-.2]) rotate([90,0,0]) cylinder(h=panel_width+4, d=.75, center=true);
    }
  }
}

cap($fn=48);
