library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity poisonous_fruit is
    generic(
            id_Num : integer range 0 to 20 := 0;
            rand_vec_start : bit_vector (11 downto 0) := "101010010011";
            ColorTest : STD_LOGIC_VECTOR := X"FFF";
            init_time : integer range 0 to 7 := 0
            );
    Port ( 
           pclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           HCnt : in integer range 1 to 800;
           VCnt : in integer range 1 to 525;
           FCnt : in integer range 1 to 960;
           FEnd : in STD_LOGIC;
           Color : out STD_LOGIC_VECTOR (11 downto 0);
           exist : out boolean;
           fallCnt : out integer range 1 to 500;
           
           game_over : in boolean
           );
end poisonous_fruit;

architecture Behavioral of poisonous_fruit is

    constant FALL_CNT_TOTAL : integer := 1000;
        
    signal s_Color : STD_LOGIC_VECTOR (11 downto 0);
    signal s_exist : STD_LOGIC ;
    signal x_pos : integer range 0 to 640 := 10 ;
    signal s_readyNum : boolean := false;
    signal rand_val_h : integer range 0 to 63 := to_integer(unsigned(to_stdLogicVector(rand_vec_start(5 downto 0)))) ;
    signal rand_val_v : integer range 0 to 2 ;
    signal rand_time : integer range 0 to 7 := init_time ;
    
    signal sec : integer range 1 to 16 := 1 ;
    signal fall_cnt : integer range 1 to FALL_CNT_TOTAL := 1 ;
    
    
    signal to_generate : boolean := false;
    signal count_fall_cnt : boolean := True;
    
    
    subtype ColType is std_logic_vector (11 downto 0);
    
    constant Red: ColType := X"F00";
    constant Green: ColType := X"0F0";
    constant Blue: ColType := X"00F";
    constant Gray: ColType := X"555";
    
    constant Black : ColType := X"000";
    constant White : ColType := X"FFF";
    
    
    
    ------------------------------------
  signal rand_vec   : bit_vector (11 downto 0) := rand_vec_start;
  -----------------------------------------
      
begin

random_position : process (pclk, reset, game_over)
 
 begin
 
   if reset = '1' then
        
        fall_cnt <= 1;
  
   elsif rising_edge(pclk) then
   
        if game_over then 
            fall_cnt <= 1;
        end if; 
   
        if FEnd = '1' and count_fall_cnt then
            if fall_cnt < FALL_CNT_TOTAL then
                fall_cnt <= fall_cnt + rand_val_v / 2 + 1;            
            else 
                fall_cnt <= 1 ;
            end if;
        end if;
    
        if FEnd = '1' and fall_cnt > 490 then --rising_edge(pclk) then -- FEnd = '1' then -- rising_edge(pclk) then -- 
            rand_vec <=  rand_vec sll 1; 
            rand_vec(0) <= rand_vec(11) xnor rand_vec(10) xnor rand_vec(9) xnor rand_vec(4);   
            rand_val_h <= to_integer(unsigned(to_stdLogicVector(rand_vec(5 downto 0))));
            rand_val_v <= to_integer(unsigned(to_stdLogicVector(rand_vec(4 downto 3))));
            rand_time <= to_integer(unsigned(to_stdLogicVector(rand_vec(8 downto 6))));
        end if;
        
        if FCnt mod 60 = 0 and FEnd = '1' then
            sec <= sec + 1;
            if sec = 16 then
                sec <= 1;
            end if;
        end if;
        
        
        if sec > rand_time then
        
            to_generate <= true;       
            
        end if;
        
        if to_generate then
             
            exist <= False; 
            count_fall_cnt <= true;  
            
            if HCnt = 5 + rand_val_h * 10 then 
                    if VCnt = 1 + fall_cnt then
                        Color  <= Green;
                        exist <= True;
                    end if;
            end if;
            
            if HCnt = 4 + rand_val_h * 10 then 
                    if VCnt = 2 + fall_cnt then
                        Color  <= Green;
                        exist <= True;
                    end if;
            end if;
            
            if HCnt = 4 + rand_val_h * 10 then 
                    if VCnt = 3 + fall_cnt then
                        Color  <= Green;
                        exist <= True;
                    end if;
            end if;
            
            if (HCnt >= 2 + rand_val_h * 10 and HCnt <= 3 + rand_val_h * 10) or (HCnt >= 5 + rand_val_h * 10 and HCnt <= 6 + rand_val_h * 10) then 
                    if VCnt = 3 + fall_cnt then
                        Color  <= Gray;
                        exist <= True;
                    end if;
            end if;
            
            if HCnt >= 1 + rand_val_h * 10 and HCnt <= 7 + rand_val_h * 10 then 
                    if VCnt >= 4 + fall_cnt and VCnt <= 8 + fall_cnt then
                        Color  <= Gray;
                        exist <= True;
                    end if;
            end if;
            
            
            if (HCnt >= 2 + rand_val_h * 10 and HCnt <= 3 + rand_val_h * 10) or (HCnt >= 5 + rand_val_h * 10 and HCnt <= 6 + rand_val_h * 10) then 
                    if VCnt = 9 + fall_cnt then
                        Color  <= Gray;
                        exist <= True;
                    end if;
            end if;
            
            
                  
