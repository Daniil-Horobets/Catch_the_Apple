library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Background_Object is
    Port ( 
           pclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           HCnt : in integer range 1 to 800;
           VCnt : in integer range 1 to 525;
           FCnt : in integer range 1 to 960;
           FEnd : in STD_LOGIC;
           
           Color : out STD_LOGIC_VECTOR (11 downto 0);
           exist : out boolean);
end Background_Object;

architecture Behavioral of Background_Object is

    signal s_Color : STD_LOGIC_VECTOR (11 downto 0);
    signal s_exist : STD_LOGIC ;
    
    signal shift_cnt : integer range 1 to 480 := 1;
    
    subtype ColType is std_logic_vector (11 downto 0);
    
    constant Red: ColType := X"F00";
    constant Green: ColType := X"0F0";
    constant GreenLow: ColType := X"0B0";
    constant Grass: ColType := X"0FA";
    constant GrassL: ColType := X"076";
    constant Blue: ColType := X"00F";
    constant Sky: ColType := X"36B";
    constant Brown: ColType := X"B40";
    constant dark_Brown: ColType := X"740";
    constant dark_Green: ColType := X"040";

    
    constant Black : ColType := X"000";
    constant White : ColType := X"FFF";
    
    
    constant center_x : integer := 320;
    constant center_y : integer := 240; 
    constant radius : integer := 40; 
    
    
    constant radius_G1 : integer := 70; 
    constant radius_G2 : integer := 67; 


    constant vertex1_x : integer := 110;
    constant vertex1_y : integer := 400;
    constant vertex2_x : integer := 210;
    constant vertex2_y : integer := 400; 
    constant vertex3_x : integer := 160;
    constant vertex3_y : integer := 20;
    
        
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

Shift_Counter : process (pclk, FEnd)
begin

end process;

Main_Process : process (HCnt, VCnt, shift_cnt)
    
    variable area : integer range 0 to 2000000;
    variable alpha : integer ; -- range -2000000 to 2000000;
    variable beta : integer ; -- range -2000000 to 2000000;
    variable gamma : integer ; -- range -2000000 to 2000000;

    begin
    exist <= True;
    color <= black;
    
        if HCnt >= 0 and HCnt <= 640 then
            if VCnt >= 380 and VCnt <= 480 then
                Color  <= Grass;
            end if;
            if VCnt >= 0 and VCnt <= 379 then
                Color  <= Sky;
            end if;
            
        end if;

--         base of trees
        if (HCnt >= 160 - 50 and HCnt <= 160 + 50) or (HCnt >= 480 - 50 and HCnt <= 480 + 50) then
            if VCnt >= 120 and VCnt <= 400 then
            
                if HCnt mod 6 = 0 or HCnt mod 6 = 1 then               
                    Color  <= Brown;
                elsif HCnt mod 6 = 2 or HCnt mod 6 = 3 then
                    Color <= dark_Brown;
                elsif HCnt mod 6 = 4 or HCnt mod 6 = 5 then
                    Color <= Black;
                end if;
                
                
                if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 220, center_y=> 450) < radius_G2*radius_G2 then
                    Color  <= Grass;
                elsif distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 220, center_y=> 450) <= radius_G1*radius_G1 and distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 220, center_y=> 450) >= radius_G2*radius_G2 then
                    Color <= dark_Green;
                end if;
                
                if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 110, center_y=> 460) < radius_G2*radius_G2 then
                    Color  <= Grass;
                elsif distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 110, center_y=> 460) <= radius_G1*radius_G1 and distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 220, center_y=> 450) >= radius_G2*radius_G2 then
                    Color <= dark_Green;
                end if;
                --------
                if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 220 + 320, center_y=> 450) < radius_G2*radius_G2 then
                    Color  <= Grass;
                elsif distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 220 + 320, center_y=> 450) <= radius_G1*radius_G1 and distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 220 + 320, center_y=> 450) >= radius_G2*radius_G2 then
                    Color <= dark_Green;
                end if;
                
                if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 110 + 320, center_y=> 460) < radius_G2*radius_G2 then
                    Color  <= Grass;
                elsif distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 110 + 320, center_y=> 460) <= radius_G1*radius_G1 and distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 220 + 320, center_y=> 450) >= radius_G2*radius_G2 then
                    Color <= dark_Green;
                end if;
                
            end if;
        end if;    

        ---------------------------------------------------
