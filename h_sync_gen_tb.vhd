--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:34:12 01/29/2014
-- Design Name:   
-- Module Name:   C:/Users/c15Jason.Mossing/ece383/VGA_Synchronization/h_sync_gen_tb.vhd
-- Project Name:  VGA_Synchronization
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: h_sync_gen
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY h_sync_gen_tb IS
END h_sync_gen_tb;
 
ARCHITECTURE behavior OF h_sync_gen_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT h_sync_gen
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         h_sync : OUT  std_logic;
         blank : OUT  std_logic;
         completed : OUT  std_logic;
         column : OUT  unsigned(10 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal h_sync : std_logic;
   signal blank : std_logic;
   signal completed : std_logic;
   signal column : unsigned(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: h_sync_gen PORT MAP (
          clk => clk,
          reset => reset,
          h_sync => h_sync,
          blank => blank,
          completed => completed,
          column => column
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		reset <= '1';
		wait for clk_period;
		assert ((column = to_unsigned(0,11)) and (blank = '0') and (h_sync = '1') and (completed = '0'))
		report "reset doesnt work";
		
		reset <= '0';
		wait for clk_period*300;
		assert ((column = to_unsigned(300,11)) and (blank = '0') and (h_sync = '1') and (completed = '0'))
		report "active at 300 doesnt work";
		
		wait for clk_period*350;
		assert ((column = to_unsigned(0,11)) and (blank = '1') and (h_sync = '1') and (completed = '0'))
		report "front porch doesnt work";
		
		wait for clk_period*16;
		assert ((column = to_unsigned(0,11)) and (blank = '1') and (h_sync = '0') and (completed = '0'))
		report "sync pulse doesnt work";
		
		wait for clk_period*90;
		assert ((column = to_unsigned(0,11)) and (blank = '1') and (h_sync = '1') and (completed = '0'))
		report "back porch doesnt work";
		
		wait for clk_period*48;
		assert ((column = to_unsigned(0,11)) and (blank = '1') and (h_sync = '1') and (completed = '1'))
		report "completed signal doesnt work";
		
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
