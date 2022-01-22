----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/13/2022 05:09:50 PM
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

entity fir_filter is
  Port (clk : in std_logic; -- system clock
        rst : in std_logic; -- reset signal
        data : in std_logic_vector(data_length-1 downto 0); -- data symbol per symbol
        data_val : in std_logic;
        res : out std_logic_vector(data_length-1 downto 0); -- result symbol per symbol
        res_val : out std_logic
  );
end fir_filter;

architecture Behavioral of fir_filter is

signal sample : std_logic_vector(data_length-1 downto 0);
signal samples : data_array;
signal products : product_array;

-- coefficients are all the same for MA filter and set to 1 => with python after receiving filtered data
-- divide it by the length of the filter
signal coeffs : data_array := (
    0 => "00000001",
    1 => "00000001",
    2 => "00000001",
    3 => "00000001",
    4 => "00000001",
    5 => "00000001",
    6 => "00000001"
);

begin

main : process (clk, rst)
variable sum : unsigned(2*data_length + integer(ceil(log2(real(taps))))-1 downto 0); --to do 'convolution'
begin
    if rst = '1' then
        res <= (others => '0');
        res_val <= '0';
        samples <= (others => (others => '0'));
        sum := (others => '0');

    elsif rising_edge(clk) then        
        if data_val = '1' then
            sample <= data;
            samples <= unsigned(sample) & samples(0 to taps-2); --shift new data through register
        end if;            
            
        sum := (others => '0');
        for i in 0 to taps-1 loop
            sum := sum + products(i);
        end loop;
            
        res <= std_logic_vector(resize(sum,8)); --put filtered data in output
        res_val <= '1'; --tell to uart tx that filtered data is ready
    end if;
end process;

prod_gen : for i in 0 to taps-1 generate
    products(i) <= samples(i) * coeffs(i);
end generate;

end Behavioral;