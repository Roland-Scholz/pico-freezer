library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Turbo Freezer XL next generation
-- original logic (c) 1986 Bernhard Engl
-- VHDL version (c) 2004 Matthias Reichl <hias@horus.com>

-- 128k RAM support
-- 512k flash ROM support
-- 8k/16k/OSS/SDX cartridge emulation support
-- RAM cartrdige emulation support

-- I used ispLever 4.1 and Synplify (both with service pack 1 installed)
-- with the following optimization settings to fit the design:
-- * Nodes collapsing mode = Area
-- * other settings are default

entity TurboFreezerXL is
	port(	phi2, reset, rw_in, os_select: in std_logic;
		a_in: in std_logic_vector ( 15 downto 0 );
		activate_in: in std_logic;
		poweron: std_logic;
		flash_enable_in: in std_logic;
		flash_writable_in: in std_logic;
		ram_rom_a: out std_logic_vector ( 18 downto 12 );
		refresh, ram_ce, rom_ce: out std_logic
	);

	attribute LOC: String;

	attribute LOC of phi2: signal is "P33";
	attribute LOC of reset: signal is "P14";
	attribute LOC of rw_in: signal is "P11";
	attribute LOC of os_select: signal is "P29";
	attribute LOC of a_in: signal is
		"P25 P26 P28 P27 P31 P30 P36 P37 P38 P40 P24 P21 P20 P19 P18 P17";
	attribute LOC of activate_in: signal is "P6";
	attribute LOC of refresh: signal is "P9";

	attribute LOC of poweron: signal is "P5";
	attribute LOC of flash_enable_in: signal is "P8";
	attribute LOC of flash_writable_in: signal is "P7";

	attribute LOC of ram_rom_a: signal is "P4 P43 P15 P2 P41 P39 P16";

	attribute LOC of ram_ce: signal is "P3";
	attribute LOC of rom_ce: signal is "P42";


-- ram_rom_a is used in this way:
-- a12..18 -> flash A12-A18
-- a12..16 -> RAM A12-A16
-- a17     -> RAM A4
-- a18     -> enable RAM A5..A7

	attribute lat_power_default: String;

	attribute slew_default: String;
	attribute pull_default: String;
	attribute lat_usercode: String;

	attribute syn_keep: boolean;
	attribute syn_preserve: boolean;
	attribute opt: String;

	attribute syn_enum_encoding: String;

end;


architecture TurboFreezerXL_architecture of TurboFreezerXL is

	attribute lat_power_default of TurboFreezerXL_architecture: architecture is "HIGH";
	attribute slew_default of TurboFreezerXL_architecture: architecture is "SLOW";
	attribute pull_default of TurboFreezerXL_architecture: architecture is "HOLD";
	attribute lat_usercode of TurboFreezerXL_architecture: architecture is "HIAS,ASCII";

	constant low  : std_logic := '0';
	constant high : std_logic := '1';

	constant atari_vector_address              : std_logic_vector(15 downto  0) := "1111111111111---"; -- FFF8-FFFF
	constant atari_chips_address               : std_logic_vector(15 downto  0) := "11010-----------"; -- D000-D7FF
	constant atari_oldrom_no_rom_address       : std_logic_vector(15 downto  0) := "1100------------"; -- C000-CFFF

-- freezer control
	constant freezer_address_01x               : std_logic_vector(15 downto  0) := "11010111000-----"; -- D700-D71F
--	constant freezer_onoff_address             : std_logic_vector(15 downto  0) := "110101110000----"; -- D700-D70F
--	constant freezer_ram_mode_address          : std_logic_vector(15 downto  0) := "110101110001----"; -- D710-D71F
	constant freezer_rom_bankselect_address    : std_logic_vector(15 downto  0) := "1101011101------"; -- D740-D77F
	constant freezer_ram_bankselect_address    : std_logic_vector(15 downto  0) := "11010111100-----"; -- D780-D79F

