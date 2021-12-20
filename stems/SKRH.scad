include <../settings.scad>;
use <../include/keycap.scad>;

/* tuned on a Prusa MK3 using .20 mm layer height. enable printing of external perimeters first for accurate dimensions.
 * recommendation is to print upright and don't enable supports for the bridging over the switch hole (which plug the hole).
 * if the keycap sits too high on the switch you can use the vertical slop to try to account for the droop in the bridging,
 * otherwise you can try upside-down with supports.
 * I experienced a lot of variability from print to print, especially upside-down.
 * letting the machine cool somewhat between prints seemed to help.
 */
vertical_slop = 0.4;
inner_slop = printer == "prusa" ? .015 : "cr10" ? .25 : 0;
//outer_slop = 0.2;

stemdia = 6.6;
switch_stem_base = 3 - 1.85; // from datasheet
switch_stem_height = 2 + switch_stem_base; // from datasheet

switch_stem_clearance = 0.3; // from datasheet

switch_offset = switch_stem_base + switch_stem_clearance;
holedepth = switch_stem_height - switch_offset + vertical_slop;

stemheight = effective_height - height_offset() - switch_offset;
holeside_raw = 1.95; // from datasheet

// adjust for FDM imprecision
function holeside_x() = holeside_raw + inner_slop + (is_undef($inner_slop_x) ? 0 : $inner_slop_x);
function holeside_y() = holeside_raw + inner_slop + (is_undef($inner_slop_y) ? 0 : $inner_slop_y);

if (keycap_style == "trackpoint-lp") {
  assert(stemheight >= holedepth, str("stem height ", stemheight, " must be at least ", holedepth, ", the depth of the switch stem hole"));
} else {
  assert(stemheight >= minimum_thickness, str("stem height ", stemheight, " is less than the minimum thickness ", minimum_thickness));
}

module stemouter() {
  cylinder(stemheight, d=stemdia);
}

module stem() {
  difference() {
    stemouter();
    translate([0,0,holedepth/2]) cube([holeside_x(),holeside_y(),holedepth], true);
  }
}

module assembled() {
  difference() {
    union() {
      stemouter();
      translate([0,0,stemheight]) rotate(keycap_rotation) cap();
    }
    translate([0,0,holedepth/2]) cube([holeside_x(),holeside_y(),holedepth], true);
  }
}


// preview
translate([0,0,switch_offset]) assembled($fn=24);

// see README for the gf*mm calculation from the SKRH datasheet values
echo(str("  Estimated operating force is ", 550 / effective_height, " gf"));
