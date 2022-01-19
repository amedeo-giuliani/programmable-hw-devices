----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2022 06:17:04 PM
-- Design Name: 
-- Module Name: system - Behavioral
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

package types is

  constant taps        : integer := 7; -- filter taps
  constant data_length : integer := 4; -- data precision
  
  type data_array is array (0 to taps-1) of signed(data_length-1 downto 0); -- array of input data
  type product_array is array (0 to taps-1) of signed(data_length-1 downto 0); -- array of element-wise product between data and coefficients
  
end package types;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

use work.types.all;

entity system is
  Port (CLK100MHz : in std_logic;
        uart_txd_in : in std_logic;
        uart_rxd_out : out std_logic);
end system;

architecture Behavioral of system is

component uart_receiver is
    Port (clock : in std_logic;
          uart_rx : in std_logic;
          valid : out std_logic;
          received_data : out std_logic_vector(7 downto 0));
end component;

component uart_transmitter is
    Port (clock : in std_logic;
          data_valid : in std_logic;
          data_to_send : in std_logic_vector(7 downto 0);
          uart_tx : out std_logic;
          busy : out std_logic);
end component;

component fir_filter is
    Port (clk : in std_logic; -- system clock
          rst : in std_logic; -- reset signal
          data : in std_logic_vector(2*data_length-1 downto 0); -- data symbol per symbol
          res : out std_logic_vector(2*data_length-1 downto 0); -- result symbol per symbol
          res_val : out std_logic                                                                                          
    );
end component;

signal val_in, val_out, line_busy, reset : std_logic;
signal to_receive, to_send : std_logic_vector(7 downto 0);

begin

uartrx : uart_receiver port map (clock => CLK100MHz, uart_rx => uart_txd_in, valid => val_in, received_data => to_receive);
uarttx : uart_transmitter port map (clock => CLK100MHz, data_valid => val_out, data_to_send => to_send, uart_tx => uart_rxd_out, busy => line_busy);

-- instead of having input and coefficient separately, use a generic data signal since with UART transmission is serial
-- and we must transmit first the signal and then the coeffients or viceversa
-- the filter must wait for both of them to come from the data input variable
filter : fir_filter port map (clk => CLK100MHz, rst => reset, data => to_receive, res => to_send, res_val => val_in);

end Behavioral;