-- freezer ram/rom addresses
	constant freezer_fixed_ram_address         : std_logic_vector(15 downto  0) := "0000------------"; -- 0000-0FFF
	constant freezer_banked_ram_address        : std_logic_vector(15 downto  0) := "0001------------"; -- 1000-1FFF

-- flash rom bank select
	constant cart_bankselect_address           : std_logic_vector(15 downto  0) := "1101010101------"; -- D54X-D57X
	constant oss_bankselect_address            : std_logic_vector(15 downto  0) := "110101010000----"; -- D500-D50F
	constant sdx_bankselect_address            : std_logic_vector(15 downto  0) := "110101011110----"; -- D5E0-D5EF

	constant flash_config_address              : std_logic_vector(15 downto  0) := "110101011000----"; -- D58X

	constant flash_on_offset                   : std_logic_vector(15 downto  0) := "------------0001"; -- D581
	constant flash_off_offset                  : std_logic_vector(15 downto  0) := "------------0000"; -- D580

	constant flash_resetmode_keep_offset       : std_logic_vector(15 downto  0) := "------------0011"; -- D583
	constant flash_resetmode_reset_offset      : std_logic_vector(15 downto  0) := "------------0010"; -- D582

	constant cart_write_enable_offset          : std_logic_vector(15 downto  0) := "------------0101"; -- D585
	constant cart_write_disable_offset         : std_logic_vector(15 downto  0) := "------------0100"; -- D584

	constant cartmode_rom_offset               : std_logic_vector(15 downto  0) := "------------0110"; -- D586
	constant cartmode_ram_offset               : std_logic_vector(15 downto  0) := "------------0111"; -- D587

	constant cartmode_8k_offset                : std_logic_vector(15 downto  0) := "------------1000"; -- D588
	constant cartmode_16k_offset               : std_logic_vector(15 downto  0) := "------------1001"; -- D589
	constant cartmode_oss_offset               : std_logic_vector(15 downto  0) := "------------1010"; -- D58A
	constant cartmode_sdx_offset               : std_logic_vector(15 downto  0) := "------------1011"; -- D58B

-- rom banks
	constant oldrunner_rom_bank_number         : std_logic_vector(18 downto 13) := "111111";
	constant cart_rom_bank_number              : std_logic_vector(18 downto 13) := "111110";
	constant freezer_rom_bank_number           : std_logic_vector(18 downto 13) := "111100";

-- ram banks
	constant freezer_ram_bank_number           : std_logic_vector(16 downto 12) := "11111";
	constant default_ram_bank_number           : std_logic_vector(16 downto 12) := "00000";

-- flash configuration
	type cartemu_type is (
		cart_8k,
		cart_16k,
		cart_oss,
		cart_sdx
	);

-- help Synplify/ispLever fitting the design into the CPLD
--	attribute syn_enum_encoding of cartemu_type: type is "01 10 00 11";

	constant default_cartmode                  : cartemu_type := cart_8k;

-- latched inputs (needed for broken Ataris!)
	signal a: std_logic_vector(15 downto 0);
	signal rw: std_logic;

-- make sure Ax and R/W are implemented as input latches (to save space)
	attribute syn_keep of a: signal is true;
	attribute syn_keep of rw: signal is true;

-- freezer activation button
	signal activate : boolean;

-- implement freezer activate button as an input register
	signal activate_inputreg : std_logic;
	attribute syn_keep of activate_inputreg: signal is true;

-- freezer activation state machine
	type state_type is (
		freezer_disabled,
		freezer_half_enabled,
		freezer_temporarily_disabled,
		freezer_enabled
	);

	signal freezer_state: state_type;

-- Atari access to hardware vectors
	signal vector_access: boolean;

-- access to freezer rom
	signal freezer_rom_access: boolean;

-- access to freezer ram
	signal freezer_ram_access: boolean;
	signal freezer_ram_disable_atari: boolean;

