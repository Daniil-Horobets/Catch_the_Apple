library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Player is
    Port ( 
           pclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           HCnt : in integer range 1 to 800;
           VCnt : in integer range 1 to 525;
           FCnt : in integer range 1 to 960;
           FEnd : in STD_LOGIC;
           game_over : in boolean;
           
           i_slow : in boolean;
           
           L_direction: in STD_LOGIC;
           R_direction: in STD_LOGIC;
           
           Color : out STD_LOGIC_VECTOR (11 downto 0);
           exist : out boolean);
end Player;

architecture Behavioral of Player is

    signal s_Color : STD_LOGIC_VECTOR (11 downto 0);
    signal s_exist : STD_LOGIC ;
    
    signal shift_cnt : integer range 1 to 480 := 1;
    
    signal s_position : integer range 10 to 630 := 320;
    
    subtype ColType is std_logic_vector (11 downto 0);
    
    signal speed : integer range 2 to 5 := 5;
    signal to_count : boolean := false;
    
    constant Red: ColType := X"F00";
    constant Green: ColType := X"0F0";
    constant Blue: ColType := X"00F";
    
    constant Black : ColType := X"000";
    constant White : ColType := X"FFF";
    constant light_Brown: ColType := X"B73";
    
    constant Brown : ColType := X"600";
    
    constant Length : integer := 25;
    
    
    constant center_y : integer := 390; 
    constant radius : integer := 40; 
    
    signal slow_counter : integer range 0 to 15 := 0;
    
    
    
  function distance_func (
        HCnt : in integer range 1 to 800;
        VCnt : in integer range 1 to 525;
        center_x : in integer range 1 to 800;
        center_y : in integer range 1 to 525
        )
        return integer is
        variable distance_squared : integer range 0 to 1048575:= 0;
      begin
        distance_squared := (Hcnt - center_x)*(Hcnt - center_x) + (Vcnt - center_y)*(Vcnt - center_y);
        return distance_squared;
     
  end function distance_func;
    
    
begin

    process (pclk, FEnd, reset, game_over)
    
    begin
        if reset = '1' then
        
            s_position <= 320;
        
        elsif rising_edge(pclk) then
        
        if game_over then
            s_position <= 320;
        end if;
        
        
        
        if i_slow then
            to_count <= true;
        end if;
        
        if to_count then
            speed <= 2;
            if FCnt mod 60 = 0 then                
                if slow_counter >= 15 then
                    slow_counter <= 0;
                    speed <= 5;
                    to_count <= false;
                else
                    slow_counter <= slow_counter + 1;
                end if;
            end if;
        end if; 
           
        if FEnd = '1' then
            if L_direction = '1' and R_direction = '0' and s_position >= 30 then
                
                s_position <= s_position - speed;
                                
            elsif R_direction = '1' and L_direction = '0' and s_position <= 610 then
            
                s_position <= s_position + speed;
            
            end if;
            end if;
        end if;
    end process;
    
    process (s_position, HCnt, VCnt)
    begin
--        Color  <= Player;
        exist <= False;
        
        if HCnt >= s_position - Length and HCnt <= s_position + Length then --and VCnt >= 10 and VCnt <= 13 then
            if VCnt >= 420  and VCnt <= 440 then
                if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> s_position, center_y=> center_y + 10) <= radius*radius then
                    exist <= TRUE;
                    if VCnt <= 423 then
                        Color <= light_Brown;
                    elsif VCnt > 423 and VCnt < 435 then
                    
                        if HCnt mod 8 > 4 then
                            Color <= light_Brown;
                        elsif HCnt mod 8 <= 4 then
                            Color <= Brown;

                        end if;
                    
                    elsif VCnt <= 440 and VCnt >= 435 then
                        Color <= light_Brown;
                    end if;
                end if;
            end if;
        end if;    
    end process;

end Behavioral;
