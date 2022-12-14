library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProyekAkhir_tb is
end entity;

architecture bench of ProyekAkhir_tb is

    component ProyekAkhir is
        port (
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
    end component;

    -- signal to be used for the testbench
    signal Machine      : STD_LOGIC;
    signal CLK          : STD_LOGIC;
    signal Sensor       : STD_LOGIC;
    signal Direction    : STD_LOGIC_VECTOR (2 downto 0);
    signal Hook         : STD_LOGIC;
    signal Sampah       : STD_LOGIC;
    signal led          : STD_LOGIC;
    signal buzz         : STD_LOGIC;
    constant period     : time      := 20 ps; --
    signal max_clk      : integer   := 60;
    signal count        : integer   := 0;

begin

    -- The port map statement maps the input and output signals of the component
    -- to the corresponding signals in the testbench
    testMesin : ProyekAkhir port map (
        Machine => Machine,
        CLK => CLK,
        Sen => Sensor,
        Direction (2 downto 0) => Direction (2 downto 0),
        Hook => Hook,
        Sampah => Sampah,
        Lamp => Led,
        Alarm => Buzz
    );

    process
        constant led_red      : STD_LOGIC := '0';
        constant led_green    : STD_LOGIC := '1';   
        constant buzz_off     : STD_LOGIC := '0';
        constant buzz_on      : STD_LOGIC := '1';

    begin
        Machine <= '0';
        Sensor <= '0';
        Hook <= '0';
        wait for period;
        assert (led = led_red)
            report "Machine OFF!" severity note;

        Machine <= '1';
        Sensor <= '0';
        Hook <= '0';
        wait for period;
        assert (led = led_red)
            report "Machine ON!" severity note;

        Machine <= '1';
        Sensor <= '0';
        Hook <= '0';
        Direction <= "001";
        wait for period;
        assert (buzz = buzz_on)
            report "Hook to Back" severity note;

        Machine <= '1';
        Sensor <= '0';
        Hook <= '0';
        Direction <= "011";
        wait for period;
        assert (buzz = buzz_on)
            report "Hook to Left" severity note;

        Machine <= '1';
        Sensor <= '0';
        Hook <= '0';
        Direction <= "101";
        wait for period;
        assert (buzz = buzz_on)
            report "Hook to Right" severity note;

        Machine <= '1';
        Sensor <= '0';
        Hook <= '0';
        Direction <= "000";
        wait for period;
        assert (buzz = buzz_on)
                report "Hook Stop" severity note;

        Machine <= '1';
        Sensor <= '0';
        Hook <= '0';
        wait for period;
        assert (led = led_red)
            report "Hook going down to find debris" severity note;

        Machine <= '1';
        Sensor <= '0';
        Hook <= '1';
        wait for period;
        assert (led = led_red)
            report "Picking up trash" severity note;

        Machine <= '1';
        Sensor <= '1';
        Hook <= '1';
        Sampah <= '1';
        wait for period;
        assert (led = led_green)
            report "The sensor detects the trash is full" severity note;

        Machine <= '1';
        Sensor <= '1';
        Hook <= '0';
        Sampah <= '1';
        wait for period;
        assert (led = led_green)
            report "Hook going up to pickup the debris" severity note;

        Machine <= '0';
        Sensor <= '0';
        Hook <= '0';
        Sampah <= '1';
        wait for period;
        assert (led = led_red)
            report "Machine going OFF!" severity note;
        wait;
    end process;

    process
    begin
        CLK <= '0';
        wait for period/2;
        CLK <= '1';
        wait for period/2;

        if (count <= max_clk) then count <= count + 1;
            else wait;
        end if;
    end process;

end bench;