-- A12-A16 RAM address select
	signal freezer_ram_a : std_logic_vector (16 downto 12);

-- RAM A4 and A5-A7 masking
	signal freezer_ram_a4 : std_logic;
	signal freezer_ram_mask_a5a7 : std_logic;

-- freezer ram bank select
	signal freezer_ram_bank : std_logic_vector(16 downto 12);

-- A12-A18 ROM bank select

	signal freezer_rom_a : std_logic_vector (18 downto 12);

-- acccess to flash config
	signal flash_config_access: boolean;

-- access to flash rom
	signal cart_a : std_logic_vector(18 downto 12);
	signal cart_ram_access : boolean;
	signal cart_rom_access : boolean;

-- freezer/flash rom bank select
	signal freezer_rom_bank : std_logic_vector (18 downto 13);
	signal cart_bank : std_logic_vector (18 downto 13);

	signal flash_enable: boolean;

	signal reset_freezer_banks: boolean;

-- oss bank select
	signal oss_bank: std_logic_vector(13 downto 12);

-- sdx bank select
	signal sdx_enable: boolean;

-- keep cartemu settings on reset
	signal cart_keepsettings: boolean;

	signal reset_cartemu: boolean;

-- cart emu mode
	signal cart_mode: cartemu_type;

-- cart emu: ram or rom
	signal cart_mode_ram: boolean;

-- flash write mode
	signal cart_write_enable: boolean;

-- oldrunner OS:
--	signal use_oldrunner: boolean;
--	attribute syn_keep of use_oldrunner: signal is true;
 
-- A2 at the time of freezing (vector access)
	signal vector_a2: std_logic;

-- ram access mode: standard / lo bank no = vector a2
	signal use_vector_bankno: boolean;

-- access to d700-d71f
	signal d700_d71f_access: boolean;
	attribute syn_preserve of d700_d71f_access: signal is true;

begin


-- ********************************************************************
-- *** freezer logic
-- ********************************************************************

	latch_inputs: process(phi2, a_in, rw_in)
	begin
		if (phi2 = low) then
			a <= a_in;
			rw <= rw_in;
		end if;
	end process latch_inputs;

-- ********************************************************************
-- *** freezer activation button
-- ********************************************************************

	inputreg_activate_button: process (phi2, activate_in)
	begin
		if falling_edge(phi2) then
			activate_inputreg <= activate_in;
		end if;
	end process inputreg_activate_button;

	check_activate_button: process (activate_inputreg)
	begin
		activate <= (activate_inputreg = low);
	end process check_activate_button;

-- ********************************************************************
-- *** oldrunner input workaround
-- ********************************************************************

--	check_oldrunner: process (os_select)
--	begin
--		use_oldrunner <= (os_select = low);
--	end process check_oldrunner;

-- ********************************************************************
-- *** freezer logic
-- ********************************************************************

	check_vector_access: process (a, rw, activate)
	begin
		if std_match(a, atari_vector_address) AND
		   (rw = high) AND activate then
			vector_access <= true;
		else
			vector_access <= false;
		end if;
	end process check_vector_access;

	check_d700_d71f_access: process(a)
	begin
		if std_match(a, freezer_address_01x) then
			d700_d71f_access <= true;
		else
			d700_d71f_access <= false;
		end if;
	end process check_d700_d71f_access;

--	check_freezer_onoff_access: process (a, d700_d71f_access)
--	begin
--		if d700_d71f_access AND (a(4) = low) then
--			freezer_onoff_access <= true;
--		else
--			freezer_onoff_access <= false;
--		end if;
--	end process check_freezer_onoff_access;
--
--	check_freezer_ram_mode_access: process (a, d700_d71f_access)
--	begin
--		if d700_d71f_access AND (a(4) = high) then
--			freezer_ram_mode_access <= true;
--		else
--			freezer_ram_mode_access <= false;
--		end if;
--	end process check_freezer_ram_mode_access;

