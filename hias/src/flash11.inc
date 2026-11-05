;  flash11.inc - common definitions and addresses for Freezer 2011 flash
;
;  Copyright (C) 2011 Matthias Reichl <hias@horus.com>
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

CE_BANK		= $D590		; main bank register (0-127), 8k granularity
CE_ENABLE	= $D591		; cartemu enable(=1)/disable(=0)

CE_RBANK	= $D592		; separate 8k RAM bank register (0-47)
CE_RENABLE	= $D593		; separate 8k RAM enable(=1)/disable(=0)

CE_MODE		= $D594		; cartemu mode (0-7), see below
CE_MODE_OFF 	= 0		; no cartemu at all
CE_MODE_8K  	= 1		; 8k banks at $A000
CE_MODE_8K_RAM	= 2		; 8k banks with optional 8k RAM at $8000
CE_MODE_8K_OLD	= 3		; 8k with Turbo Freezer 2005 bank select (D540-7F,80/81/84/85)
CE_MODE_16K	= 4		; 16k banks at $8000-$BFFF
CE_MODE_OSS	= 5		; 16k OSS cart at $A000-$BFFF
CE_MODE_AMAX	= 6		; 8k using Atarimax 8MBit compatible banking
;CE_MODE_RESVD	= 7		; reserved

CE_CFG		= $D595		; cartemu config (0-7 / bit 2-0), see below
CE_CFG_WE	= 1		; write enable (=1)/disable (=0)
CE_CFG_WE_MSK	= $FE		; corresponding bit mask
CE_CFG_SRC	= 2		; source RAM (=2) / ROM (=0)
CE_CFG_SRC_MSK	= $FD		; corresponding bit mask
CE_CFG_MENU	= 4		; enable cartemu menu (=4) / normal operation (=0)
CE_CFG_MENU_MSK	= $FB		; corresponding bit mask

CE_SDX		= $D596		; SDX emulation (Ultimate 1MB banking, 0-3), see below
CE_SDX_OFF	= 0		; SDX emulation off
CE_SDX_RAM	= 1		; SDX emulation from RAM (starting bank 0)
CE_SDX_ROM1	= 2		; SDX emulation from ROM (starting bank 0)
CE_SDX_ROM2	= 3		; SDX emulation from ROM (starting bank 64)

; OSS banking registers
OSSBANK1	= $D500
OSSBANK2	= $D509
OSSBANK3	= $D501
OSSOFF		= $D508

; SDX banking registers (bit 7,6=ctl, 5-0=bank)
SDXBANKCTL	= $D5E0

; Atarimax banking registers
AMAXBANK	= $D500
AMAXOFF		= $D580

; offset to freezer version (located in bank no. 125)
VEROFSH		= $0F
VEROFSL		= $BEE0

; cartemu menu ROM bank
CE_MENU_BANK	= $7E
; RAM bank for cartemu menu configuration
CE_MENU_RAM_BANK= $3D
