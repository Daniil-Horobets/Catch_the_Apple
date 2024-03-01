library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Collision is
    Port ( 
           pclk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           i_ex_bg : in boolean;
           i_ex_Player : in boolean;
           i_ex_f0 : in boolean;
           i_ex_f1 : in boolean;
           i_ex_f2 : in boolean;
           i_ex_fp : in boolean;
           
           fall_cnt_f0 : in integer range 1 to 500;
           fall_cnt_f1 : in integer range 1 to 500;
           fall_cnt_f2 : in integer range 1 to 500;
           fall_cnt_fp : in integer range 1 to 1000;
           
           FCnt : in integer range 1 to 960;
           
           o_ex_bg : out boolean;
           o_ex_Player : out boolean;
           o_ex_f0 : out boolean;
           o_ex_f1 : out boolean;
           o_ex_f2 : out boolean;
           o_ex_fp : out boolean;
           
           o_slow : out boolean;
           
           point : out integer range 0 to 1023 ;
           life : out integer range 0 to 63 ;
           game_over : out boolean;
           
           Col_O : out STD_LOGIC_VECTOR (11 downto 0));
end Collision;

architecture Behavioral of Collision is

    
    signal s_ex_bg : boolean ;
    signal s_ex_Player : boolean ;
    signal s_ex_f0 : boolean ;
    signal s_ex_f1 : boolean ;
    signal s_ex_f2 : boolean ;
    signal s_ex_f3 : boolean ;
    signal s_ex_fp : boolean ;
    
    signal s_point : integer range 0 to 1023 := 0 ;
    signal s_life  : integer range 0 to 63 := 3 ;
    
    signal s_f0_gone : boolean := false;
    signal s_f1_gone : boolean := false;
    signal s_f2_gone : boolean := false;
    signal s_fp_gone : boolean := false;
    
    signal s_slow : boolean := false;
    
    signal s_fail0    : boolean := false;
    signal s_fail1    : boolean := false;
    signal s_fail2    : boolean := false;
    signal s_failp    : boolean := false;
    signal s_game_over : boolean := false;

begin

   o_ex_bg <= s_ex_bg;
   o_ex_Player <= s_ex_Player;
   o_ex_f0 <= s_ex_f0;
   o_ex_f1 <= s_ex_f1;
   o_ex_f2 <= s_ex_f2;
   o_ex_fp <= s_ex_fp;
   
   o_slow <= s_slow;
   point <= s_point;
   life <= s_life;
   game_over <= s_game_over;
   
   process (pclk, fall_cnt_f0, fall_cnt_f1, fall_cnt_f2, fall_cnt_fp)
   begin
        if Reset = '1' then 
            s_life <= 3;
            s_point <= 0;
            s_slow <= false;
            
   
        elsif rising_edge(pclk) then
        
        
            -- game over control
            if s_life = 0 then
                s_life <= 3;
                s_point <= 0;
                s_game_over <= true;
                s_slow <= false;

            else 
                s_game_over <= false;
            end if;
            
            
            
            s_slow <= false;
            
            if i_ex_Player and i_ex_f0 then
            
                -- Player catch fruit0
                if fall_cnt_f0 > 420 then
                    if s_f0_gone = false then
                        s_point <= s_point + 1;
                        s_f0_gone <= true;
                        if s_point >= 3 then
                            s_life <= s_life + 1;
                            s_point <= 0;
                        end if;
                        s_ex_f0 <= false;
                    end if;
                end if;
            elsif i_ex_Player and i_ex_fp then
                if fall_cnt_fp > 420 then
                    if s_fp_gone = false then
                        s_slow <= true;
                        s_fp_gone <= true;
                        s_ex_fp <= false;
                    end if;
                end if;                        
                
            elsif i_ex_Player and i_ex_f1 then      
                      
                -- Player catch fruit1
                if fall_cnt_f1 > 420 then
                    if s_f1_gone = false then
                        s_point <= s_point + 1;
                        s_f1_gone <= true;
                        if s_point >= 3 then
                            s_life <= s_life + 1;
                            s_point <= 0;
                        end if;
                        s_ex_f1 <= false;
                    end if;
                end if;    
                
            elsif i_ex_Player and i_ex_f2 then
                      
               -- Player catch fruit2
                if fall_cnt_f2 > 420 then
                    if s_f2_gone = false then
                        s_point <= s_point + 1;
                        s_f2_gone <= true;
                        if s_point >= 3 then
                            s_life <= s_life + 1;
                            s_point <= 0;
                        end if;
                        s_ex_f2 <= false;
                    end if;
                end if;     
                     
            else
                
                if s_f0_gone = false then
                    s_ex_f0 <= i_ex_f0;
                else 
                    s_ex_f0 <= false;
                end if;
                
                if s_fp_gone = false then
                    s_ex_fp <= i_ex_fp;
                    
--                    s_slow <= false;
                else 
                    s_ex_fp <= false;
                end if;                
                
                
                if s_f1_gone = false then
                    s_ex_f1 <= i_ex_f1;
                else 
                    s_ex_f1 <= false;
                end if;
                
                
                if s_f2_gone = false then
                    s_ex_f2 <= i_ex_f2;
                else 
                    s_ex_f2 <= false;
                end if;
            
                
                if fall_cnt_f0 >= 460 and fall_cnt_f0 <= 479 and s_f0_gone = false then
                    s_fail0 <= true;
                end if;
                if fall_cnt_f1 >= 460 and fall_cnt_f1 <= 479 and s_f1_gone = false then
                    s_fail1 <= true;
                end if;
                if fall_cnt_f2 >= 460 and fall_cnt_f2 <= 479 and s_f2_gone = false then
                    s_fail2 <= true;
                end if;
                
                if fall_cnt_fp >= 460 and fall_cnt_fp <= 479 and s_fp_gone = false then
                    s_failp <= true;
                end if;
                
                
                if fall_cnt_f0 >= 480 and fall_cnt_f0 <= 490 then
                    s_f0_gone <= false;
                end if;
                if fall_cnt_f1 >= 480 and fall_cnt_f1 <= 490 then
                     s_f1_gone <= false;
                end if;
                if fall_cnt_f2 >= 480 and fall_cnt_f2 <= 490 then
                     s_f2_gone <= false;
                end if;
                if fall_cnt_fp >= 480 and fall_cnt_fp<= 490 then
                     s_fp_gone <= false;
                end if;
                
--                if fall_cnt_fp >= 950 then
--                     s_slow <= false;
--                end if;
                
                                
                if fall_cnt_f0 >= 491 and fall_cnt_f0 <= 500 and s_fail0 = true then
                    s_life <= s_life - 1;
                    s_fail0 <= false;
                end if;
                if fall_cnt_f1 >= 491 and fall_cnt_f1 <= 500 and s_fail1 = true then
                    s_life <= s_life - 1;
                    s_fail1 <= false;
                end if;
                if fall_cnt_f2 >= 491 and fall_cnt_f2 <= 500 and s_fail2 = true then
                    s_life <= s_life - 1;
                    s_fail2 <= false;
                end if;
                if fall_cnt_fp >= 491 and fall_cnt_fp <= 500 and s_failp = true then
                    s_failp <= false;
                end if;
                
               
               s_ex_bg <= i_ex_bg ; 
               s_ex_Player <= i_ex_Player ;                  
            end if;
        end if;
   end process;
   


end Behavioral;
