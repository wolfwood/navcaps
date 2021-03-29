// give us finer grained renders, so holes are reasonable circular
$fn=128;

totalheight=10;
totalwidth=16;

thumbthickness = 0;
thumbdia = totalwidth-thumbthickness;
thumbdeflection = 15;

stemdia = 8;
stemheight = totalheight-thumbthickness;
holeside = 3.3;
holedepth = 3;


module stemoutter() {
  cylinder(stemheight+(thumbthickness/2), d=stemdia);
}

module stem() {
  difference() {
    stemoutter();
    cube([holeside,holeside,holedepth], true);
  }
}

module capsquare() {
  union() {
    cube([thumbdia/3, thumbdia/3,thumbthickness]);
    //translate([0,0,thumbthickness/2]) rotate([0,90,0]) cylinder(thumbdia/3,d=thumbthickness);
    //translate([0,0,thumbthickness/2]) rotate([-90,90,0]) cylinder(thumbdia/3,d=thumbthickness);
    //translate([0,thumbdia/3,thumbthickness/2]) rotate([0,90,0]) cylinder(thumbdia/3,d=thumbthickness);
    //translate([thumbdia/3,0,thumbthickness/2]) rotate([-90,90,0]) cylinder(thumbdia/3,d=thumbthickness);
  }
}

module capsquaredown(chamfer=true) {
  translate([0,0,thumbthickness]) rotate([0,thumbdeflection,0])
    translate([0,0,-thumbthickness]) union() {
    capsquare();

    if(chamfer){
      translate([thumbdia/3,0,thumbthickness/2]) rotate([-90,90,0]) cylinder(thumbdia/3,d=thumbthickness);
    }
  }
}

module capsquareup (chamfer=true) {
  translate([0,0,thumbthickness]) rotate([thumbdeflection,0,0]) translate([0,0,-thumbthickness]) union() {
    capsquare();

    if(chamfer){
      translate([0,thumbdia/3,thumbthickness/2]) rotate([0,90,0]) cylinder(thumbdia/3,d=thumbthickness);
    }
    // this bit is to plug the gap created by the rotation
    //translate([0,-.55,0]) capsquare();
  }
  //rotate([thumbdeflection,0,0]) cap();
}

module capcrosssection(chamfer=true) {
  union(){
    polygon([[0,0], [0, thumbthickness], [thumbdia/3,thumbthickness], [thumbdia/3,0]]);
    if(chamfer){
      translate([thumbdia/3,thumbthickness/2,0]) circle(d=thumbthickness);
    }
  }
}

module capquarter(chamfer=true) {
  difference() {
    union() {
      translate([0,0,thumbthickness])
	rotate([thumbdeflection,thumbdeflection,0])
	translate([0,0,-thumbthickness])
	union(){
	rotate_extrude(angle=90) capcrosssection(chamfer);
	//mirror([1,0,0])
	/*if(chamfer){
	  rotate([-90,90,0])
	    rotate_extrude(angle=-90)
	    rotate([0,0,90]) capcrosssection();
	  translate([0,0,thumbthickness])rotate([-90,180,-90])
	    rotate_extrude(angle=90)
	    rotate([0,0,90]) capcrosssection();
	    }*/
      }
      //rotate_extrude(angle=90) rotate capcrosssection();
      }
    // trim the top of the bridge material
    /*if(chamfer){
      translate([0,0,thumbthickness]) rotate([thumbdeflection,0,0]) translate([-thumbdia/3,-thumbdia/2,0]) cube([thumbdia, thumbdia,thumbthickness]);
// trim the bottom of the bridge material
      translate([0,0,0]) rotate([0,thumbdeflection,0]) translate([-thumbdia/3,-thumbdia/2,-thumbthickness]) cube([thumbdia, thumbdia,thumbthickness]);
      }*/
  }
}

module cap(chamfer=true) {
  offset=thumbdia/6;
  //hull() {
    union() {
      translate([-offset,-offset,0]) capsquare();

      translate([offset,-offset,0]) capsquaredown(chamfer);
      translate([-offset,-offset,0]) mirror([1,0,0]) capsquaredown(chamfer);

      translate([-offset,offset,0]) capsquareup(chamfer);
      translate([-offset,-offset,0]) mirror([0,1,0]) capsquareup(chamfer);

      translate([offset, offset,0]) capquarter(chamfer);
      translate([-offset, offset,0]) mirror([1,0,0]) capquarter(chamfer);

      translate([offset, -offset,0]) mirror([0,1,0]) capquarter(chamfer);
      translate([-offset, -offset,0]) rotate([0,0,180]) capquarter(chamfer);
    }
    //}
}

/*union() {
  offset=thumbdia/6;
  stem();
  translate([0,0,stemheight]) difference() {
    cap();
    //translate([0,0,-thumbthickness]) cap();

  }

  }*/
/*intersection(){
  translate([0,0,-5]) cylinder(h=10,d=thumbdia);
  cap();
  }*/

