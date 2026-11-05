F_rf18 := Reset & F_rf17 & F_rf18 +
		 /Reset &  /RW & F_rf17 &  /F_rf18 +
		A14 & A15 & A11 & A13 & A12 & RW &  /F_rf17 &  /F_rf18 &  /F_rf19
				; 3 
F_rf17 :=  /RW & F_rf17 +
		Reset & F_rf17 +
		A14 & A15 & A11 & A13 & A12 & RW &  /F_rf17 & F_rf18 &  /F_rf19 +
		A14 & A15 & A11 & A13 & Reset & A12 & RW & F_rf18 &  /F_rf19
				; 4 
F_o16 = A14 & A15 &  /A12 +
		A14 & A15 & A13 +
		A14 & A15 &  /A11
				; 3 
F_o14 =  /A15 & A13 & F_rf17 &  /F_rf18 +
		 /A15 & A12 & F_rf17 &  /F_rf18 +
		 /A15 & A11 & F_rf17 &  /F_rf18 +
		A14 & A13 +
		A14 &  /A15
				; 5 
F_o13 =  /A15 &  /A11 &  /A13 &  /A12 & F_rf17 &  /F_rf18 +
		A14 & A11 & A13 & A12 & RW &  /F_rf17 & F_rf18 &  /F_rf19 +
		A14 &  /A11 &  /A13 & A12 +
		A14 &  /A15
				; 4 
/RamCE = A14 & A15 &  /A11 &  /A13 & A12 &  /RW & PHI2 &  /F_rf17 &  /F_rf18 +
		 /A14 &  /A15 &  /A11 &  /A13 &  /A12 & PHI2 & F_rf17 &  /F_rf18
				; 2 
/RomOE = A14 & A15 & A11 & A13 & A12 & RW &  /F_rf17 & F_rf18 &  /F_rf19 +
		 /A14 &  /A15 & A12 & RW & F_rf17 &  /F_rf18 +
		 /A14 &  /A15 & A13 & RW & F_rf17 &  /F_rf18 +
		 /A14 &  /A15 & A11 & RW & F_rf17 &  /F_rf18
				; 4 


$__SYMTAB_INFO:
Design_Name: GAL_F
Gal_Type: 0
Gal_Mode: 4
Clk_Pin: 1
User_ID: __LEER

Pin_Node: CLK Pin_or_Node: 1 Number: 1 Pol: 1 IO: 4 Reg: -1 Trst: -1 Res: 1
Pin_Node: A14 Pin_or_Node: 1 Number: 2 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A15 Pin_or_Node: 1 Number: 3 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A11 Pin_or_Node: 1 Number: 4 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A13 Pin_or_Node: 1 Number: 5 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: Reset Pin_or_Node: 1 Number: 6 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: A12 Pin_or_Node: 1 Number: 7 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: RW Pin_or_Node: 1 Number: 8 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: PHI2 Pin_or_Node: 1 Number: 9 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: GND Pin_or_Node: 1 Number: 10 Pol: 1 IO: 4 Reg: -1 Trst: -1 Res: 1
Pin_Node: NOE Pin_or_Node: 1 Number: 11 Pol: 1 IO: 4 Reg: -1 Trst: -1 Res: 1
Pin_Node: RomOE Pin_or_Node: 1 Number: 12 Pol: 0 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: F_o13 Pin_or_Node: 1 Number: 13 Pol: 1 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: F_o14 Pin_or_Node: 1 Number: 14 Pol: 1 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: RamCE Pin_or_Node: 1 Number: 15 Pol: 0 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: F_o16 Pin_or_Node: 1 Number: 16 Pol: 1 IO: 2 Reg: 0 Trst: -1 Res: 0
Pin_Node: F_rf17 Pin_or_Node: 1 Number: 17 Pol: 1 IO: 3 Reg: 1 Trst: -1 Res: 0
Pin_Node: F_rf18 Pin_or_Node: 1 Number: 18 Pol: 1 IO: 3 Reg: 1 Trst: -1 Res: 0
Pin_Node: F_rf19 Pin_or_Node: 1 Number: 19 Pol: 1 IO: 1 Reg: -1 Trst: -1 Res: 0
Pin_Node: VCC Pin_or_Node: 1 Number: 20 Pol: 1 IO: 4 Reg: -1 Trst: -1 Res: 1