-- main freezer state machine

	freezer_activation: process (phi2, reset, a, rw, d700_d71f_access, vector_access)
	begin
		if reset = low then
			freezer_state <= freezer_disabled;
		else
			if falling_edge(phi2) then
				case freezer_state is
				when freezer_disabled =>
					if vector_access then
						freezer_state <= freezer_half_enabled;
					else
						freezer_state <= freezer_disabled;
					end if;
				when freezer_half_enabled =>
					if vector_access then
						freezer_state <= freezer_enabled;
					else
						freezer_state <= freezer_disabled;
					end if;
				when freezer_enabled =>
					if d700_d71f_access AND (a(4) = low) then
						if rw = high then
							freezer_state <= freezer_disabled;
						else
							freezer_state <= freezer_temporarily_disabled;
						end if;
					else
						freezer_state <= freezer_enabled;
					end if;
				when freezer_temporarily_disabled =>
					if d700_d71f_access AND (a(4) = low) then
						if rw = high then
							freezer_state <= freezer_disabled;
						else
							freezer_state <= freezer_enabled;
						end if;
					else
						freezer_state <= freezer_temporarily_disabled;
					end if;
				end case;
			end if;
		end if;
	end process freezer_activation;

-- store a2 at the time when the low-byte of the interrupt-vector is accessed

	freezer_remember_a2: process (a, phi2, freezer_state, vector_access)
	begin
		if falling_edge(phi2) then
			if (freezer_state = freezer_disabled) AND vector_access then
				vector_a2 <= a(2);
			end if;
		end if;
	end process freezer_remember_a2;

-- freezer ram/rom bankselect and access

	check_reset_freezer_banks: process (freezer_state, vector_access)
	begin
		reset_freezer_banks <= ( (freezer_state = freezer_disabled) AND vector_access );
	end process check_reset_freezer_banks;

	freezer_ram_bank_select: process (phi2, reset_freezer_banks, a)
	begin
		if reset_freezer_banks then
			freezer_ram_bank <= default_ram_bank_number;
		else
			if falling_edge(phi2) then
				if std_match(a, freezer_ram_bankselect_address) then
					freezer_ram_bank <= a(4 downto 0);
				end if;
			end if;
		end if;
	end process freezer_ram_bank_select;

	freezer_ram_mode_select: process (phi2, reset_freezer_banks, d700_d71f_access, rw)
	begin
		if reset_freezer_banks then
			use_vector_bankno <= false;
		else
			if falling_edge(phi2) then
				if d700_d71f_access AND (a(4) = high) then
					use_vector_bankno <= (rw = high);
				end if;
			end if;
		end if;
	end process freezer_ram_mode_select;

	ram_access: process(a, rw, freezer_state, freezer_ram_bank, use_vector_bankno, vector_a2)
	begin
		freezer_ram_disable_atari <= false;
		freezer_ram_access <= false;
		freezer_ram_a <= "00000";
		freezer_ram_a4 <= low;
		freezer_ram_mask_a5a7 <= low;

		case freezer_state is
		when freezer_disabled =>
			-- shadow hardware registers
			if std_match(a, atari_chips_address) then
				freezer_ram_access <= (rw = low);

				if (a(10 downto 8) = "000") then
					-- $D0XX needs 32 bytes, so let A4 pass through
					freezer_ram_a4 <= a(4);
				end if;
				freezer_ram_a <= freezer_ram_bank_number;
			end if;
		when freezer_enabled =>
			if std_match(a, freezer_fixed_ram_address) OR
			   std_match(a, freezer_banked_ram_address) then
				freezer_ram_disable_atari <= true;
				freezer_ram_access <= true;
				if (use_vector_bankno) then
					freezer_ram_a4 <= vector_a2;
				else
					freezer_ram_a4 <= a(4);
				end if;
				freezer_ram_mask_a5a7 <= high;
				if std_match(a, freezer_fixed_ram_address) then
					freezer_ram_a <= freezer_ram_bank_number;
				else
					freezer_ram_a <= freezer_ram_bank;
				end if;
			end if;
		when others =>
			NULL;
		end case;
	end process ram_access;


	freezer_rom_bank_select: process (phi2, reset_freezer_banks, a)
	begin
		if reset_freezer_banks then
			freezer_rom_bank <= freezer_rom_bank_number;
		else
			if falling_edge(phi2) then
				if std_match(a, freezer_rom_bankselect_address) then
					freezer_rom_bank <= a(5 downto 0);
				end if;
			end if;
		end if;
	end process freezer_rom_bank_select;

