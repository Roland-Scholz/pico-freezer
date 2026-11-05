RamA7 = A7 & G_i11
				; 1 
RamA6 = A6 & G_i11
				; 1 
RamA5 = A5 & G_i11
				; 1 
RamA4 = A4 & G_i11 +
		 /A10 &  /A9 &  /A8 & A4
				; 2 
/G_o15 = A10 & A9 & A8 &  /G_i11
				; 1 
G_o13 =  /A10 & A9 & A8 &  /A1 &  /G_i11
				; 1 
/G_o12 = A10 & A9 & A8 & A3 & A5 & A7 & A6 & A4 & G_i14
				; 1 


$__SYMTAB_INFO:
Design_Name: GAL_G
Gal_Type: 0
Gal_Mode: 2
Clk_Pin: 1
User_ID: __LEER

Pin_Node: A10 Pin_or_Node: 1 Number: 1 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A9 Pin_or_Node: 1 Number: 2 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A8 Pin_or_Node: 1 Number: 3 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A1 Pin_or_Node: 1 Number: 4 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A3 Pin_or_Node: 1 Number: 5 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A5 Pin_or_Node: 1 Number: 6 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A7 Pin_or_Node: 1 Number: 7 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A6 Pin_or_Node: 1 Number: 8 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A4 Pin_or_Node: 1 Number: 9 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: GND Pin_or_Node: 1 Number: 10 Pol: 1 IO: 4 Reg: -1 Trst: -1 Res: 1
Pin_Node: G_i11 Pin_or_Node: 1 Number: 11 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: G_o12 Pin_or_Node: 1 Number: 12 Pol: 0 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: G_o13 Pin_or_Node: 1 Number: 13 Pol: 1 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: G_i14 Pin_or_Node: 1 Number: 14 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: G_o15 Pin_or_Node: 1 Number: 15 Pol: 0 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: RamA4 Pin_or_Node: 1 Number: 16 Pol: 1 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: RamA5 Pin_or_Node: 1 Number: 17 Pol: 1 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: RamA6 Pin_or_Node: 1 Number: 18 Pol: 1 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: RamA7 Pin_or_Node: 1 Number: 19 Pol: 1 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: VCC Pin_or_Node: 1 Number: 20 Pol: 1 IO: 4 Reg: -1 Trst: -1 Res: 1
