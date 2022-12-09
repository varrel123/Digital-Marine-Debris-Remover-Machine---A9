library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProyekAkhir_tb is
end entity;

architecture bench of ProyekAkhir_tb is

    component ProyekAkhir is
        port (
            -- Input
            M : IN STD_LOGIC; --ON/OFF untuk menyalakan atau mematikan mesin
            CLK : IN STD_LOGIC; -- CLOCK
            Sen : IN STD_LOGIC; -- Sensor
            D : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- Arah
            H : IN STD_LOGIC; -- Kail dengan jaring
    
            -- Output
            Sampah  : OUT STD_LOGIC; -- Sampah
            Lamp    : OUT STD_LOGIC; -- Lampu Led untuk arah
            Alarm    : OUT STD_LOGIC_VECTOR  -- Bel alarm untuk Kail
        );
    end component;

    signal M, CLK, Sen, H, Sampah : STD_LOGIC;
    signal D : STD_LOGIC_VECTOR(1 downto 0);
    constant period : time      := 30 ps;
    signal max_clk  : integer   := 60;
    signal count    : integer   := 0;
    signal sensor   : STD_LOGIC;
    signal led      : STD_LOGIC;
    signal buzz     : STD_LOGIC_VECTOR(1 downto 0);


begin

    testMesin : ProyekAkhir port map (
        M => M,
        CLK => CLK,
        Sen => Sen,
        D => D,
        H => H,
        Sampah => Sampah,
        Lamp => Led,
        Alarm => Buzz
    );

    process
        constant led_red      : STD_LOGIC := '0';
        constant led_green    : STD_LOGIC := '1';   
        constant buzz_front      : STD_LOGIC_VECTOR := "00";
        constant buzz_back      : STD_LOGIC_VECTOR := "01";
        constant buzz_left      : STD_LOGIC_VECTOR := "10";
        constant buzz_right      : STD_LOGIC_VECTOR := "11";
    begin
        M <= '1';
        Sen <= '0';
        H <= '0';
        wait for period;
        assert (led = led_red)
            report "LED is RED, Machine Ready!" severity note;
        
        D <= "00";
        wait for period;
        assert (buzz = buzz_front)
            report "Hook to Forward" severity note;

        D <= "01";
        wait for period;
        assert (buzz = buzz_back)
            report "Hook to Back" severity note;
            
        D <= "10";
        wait for period;
        assert (buzz = buzz_left)
            report "Hook to Left" severity note;

        D <= "11";
        wait for period;
        assert (buzz = buzz_right)
            report "Hook to Right" severity note;
        
        H <= '1';
        wait for period;
        assert (led = led_red)
            report "Hook going down to find debris" severity note;

        Sen <= '0';
        wait for period;
        assert (led = led_red)
            report "Picking up trash" severity note;

        Sen <= '1';
        wait for period;
        assert (led = led_green)
            report "The sensor detects the trash is full" severity note;

        H <= '0';
        wait for period;
        assert (led = led_green)
            report "Hook going up to pickup the debris" severity note;
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