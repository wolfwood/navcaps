// functions for computing ratios between chord, radius and angle on a circle
function chord(angle) = 2 * sin(angle/2);
function achord(c, r) = 2 * asin(c/(2*r));
function chord_from_r(r, a) = r * chord(a);
function r_from_chord(c, a) = c / chord(a);

function normalize_chord(t) = [t[0] ? t[0] : chord_from_r(t[1], t[2]),
                               t[1] ? t[1] : r_from_chord(t[0], t[2]),
                               t[2] ? t[2] : achord(t[0], t[1])];