--	rom_access: process(a, rw, freezer_rom_bank, use_oldrunner, freezer_state, vector_access)
	rom_access: process(a, rw, freezer_rom_bank, os_select, freezer_state, vector_access)
	begin
		freezer_rom_access <= false;
		freezer_rom_a <= "0000000";

		case a(15 downto 13) is
		when "111" =>
			if (rw = high) then
				if (freezer_state = freezer_half_enabled) AND vector_access then
					freezer_rom_access <= true;
					freezer_rom_a(18 downto 13) <= freezer_rom_bank_number;
					freezer_rom_a(12) <= a(12);
				elsif (os_select = low) then
					freezer_rom_access <= true;
					freezer_rom_a(18 downto 13) <= oldrunner_rom_bank_number;
					freezer_rom_a(12) <= a(12);
				end if;
			end if;
		when "001" =>
			-- enable freezer ROM from $2000-$3FFF if freezer is enabled
			if (rw = high) AND (freezer_state = freezer_enabled) then
				freezer_rom_access <= true;
				freezer_rom_a(18 downto 13) <= freezer_rom_bank;
				freezer_rom_a(12) <= a(12);
			end if;
		when others =>
			NULL;
		end case;
	end process rom_access;


-- ********************************************************************
-- *** cartridge emulation logic
-- ********************************************************************


-- cartridge emulation

	check_flash_config_access: process(a)
	begin
		flash_config_access <= std_match(a, flash_config_address);
	end process check_flash_config_access;

-- cartridge emu reset logic

	check_cartemu_reset_mode: process(phi2, poweron, a, flash_config_access)
	begin
		if (poweron = high) then
			cart_keepsettings <= true;
		else
			if falling_edge(phi2) then
				if flash_config_access AND std_match(a, flash_resetmode_keep_offset) then
					cart_keepsettings <= true;
				end if;
				if flash_config_access AND std_match(a, flash_resetmode_reset_offset) then
					cart_keepsettings <= false;
				end if;
			end if;
		end if;
	end process check_cartemu_reset_mode;

	check_reset_cartemu: process(reset, poweron, cart_keepsettings)
	begin
		reset_cartemu <= (poweron = high) OR ( (reset = low) AND (cart_keepsettings = false) );
	end process check_reset_cartemu;

-- cartridge ram/rom select
	check_cartemu_ram_rom: process(phi2, reset_cartemu, a, flash_config_access)
	begin
		if reset_cartemu then
			cart_mode_ram <= false;
		else
			if falling_edge(phi2) then
				if flash_config_access AND std_match(a, cartmode_ram_offset) then
					cart_mode_ram <= true;
				end if;
				if flash_config_access AND std_match(a, cartmode_rom_offset) then
					cart_mode_ram <= false;
				end if;
			end if;
		end if;
	end process check_cartemu_ram_rom;

-- cartridge write enable
	check_cart_write_enable: process(phi2, reset, a, flash_config_access)
	begin
		if (reset = low) then
			cart_write_enable <= false;
		else
			if falling_edge(phi2) then
				if flash_config_access AND std_match(a, cart_write_enable_offset) then
					cart_write_enable <= true;
				end if;
				if flash_config_access AND std_match(a, cart_write_disable_offset) then
					cart_write_enable <= false;
				end if;
			end if;
		end if;
	end process check_cart_write_enable;

