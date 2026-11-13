library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Maquina de 4 estados (S0..S3), entrada de 2 bits, salida por estado (Moore)
-- Salida I0..I3 en un LED cada una (LD0..LD3)
-- El estado siguiente siempre es el valor de la entrada:
-- 00->S0, 01->S1, 10->S2, 11->S3 (desde cualquier estado)
entity maquina4 is
    Port ( clk    : in  STD_LOGIC;                     -- 100 MHz
           reset  : in  STD_LOGIC;                     -- SW7
           x      : in  STD_LOGIC_VECTOR (1 downto 0); -- SW1 SW0
           salida : out STD_LOGIC_VECTOR (3 downto 0));-- LD3..LD0 = I3..I0
end maquina4;

architecture Behavioral of maquina4 is

    type tipo_estado is (S0, S1, S2, S3);
    signal estado_presente : tipo_estado := S0;
    signal estado_proximo  : tipo_estado;
    signal clk_lento       : STD_LOGIC;

begin

    U1: entity work.divisor port map (clk_in => clk, clk_out => clk_lento);

    -- ESTADO PRESENTE
    process(clk_lento, reset)
    begin
        if reset = '1' then
            estado_presente <= S0;
        elsif rising_edge(clk_lento) then
            estado_presente <= estado_proximo;
        end if;
    end process;

    -- ESTADO PROXIMO
    process(estado_presente, x)
    begin
        estado_proximo <= estado_presente;
        if estado_presente = S0 then
            if    x = "00" then estado_proximo <= S0;   -- lazo
            elsif x = "01" then estado_proximo <= S1;
            elsif x = "10" then estado_proximo <= S2;
            else                estado_proximo <= S3;   -- 11
            end if;
        elsif estado_presente = S1 then
            if    x = "00" then estado_proximo <= S0;
            elsif x = "01" then estado_proximo <= S1;   -- lazo
            elsif x = "10" then estado_proximo <= S2;
            else                estado_proximo <= S3;
            end if;
        elsif estado_presente = S2 then
            if    x = "00" then estado_proximo <= S0;
            elsif x = "01" then estado_proximo <= S1;
            elsif x = "10" then estado_proximo <= S2;   -- lazo
            else                estado_proximo <= S3;
            end if;
        elsif estado_presente = S3 then
            if    x = "00" then estado_proximo <= S0;
            elsif x = "01" then estado_proximo <= S1;
            elsif x = "10" then estado_proximo <= S2;
            else                estado_proximo <= S3;   -- lazo
            end if;
        end if;
    end process;

    -- SALIDA (depende solo del estado)
    process(estado_presente)
    begin
        if    estado_presente = S0 then salida <= "0001";  -- I0
        elsif estado_presente = S1 then salida <= "0010";  -- I1
        elsif estado_presente = S2 then salida <= "0100";  -- I2
        else                            salida <= "1000";  -- I3
        end if;
    end process;

end Behavioral;
