/*
 *  A saddle with a nearly uniform thickness
 */

include <../settings.scad>;

/*
 * saddle_sheet implementation is coupled to the saddle (specifically the thumbdeflection angle and the spacer
 *   calculated from it) so the impelentation is in saddle.scad and controlled by the saddle_sheet bool.
 *  module cap() is redefined here overriding the other.
 */
include <saddle.scad>;
saddle_sheet = true;

// XXX: why can't I use thumbdeflection from saddle.scad even when I include???
//thumbthickness = (minimum_thickness / cos(15)) - cham_sphere_dia;

/*
module cap() {
  if (auto_chamfer()) {
    minkowski(){
      saddle_sheet();
      // sphere is off-center so we don't grow in the -z direction and the cap stays positioned with the bottom on the origin
      translate([0,0,cham_sphere_dia/2]) sphere(d=cham_sphere_dia);
    }
  }
  }*/

///*translate([total_width+5,0,0])*/ cap($fn=12);
