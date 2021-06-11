/*
 * This adapter is for SKRHACE010 and SKRHADE010 (with guide bosses).
 * the A and B variants are slightly smaller (which isn't useful in this case) and much less reliable so I didn't
 * model them, but but it should be easy to adapt this model by changing the switch_* values to match the datasheet
 */

include <util.scad>;
include <../settings.scad>;


/* my switch measurments are a bit tighter than the spec sheet says, the slop factor will make up the difference,
 * but we want a tight fit to hold the switch in place so this may need to be tuned
 */
switch_side = 7.4; // 'x' in the dimension table of the data sheet says 7.45 / 7.5
switch_cropped_corner = 8.5; // 'c' in the table says 8.7
switch_height = 1.85; // 'h' in the table
switch_boss_dia = 0.95; // PC Board Mounting diagram suggests a 1.05 mm and a .75 mm hole
switch_boss_height = 0.5; // diagram says 0.5


// good enough if you want to solder the switch with the wires already passed through the adapter
module basic_SKRH_adapter() {
  difference() {
    // the shape that fits the switch plate hole
    mx_blank();

    // the basic shape of the switch
    translate([0,0,3]) intersection() {
      rotate([0,0,45]) cube([switch_side,switch_side,switch_height+vertical_slop*2], true);
      cube([switch_cropped_corner,switch_cropped_corner,switch_height+vertical_slop*2],true);
    }

    /* guide boss holes for the SKRHADE variant
     * NOTE: bosses are actually different sizes (probably so you don't solder the switch backwards),
     * but to me, not being reversable seems like an anti-feature, so we only use the larger size.
     */
    rotate([0,0,45]) translate([3.8/2,0,4-.5-switch_height-2*vertical_slop]) cylinder($fn=60, h=switch_boss_height+vertical_slop, d=switch_boss_dia+inner_slop);
    rotate([0,0,180+45]) translate([3.8/2,0,4-.5-switch_height-2*vertical_slop]) cylinder($fn=60, h=switch_boss_height+vertical_slop, d=switch_boss_dia+inner_slop);

    // holes to expose contacts and allow wires to pass
    rotate([0,0,-45]) translate([switch_side/2,0,2])  cube([2,4.7,4+vertical_slop*2], true);
    rotate([0,0,180-45]) translate([switch_side/2,0,2])  cube([2,4.7,4+vertical_slop*2], true);
  }
}

// an adapter with channels for wires so we can add and remove adapter from an already soldered switch
module SKRH_adapter() {
  difference() {
    basic_SKRH_adapter();
    translate([-6,2.16,2]) cube([5,1, 4+vertical_slop*2], true);
    translate([6,-2.16,2]) cube([5,1, 4+vertical_slop*2], true);
  }
}

SKRH_adapter();