-- cartridge emu mode select

	check_cartemu_type: process(phi2, reset_cartemu, a, flash_config_access)
	begin
		if reset_cartemu then
			cart_mode <= default_cartmode;
		else
			if falling_edge(phi2) then
				if flash_config_access AND std_match(a, cartmode_8k_offset) then
					cart_mode <= cart_8k;
				end if;
				if flash_config_access AND std_match(a, cartmode_16k_offset) then
					cart_mode <= cart_16k;
				end if;
				if flash_config_access AND std_match(a, cartmode_oss_offset) then
					cart_mode <= cart_oss;
				end if;
				if flash_config_access AND std_match(a, cartmode_sdx_offset) then
					cart_mode <= cart_sdx;
				end if;
			end if;
		end if;
	end process check_cartemu_type;

-- oss bank select
	check_oss_bank: process(phi2, a)
	begin
		if falling_edge(phi2) then
			if std_match(a, oss_bankselect_address) then
				oss_bank(13) <= a(0);
				oss_bank(12) <= NOT a(3);
			end if;
		end if;
	end process check_oss_bank;

-- sdx bank select

	check_sdx_enable: process(phi2, a)
	begin
		if falling_edge(phi2) then
			if std_match(a, sdx_bankselect_address) then
				sdx_enable <= (a(3) = low);
			end if;
		end if;
	end process check_sdx_enable;

-- flash rom bank select

	cart_bank_select: process (phi2, reset_cartemu, a, cart_mode)
	begin
		if reset_cartemu then
			cart_bank <= cart_rom_bank_number;
		else
			if falling_edge(phi2) then
				if std_match(a, cart_bankselect_address) then
					cart_bank <= a(5 downto 0);
				end if;
				if (cart_mode = cart_sdx) AND std_match(a, sdx_bankselect_address) then
					cart_bank(15 downto 13) <= a(2 downto 0) XOR "111";
				end if;
			end if;
		end if;
	end process cart_bank_select;

	check_flash_enable: process (phi2, reset_cartemu, a, flash_enable_in, flash_writable_in, flash_config_access)
	begin
		if reset_cartemu then
			flash_enable <= (flash_enable_in = low);
		else
			if falling_edge(phi2) then
				if (flash_enable_in = low) OR (flash_writable_in = low) then
					if flash_config_access AND std_match(a, flash_on_offset) then
						flash_enable <= true;
					end if;
					if flash_config_access AND std_match(a, flash_off_offset) then
						flash_enable <= false;
					end if;
				end if;
			end if;
		end if;
	end process check_flash_enable;

	cart_access: process(a, rw, flash_enable, cart_mode, flash_writable_in, cart_bank, 
		cart_write_enable, cart_mode_ram, oss_bank, sdx_enable)
		variable tmp_cart_a: std_logic_vector(18 downto 12);
		variable tmp_cart_access: boolean;
	begin
		tmp_cart_a := "0000000";
		tmp_cart_access := false;
		if (flash_enable) AND ( (rw = high) OR ( (flash_writable_in = low) AND cart_write_enable) ) then
			case cart_mode is
			when cart_8k =>
				if a(15 downto 13) = "101" then
					tmp_cart_a(18 downto 13) := cart_bank;
					tmp_cart_a(12) := a(12);
					tmp_cart_access := true;
				end if;
			when cart_16k =>
				if a(15 downto 14) = "10" then
					tmp_cart_a(18 downto 14) := cart_bank(18 downto 14);
					tmp_cart_a(13) := a(13);
					tmp_cart_a(12) := a(12);
					tmp_cart_access := true;
				end if;
			when cart_oss =>
				if (a(15 downto 13) = "101") AND (oss_bank /= "00") then
					tmp_cart_a(18 downto 14) := cart_bank(18 downto 14);
					tmp_cart_a(13) := oss_bank(13) AND (NOT a(12));
					tmp_cart_a(12) := oss_bank(12) AND (NOT a(12));
					tmp_cart_access := true;
				end if;
			when cart_sdx =>
				if (a(15 downto 13) = "101") AND sdx_enable then
					tmp_cart_a(18 downto 13) := cart_bank(18 downto 13);
					tmp_cart_a(12) := a(12);
					tmp_cart_access := true;
				end if;
			when others =>
				NULL;
			end case;
		end if;
		if (tmp_cart_access) then
			if (cart_mode_ram) then
				cart_a(16 downto 12) <= tmp_cart_a(16 downto 12);
				cart_a(17) <= a(4);
				cart_a(18) <= high;
				cart_rom_access <= false;
