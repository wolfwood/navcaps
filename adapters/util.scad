
module mx_blank() {
  footer = 1;
  translate([0,0,footer]) union() {
    import("mx-adapter.stl");
    translate([0,0,2]) cube([12,12,4], true);
    translate([0,0,0]) cube([13.5165,13.835,footer*2], true);

  }
}

*mx_blank();