//capquarter();
//capsquaredown();
/*hull()
{
  //sphere(d=thumbthickness/2);
  union() {
    translate([0,0,thumbthickness/4]) rotate([0,90,0]) cylinder(thumbdia/3,d=thumbthickness/2);
    translate([0,0,thumbthickness/4]) rotate([-90,90,0]) cylinder(thumbdia/3,d=thumbthickness/2);
    translate([0,thumbdia/3,thumbthickness/4]) rotate([0,90,0]) cylinder(thumbdia/3,d=thumbthickness/2);
    translate([thumbdia/3,0,thumbthickness/4]) rotate([-90,90,0]) cylinder(thumbdia/3,d=thumbthickness/2);
    cube([thumbdia/3, thumbdia/3,thumbthickness/2]);
  }


  }*/

// subtractive cap

module chamfercutter(arc=360/8, rotation=[0,0,0], center=true){
  //radius = (totalwidth/2)-(thumbthickness/2);

  //if (rotation != [0,0,0]) {
  radius = ((1/cos(rotation.y))*((totalwidth/2)/*-(thumbthickness/2)*/))-(thumbthickness/2);
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

module subtractivecap(chamfer=true){
  spacer=tan(thumbdeflection)*totalwidth/3;
  offset=totalwidth/6;
  depth= thumbthickness+(2*spacer);

  translate([0,0,-spacer]) difference() {
    // workpiece
    cylinder(h=depth,d=totalwidth);

    //center
    translate([-offset,-offset,spacer+thumbthickness]) cube([totalwidth/3, totalwidth/3,depth]);

    // downslopes
    translate([offset,-offset,spacer+thumbthickness]) rotate([0,thumbdeflection,0])
      translate([-offset, 0,0]) cube([totalwidth, totalwidth/3,depth]);
    translate([-offset,-offset,spacer+thumbthickness]) mirror([1,0,0]) rotate([0,thumbdeflection,0])
      translate([-offset,0,0]) cube([totalwidth, totalwidth/3,depth]);

    if (chamfer) {
      translate([0,0,thumbthickness]) chamfercutter(41,[0,-thumbdeflection,0]);
      translate([0,0,thumbthickness]) mirror([1,0,0]) chamfercutter(41, [0,-thumbdeflection,0]);
    }
    // upslopes
    translate([-totalwidth/2,offset,spacer+thumbthickness]) rotate([thumbdeflection,0,0])  cube([totalwidth, totalwidth,depth]);
    translate([-totalwidth/2,-offset,spacer+thumbthickness]) mirror([0,1,0]) rotate([thumbdeflection,0,0]) cube([totalwidth, totalwidth,depth]);

    if (chamfer) {
      translate([0,0,thumbthickness]) chamfercutter(43, [0,thumbdeflection,90]);
      translate([0,0,thumbthickness]) mirror([0,1,0]) chamfercutter(43, [0,thumbdeflection,90]);
    }

    // quarters
    translate([offset, offset,spacer+thumbthickness])
      rotate([thumbdeflection,thumbdeflection,0])
      translate([-offset, 0,0]) cube([totalwidth, totalwidth,depth]);
    translate([-offset, offset,spacer+thumbthickness]) mirror([1,0,0])
      rotate([thumbdeflection,thumbdeflection,0])
      translate([-offset, 0,0]) cube([totalwidth, totalwidth,depth]);
    translate([offset, -offset,spacer+thumbthickness]) mirror([0,1,0])
      rotate([thumbdeflection,thumbdeflection,0])
      translate([-offset, 0,0]) cube([totalwidth, totalwidth,depth]);
    translate([-offset, -offset,spacer+thumbthickness]) rotate([0,0,180])
      rotate([thumbdeflection,thumbdeflection,0])
      translate([-offset, 0,0]) cube([totalwidth, totalwidth,depth]);


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
}

//subtractivecap(false);

union() {
  stem();
  translate([0,0,stemheight]) minkowski(){
    subtractivecap(false);
    sphere(d=2);
  }
}

//translate([0,0,spacer+thumbthickness]) rotate([0,thumbdeflection,0]) chamfercutter();
//translate([0,0,thumbthickness])  rotate([0,-thumbdeflection,90]) chamfercutter(41);
//translate([0,0,thumbthickness]) rotate([0,-thumbdeflection,90]) chamfercutter(41);
//translate([0,0,thumbthickness]) mirror([0,1,0]) rotate([0,-thumbdeflection,90]) chamfercutter(41);
/*rotate([0,0,-thumbdeflection]) translate([((1/cos(20))*totalwidth/2) -(thumbthickness/2),0,0]) difference(){
    square(thumbthickness);
    circle(d=thumbthickness);
    };*/
//translate([0,0,spacer+thumbthickness]) chamfercutter(41,[0,-thumbdeflection,0]);
//chamfercutter(41,[0,-thumbdeflection,0]);
//radius = ((1/cos(20))*totalwidth/2) -(thumbthickness/2);
/*rotate_extrude(angle=arc) {
     translate([radius-1,0,0]) difference(){
      square(thumbthickness);
      translate([-1,0,0]) rotate([0,0,-20]) translate([1,0,0]) circle(d=thumbthickness);
    }
*/
//rotate([0,0,-20]) translate([1,0,0]) circle(d=thumbthickness);
//translate([0,0,thumbthickness/2]) mirror([0,0,1]) chamfercutter(360);
