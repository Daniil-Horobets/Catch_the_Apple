library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_VGA is

end tb_VGA;

architecture Behavioral of tb_VGA is

component TopModule is
    Port ( clk : in STD_LOGIC;
           btnCpuReset : in STD_LOGIC;
           Vsync : out STD_LOGIC;
           Hsync : out STD_LOGIC;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
           btnL : in STD_LOGIC;
           btnR : in STD_LOGIC);
end component;

signal w_clk: std_logic := '0' ;
signal w_VS : STD_LOGIC := '0' ;
signal w_HS : STD_LOGIC := '0' ;
signal w_Res: STD_LOGIC := '1' ;
signal w_vgaRed : std_logic_vector (3 downto 0) := (others => '0') ;
signal w_vgaGreen: std_logic_vector (3 downto 0) := (others => '0') ;
signal w_vgaBlue: std_logic_vector (3 downto 0)  := (others => '0') ;
signal w_btnL : STD_LOGIC := '0';
signal w_btnR : STD_LOGIC := '0';

constant period : time := 10ns;
begin
 
    TopModule_inst : TopModule
    
    port map(
        clk => w_clk ,
        btnCpuReset => w_Res,
        Vsync => w_VS,
        Hsync => w_HS,
        vgaRed=> w_vgaRed,
        vgaGreen=> w_vgaGreen,
        vgaBlue=> w_vgaBlue,
        btnL => w_btnL,
        btnR => w_btnR
    );
    


w_clk <= not w_clk after period/2;

process 
begin
wait for 2 * period;
w_btnR <= '1';
wait for 10 * period;
w_btnR <= '0';

wait;
end process;






end Behavioral;
