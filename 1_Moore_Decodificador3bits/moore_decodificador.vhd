library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Maquina de Moore: decodificador / contador de 3 bits
-- x = 1 avanza al siguiente estado, x = 0 se queda
-- La salida es el estado decodificado a 8 bits (one-hot)
entity moore_decodificador is
    Port ( clk     : in  STD_LOGIC;                      -- 100 MHz
           reset   : in  STD_LOGIC;                      -- SW7
           x       : in  STD_LOGIC;                      -- SW0
           salida  : out STD_LOGIC_VECTOR (7 downto 0)); -- LD7..LD0
end moore_decodificador;

architecture Behavioral of moore_decodificador is

    type tipo_estado is (S000, S001, S010, S011, S100, S101, S110, S111);
    signal estado_presente : tipo_estado := S000;
    signal estado_proximo  : tipo_estado;
    signal clk_lento       : STD_LOGIC;

begin

    U1: entity work.divisor port map (clk_in => clk, clk_out => clk_lento);

    -- ESTADO PRESENTE (memoria)
    process(clk_lento, reset)
    begin
        if reset = '1' then
            estado_presente <= S000;
        elsif rising_edge(clk_lento) then
            estado_presente <= estado_proximo;
        end if;
    end process;

    -- ESTADO PROXIMO
    process(estado_presente, x)
    begin
        estado_proximo <= estado_presente;
        if estado_presente = S000 then
            if x = '0' then estado_proximo <= S000; else estado_proximo <= S001; end if;
        elsif estado_presente = S001 then
            if x = '0' then estado_proximo <= S001; else estado_proximo <= S010; end if;
        elsif estado_presente = S010 then
            if x = '0' then estado_proximo <= S010; else estado_proximo <= S011; end if;
        elsif estado_presente = S011 then
            if x = '0' then estado_proximo <= S011; else estado_proximo <= S100; end if;
        elsif estado_presente = S100 then
            if x = '0' then estado_proximo <= S100; else estado_proximo <= S101; end if;
        elsif estado_presente = S101 then
            if x = '0' then estado_proximo <= S101; else estado_proximo <= S110; end if;
        elsif estado_presente = S110 then
            if x = '0' then estado_proximo <= S110; else estado_proximo <= S111; end if;
        elsif estado_presente = S111 then
            if x = '0' then estado_proximo <= S111; else estado_proximo <= S000; end if;
        end if;
    end process;

    -- SALIDA (Moore: depende solo del estado presente)
    process(estado_presente)
    begin
        if    estado_presente = S000 then salida <= "00000001";
        elsif estado_presente = S001 then salida <= "00000010";
        elsif estado_presente = S010 then salida <= "00000100";
        elsif estado_presente = S011 then salida <= "00001000";
        elsif estado_presente = S100 then salida <= "00010000";
        elsif estado_presente = S101 then salida <= "00100000";
        elsif estado_presente = S110 then salida <= "01000000";
        else                              salida <= "10000000";
        end if;
    end process;

end Behavioral;
