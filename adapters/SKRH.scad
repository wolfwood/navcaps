/*
 * This adapter is for SKRHACE010 and SKRHADE010 (with guide bosses).
 * the A and B variants are slightly smaller (which isn't useful in this case) and much less reliable so I didn't
 * model them, but it should be easy to adapt this model by changing the switch_* values to match the datasheet
 */


/* tuned on a Prusa MK3 using .20 mm layer height. supports are helpful but not necessarily required. */
vertical_slop = 0.1;
switch_inner_slop = 0.0;
switch_corner_inner_slop = 0.05;
boss_inner_slop = 0.05;
//outer_slop = 0.2;

include <util.scad>;
include <../settings.scad>;
include <../common/util.scad>

/* my switch measurments are a bit tighter than the spec sheet says, the slop factor will make up the difference,
 * but we want a tight fit to hold the switch in place so this may need to be tuned
 */
switch_side = 7.4; // 'x' in the dimension table of the data sheet says 7.45 / 7.5 , I measured 7.4
switch_cropped_corner = 8.5; // 'c' in the table says 8.7, I measured 8.5
switch_height = 1.85; // 'h' in the table
switch_boss_dia = 1.05; // PC Board Mounting diagram suggests a 1.05 mm and a .75 mm hole, I measured 0.95
switch_boss_height = 0.5; // diagram says 0.5
switch_boss_separation = 3.8;

// good enough if you want to solder the switch with the wires already passed through the adapter
module basic_SKRH_adapter() {
  difference() {
    // the shape that fits the switch plate hole
    mx_blank();
    blank_height = 4;
    blank_lip = 1.2;

    pocket_height = switch_height + vertical_slop + blank_lip;
    switch_floor = blank_height - pocket_height;

    // the basic shape of the switch
    translate([0,0,blank_height]) intersection() {
      rotate([0,0,45]) cube([switch_side+switch_inner_slop,switch_side+switch_inner_slop,2*pocket_height], center=true);
      cube([switch_cropped_corner+switch_corner_inner_slop,switch_cropped_corner+switch_corner_inner_slop,2*pocket_height],center=true);
    }

    /* guide boss holes for the SKRHADE variant
     * NOTE: bosses are actually different sizes (probably so you don't solder the switch backwards),
     * but to me, not being reversable seems like an anti-feature, so we only use the larger size.
     */
    rotational_clone(2) rotate([0,0,45])  translate([switch_boss_separation/2,0,switch_floor]) cube([switch_boss_dia+boss_inner_slop,switch_boss_dia+boss_inner_slop,2*(switch_boss_height+vertical_slop)], center=true);

    // holes to expose contacts and allow wires to pass
    rotational_clone(2) rotate([0,0,-45])  translate([switch_side/2,0,2])  cube([2,4.7,blank_height+vertical_slop*2], true);

    // scoring to make flexing the holder easier - not needed now that adapter is thinner
    //translate([0,0,switch_floor]) rotate(45) rotate([90,0,0]) rotate([0,0,45]) cube([.5,.5,6], true);
  }
}

// an adapter with channels for wires so we can add and remove adapter from an already soldered switch
module SKRH_adapter() {
  difference() {
    basic_SKRH_adapter();
    rotational_clone(2) translate([-6,2.16,2]) cube([5,2, 4+vertical_slop*2], true);
  }
}

SKRH_adapter();
