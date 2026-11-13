library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Maquina de Moore de 8 estados (a..h). La salida es el codigo de cada estado:
-- a=000 b=100 c=110 d=111 e=011 f=001 g=010 h=101
entity maquina8 is
    Port ( clk    : in  STD_LOGIC;                     -- 100 MHz
           reset  : in  STD_LOGIC;                     -- SW7
           x      : in  STD_LOGIC;                     -- SW0
           salida : out STD_LOGIC_VECTOR (2 downto 0));-- LD2..LD0
end maquina8;

architecture Behavioral of maquina8 is

    type tipo_estado is (Ea, Eb, Ec, Ed, Ee, Ef, Eg, Eh);
    signal estado_presente : tipo_estado := Ea;
    signal estado_proximo  : tipo_estado;
    signal clk_lento       : STD_LOGIC;

begin

    U1: entity work.divisor port map (clk_in => clk, clk_out => clk_lento);

    -- ESTADO PRESENTE
    process(clk_lento, reset)
    begin
        if reset = '1' then
            estado_presente <= Ea;
        elsif rising_edge(clk_lento) then
            estado_presente <= estado_proximo;
        end if;
    end process;

    -- ESTADO PROXIMO
    process(estado_presente, x)
    begin
        estado_proximo <= estado_presente;
        if estado_presente = Ea then
            if x = '0' then estado_proximo <= Ea; else estado_proximo <= Eb; end if;
        elsif estado_presente = Eb then
            if x = '0' then estado_proximo <= Eg; else estado_proximo <= Ec; end if;
        elsif estado_presente = Ec then
            if x = '0' then estado_proximo <= Ee; else estado_proximo <= Ed; end if;
        elsif estado_presente = Ed then
            if x = '0' then estado_proximo <= Ee; else estado_proximo <= Ed; end if;
        elsif estado_presente = Ee then
            if x = '0' then estado_proximo <= Ef; else estado_proximo <= Eh; end if;
        elsif estado_presente = Ef then
            if x = '0' then estado_proximo <= Ea; else estado_proximo <= Eb; end if;
        elsif estado_presente = Eg then
            if x = '0' then estado_proximo <= Ef; else estado_proximo <= Eh; end if;
        elsif estado_presente = Eh then
            if x = '0' then estado_proximo <= Eg; else estado_proximo <= Ec; end if;
        end if;
    end process;

    -- SALIDA (codigo del estado)
    process(estado_presente)
    begin
        if    estado_presente = Ea then salida <= "000";
        elsif estado_presente = Eb then salida <= "100";
        elsif estado_presente = Ec then salida <= "110";
        elsif estado_presente = Ed then salida <= "111";
        elsif estado_presente = Ee then salida <= "011";
        elsif estado_presente = Ef then salida <= "001";
        elsif estado_presente = Eg then salida <= "010";
        else                            salida <= "101";
        end if;
    end process;

end Behavioral;
