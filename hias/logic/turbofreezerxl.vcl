[DEVICE]

Family = M4A5;
PartType = M4A5-64/32;
Package = 44PLCC;
PartNumber = M4A5-64/32-10JC;
Speed = -10;
Operating_condition = COM;
EN_Segment = NO;
Pin_MC_1to1 = NO;
Voltage = 5.0;

[REVISION]

RCS = "$Revision: 1.2 $";
Parent = m4a5.lci;
SDS_file = m4a5.sds;
Design = turbofreezerxl.tt4;
Rev = 0.01;
DATE = 5/4/05;
TIME = 18:07:28;
Type = TT2;
Pre_Fit_Time = 1;
Source_Format = Schematic_VHDL;

[IGNORE ASSIGNMENTS]

Pin_Assignments = NO;
Pin_Keep_Block = NO;
Pin_Keep_Segment = NO;
Group_Assignments = NO;
Macrocell_Assignments = NO;
Macrocell_Keep_Block = NO;
Macrocell_Keep_Segment = NO;
Pin_Reservation = NO;
Timing_Constraints = NO;
Block_Reservation = NO;
Segment_Reservation = NO;
Ignore_Source_Location = NO;
Ignore_Source_Optimization = NO;
Ignore_Source_Timing = NO;

[CLEAR ASSIGNMENTS]

Pin_Assignments = NO;
Pin_Keep_Block = NO;
Pin_Keep_Segment = NO;
Group_Assignments = NO;
Macrocell_Assignments = NO;
Macrocell_Keep_Block = NO;
Macrocell_Keep_Segment = NO;
Pin_Reservation = NO;
Timing_Constraints = NO;
Block_Reservation = NO;
Segment_Reservation = NO;
Ignore_Source_Location = NO;
Ignore_Source_Optimization = NO;
Ignore_Source_Timing = NO;

[BACKANNOTATE NETLIST]

Netlist = VHDL;
Delay_File = SDF;
Generic_VCC = ;
Generic_GND = ;

[BACKANNOTATE ASSIGNMENTS]

Pin_Assignment = NO;
Pin_Block = NO;
Pin_Macrocell_Block = NO;
Routing = NO;

[GLOBAL PROJECT OPTIMIZATION]

Balanced_Partitioning = YES;
Spread_Placement = YES;
Max_Pin_Percent = 100;
Max_Macrocell_Percent = 100;
Max_Inter_Seg_Percent = 100;
Max_Seg_In_Percent = 100;
Max_Blk_In_Percent = 100;

[FITTER REPORT FORMAT]

Fitter_Options = YES;
Pinout_Diagram = NO;
Pinout_Listing = YES;
Detailed_Block_Segment_Summary = YES;
Input_Signal_List = YES;
Output_Signal_List = YES;
Bidir_Signal_List = YES;
Node_Signal_List = YES;
Signal_Fanout_List = YES;
Block_Segment_Fanin_List = YES;
Prefit_Eqn = YES;
Postfit_Eqn = YES;
Page_Break = YES;

[OPTIMIZATION OPTIONS]

Logic_Reduction = YES;
Max_PTerm_Split = 16;
Max_PTerm_Collapse = 16;
XOR_Synthesis = YES;
Node_Collapse = Yes;
DT_Synthesis = Yes;

[FITTER GLOBAL OPTIONS]

Run_Time = 0;
Set_Reset_Dont_Care = NO;
In_Reg_Optimize = YES;
Clock_Optimize = NO;
Conf_Unused_IOs = OUT_LOW;

[POWER]
Powerlevel = Low, High;
Default = HIGH;
Type = GLB;

[HARDWARE DEVICE OPTIONS]
Zero_Hold_Time = No;
Signature_Word = HIAS;
Pull_up = No;
Out_Slew_Rate = SLOW, FAST, 0;
Device_max_fanin = 33;
Device_max_pterms = 20;
Usercode_Format = ASCII;

[LOCATION ASSIGNMENT]

