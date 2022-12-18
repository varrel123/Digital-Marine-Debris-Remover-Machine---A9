library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY Sensor IS
    PORT (
        -- Input
        clk  : IN STD_LOGIC; -- clock
        echo : IN STD_LOGIC; -- echo

        -- Output
        trigger : OUT STD_LOGIC; -- trigger
        MSB1  : OUT unsigned(3 DOWNTO 0); -- MSB pertama distance di binary form
        MSB0  : OUT unsigned(3 DOWNTO 0)); -- MSB kedua distance di binary form
END Sensor;

ARCHITECTURE Sensor_arch OF Sensor IS

    SIGNAL count : INTEGER RANGE 0 TO 5800; -- This will be used to measure up to 100 cm
    -- Declare signals to hold the binary representation of the distance
    SIGNAL temp_MSB1 : unsigned(3 DOWNTO 0) := "0000"; -- MSB untuk ditance
    SIGNAL tmpMSB0 : unsigned(3 DOWNTO 0) := "0000";
    -- Declare a signal to control the detection process
    SIGNAL sendDetec : STD_LOGIC := '1';

BEGIN
    PROCESS (clk)
    BEGIN
        -- Wait for a rising edge on the clock signal
        IF rising_edge(clk) THEN
            -- Check if we are currently in the detection phase
            IF sendDetec = '1' THEN -- memberi 10 us deteksi
                -- If we've reached 10 us of detection, reset the temporary signals
                -- and stop sending the detection pulse
                IF count = 10000 THEN -- 10 us deteksi selesai, reset tmp signals untuk perhitungan baru
                    trigger <= '0';
                    sendDetec <= '0';
                    count <= 0;
                    tmpMSB0 <= "0000";
                    temp_MSB1 <= "0000";
                ELSE
                    trigger <= '1';
                    count <= count + 1;
                END IF;
            -- If we're not in the detection phase, start measuring the distance
            ELSE -- stop mengirim deteksi, melakukan perhitungan (5800 clk cycle = 1cm)(perhitungan bernilai 0)
            -- Check if we've received an echo signal
                IF echo = '1' THEN -- kita akan memulai perhitungan lebar dari echo
                    -- If we've counted 1 cm, update the distance calculation
                    IF count = 5799 THEN -- kita menghitung 1 cm
                        -- If we've reached the maximum distance, stop measuring and
                        -- send another detection pulse
                        IF tmpMSB0 = "1001" THEN
                            IF temp_MSB1 = "1001" THEN
                                sendDetec <= '1'; --jarak maksimal ukuran(100 cm), berhenti mengukur, mengirim ulang deteksi(dan mengupdate output)
                                MSB0 <= tmpMSB0;
                                MSB1 <= temp_MSB1;
                            -- If we haven't reached the maximum distance, increment
                            -- the distance calculation
                            ELSE
                                temp_MSB1 <= temp_MSB1 + "0001";
                                tmpMSB0 <= "0000";
                            END IF;
                        -- If we haven't counted a full 1 cm yet, continue counting
                        ELSE
                            tmpMSB0 <= tmpMSB0 + "0001";
                        END IF;
                        -- Reset the count for the next 1 cm measurement
                        count <= 0;
                    -- If we haven't counted a full 1 cm yet, continue counting
                    ELSE
                        count <= count + 1;
                    END IF;
                    -- If we receive a falling edge on the echo signal, stop measuring
                    -- and send another detection pulse
                    IF echo = '0' THEN
                        sendDetec <= '1';
                        MSB0 <= tmpMSB0;
                        MSB1 <= temp_MSB1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END Sensor_arch;