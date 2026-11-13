library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Divisor de reloj: 100 MHz -> 1 Hz (periodo de 1 segundo)
-- Para ir mas rapido, baja el valor 49999999 (ej. 24999999 = 2 Hz)
entity divisor is
    Port ( clk_in  : in  STD_LOGIC;
           clk_out : out STD_LOGIC);
end divisor;

architecture Behavioral of divisor is
    signal cont  : integer range 0 to 49999999 := 0;
    signal clk_s : STD_LOGIC := '0';
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if cont = 49999999 then
                cont  <= 0;
                clk_s <= not clk_s;
            else
                cont <= cont + 1;
            end if;
        end if;
    end process;
    clk_out <= clk_s;
end Behavioral;
