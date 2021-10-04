/*
 * This adapter is for SKRHACE010 and SKRHADE010 (with guide bosses).
 * the A and B variants are slightly smaller (which isn't useful in this case) and much less reliable so I didn't
 * model them, but but it should be easy to adapt this model by changing the switch_* values to match the datasheet
 */


/* tuned on a Prusa MK3 using .20 mm layer height. supports are helpful but not necessarily required. */
vertical_slop = 0.1;
switch_inner_slop = 0.1;
//switch_corner_inner_slop = 0.05;
boss_inner_slop = 0.05;

include <../settings.scad>;
use <util.scad>;
use <../common/util.scad>




switch_side = 11.9; // datasheet says 11.7 but mine definitely measures more
switch_roomy_corner = 12.3; // datasheet says max 12.3, I measure 12.2. don't want any contact with this plastic
switch_height = 2.2; // datasheet says 2.3
switch_boss_dia = [1.3, 0.9]; // from datasheet PC Board diagram
switch_boss_height = 0.8; // from datasheet
switch_boss_separation = 6.6;
switch_boss_deflection = -45;

// good enough if you want to solder the switch with the wires already passed through the adapter
module basic_RKJXS_adapter() {
  difference() {
    /* the outer shape that fits the switch plate hole */
    mx_blank();
    blank_height = 5;
    blank_lip = 0.8;

    pocket_height = switch_height + vertical_slop + blank_lip;
    switch_floor = blank_height - pocket_height;

    /* the basic shape of the switch */
    translate([0,0,blank_height]) intersection() {
      cube([switch_side+switch_inner_slop,switch_side+switch_inner_slop,pocket_height*2], true);
      // only roomy at upper left and lower right
      rotate([0,0,45]) cube([switch_side+switch_inner_slop,switch_roomy_corner+switch_inner_slop,pocket_height*2],true);
    }

    /* guide boss holes
     * NOTE: bosses are different sizes
     */
    boss_position = [0, switch_boss_separation/2, switch_floor];
    rotate([0,0,switch_boss_deflection]) translate(boss_position) cube([switch_boss_dia[0]+boss_inner_slop,switch_boss_dia[0]+boss_inner_slop,2*(switch_boss_height+vertical_slop)], true) /*cylinder($fn=60, h=switch_boss_height+2*vertical_slop, d=switch_boss_dia[0]+boss_inner_slop)*/;
    rotate([0,0,180+switch_boss_deflection]) translate(boss_position) cube([switch_boss_dia[1]+boss_inner_slop,switch_boss_dia[1]+boss_inner_slop,2*(switch_boss_height+vertical_slop)], true) /*cylinder($fn=60, h=switch_boss_height+2*vertical_slop, d=switch_boss_dia[1]+boss_inner_slop)*/;


    /* holes to expose contacts and allow wires to pass */
    bore = 2;

    rotational_clone(4) translate([switch_side/2,0,2])  cylinder(d=bore,h=2*(blank_height+vertical_slop), center=true);

    // non-functional 'E' contacts
    //rotate([0,0,45]) translate([switch_side/2,0,2])  cylinder(d=bore,h=4+vertical_slop*2, center=true);
    //rotate([0,0,180+45]) translate([switch_side/2,0,2])  cylinder(d=bore,h=4+vertical_slop*2, center=true);

    rotational_clone(2) rotate([0,0,90]) translate([switch_side/2-bore/2,2.8,2])  cylinder(d=bore,h=2*(blank_height+vertical_slop), center=true);


    /* The switch adapter is not rotatable, so we add orientation markings to help get the swtich in the right position */

    // match the dot on top of the switch
    translate([0,switch_roomy_corner/2+1.2,blank_height]) /*cylinder(h=0.5,d=.7,center=true)*/ cube([.5,.5,.7],true);

    // shoulders to match the white plastic on the switch
    rotational_clone(2) translate([-switch_roomy_corner/2+1.7,switch_roomy_corner/2-1.7,blank_height]) intersection() {
      cube([3,3,1], true);
      rotate([0,0,-45]) translate([-1,0,0]) cube([.75,3,1], true);
    }
  }
}

// an adapter with channels for wires so we can add and remove adapter from an already soldered switch
module RKJXS_adapter() {
  difference() {
    basic_RKJXS_adapter();
    //translate([-6,2.16,2]) cube([5,1, 4+vertical_slop*2], true);
    //translate([6,-2.16,2]) cube([5,1, 4+vertical_slop*2], true);
  }
}

RKJXS_adapter($fn=60);
