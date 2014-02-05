----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:53:18 01/29/2014 
-- Design Name: 
-- Module Name:    h_sync_gen - Behavioral 
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

entity h_sync_gen is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_sync : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           completed : out  STD_LOGIC;
           column : out  unsigned(10 downto 0));
end h_sync_gen;

architecture Behavioral of h_sync_gen is
	type h_states is (active_video, front_porch, sync_pulse, back_porch, complete);
	signal state_reg, state_next : h_states;
	signal count_reg, count_next, column_next, column_reg : unsigned(10 downto 0);
	signal h_sync_next, blank_next, completed_next : std_logic;
	signal h_sync_reg, blank_reg, completed_reg : std_logic;
	
begin
	
	
	--State Register
	process(reset, clk)
	begin
		if (reset = '1') then
			state_reg <= active_video;
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
		end if;
	end process;
	

	-- Count State Register
	process(reset, clk)
	begin
		if (reset = '1') then
			count_reg <= (others => '0');
		elsif rising_edge(clk) then
			count_reg <= count_next;
		end if;
	end process;
	
	count_next <= count_reg + 1 when state_reg = state_next else
						(others => '0');
	
	-- Next State logic
	process(state_reg, count_reg)
	begin
		state_next <= state_reg;
	
		case state_reg is
			when active_video =>
				if (count_reg = 639) then
					state_next <= front_porch;
				end if;
			when front_porch =>
				if (count_reg = 15) then
					state_next <= sync_pulse;
				end if;
			when sync_pulse =>
				if (count_reg = 95) then
					state_next <= back_porch;
				end if;
			when back_porch =>
				if (count_reg = 46) then
					state_next <= complete;
				end if;
			when complete =>
				state_next <= active_video;
		end case;
	end process;
	
	--output logic
	process (state_next, count_next)
	begin
		h_sync_next <= '1';
		blank_next <= '1';
		completed_next <= '0';
		column_next <= (others => '0');
		
		case state_next is
			when active_video =>
				blank_next <= '0';
				column_next <= count_next;
			when front_porch =>
			when sync_pulse =>
				h_sync_next <= '0';
			when back_porch =>
			when complete =>
				completed_next <= '1';
		end case;
	end process;

	process (clk)
	begin
		if rising_edge(clk) then
			h_sync_reg <= h_sync_next;
			blank_reg <= blank_next;
			completed_reg <= completed_next;
			column_reg <= column_next;
		end if;
	end process;
	
	h_sync <= h_sync_reg;
	blank <= blank_reg;
	completed <= completed_reg;
	column <= column_reg;
	
end Behavioral;