# Navigation Switch Keycaps and MX Adapters, and Trackpoint Extension Stems


## Status

### Navigation Switch Keycap and MX Adapter Status
Right now, the project has functional MX adapters and stems that fit the SKQU and SKRH nav switches described below, and 'keycaps' for using a trackpoint rubber cap.

There are also a variety of purely 3D-printed keycaps, in a variety of shapes: cup, saddle, bar, banana (maybe I should have called it macaroni?), dome and cup with a 'chin' which is meant to be used at an angle with the chin providing extra material to press down/towards the user. Right now I think the trackpoint is the most comfortable; everything else should be considered a work in progress, but the dome (basically a less-good trackpoint) and banana show the most promise. Sheet versions of the cup and saddle are thinner and less likely to bump into adjacent keys, but the plain versions are cool too.

The RKJXS adapter (and stem) exist but are not quite useable in current form. The adapter in particular is challenging because the switch is very large and the adapter walls become very narrow, to the point that the slicer ignores them.


### Trackpoint Stem Extension Status
Right now the only recommended model is the  low profile trackpoint clamp stem extension, `trackpoint-lp-clamp`. This fits over the trackpoint stem and then clamps diagonally using two M1.6x8 or longer screws, along with appropriate washers, lock washers and nuts. make sure to tune the `vertical_slop` so that you can see the trackpoint stem underneath the clamp (i.e. the clamp is not resting flat on the trackpoint sensor, but instead resting on the top of the trackpoint stem and held off the surface of the sensor). This will help prevent force on the top of the extension from levering the trackpoint stem and breaking it off (if this does happen, it is possible to superglue the stem back into place but it should be avoided).

The `trackpoint-lp-square` stem extension is a work in progress, as I've been having difficulty obtaining a press-fit that will not rock on at least one axis. I've stopped working on it as I found, at least with the Sprintek trackpoint modules, **removing a press-fit stem extension can rip the trackpoint stem off of the sensor, so proceed at your own risk!** If you do suffer this fate, you can try supergluing the stem back on. If you are committed to this path, your best bet is probably using [series.scad](series.scad) to print a variety of sizes at once and possibly tweaking the corner cutouts if you see rounding of the corners that interferes with insertion (or if the corner cutouts are too large and you get rounding of the sides of the hole).


## Usage

First, edit `settings.scad` to select a `stem_model` and `keycap_style` from among those available in `stems/` and `keycaps/` respectively. Edit others settings as appropriate, the main one of interest is `effective_height`; measuring the height of adjacent keys from the switch plate will provide a good starting place. All distances are in millimeters.

Next, run `make update`. This is necessary anytime you edit `stem_model` or `keycap_style` because openscad only allows string literals in imports, so we import a symlink, maintained by `make`, that points to the appropiate files. You will also need to manually initiate a preview or render once in any running openscad window as it doesn't watch the symlinks for changes.

You can then open the the stem in openscad to look at the result, or `openscad final.scad` to see the high quality render (may take several minutes to complete). If you are happy with the result you can use export, or run `make things/<MyStem>.stl` to generate an `.stl` for slicing. Any name of the form `things/*.stl` will render the cap specified in the settings, so its easy to try out a few different settings.


## Printer Settings

I have only used FDM prints to produce these models so far. SLA results could be wildly different. [stems/SKRH.scad](stems/SKRH.scad) has some specific recommendations but here's some general tips:

* print keycaps at a 45 degree angle for a nicer surface against your finger (this may make the stem fit against the switch worse)

* print "external perimeters first" to get better dimensional accuracy for both keycap stems and MX adapters

* disable supports for bridging, so that the hole for the switch stem isn't plugged by support material

* you might get a better fit against the switch printing upside down (no elephant foot on the first few layers making things too tight)

* don't decrease layer height expecting prints to better fit the switch stem; X-Y accuracy isn't dependent on layer height, and bridges of thinner layers sag more, plugging up the switch hole in a stem

