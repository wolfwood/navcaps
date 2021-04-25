include <settings.scad>;
use <include/stem.scad>;

//rotate([0,53,0]) 
rotate([0,0,-keycap_rotation.z]) assembled($fn=120);
