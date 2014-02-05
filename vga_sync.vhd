----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:00:18 01/29/2014 
-- Design Name: 
-- Module Name:    vga_sync - Behavioral 
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

entity vga_sync is
	 Generic (
		H_activeSize : natural;
		H_frontSize : natural;
		H_syncSize : natural;
		H_backSize : natural;
		V_activeSize : natural;
		V_frontSize : natural;
		V_syncSize : natural;
		V_backSize : natural
		);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_sync : out  STD_LOGIC;
           v_sync : out  STD_LOGIC;
           v_completed : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           row : out  unsigned (10 downto 0);
           column : out  unsigned(10 downto 0));
end vga_sync;

architecture Behavioral of vga_sync is
	component h_sync_gen
		Generic (
			activeSize : natural;
			frontSize : natural;
			syncSize : natural;
			backSize : natural
			);
	    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_sync : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           completed : out  STD_LOGIC;
           column : out  unsigned(10 downto 0));
	end component;
	
	component v_sync_gen
		 Generic (
			activeSize : natural;
			frontSize : natural;
			syncSize : natural;
			backSize : natural
			);
	    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_completed : in  STD_LOGIC;
           v_sync : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           completed : out  STD_LOGIC;
           row : out  unsigned (10 downto 0));
	end component;
	signal h_completed_sig, h_blank, v_blank : std_logic;
begin

	h_sync_gen1 : h_sync_gen
		generic map(
			activeSize => H_activeSize,
			frontSize => H_frontSize,
			syncSize => H_syncSize,
			backSize => H_backSize
			)
		port map (
			clk => clk,
			reset => reset,
			h_sync => h_sync,
			blank => h_blank,
			completed => h_completed_sig,
			column => column);
	
	v_sync_gen1 : v_sync_gen
			generic map(
			activeSize => V_activeSize,
			frontSize => V_frontSize,
			syncSize => V_syncSize,
			backSize => V_backSize
			)
		port map(
			clk => clk,
			reset => reset,
			h_completed => h_completed_sig,
			v_sync => v_sync,
			blank => v_blank,
			completed => v_completed,
			row => row);

blank <= (h_blank or v_blank);

end Behavioral;