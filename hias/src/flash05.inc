;  flash05.inc - common definitions and addresses for Freezer 2005 flash
;
;  Copyright (C) 2004-2005 Matthias Reichl <hias@horus.com>
;
;  This program is free software; you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation; either version 2 of the License, or
;  (at your option) any later version.
;
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with this program; if not, write to the Free Software
;  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

BANKREG	= $D540

SELBANK	= $D57E

ENABLE	= $D581
DISABLE	= $D580

WREN	= $D585
WRDIS	= $D584

MODKEEP	= $D583
MODRES	= $D582

MODEROM	= $D586
MODERAM	= $D587

MODE8K	= $D588
MODE16K	= $D589
MODEOSS	= $D58A
MODESDX	= $D58B

BASE8K	= $A000
BASE16K	= $8000

SDXBANK	= $D5E0
OSSBNK1	= $D500
OSSBNK2	= $D509
OSSBNK3	= $D501
OSSOFF	= $D508

; offset to freezer version (located in bank no. 56)
VEROFS  = $1EE0
