library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_Controller is
    Port ( pclk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Color : in STD_LOGIC_VECTOR (11 downto 0);
           HS : out STD_LOGIC;
           VS : out STD_LOGIC;
           VGARed : out STD_LOGIC_VECTOR (3 downto 0);
           VGAGreen : out STD_LOGIC_VECTOR (3 downto 0);
           VGABlue : out STD_LOGIC_VECTOR (3 downto 0);
           
           HCnt : out integer range 1 to 800;
           VCnt : out integer range 1 to 525;
           FCnt : out integer range 1 to 960;
           FEnd : out STD_LOGIC
           );
end VGA_Controller;


architecture Behavioral of VGA_Controller is

    -- VGA timing constants
    constant H_SYNC_PULSE : integer := 96;
    constant H_BACK_PORCH : integer := 48;
    constant H_ACTIVE_VIDEO : integer := 640;
    constant H_FRONT_PORCH : integer := 16;
    constant H_TOTAL : integer := 800;

    constant V_SYNC_PULSE : integer := 2;
    constant V_BACK_PORCH : integer := 33;
    constant V_ACTIVE_VIDEO : integer := 480;
    constant V_FRONT_PORCH : integer := 10;
    constant V_TOTAL : integer := 525;
    constant F_TOTAL : integer := 960;

    -- Counters
    signal h_count : integer range 1 to H_TOTAL := 1;
    signal v_count : integer range 1 to V_TOTAL := 1;
    signal f_count : integer range 1 to F_TOTAL := 1;
  
begin

    HCnt <= h_count ;
    VCnt <= v_count ;
    FCnt <= f_count ;

   -- VGA signal generation process
    vga_process : process(pclk, reset)
    begin
        if reset = '1' then
            -- Reset the counters
            h_count <= 1;
            v_count <= 1;
            f_count <= 1;

        elsif rising_edge(pclk) then
        
        
            FEnd <= '0';
--             Frame end
--            if v_count = V_TOTAL then
--                FEnd <= '1';
--            else
--                FEnd <= '0';
--            end if;
                
        
            -- Horizontal counter
            if h_count < H_TOTAL then
                h_count <= h_count + 1;
            else
                h_count <= 1;
                -- Vertical counter
--                f_end <= '0';
                if v_count < V_TOTAL then
                    v_count <= v_count + 1;
                else
                    FEnd <= '1';
                    v_count <= 1;
                    
                    -- Frame counter
                    if f_count < F_TOTAL then
                        f_count <= f_count + 1 ;
                    else 
                        f_count <= 1 ;
                    end if;
                end if;
            end if;
    
        end if;
    end process;
    
    counting_process : process(v_count, h_count, color)
    begin
    
        -- Generate sync pulses
        -- h_count =>  1 and h_count < H_ACTIVE_VIDEO + H_FRONT_PORCH then HS <='1'
        if h_count >  H_ACTIVE_VIDEO + H_FRONT_PORCH and h_count < H_ACTIVE_VIDEO + H_FRONT_PORCH + H_SYNC_PULSE then
            HS <= '0';
        else
            HS <= '1';
        end if;

        if v_count >  V_ACTIVE_VIDEO + V_FRONT_PORCH and V_count < V_ACTIVE_VIDEO + V_FRONT_PORCH + V_SYNC_PULSE then
            VS <= '0';
        else
            VS <= '1';
        end if;

        -- Generate green color during active video time
        if h_count >= 1 and h_count <= H_ACTIVE_VIDEO and
           v_count >= 1 and v_count <= V_ACTIVE_VIDEO then
           
            VGARed <= Color(11 downto 8);
            VGAGreen <= Color(7 downto 4);
            VGABlue <= Color(3 downto 0);
           
--             if h_count = 1 or h_count = 640 or v_count = 1 or v_count = 480 then
--                    VGARed <= not Color(11 downto 8);
--                    VGAGreen <= not  Color(7 downto 4);
--                    VGABlue <= not  Color(3 downto 0);
--            end if;
                 
        else
            VGARed <= (others => '0');
            VGAGreen <= (others => '0');
            VGABlue <= (others => '0');
        end if;

    end process;

end Behavioral;

