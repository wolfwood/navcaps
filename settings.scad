/*
 *   Edit these settings to control the generated keycaps
 */

/* height of the part the finger rests on, doesn't exclude higher protrusions,
       eg. the saddle keycap rises on either side of the thumb for leverage */
effective_height=16+5;

// maximum width in any direction, strict limit to prevent collision with adjacent keycaps
total_width=16;

// how thick the keycap, excluding the stem, should be. mostly aesthetic preference?
minimum_thickness = 1;


keycap_style = "trackpoint-lp";

/* can be auto (computationally expensive), manual (a bit janky, needs to be implemented for each keycap), or none.
     has no effect on certain keycaps such as trackpoint variants */
chamfer_style = "auto";

/* this allows you to rotate the keycap if the finger approaches at an angle
   you probably only want to rotate the Z-axis (third value) */
keycap_rotation = [0,0,0];


stem_model = "trackpoint-lp-square";


/* -----------------------------------------------------------------------
 *  Do Not Edit - this machinery is consistent regardless of above values
 * -----------------------------------------------------------------------
 */

function auto_chamfer() = chamfer_style == "auto";

function manual_chamfer() = chamfer_style == "manual";
