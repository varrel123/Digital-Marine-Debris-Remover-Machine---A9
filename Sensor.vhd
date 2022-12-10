library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY Sensor IS
    PORT (
        -- Input
        clk  : IN STD_LOGIC;
        echo : IN STD_LOGIC;

        -- Output
        trig : OUT STD_LOGIC; --
        MSB1  : OUT unsigned(3 DOWNTO 0); -- MSB pertama distance di binary form
        MSB0  : OUT unsigned(3 DOWNTO 0)); -- MSB kedua distance di binary form
END Sensor;

ARCHITECTURE Sensor_arch OF Sensor IS

    SIGNAL count : INTEGER RANGE 0 TO 5800; -- akan mengukur sampai 100 cm
    SIGNAL temp_MSB1 : unsigned(3 DOWNTO 0) := "0000"; -- MSB untuk ditance
    SIGNAL tmpMSB0 : unsigned(3 DOWNTO 0) := "0000";
    SIGNAL sendDetec : STD_LOGIC := '1';

BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF sendDetec = '1' THEN -- memberi 10 us deteksi
                IF count = 10000 THEN -- 10 us deteksi selesai, reset tmp signals untuk perhitungan baru
                    trig <= '0';
                    sendDetec <= '0';
                    count <= 0;
                    tmpMSB0 <= "0000";
                    temp_MSB1 <= "0000";
                ELSE
                    trig <= '1';
                    count <= count + 1;
                END IF;

            ELSE -- stop mengirim deteksi, melakukan perhitungan (5800 clk cycle = 1cm)(perhitungan bernilai 0)
                IF echo = '1' THEN -- kita akan memulai perhitungan lebar dari echo
                    IF count = 5799 THEN -- kita menghitung 1 cm
                        IF tmpMSB0 = "1001" THEN
                            IF temp_MSB1 = "1001" THEN
                                sendDetec <= '1'; --jarak maksimal ukuran(100 cm), berhenti mengukur, mengirim ulang deteksi(dan mengupdate output)
                                MSB0 <= tmpMSB0;
                                MSB1 <= temp_MSB1;
                            ELSE
                                temp_MSB1 <= temp_MSB1 + "0001";
                                tmpMSB0 <= "0000";
                            END IF;
                        ELSE
                            tmpMSB0 <= tmpMSB0 + "0001";
                        END IF;
                        count <= 0;
                    ELSE
                        count <= count + 1;
                    END IF;

                    IF echo = '0' THEN --equivalent dari falling_edge(echo), jarak di perhitungkan, mengerimin deteksi lain (dan mengupdate output)
                        sendDetec <= '1';
                        MSB0 <= tmpMSB0;
                        MSB1 <= temp_MSB1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END Sensor_arch;

-- entity ultrasonic_sensor is
--     port(
--         echo: in std_logic;
--         clk: in std_logic;

--         trig: out std_logic;
--         distance: out unsigned(15 downto 0)
--     );
-- end entity ultrasonic_sensor;

-- architecture behavioral of ultrasonic_sensor is
--     signal start_time, end_time: unsigned(31 downto 0);
--     signal clk_cycle: integer := 0;
-- begin
--     trig <= not echo;

--     process(clk)
--     begin
--         if rising_edge(clk) then
--             if trig = '1' then
--                 start_time <= to_unsigned(clk_cycle, 32);
--             elsif echo = '1' then
--                 end_time <= to_unsigned(clk_cycle, 32);
--             end if;

--             clk_cycle <= clk_cycle + 1;
--         end if;
--     end process;

--     distance <= (end_time - start_time) * 340 / 2 / 1000000;
-- end architecture behavioral;
