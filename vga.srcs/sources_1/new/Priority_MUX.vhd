library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Priority_MUX is
    Port ( 
           pclk : in STD_LOGIC;
           Col_bg : in STD_LOGIC_VECTOR (11 downto 0);
           Col_Player : in STD_LOGIC_VECTOR (11 downto 0);
           Col_f0 : in STD_LOGIC_VECTOR (11 downto 0);
           Col_f1 : in STD_LOGIC_VECTOR (11 downto 0);
           Col_f2 : in STD_LOGIC_VECTOR (11 downto 0);
           Col_fp : in STD_LOGIC_VECTOR (11 downto 0);
           Col_life : in STD_LOGIC_VECTOR (11 downto 0);
           
           ex_bg : in boolean;
           ex_Player : in boolean;
           ex_f0 : in boolean;
           ex_f1 : in boolean;
           ex_f2 : in boolean;
           ex_fp : in boolean;
           ex_life : in boolean;
           
           Col_O : out STD_LOGIC_VECTOR (11 downto 0));
end Priority_MUX;

architecture Behavioral of Priority_MUX is

begin


       process (pclk)
       begin
            if rising_edge(pclk) then
            
                    
                if ex_Player then
                    Col_O <= Col_Player;
                elsif ex_f0  and ex_Player = false then
                    Col_O <= Col_f0;
                elsif ex_f1  and ex_Player = false then
                    Col_O <= Col_f1;
                elsif ex_f2  and ex_Player = false then
                    Col_O <= Col_f2;
                elsif ex_fp  and ex_Player = false then
                    Col_O <= Col_fp;
                elsif ex_life then
                    Col_O <= Col_life;
                else
                    Col_O <= Col_bg;
                end if;
            end if;
       end process;


end Behavioral;
