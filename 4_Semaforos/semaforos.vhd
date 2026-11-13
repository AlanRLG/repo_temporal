library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Dos semaforos (como en la vida real: cuando uno esta en verde/amarillo el otro esta en rojo)
-- Secuencia:
--   Semaforo 1: VERDE x3 ciclos -> AMARILLO -> ROJO   (semaforo 2 en ROJO)
--   Semaforo 2: VERDE x3 ciclos -> AMARILLO -> ROJO   (semaforo 1 en ROJO)
-- Cada ciclo = 1 segundo (ver divisor.vhd)
entity semaforos is
    Port ( clk   : in  STD_LOGIC;   -- 100 MHz
           reset : in  STD_LOGIC;   -- SW7
           run   : in  STD_LOGIC;   -- SW0 (1 = funciona, 0 = pausa)
           r1, am1, v1 : out STD_LOGIC;  -- semaforo 1: LD0, LD1, LD2
           r2, am2, v2 : out STD_LOGIC); -- semaforo 2: LD3, LD4, LD5
end semaforos;

architecture Behavioral of semaforos is

    type tipo_estado is (V1_a, V1_b, V1_c, A1, V2_a, V2_b, V2_c, A2);
    signal estado_presente : tipo_estado := V1_a;
    signal estado_proximo  : tipo_estado;
    signal clk_lento       : STD_LOGIC;

begin

    U1: entity work.divisor port map (clk_in => clk, clk_out => clk_lento);

    -- ESTADO PRESENTE
    process(clk_lento, reset)
    begin
        if reset = '1' then
            estado_presente <= V1_a;
        elsif rising_edge(clk_lento) then
            estado_presente <= estado_proximo;
        end if;
    end process;

    -- ESTADO PROXIMO
    process(estado_presente, run)
    begin
        estado_proximo <= estado_presente;
        if run = '1' then
            if    estado_presente = V1_a then estado_proximo <= V1_b;
            elsif estado_presente = V1_b then estado_proximo <= V1_c;
            elsif estado_presente = V1_c then estado_proximo <= A1;
            elsif estado_presente = A1   then estado_proximo <= V2_a;
            elsif estado_presente = V2_a then estado_proximo <= V2_b;
            elsif estado_presente = V2_b then estado_proximo <= V2_c;
            elsif estado_presente = V2_c then estado_proximo <= A2;
            elsif estado_presente = A2   then estado_proximo <= V1_a;
            end if;
        end if;
    end process;

    -- SALIDAS
    process(estado_presente)
    begin
        -- por defecto ambos en rojo
        r1 <= '1'; am1 <= '0'; v1 <= '0';
        r2 <= '1'; am2 <= '0'; v2 <= '0';
        if estado_presente = V1_a or estado_presente = V1_b or estado_presente = V1_c then
            r1 <= '0'; v1 <= '1';             -- S1 verde, S2 rojo
        elsif estado_presente = A1 then
            r1 <= '0'; am1 <= '1';             -- S1 amarillo, S2 rojo
        elsif estado_presente = V2_a or estado_presente = V2_b or estado_presente = V2_c then
            r2 <= '0'; v2 <= '1';             -- S2 verde, S1 rojo
        elsif estado_presente = A2 then
            r2 <= '0'; am2 <= '1';             -- S2 amarillo, S1 rojo
        end if;
    end process;

end Behavioral;
