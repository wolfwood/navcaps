
module mx_blank() {
  union() {
    import("mx-adapter.stl");
    translate([0,0,2]) cube([12,12,4], true);
  }
}