--          distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> center_x, center_y=> center_y)
--          round trees
          
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 80, center_y=> 230) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 80, center_y=> 150) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 80, center_y=> 70) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 160, center_y=> 70) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 240, center_y=> 70) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 240, center_y=> 150) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 240, center_y=> 230) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 160, center_y=> 230) <= radius*radius then
                Color  <= GreenLow;
            end if;
        -----------------------------------------------------
        
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 80 + 320, center_y=> 230) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 80 + 320, center_y=> 150) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 80 + 320, center_y=> 70) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 160 + 320, center_y=> 70) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 240 + 320, center_y=> 70) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 240 + 320, center_y=> 150) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 240 + 320, center_y=> 230) <= radius*radius then
                Color  <= GreenLow;
            end if;
            if distance_func (HCnt => HCnt, VCnt => VCnt, center_x=> 160 + 320, center_y=> 230) <= radius*radius then
                Color  <= GreenLow;
            end if;
        
        
            
         -- leavs of trees    
         if (HCnt >= 160 - 90 and HCnt <= 160 + 90) or (HCnt >= 480 - 90 and HCnt <= 480 + 90) then
            if VCnt >= 50 and VCnt <= 250 then
                Color  <= GreenLow;
            end if;
        end if;
        
        -- left little Apples    
        if HCnt >= 60 and HCnt <= 60 + 3 then
            if VCnt >= 157 and VCnt <= 157 + 3 then
                Color  <= Red;
            end if;
        end if;
        if HCnt >= 103 and HCnt <= 103 + 3 then
            if VCnt >= 230  and VCnt <= 230 + 3 then
                Color  <= Red;
            end if;
        end if;
        if HCnt >= 167 and HCnt <= 167 + 3 then
            if VCnt >= 40 and VCnt <= 40 + 3 then
                Color  <= Red;
            end if;
        end if;
        if HCnt >= 203 and HCnt <= 203 + 3 then
            if VCnt >= 189 and VCnt <= 189 + 3 then
                Color  <= Red;
            end if;
        end if;
        if HCnt >= 240 and HCnt <= 240 + 3 then
            if VCnt >= 105 and VCnt <= 105 + 3 then
                Color  <= Red;
            end if;
        end if;
        if HCnt >= 160 and HCnt <= 160 + 3 then
            if VCnt >= 135 and VCnt <= 135 + 3 then
                Color  <= Red;
            end if;
        end if;
        
        -- right little Apples    
        if HCnt >= 60 + 320 and HCnt <= 60 + 3 + 320 then
            if VCnt >= 157 and VCnt <= 157 + 3 then
                Color  <= Red;
            end if;
        end if;
        if HCnt >= 103 + 320 and HCnt <= 103 + 3 + 320 then
            if VCnt >= 230  and VCnt <= 230 + 3 then
                Color  <= Red;
            end if;
        end if;
        if HCnt >= 167 + 320 and HCnt <= 167 + 3 + 320 then
            if VCnt >= 40 and VCnt <= 40 + 3 then
                Color  <= Red;
            end if;
        end if;
        if HCnt >= 203 + 320 and HCnt <= 203 + 3 + 320 then
            if VCnt >= 189 and VCnt <= 189 + 3 then
                Color  <= Red;
            end if;
        end if;
        if HCnt >= 240 + 320 and HCnt <= 240 + 3 + 320 then
            if VCnt >= 105 and VCnt <= 105 + 3 then
                Color  <= Red;
            end if;
        end if;
        if HCnt >= 160 + 320 and HCnt <= 160 + 3 + 320 then
            if VCnt >= 135 and VCnt <= 135 + 3 then
                Color  <= Red;
            end if;
        end if;

        
    end process;


end Behavioral;