--            if HCnt >= rand_val_h * 10 and HCnt <= rand_val_h * 10 + 5 then 
--                    if VCnt >= fall_cnt and VCnt <= fall_cnt + 5 then
--                        Color  <= ColorTest;
--                        exist <= TRUE;
--                    end if;
--            end if;
            
       else
            exist <= False;  
            count_fall_cnt <= false;  
            fall_cnt <= 1;  
--            if HCnt >= rand_val_h * 10 and HCnt <= rand_val_h * 10 + 5 then 
--                    if VCnt >= -5 and VCnt <= -5 + 5 then
--                        Color  <= ColorTest;
--                        exist <= TRUE;
--                    end if;
--            end if;
            
            if HCnt = 5 + rand_val_h * 10 then 
                    if VCnt = 1 + fall_cnt - 10 then
                        Color  <= Green;
                        exist <= True;
                    end if;
            end if;
            
            if HCnt = 4 + rand_val_h * 10 then 
                    if VCnt = 2 + fall_cnt - 10 then
                        Color  <= Green;
                        exist <= True;
                    end if;
            end if;
            
            if HCnt = 4 + rand_val_h * 10 then 
                    if VCnt = 3 + fall_cnt - 10 then
                        Color  <= Green;
                        exist <= True;
                    end if;
            end if;
            
            if (HCnt >= 2 + rand_val_h * 10 and HCnt <= 3 + rand_val_h * 10) or (HCnt >= 5 + rand_val_h * 10 and HCnt <= 6 + rand_val_h * 10) then 
                    if VCnt = 3 + fall_cnt - 10 then
                        Color  <= Gray;
                        exist <= True;
                    end if;
            end if;
            
            if HCnt >= 1 + rand_val_h * 10 and HCnt <= 7 + rand_val_h * 10 then 
                    if VCnt >= 4 + fall_cnt - 10 and VCnt <= 8 + fall_cnt - 10 then
                        Color  <= Gray;
                        exist <= True;
                    end if;
            end if;
            
            
            if (HCnt >= 2 + rand_val_h * 10 and HCnt <= 3 + rand_val_h * 10) or (HCnt >= 5 + rand_val_h * 10 and HCnt <= 6 + rand_val_h * 10) then 
                    if VCnt = 9 + fall_cnt - 10 then
                        Color  <= Gray;
                        exist <= True;
                    end if;
            end if;
            
            
                       
        end if;      
    end if;
 end process;  

fallCnt <= fall_cnt;

end Behavioral;
