----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:53:43 01/30/2014 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
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

entity pixel_gen is
    Port ( row : in  unsigned(10 downto 0);
           column : in  unsigned(10 downto 0);
           blank : in  STD_LOGIC;
				switch1 : in std_logic;
				switch2 : in std_logic;
           r : out  STD_LOGIC_VECTOR (7 downto 0);
           g : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));
end pixel_gen;

architecture Behavioral of pixel_gen is

begin
	
	process (blank, row, column, switch1, switch2)
	begin
		r <= 	"00000000";
		g <=	"00000000";
		b <=	"00000000";
		
		if (blank = '0') then
			if (switch1 = '0' and switch2 = '0') then 
				if (row > 350) then
					r <= "11111111";
				elsif (column < 213) then
					g <= "11111111";
				elsif (column < 427) then
					b <= "11111111";
				else
					r <= "11111111";
					g <= "11111111";
				end if;
			
			elsif (switch1 = '0' and switch2 = '1') then 
				if (row > 350) then
					g <= "11111111";
				elsif (column < 213) then
					b <= "11111111";
				elsif (column < 427) then
					r <= "11111111";
				else
					r <= "11111111";
					b <= "11111111";
				end if;
			
			elsif (switch1 = '1' and switch2 = '0') then 
				if (row > 350) then
					r <= "11111111";
					g <= "11111111";
				elsif (column < 213) then
					b <= "11111111";
				elsif (column < 427) then
					r <= "11111111";
				else
					r <= "11111111";
					g <= "11111111";
				end if;
			
			elsif (switch1 = '1' and switch2 = '1') then 
				if (row > 350) then
					g <= "11111111";
				elsif (column < 213) then
					g <= "11111111";
					r <= "11111111";
					b <= "11111111";
				elsif (column < 427) then
					b <= "11111111";
					r <= "11111111";
				else
					g <= "11111111";
					b <= "11111111";
				end if;
			end if;
		end if;
	end process;

end Behavioral;