--				if (tmp_cart_a(16 downto 12) = freezer_ram_bank_number) then
				if (tmp_cart_a(16 downto 13) = freezer_ram_bank_number(16 downto 13)) then
					cart_ram_access <= false;
				else
					cart_ram_access <= true;
				end if;
			else
				cart_a <= tmp_cart_a;
				cart_ram_access <= false;
				cart_rom_access <= true;
			end if;
		else
			cart_a <= "0000000";
			cart_ram_access <= false;
			cart_rom_access <= false;
		end if;
	end process cart_access;


-- ********************************************************************
-- *** common logic
-- ********************************************************************


	activate_freezer_chips: process (freezer_ram_a, freezer_ram_a4, freezer_ram_mask_a5a7, freezer_rom_a,
		freezer_ram_access, freezer_rom_access,
		cart_a, cart_ram_access, cart_rom_access)
	begin
		if freezer_rom_access OR cart_rom_access then
			rom_ce <= low;
		else
			rom_ce <= high;
		end if;

		if freezer_ram_access OR cart_ram_access then
			ram_ce <= low;
		else
			ram_ce <= high;
		end if;

		ram_rom_a(18) <= freezer_ram_mask_a5a7 OR freezer_rom_a(18) OR cart_a(18);
		ram_rom_a(17) <= freezer_ram_a4        OR freezer_rom_a(17) OR cart_a(17);
		ram_rom_a(16) <= freezer_ram_a(16)     OR freezer_rom_a(16) OR cart_a(16);
		ram_rom_a(15) <= freezer_ram_a(15)     OR freezer_rom_a(15) OR cart_a(15);
		ram_rom_a(14) <= freezer_ram_a(14)     OR freezer_rom_a(14) OR cart_a(14);
		ram_rom_a(13) <= freezer_ram_a(13)     OR freezer_rom_a(13) OR cart_a(13);
		ram_rom_a(12) <= freezer_ram_a(12)     OR freezer_rom_a(12) OR cart_a(12);

	end process activate_freezer_chips;


-- disable builtin Atari memory when either
-- * accessing the freezer ROM (in oldrunner mode, or when freezer is activated) or
-- * accessing the freezer RAM (when freezer is activated) or
-- * accessing $C000-$CFFF in oldrunner mode (there's no memory in old Ataris) or
-- * accessing $A000-$BFFF in 8k flash mode or
-- * accessing $8000-$BFFF in 16k flash mode

--	disable_atari: process (a, use_oldrunner,
	disable_atari: process (a, os_select,
		freezer_rom_access, freezer_ram_disable_atari,
		cart_rom_access, cart_ram_access) 
	begin
		if freezer_rom_access OR freezer_ram_disable_atari OR
		   cart_rom_access OR cart_ram_access OR
		   ( (os_select = low) AND std_match(a, atari_oldrom_no_rom_address) ) then
			refresh <= low;
		else
			refresh <= high;
		end if;
	end process disable_atari;

end architecture TurboFreezerXL_architecture;
