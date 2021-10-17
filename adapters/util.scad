
module mx_blank(footer=1) {
  translate([0,0,footer]) {
    import("mx-adapter.stl");
    translate([0,0,2]) cube([12,12,4], true);
  }
  translate([0,0,footer/2]) cube([13.5165,13.835,footer], true);
}

*mx_blank();
