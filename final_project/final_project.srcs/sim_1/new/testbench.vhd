----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/22/2022 11:06:52 AM
-- Design Name: 
-- Module Name: testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

use work.types.all;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is

component fir_filter is
    Port (clk : in std_logic; -- system clock
          rst : in std_logic; -- reset signal
          data : in std_logic_vector(data_length-1 downto 0); -- data symbol per symbol
          data_val : in std_logic;
          res : out std_logic_vector(data_length-1 downto 0); -- result symbol per symbol
          res_val : out std_logic
    );
end component;

signal val_in : std_logic := '1';
signal clk, rst, val_out : std_logic;
signal to_receive : std_logic_vector(7 downto 0) := "00001010";
signal to_send : std_logic_vector(7 downto 0);

begin

fir : fir_filter port map(clk => clk, rst => rst, data => to_receive, data_val => val_in, res => to_send, res_val => val_out);

p_clk : process
begin
    clk <= '0'; wait for 5ns; clk <= '1'; wait for 5ns;
end process;

p_rst : process
begin
    rst <= '1'; wait for 15ns; rst <= '0'; wait;
end process;

end Behavioral;