Layer = OFF
ram_rom_a_12_ = OUTPUT,16,1,-;
refresh = OUTPUT,9,0,-;
ram_rom_a_17_ = OUTPUT,43,3,-;
ram_rom_a_14_ = OUTPUT,41,3,-;
ram_rom_a_13_ = OUTPUT,39,3,-;
ram_rom_a_16_ = OUTPUT,15,1,-;
ram_rom_a_15_ = OUTPUT,2,0,-;
ram_rom_a_18_ = OUTPUT,4,0,-;
ram_ce = OUTPUT,3,0,-;
rom_ce = OUTPUT,42,3,-;
rw = NODE,*,1,-;
N_275 = NODE,*,1,-;
freezer_state_0_ = NODE,*,3,-;
freezer_state_1_ = NODE,*,3,-;
cart_bank_14_ = NODE,*,2,-;
cart_access_un13_flash_enable_n = NODE,*,2,-;
inst_cart_mode_ram = NODE,*,2,-;
check_vector_access_un1_activate_n = NODE,*,0,-;
freezer_rom_bank_select_std_match_result_n = NODE,*,0,-;
N_272 = NODE,*,2,-;
cart_mode_1_ = NODE,*,2,-;
cart_mode_0_ = NODE,*,2,-;
cart_bank_15_ = NODE,*,2,-;
freezer_rom_bank_17_ = NODE,*,0,-;
freezer_rom_bank_13_ = NODE,*,1,-;
freezer_ram_bank_15_ = NODE,*,1,-;
cart_bank_18_ = NODE,*,2,-;
cart_bank_17_ = NODE,*,2,-;
cart_bank_16_ = NODE,*,1,-;
inst_sdx_enable = NODE,*,1,-;
reset_cartemu = NODE,*,2,-;
oss_bank_13_ = NODE,*,1,-;
freezer_ram_bank_select_std_match_result_n = NODE,*,0,-;
cart_bank_select_std_match_result_n = NODE,*,0,-;
inst_vector_a2 = NODE,*,3,-;
inst_flash_enable = NODE,*,2,-;
cart_bank_13_ = NODE,*,2,-;
inst_use_vector_bankno = NODE,*,3,-;
freezer_rom_bank_18_ = NODE,*,0,-;
freezer_rom_bank_16_ = NODE,*,1,-;
freezer_rom_bank_15_ = NODE,*,0,-;
freezer_rom_bank_14_ = NODE,*,3,-;
un1_result_2 = NODE,*,1,-;
freezer_ram_bank_16_ = NODE,*,1,-;
freezer_ram_bank_14_ = NODE,*,3,-;
freezer_ram_bank_13_ = NODE,*,3,-;
freezer_ram_bank_12_ = NODE,*,1,-;
inst_cart_write_enable = NODE,*,2,-;
oss_bank_12_ = NODE,*,1,-;
inst_cart_keepsettings = NODE,*,2,-;
check_sdx_enable_std_match_result_n = NODE,*,0,-;
flash_config_access = NODE,*,0,-;
check_oss_bank_std_match_result_n = NODE,*,0,-;
check_d700_d71f_access_std_match_result_n = NODE,*,0,-;
a_in_6_ = INPUT,40,3,-;
a_in_7_ = INPUT,38,3,-;
a_in_8_ = INPUT,37,3,-;
a_in_9_ = INPUT,36,3,-;
a_in_11_ = INPUT,31,2,-;
a_in_10_ = INPUT,30,2,-;
a_in_13_ = INPUT,28,2,-;
a_in_12_ = INPUT,27,2,-;
a_in_14_ = INPUT,26,2,-;
a_in_15_ = INPUT,25,2,-;
a_in_5_ = INPUT,24,2,-;
a_in_4_ = INPUT,21,1,-;
a_in_3_ = INPUT,20,1,-;
a_in_2_ = INPUT,19,1,-;
a_in_1_ = INPUT,18,1,-;
a_in_0_ = INPUT,17,1,-;
activate_in = INPUT,6,0,-;
a_15_ = NODE,25,2,-;
a_14_ = NODE,26,2,-;
a_12_ = NODE,27,2,-;
a_13_ = NODE,28,2,-;
a_4_ = NODE,21,1,-;
a_11_ = NODE,31,2,-;
a_3_ = NODE,20,1,-;
a_2_ = NODE,19,1,-;
a_7_ = NODE,38,3,-;
a_8_ = NODE,37,3,-;
a_9_ = NODE,36,3,-;
a_5_ = NODE,24,2,-;
a_10_ = NODE,30,2,-;
a_1_ = NODE,18,1,-;
a_0_ = NODE,17,1,-;
a_6_ = NODE,40,3,-;
activate_inputreg = NODE,6,0,-;
phi2 = INPUT,33,-,-;
