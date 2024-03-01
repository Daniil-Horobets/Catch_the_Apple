library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Life_Counter is
    Port ( 
           pclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           HCnt : in integer range 1 to 800;
           VCnt : in integer range 1 to 525;
           FCnt : in integer range 1 to 960;
           FEnd : in STD_LOGIC;
           
           life : in integer range 0 to 63;
           Color : out STD_LOGIC_VECTOR (11 downto 0);
           exist : out boolean);
end Life_Counter;

architecture Behavioral of Life_Counter is
    
    
    subtype ColType is std_logic_vector (11 downto 0);
    
    constant Red: ColType := X"F00";
    constant Green: ColType := X"0F0";
    constant Blue: ColType := X"00F";
    
    constant Black : ColType := X"000";
    constant White : ColType := X"FFF";
    
    constant VShift : integer := 10;
    constant HShift : integer := 10;
    signal i: integer range 0 to 100 := 0;
    
      
begin


    i <= VCnt/10;


    process(HCnt, VCnt, life, i)
    begin
    
    
        exist <= False;
        Color  <= Red;
           
           if i < life then
           
                if HCnt = 3 + HShift and HCnt = 9 + HShift then 
                        if VCnt = 1 + VShift * i then
                            exist <= True;
                        end if;
                end if;
                
                if (HCnt >= 2 + HShift and HCnt <= 4 + HShift) or (HCnt >= 8 + HShift and HCnt <= 10 + HShift) then 
                        if VCnt = 2 + VShift * i then
                            exist <= True;
                        end if;
                end if;
                
                if (HCnt >= 1 + HShift and HCnt <= 5 + HShift) or (HCnt >= 7 + HShift and HCnt <= 11 + HShift) then 
                        if VCnt = 3 + VShift * i then
                            exist <= True;
                        end if;
                end if;
                
                if HCnt >= 1 + HShift and HCnt <= 11 + HShift then 
                        if VCnt >= 4 + VShift * i and VCnt <= 5 + VShift * i then
                            exist <= True;
                        end if;
                end if;   
                
                if HCnt >= 2 + HShift and HCnt <= 10 + HShift then 
                        if VCnt = 6 + VShift * i then
                            exist <= True;
                        end if;
                end if;   
                
                if HCnt >= 3 + HShift and HCnt <= 9 + HShift then 
                        if VCnt = 7 + VShift * i then
                            exist <= True;
                        end if;
                end if;   
                
                
                if HCnt >= 4 + HShift and HCnt <= 8 + HShift then 
                        if VCnt = 8 + VShift * i then
                            exist <= True;
                        end if;
                end if;   
                
                
                if HCnt >= 5 + HShift and HCnt <= 7 + HShift then 
                        if VCnt = 9 + VShift * i then
                            exist <= True;
                        end if;
                end if;    
                
                
                if HCnt = 6 + HShift then 
                        if VCnt = 10 + VShift * i then
                            exist <= True;
                        end if;
                end if;   
           
           end if;
    end process;


end Behavioral;
