/OldRomOE =  /M_i1 & M_i3 & M_i7 &  /OSselect
				; 1 
/M_o17 = M_i1 &  /M_i3 &  /RAS & M_i7
				; 1 
/Refresh = M_i1 & M_i3 & M_i7 +
		 /M_i1 & M_i7 &  /OSselect
				; 2 
ExtSel = M_i1 & M_i3 &  /M_i7 &  /OSselect +
		M_i1 &  /M_i3 & M_i7 +
		M_i1 & M_i2 & M_i3 & PBD6 &  /M_i7 & PBD4 +
		M_i1 &  /M_i2 & M_i3 & PBD6 & PBD5 &  /M_i7 +
		 /M_i1 & M_i7 & OSselect +
		 /M_i1 &  /M_i3 & OSselect +
		 /M_i1 &  /M_i3 &  /M_i7
				; 7 
/Dram0 = M_i1 & M_i3 &  /PBD5 &  /RAS &  /M_i7 &  /PBD4 &  /M_i9 & OSselect +
		M_i1 & M_i2 & M_i3 & PBD6 &  /RAS &  /M_i7 &  /PBD4 &  /M_i9 & OSselect +
		M_i1 &  /M_i2 & M_i3 & PBD6 &  /PBD5 &  /RAS &  /M_i7 &  /M_i9 & OSselect
				; 3 
/Dram1 = M_i1 & M_i3 &  /PBD6 &  /PBD5 &  /RAS &  /M_i7 & PBD4 &  /M_i9 & OSselect
				; 1 
/Dram2 = M_i1 & M_i3 &  /PBD6 & PBD5 &  /RAS &  /M_i7 &  /PBD4 &  /M_i9 & OSselect
				; 1 
/Dram3 = M_i1 & M_i3 &  /PBD6 & PBD5 &  /RAS &  /M_i7 & PBD4 &  /M_i9 & OSselect
				; 1 


$__SYMTAB_INFO:
Design_Name: GAL_M
Gal_Type: 0
Gal_Mode: 1
Clk_Pin: 1
User_ID: __LEER

Pin_Node: M_i1 Pin_or_Node: 1 Number: 1 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: M_i2 Pin_or_Node: 1 Number: 2 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: M_i3 Pin_or_Node: 1 Number: 3 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: PBD6 Pin_or_Node: 1 Number: 4 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: PBD5 Pin_or_Node: 1 Number: 5 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: RAS Pin_or_Node: 1 Number: 6 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: M_i7 Pin_or_Node: 1 Number: 7 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: PBD4 Pin_or_Node: 1 Number: 8 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: M_i9 Pin_or_Node: 1 Number: 9 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: GND Pin_or_Node: 1 Number: 10 Pol: 1 IO: 4 Reg: -1 Trst: -1 Res: 1
Pin_Node: OSselect Pin_or_Node: 1 Number: 11 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: Dram3 Pin_or_Node: 1 Number: 12 Pol: 0 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: Dram2 Pin_or_Node: 1 Number: 13 Pol: 0 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: ExtSel Pin_or_Node: 1 Number: 14 Pol: 1 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: Refresh Pin_or_Node: 1 Number: 15 Pol: 0 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: Dram1 Pin_or_Node: 1 Number: 16 Pol: 0 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: M_o17 Pin_or_Node: 1 Number: 17 Pol: 0 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: Dram0 Pin_or_Node: 1 Number: 18 Pol: 0 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: OldRomOE Pin_or_Node: 1 Number: 19 Pol: 0 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: VCC Pin_or_Node: 1 Number: 20 Pol: 1 IO: 4 Reg: -1 Trst: -1 Res: 1
