----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2024 12:35:09 PM
-- Design Name: 
-- Module Name: Object - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Object is
    generic(
        H_Pos_L : integer := 5 ;
        H_Len : integer := 3 ;
        V_Pos_L : integer := 5 ;
        V_Len : integer := 3 ;
        Obj_Col : STD_LOGIC_VECTOR (11 downto 0) := X"FFF"
    );
    Port ( 
           pclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           HCnt : in integer;
           VCnt : in integer;
           FCnt : in integer;
           FEnd : in STD_LOGIC;
           
           Color : out STD_LOGIC_VECTOR (11 downto 0);
           exist : out boolean);
end Object;

architecture Behavioral of Object is

    signal s_Color : STD_LOGIC_VECTOR (11 downto 0);
    signal s_exist : STD_LOGIC ;
    
    subtype ColType is std_logic_vector (11 downto 0);
    
    constant Red: ColType := X"F00";
    constant Green: ColType := X"0F0";
    constant Blue: ColType := X"00F";
    
    constant Black : ColType := X"000";
begin

    process (HCnt, VCnt, reset)
    begin
--        if reset = '1' then
--            s_Color <= (others => '0');
--            s_exist <= '0';
--        else
        if HCnt >= H_Pos_L and HCnt <= H_Pos_L +  H_Len and VCnt >= V_Pos_L and VCnt <= V_Pos_L + V_Len then
        
            Color  <= obj_Col; 
                             
        end if;
    end process;

end Behavioral;
