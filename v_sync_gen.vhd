----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:41:00 01/29/2014 
-- Design Name: 
-- Module Name:    v_sync_gen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity v_sync_gen is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_completed : in  STD_LOGIC;
           v_sync : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           completed : out  STD_LOGIC;
           row : out  unsigned (10 downto 0));
end v_sync_gen;

architecture Behavioral of v_sync_gen is
	type v_states is (active_video, front_porch, sync_pulse, back_porch, complete);
	signal state_reg, state_next : v_states;
	signal count_reg, count_next : unsigned(10 downto 0);
	
	
begin
	
	--State Register
	process(reset, clk, h_completed)
	begin
		if (reset = '1') then
			state_reg <= active_video;
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
		end if;
	end process;
	
	-- Count State Register
	process(reset, clk, count_next)
	begin
		if (reset = '1') then
			count_reg <= to_unsigned(0,11);
		elsif (clk'event and clk = '1') then
			if (state_reg = state_next) then
				count_reg <= count_next;
			else
				count_reg <= to_unsigned(0,11);
			end if;
		end if;
	end process;
	
	--Next count logic
	process(count_reg, clk, h_completed)
	begin
		if (clk = '1') then 
			if (h_completed = '1') then
				count_next <= count_reg + to_unsigned(1,11);
			else
				count_next <= count_reg;
			end if;
		end if;
	end process;
	
	-- Next State logic
	process(state_reg, clk, count_next)
	begin
		case state_reg is
			when active_video =>
				if (count_reg < 480) then
					state_next <= active_video;
				else
					state_next <= front_porch;
				end if;
			when front_porch =>
				if (count_next < 10) then
					state_next <= front_porch;
				else
					state_next <= sync_pulse;
				end if;
			when sync_pulse =>
				if (count_next < 2) then
					state_next <= sync_pulse;
				else
					state_next <= back_porch;
				end if;
			when back_porch =>
				if (count_next < 33) then
					state_next <= back_porch;
				else
					state_next <= complete;
				end if;
			when complete =>
				state_next <= active_video;
		end case;
	end process;
	
	--output logic
	process (state_reg, count_reg)
	begin
		v_sync <= '1';
		blank <= '1';
		completed <= '0';
		row <= to_unsigned(0,11);
		
		case state_reg is
			when active_video =>
				blank <= '0';
				row <= count_reg;
			when front_porch =>
			when sync_pulse =>
				v_sync <= '0';
			when back_porch =>
			when complete =>
				completed <= '1';
		end case;
	end process;
end Behavioral;

