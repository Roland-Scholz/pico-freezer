Turbo Freezer XL III information

by HiassofT - Matthias Reichl <hias@horus.com>

1. Files included:

freezer.rom : the ROM-dump of the 27128
frz-105.jed : JEDEC file for the 82S105A (PLS105)
freezer.png : schematic of the Turbo Freezer board

freezer.sch : schematic of the Turbo Freezer board in Eagle
format. Please note: if you want to create a PCB from this file
you'll have to do some additional work. I didn't work with Eagle
before and didn't fully understand how to build busses.

hias.lbr : eagle library containing the PLS105

freezer.c, freezer2.c :
small C programs that print the logic function of the PLS105 in
readable form.  freezer2.c dumps the address-decoder logic in short
form: '0' and '1' mean the corresponding address line has to be
'0' or '1', respectively, 'x' means: don't care.

translations :
a sed script to post-process the output of freezer.c / freezer2.c
that substitutes input/output pin numbers with the used signal names
(eg I00 becomes A4).

freezer-logic.txt, freezer-logic2.txt :
output of freezer.c and freezer2.c, post-processed with translations
script.

2. Here's some information I found out about the Freezer internals:

The original Freezer uses a 82S105A. This chip may run up to 20MHz.
If you replace it with a 82S105 or a PLS105 capable of doing only
10MHz, you'll most likely experience timing problems (since the
slower chip has a longer propagation delay). I solved this by
omitting the last gate of the 74HCT132 before the PLS and connected
the clock input of the PLS105 to pin 11 of the '132 (instead of
pin 3).

The circuit with the '132 and the resistors and capacitors acts
as a clock-multiplier, synchronized to the PHI2-signal of the Atari.
I don't have a frequency meter or a 'scope, so I couldn't measure
the exact frequency, but when analyzing the logic equations inside
the PLS105, I came to the conclusion that it must run at 4 times
the frequency of the Atari (at least).

I emailed with Bernhard Engl (the original designer of the Turbo
Freezer) in summer 2003 and he told me that the clock-multiplier
also acts as a copy protection scheme: The '132 had to be selected
to match certain switching characteristics, otherwise the freezer
wouldn't work stable. Using a 'scope and an original freezer as
reference it should be possible to adjust the resistor in the
oscillator so that any HCT132 should work.
