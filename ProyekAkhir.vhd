LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ProyekAkhir IS
    PORT (
        -- Input
        Machine     : IN STD_LOGIC; --ON/OFF to turn on or turn off the machine
        CLK         : IN STD_LOGIC; -- CLOCK
        Sen         : IN STD_LOGIC; -- Sensor
        Direction   : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- Direction
        Hook        : IN STD_LOGIC; -- Hook with net

        -- Output
        Sampah  : OUT STD_LOGIC; -- The debris
        Lamp    : OUT STD_LOGIC; -- Led light for direction
        Alarm   : OUT STD_LOGIC  -- Alarm bells for Hook
    );
END ENTITY ProyekAkhir;

ARCHITECTURE behavioral OF ProyekAkhir IS

    COMPONENT Sensor Is
        PORT (
            -- Input
            clk : IN STD_LOGIC; -- Clock
            echo : IN STD_LOGIC; -- Echo

            -- Output
            trigger : OUT STD_LOGIC -- Trigger
        );
end COMPONENT;

    TYPE state_types IS (S0, S1, S2, S3, S4, S5); -- STATE
    SIGNAL next_state, present_state: state_types; -- NextState dan PresentState
    SIGNAL detect : STD_LOGIC; -- Detect for sensors

BEGIN

    -- Sensor Instantiation
    sensorsampah : Sensor PORT MAP(
        echo => Sen, 
        clk => CLK,
        trigger => detect
    );

    -- Synchronous process function to perform Changes to the next state and clock
    sync_proc : PROCESS (CLK, next_state)
    BEGIN
        IF (rising_edge(CLK)) THEN
            present_state <= next_state;
        END IF;
    end process sync_proc;

    -- comb_proc will run the main function of the program
    -- such as hooks, sensors, directions, and starting or stopping the engine
    comb_proc : PROCESS (present_state, Machine, Direction, Hook, Sen)
    BEGIN

        CASE present_state IS
            -- S0 functions to turn on and turn off the machine with M input
            WHEN S0 =>
                IF (Machine = '1') THEN
                    next_state <= S1;
                ELSIF (Machine = '0') THEN
                    next_state <= S0;   
                END IF;

            -- S1 functions to determine the same direction as S2 with the input being D
            WHEN S1 =>
                IF (Direction = "000") THEN
                    next_state <= S2;
                ELSIF (Direction = "001") THEN
                    next_state <= S2;
                ELSIF (Direction = "010") THEN
                    next_state <= S2;
                ELSIF (Direction = "011") THEN
                    next_state <= S2;
                ELSIF (Direction = "101") THEN
                    next_state <= S2; 
                ELSE
                    next_state <= S5;
                END IF;

            -- S2 functions to determine the same direction as S1 with the input being D
            WHEN S2 =>
                IF (Direction = "000") THEN
                    next_state <= S2;
                ELSIF (Direction = "001") THEN
                    next_state <= S2;
                ELSIF (Direction = "010") THEN
                    next_state <= S2;
                ELSIF (Direction = "011") THEN
                    next_state <= S2;
                ELSIF (Direction = "101") THEN
                    next_state <= S2; 
                END IF;

                IF (Sen = '0' and Hook = '1') THEN
                    next_state <= S3;
                    Sampah <= Sen;
                ELSE
                    next_state <= S5;
                END IF;

            -- S3 functions to determine the same direction as S4 with the input being D   
            WHEN S3 =>
                IF (Sen = '0' and Hook = '1') THEN
                    next_state <= S3;
                ELSIF (Sen = '1' and Hook = '1') THEN
                    detect <= Sen;
                    next_state <= S4;
                ELSE
                    next_state <= S5;
                END IF;

            -- S4 serves to raise the hook
            WHEN S4 =>
            Sampah <= Sen;
                IF (Hook = '0') THEN
                Sampah <= '1';
                    next_state <= S0;
                END IF;

            -- S5 works for error handling
            WHEN S5 =>
                next_state <= S0;

        END CASE;
    END PROCESS;

    -- The condition of the led light is on only when state 3 and state 4
    WITH present_state SELECT
        Lamp <= '1' WHEN S3,
                '1' WHEN S4,
                '0' WHEN others;

    -- The condition of the led light is on only when state 2 and state 3
    WITH present_state SELECT
        Alarm <= '1' WHEN S2,
                '1' WHEN S3,
                '0' WHEN others;

END ARCHITECTURE behavioral;