LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ProyekAkhir IS
    PORT (
        -- Input
        M   : IN STD_LOGIC; --ON/OFF untuk menyalakan atau mematikan mesin
        CLK : IN STD_LOGIC; -- CLOCK
        Sen : IN STD_LOGIC; -- Sensor
        D   : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- Arah
        H   : IN STD_LOGIC; -- Kial dengan jaring

        -- Output
        Sampah  : OUT STD_LOGIC; -- Sampah
        Lamp    : OUT STD_LOGIC; -- Lampu Led untuk arah
        Alarm    : OUT STD_LOGIC_VECTOR(1 downto 0)  -- Bel alarm untuk Kail
    );
END ENTITY ProyekAkhir;

ARCHITECTURE flow OF ProyekAkhir IS

    COMPONENT Sensor IS
        PORT (
            -- Input
            clk : IN STD_LOGIC;
            echo : IN STD_LOGIC;

            -- Output
            Detec : OUT STD_LOGIC --trigger
        );
end COMPONENT;

    TYPE states IS (S0, S1, S2, S3, S4, S5); -- STATE
    SIGNAL NS, PS : states; -- NextState dan PresentState

BEGIN

    -- Instansiasi Sensor
    sensorsampah : Sensor PORT MAP(
        echo => Sen, 
        Detec => Sampah,
        clk => CLK
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
    comb_proc : PROCESS (PS, M, D, H, Sen)
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
                IF (D = "00") THEN
                    NS <= S2;
                ELSIF (D = "01") THEN
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
                IF (D = "00") THEN
                    NS <= S2;
                ELSIF (D = "01") THEN
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
                    Sampah <= Sen;
                ELSIF (Sen = '0') THEN
                    NS <= S3;
                ELSE
                    NS <= S5;
                END IF;

                -- S4 berfungsi untuk menaikkan kail
            WHEN S4 =>
                IF (H = '0') THEN
                    NS <= S0;
                END IF;

            WHEN S5 =>
                NS <= S0; -- error handling

        END CASE;
    END PROCESS;

END ARCHITECTURE flow;