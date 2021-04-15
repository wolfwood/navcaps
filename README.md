# Navigation Switch Key-Caps and MX Adapters


## SKQU - The Classic 10x10 mm 5-way Nav Switch

**[r/ErgoMechKeyboards](https://www.reddit.com/r/ErgoMechKeyboards/)** has coalesced around these, particularly due to the excellent modelling work and infographic by *[u/HellMoneyWarriors](https://www.reddit.com/user/hellmoneywarriors/)* found [here on thingiverse](https://www.thingiverse.com/thing:3958026), through-hole contacts, and easy availability from [Adafruit](https://www.adafruit.com/product/504) and others. Turns out these are all roughly the same regardless of manufacturer, clones of an obsoleted ALPS part, SKQU.

#### Wiring
There is one pin for each of the 5 switches and one common pin.
Because its possible to activate up to 3 switches at once (2 adjecent directions and 'down') integrating this switch with a keyboard matrix will require diodes on all switch pins.

For example if using QMK `config.h` setting `DIODE_DIRECTION ROW2COL` and connecting a switch pin to each row, with the common pin as a unique column, diodes should have the stripe facing toward the switch.  If using `DIODE_DIRECTION COL2ROW` with switch pins connected to rows and common as a new column, then diodes should face away from the switch.


#### Operating Force
At roughly 160 gf depending on vendor, more than triple the regular keyswitches I use, these can be quite straining on the thumbs. However the force required varies with the stem length, so putting a tall keycap on these can reduce the effort.

1.57+0.39-0.69 N operating force at 8.77 mm (10 mm minus 1.23 mm to center of stem rotation), reported.<br>
**141 gf·cm** (**13.8 mN·m**) calculated normalized force (divide value by actual stem length, including internal to the switch, to determine effective force).

### [Datasheet](https://cdn-shop.adafruit.com/datasheets/SKQUCAA010-ALPS.pdf)



## SKRH - The Replacement

The compact ALPS SKRH family is the manufacturer recommended replacement for the obsoleted SKQU. Longer operating life, lower operating force and smaller footprint should all make this switch an obvious improvement. Unlike the SKQU it doesn't sit flat, but has a protrusion under the stem and optional guide bosses depending on the part number.

#### Wiring
This is a surface mount part, so soldering may be more challenging. The pinout is not the identical to the SKQU, but there are still 6 contacts.

#### Operating Force
1.2±0.69 N operating force at 4.51 mm stem height (5 mm minus .49 mm to center of stem rotation), reported.<br>
**55 gf·cm** (**5.4 mN·m**) calculated normalized force.

### [Datasheet](https://tech.alpsalpine.com/prod/e/pdf/multicontrol/switch/skrh/skrh.pdf)



## RKJXS - The 8-way Upgrade
the ALPS RKJXS

#### Operating Force
0.8±0.5 N at ??? stem height (4.45 mm minus ??? mm to center of rotation), reported.<br>
**< 36 gf·cm** (**< 3.5 mN·m**) calculated normalized force.

### [Datasheet](https://tech.alpsalpine.com/prod/e/pdf/multicontrol/switch/rkjxs/rkjxs.pdf)
