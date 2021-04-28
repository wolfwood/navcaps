include <settings.scad>;
use <include/stem.scad>;

// I though rotating so keycap is aligned was better for feel, but stem aligned is better for fit so keep that for now
// rotate([0,0,-keycap_rotation.z])

// non-trackpoint keycaps have a better texture printed at an angle
rotate([0,45,0])
assembled($fn=120);
