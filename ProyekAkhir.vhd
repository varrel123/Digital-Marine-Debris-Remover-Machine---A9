LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ProyekAkhir IS
    PORT (
        -- Input
        M   : IN STD_LOGIC; --ON/OFF untuk menyalakan atau mematikan mesin
        CLK : IN STD_LOGIC; -- CLOCK
        Sen : IN STD_LOGIC; -- Sensor
        D   : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- Arah
        H   : IN STD_LOGIC; -- Kail dengan jaring

        -- Output
        Sampah  : OUT STD_LOGIC; -- Sampah
        Lamp    : OUT STD_LOGIC; -- Lampu Led untuk arah
        Alarm   : OUT STD_LOGIC  -- Bel alarm untuk Kail
    );
END ENTITY ProyekAkhir;

ARCHITECTURE behavioral OF ProyekAkhir IS

    COMPONENT Sensor Is
        PORT (
            -- Input
            clk : IN STD_LOGIC; --clock
            echo : IN STD_LOGIC; --

            -- Output
            trig : OUT STD_LOGIC --trigger
        );
end COMPONENT;

    TYPE states IS (S0, S1, S2, S3, S4, S5); -- STATE
    SIGNAL NS, PS : states; -- NextState dan PresentState

BEGIN

    -- Instansiasi Sensor
    sensorsampah : Sensor PORT MAP(
        echo => Sen, 
        clk => CLK,
        trig => Sampah
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
    -- seperti kail, sensor, arah, dan menyalakan atau matikan mesin
    comb_proc : PROCESS (PS, M, D, H, Sen)
    BEGIN

        CASE PS IS
                -- S0 berfungsi untuk menyalakan dan matikan mesin
                -- dengan input M
            WHEN S0 =>
                Sampah <= Sen;
                IF (M = '1') THEN
                    NS <= S1;
                ELSIF (M = '0') THEN
                    NS <= S0;   
                END IF;

                -- S1 berfungsi untuk menentukan arah sama seperti S2
                -- Inputnya adalah D    
            WHEN S1 =>
                Sampah <= Sen;
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
                Sampah <= Sen;
                IF (D = "00") THEN
                    NS <= S2;
                ELSIF (D = "01") THEN
                    NS <= S2;
                ELSIF (D = "10") THEN
                    NS <= S2;
                ELSIF (D = "11") THEN
                    NS <= S2;
                END IF;

                IF (Sen = '0' and H = '1') THEN
                    NS <= S3;
                    Sampah <= Sen;
                ELSE
                    NS <= S5;
                END IF;

                -- S3 berfungsi sebagai checker untuk Sensor    
            WHEN S3 =>
                IF (Sen = '1' and H = '1') THEN
                    Sampah <= Sen;
                    NS <= S4;
                ELSIF (Sen = '0' and H = '1') THEN
                    NS <= S3;
                ELSE
                    NS <= S5;
                END IF;

                -- S4 berfungsi untuk menaikkan kail
            WHEN S4 =>
                IF (H = '0') THEN
                Sampah <= '1';
                    NS <= S0;
                END IF;

            WHEN S5 =>
                NS <= S0; -- error handling

        END CASE;
    END PROCESS;

    WITH PS SELECT
        Lamp <= '1' WHEN S3,
                '1' WHEN S4,
                '0' WHEN others;

    WITH PS SELECT
        Alarm <= '1' WHEN S2,
                '1' WHEN S3,
                '0' WHEN others;

END ARCHITECTURE behavioral;