LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ProyekAkhir IS
    PORT (
        -- Input
        M : IN STD_LOGIC; --ON/OFF untuk menyalakan atau mematikan mesin
        CLK : IN STD_LOGIC; -- CLOCK
        Sen : IN STD_LOGIC; -- Sensor
        D : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- Arah
        H : IN STD_LOGIC;

        -- Output

        Sampah : OUT STD_LOGIC;
        trig : OUT STD_LOGIC; 
        cm1 : OUT unsigned(3 DOWNTO 0);
        cm0 : OUT unsigned(3 DOWNTO 0)
    );
END ENTITY ProyekAkhir;

ARCHITECTURE ProyekAkhir_arch OF ProyekAkhir IS

    COMPONENT Sensor IS
        PORT (
            -- Input
            clk : IN STD_LOGIC;
            echo : IN STD_LOGIC;

            -- Output
            trig : OUT STD_LOGIC; --trigger
            cm1 : OUT unsigned(3 DOWNTO 0); -- MSB pertama distance di binary form
            cm0 : OUT unsigned(3 DOWNTO 0)); -- MSB pertama distance di binary form
end COMPONENT;

    TYPE states IS (S0, S1, S2, S3, S4, S5); -- STATE
    SIGNAL NS, PS : states; -- NextState dan PresentState

BEGIN

    sensor1 : Sensor port map (
        clk, Sen, trig, cm1, cm0
    );
    
    -- Synchronous process berfungsi untuk melakukan 
    -- Perubahan pada next state dan clock
    sync_proc : PROCESS (CLK, NS)
    BEGIN
        IF (rising_edge(CLK)) THEN
            PS <= NS;
        END IF;
    END PROCESS;

    -- comb_proc akan menjalankan fungsi utama program
    -- seperti kail,sensor,arah,dan menyalakan atau matikan mesin
    comb_proc : PROCESS (PS, M, D, Sen)
    BEGIN
        Sampah <= '0';

        CASE PS IS
                -- S0 berfungsi untuk menyalakan dan matikan mesin
                -- dengan input M
            WHEN S0 =>
                IF (M = '1') THEN
                    NS <= S1;
                ELSIF (M = '0') THEN
                    NS <= S0;
                END IF;

                -- S1 berfungsi untuk menentukan arah sama seperti S2
                -- Inputnya adalah D    
            WHEN S1 =>
                Sampah <= '0';
                IF (D = "01") THEN
                    NS <= S2;
                ELSIF (D = "00") THEN
                    NS <= S2;
                ELSIF (D = "10") THEN
                    NS <= S2;
                ELSIF (D = "11") THEN
                    NS <= S2;
                ELSE
                    NS <= S5;
                END IF;

                -- S2 berfungsi untuk menentukan arah sama seperti S1
                -- Inputnya adalah D
            WHEN S2 =>
                Sampah <= '0';
                IF (D = "01") THEN
                    NS <= S2;
                ELSIF (D = "00") THEN
                    NS <= S2;
                ELSIF (D = "10") THEN
                    NS <= S2;
                ELSIF (D = "11") THEN
                    NS <= S2;
                ELSIF (H = '1') THEN
                    NS <= S3;
                ELSE
                    NS <= S5;
                END IF;

                -- S3 berfungsi sebagai checker untuk Sensor    
            WHEN S3 =>
                IF (Sen = '1') THEN
                    NS <= S4;
                ELSIF (Sen = '0') THEN
                    NS <= S3;
                ELSE
                    NS <= S5;
                END IF;

                -- S4 berfungsi mekanisme gerak sensor
            WHEN S4 =>
                IF (H = '1') THEN
                    NS <= S0;
                
            END IF;

            WHEN S5 =>
                NS <= S0; -- error handling
        END CASE;
    END PROCESS;

END ARCHITECTURE ProyekAkhir_arch;