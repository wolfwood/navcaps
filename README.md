# Navigation Switch Key-Caps and MX Adapters and Trackpoint Extension Stems

## Status
Right now, the project is focusd on keycaps for 10x10 nav switches and extension stems for trackpoints. I'm using this [10x10 MX adapter](https://www.thingiverse.com/thing:3958026). MX Adapters for other switches are on the TODO.

## Usage

First, edit `settings.scad` to select a `stem_model` and `keycap_style` from among those available in `stems/` and `keycaps/` respectively. Edit others settings as appropriate, the main one of interest is `effective_height`; measuring the height of adjacent keys from the switch plate will provide a good starting place. All distances are in millimeters.

Next, run `make update`. This is necessary anytime you edit `stem_model` or `keycap_style` because openscad anly allows string literals in imports, so we import a symlink, maintained by `make`, that points to the appropiate files. You will also need to manually initiate a preview or render once in any running openscad window as it doesn't watch the symlinks for changes.

You can then open the the stem in openscad to look at the result, or `openscad final.scad` to see the high quality render (may take several minutes to complete). If you are happy with the result you can use export, or run `make things/<MyStem>.stl` to generate an `.stl` for slicing. Any name of the form `things/*.stl` will render the cap specified in the settings, so its easy to try out a few different settings.


## Comparison of Supported Nav Switches

### SKQU - The Classic 10x10 mm 5-way Nav Switch

**[r/ErgoMechKeyboards](https://www.reddit.com/r/ErgoMechKeyboards/)** has coalesced around these, particularly due to the excellent modelling work and infographic by *[u/HellMoneyWarriors](https://www.reddit.com/user/hellmoneywarriors/)* found [here on thingiverse](https://www.thingiverse.com/thing:3958026), through-hole contacts, and easy availability from [Adafruit](https://www.adafruit.com/product/504) and others. Turns out these are all roughly the same regardless of manufacturer; clones of an obsoleted ALPS part, SKQU.

#### Wiring
There is one pin for each of the 5 switches and one common pin.
Because its possible to activate up to 3 switches at once (2 adjecent directions and 'down') integrating this switch with a keyboard matrix will require diodes on all switch pins.

For example if using QMK `config.h` setting `DIODE_DIRECTION ROW2COL` and connecting a switch pin to each row, with the common pin as a unique column, diodes should have the stripe facing toward the switch.  If using `DIODE_DIRECTION COL2ROW` with switch pins connected to rows and common as a new column, then diodes should face away from the switch.


#### Operating Force
At roughly 160 gf depending on vendor, more than triple the regular keyswitches I use, these can be quite straining on the thumbs. However the force required varies with the stem length, so putting a tall keycap on these can reduce the effort.

1.57+0.39-0.69 N operating force at 8.77 mm (10 mm minus 1.23 mm to center of stem rotation), reported.<br>
**141 gf·cm** (**13.8 mN·m**) calculated normalized force (divide value by actual stem length, including internal to the switch, to determine effective force).

### [Datasheet](https://cdn-shop.adafruit.com/datasheets/SKQUCAA010-ALPS.pdf)



### SKRH - The Replacement

The compact ALPS SKRH family is the manufacturer recommended replacement for the obsoleted SKQU. Longer operating life, lower operating force and smaller footprint should all make this switch an obvious improvement. Unlike the SKQU it doesn't sit flat, but has a protrusion under the stem and optional guide bosses depending on the part number.

#### Wiring
This is a surface mount part, so soldering may be more challenging. The pinout is not the identical to the SKQU, but there are still 6 contacts.

#### Operating Force
1.2±0.69 N operating force at 4.51 mm stem height (5 mm minus .49 mm to center of stem rotation), reported.<br>
**55 gf·cm** (**5.4 mN·m**) calculated normalized force.

### [Datasheet](https://tech.alpsalpine.com/prod/e/pdf/multicontrol/switch/skrh/skrh.pdf)



### RKJXS - The 8-way Upgrade
the ALPS RKJXS

#### Operating Force
0.8±0.5 N at ??? stem height (4.45 mm minus ??? mm to center of rotation), reported.<br>
**< 36 gf·cm** (**< 3.5 mN·m**) calculated normalized force.

### [Datasheet](https://tech.alpsalpine.com/prod/e/pdf/multicontrol/switch/rkjxs/rkjxs.pdf)
