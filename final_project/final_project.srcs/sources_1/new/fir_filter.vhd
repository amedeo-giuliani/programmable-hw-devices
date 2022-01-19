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
        data : in std_logic_vector(2*data_length-1 downto 0); -- data symbol per symbol
        res : out std_logic_vector(2*data_length-1 downto 0); -- result symbol per symbol
        res_val : out std_logic
  );
end fir_filter;

architecture Behavioral of fir_filter is

signal sample, coeff : std_logic_vector(data_length-1 downto 0);
signal d : std_logic_vector(2*data_length-1 downto 0);
signal samples, coeffs : data_array;
signal products : product_array;

begin

main : process (clk, rst)
variable sum : signed(2*data_length-1 downto 0); --to do 'convolution'
begin
    if rst = '1' then
        res <= (others => '0');
        res_val <= '0';
        samples <= (others => (others => '0'));
        coeffs <= (others => (others => '0'));
        sum := (others => '0');
    end if;

    if rising_edge(clk) then
        d <= data;
        coeff <= d(2*data_length-1 downto data_length); -- first half of the vector contains the coefficient
        sample <= d(data_length-1 downto 0); -- second half of the vector contains the sample
        coeffs <= signed(coeff) & coeffs(0 to taps-2);
        samples <= signed(sample) & samples(0 to taps-2);
        
        sum := (others => '0');
        for i in 0 to taps-1 loop
            sum := sum + products(i);
        end loop;
        res <= std_logic_vector(sum);
        res_val <= '1';
        end if;
end process;

prod_gen : for i in 0 to taps-1 generate
    products(i) <= samples(i) * coeffs(i);
end generate;

end Behavioral;