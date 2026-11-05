Turbo Freezer XL software V2.3 & 2.4
(c) 1987 by Bernhard Engl

Atasm version (c) 2004 by Matthias Reichl <hias@horus.com>

If you want to assemble the software, you need Atasm V1.05 or newer.

The main file is "FREEZER.M65", to create a binary ROM file type:

atasm -r -f0 -ofreezer-23.rom FREEZER.M65

This will create an 8k file named freezer-23.rom. The only difference
between V2.3 and V2.4 is that V2.4 also contains an "oldrunner" OS.
To build V2.4, concatenate freezer-23.rom with oldrunner.rom in
this directory. In Unix you can do this with:

cat freezer-23.rom oldrunner.rom > freezer-24.rom

In DOS type:

COPY /B freezer-23.rom+oldrunner.rom freezer-24.rom