* trackpoint stem extensions may get melty toward the top, print several at once so the hot end moves far enough away for each layer to cool before the next (this is a great time to experiment with several sizes at once, ala [series.scad](series.scad))


## Comparison of Supported Nav Switches

### SKQU - The Classic 10x10 mm 5-way Nav Switch

**[r/ErgoMechKeyboards](https://www.reddit.com/r/ErgoMechKeyboards/)** has coalesced around these, particularly due to the excellent modelling work and infographic by *[u/HellMoneyWarriors](https://www.reddit.com/user/hellmoneywarriors/)* found [here on thingiverse](https://www.thingiverse.com/thing:3958026), through-hole contacts, and easy availability from [Adafruit](https://www.adafruit.com/product/504) and others. Turns out these are all roughly the same regardless of manufacturer; clones of an obsoleted ALPS part, SKQU.

#### [Datasheet](https://cdn-shop.adafruit.com/datasheets/SKQUCAA010-ALPS.pdf)

#### Wiring
There is one pin for each of the 5 switches and one common pin.
Because its possible to activate up to 3 switches at once (2 adjacent directions and 'down') integrating this switch with a keyboard matrix will require diodes on all switch pins.

For example if using QMK `config.h` setting `DIODE_DIRECTION ROW2COL` and connecting a switch pin to each row, with the common pin as a unique column, diodes should have the stripe facing toward the switch.  If using `DIODE_DIRECTION COL2ROW` with switch pins connected to rows and common as a new column, then diodes should face away from the switch.


#### Operating Force
At roughly 160 gf depending on vendor, more than triple the regular keyswitches I use, these can be quite straining on the thumbs. However the force required varies with the stem length, so putting a tall keycap on these can reduce the effort.

1.57+0.39-0.69 N operating force at 8.77 mm (10 mm minus 1.23 mm to center of stem rotation), reported.<br>
**141 gf·cm** (**13.8 mN·m**) calculated normalized force (divide value by actual stem length, including internal to the switch, to determine effective force).



### SKRH - The Replacement

The compact ALPS SKRH family is the manufacturer recommended replacement for the obsoleted SKQU. Longer operating life, lower operating force and smaller footprint should all make this switch an obvious improvement. Unlike the SKQU it doesn't sit flat, but has a protrusion under the stem and optional guide bosses depending on the part number.

#### [Datasheet](https://tech.alpsalpine.com/prod/e/pdf/multicontrol/switch/skrh/skrh.pdf)

#### Wiring
This is a surface mount part, so soldering may be more challenging, but I was able to do it. Put flux on the contacts and tin both the wires and the contacts before attempting to solder. Keep wires very short to make sure the solder joints won't collide with the MX adapter.

The pinout is not the identical to the SKQU, but there are still 6 contacts.

#### Operating Force
1.2±0.69 N operating force measured at 4.3 mm from base of switch, meaning 3.71 mm stem height ( 4.3 mm minus .49 mm to center of stem rotation), reported.<br>
**46 gf·cm** (**4.5 mN·m**) calculated normalized force.



### RKJXS - The 8-way Upgrade

the ALPS RKJXS

#### [Datasheet](https://tech.alpsalpine.com/prod/e/pdf/multicontrol/switch/rkjxs/rkjxs.pdf)

#### Wiring
This is a surface mount part, so soldering may be more challenging.

This switch has 6 contacts, ignoring the 2 `E` terminals which are not electrically connected. However, with this switch any activation connects the `P` (Push) and `C` (Common) contacts, as well as 1-2 directional contacts if pushed in a cardinal direction or diagonal.  This means that the `P` contact cannot be used alone to detect a push as with the previous 2 switches. Instead, either hardware or software must evaluate all the pins with the following expression: `Push = AND(P, NOR(1, 2, 3, 4))`.

#### Operating Force
0.8±0.5 N at < 4.15 mm stem height (4.45 mm minus ??? mm to center of rotation; must be at least 0.3 mm since that is the travel of the push button), reported.<br>
**< 34 gf·cm** (**< 3.3 mN·m**) calculated normalized force.
