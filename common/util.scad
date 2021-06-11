// utility functions

module rotational_clone(clones=2) {
  for(i=[0:clones-1] ) {
    rotate([0,0,i * (360/clones)]) children();
  }
}
