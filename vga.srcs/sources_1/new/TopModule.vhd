library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Catch_the_Apple is
    Port ( clk : in STD_LOGIC;
           btnCpuReset : in STD_LOGIC;
           btnL : in STD_LOGIC;
           btnR : in STD_LOGIC;
           Vsync : out STD_LOGIC;
           Hsync : out STD_LOGIC;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0));
end Catch_the_Apple;

architecture Behavioral of Catch_the_Apple is

    signal pclk : STD_LOGIC ;
    signal inverted_reset : STD_LOGIC;
    
    signal s_HCnt : integer range 1 to 800;
    signal s_VCnt : integer range 1 to 525;
    signal s_FCnt : integer range 1 to 960;
    signal s_FEnd : STD_LOGIC;
    
    signal s_Color: STD_LOGIC_VECTOR (11 downto 0);
    signal s_Col_bg: STD_LOGIC_VECTOR (11 downto 0);
    signal s_Col_Player: STD_LOGIC_VECTOR (11 downto 0);
    signal s_Col_f0: STD_LOGIC_VECTOR (11 downto 0);
    signal s_Col_f1: STD_LOGIC_VECTOR (11 downto 0);
    signal s_Col_f2: STD_LOGIC_VECTOR (11 downto 0);
    signal s_Col_fp: STD_LOGIC_VECTOR (11 downto 0);
    
    signal s_ex_bg : boolean;
    signal s_ex_Player  : boolean;
    signal s_ex_f0 : boolean;
    signal s_ex_f1 : boolean;
    signal s_ex_f2 : boolean;
    signal s_ex_fp : boolean;
    
    signal s1_ex_bg : boolean;
    signal s1_ex_Player  : boolean;
    signal s1_ex_f0 : boolean;
    signal s1_ex_f1 : boolean;
    signal s1_ex_f2 : boolean;
    signal s1_ex_fp : boolean;
    
    signal s_slow : boolean;
    
    signal s_life : integer range 0 to 63; 
    signal s_Col_life : STD_LOGIC_VECTOR (11 downto 0);
    signal s_ex_life : boolean;  
    signal s_game_over : boolean; 
    
   
    
    signal s_Cnt_O : integer range 0 to 3 := 0 ;
    
    signal s_fallCnt_f0 : integer range 1 to 500 ;
    signal s_fallCnt_f1 : integer range 1 to 500 ;
    signal s_fallCnt_f2 : integer range 1 to 500 ;
    signal s_fallCnt_fp : integer range 1 to 500 ;
    
    
component poisonous_fruit is
    generic(
            id_Num : integer range 0 to 20  := 0;
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
end component;    


    
component Priority_MUX 
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
end component;    

component Fruit is
    generic(
            id_Num : integer range 0 to 20  := 0;
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
end component;
    
component VGA_Controller 
port 
 (
           pclk : in STD_LOGIC;
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
end component;

component Player is
    Port ( 
           pclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           HCnt : in integer range 1 to 800;
           VCnt : in integer range 1 to 525;
           FCnt : in integer range 1 to 960;
           FEnd : in STD_LOGIC;
           game_over : in boolean;
           
           L_direction: in STD_LOGIC;
           R_direction: in STD_LOGIC;
           
           i_slow : in boolean;
           
           Color : out STD_LOGIC_VECTOR (11 downto 0);
           exist : out boolean);
end component;

component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  clk_in1           : in     std_logic
 );
end component;

component Background_Object
port
 (         pclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           HCnt : in integer range 1 to 800;
           VCnt : in integer range 1 to 525;
           FCnt : in integer range 1 to 960;
           FEnd : in STD_LOGIC;
           Color : out STD_LOGIC_VECTOR (11 downto 0);
           exist : out boolean
 );
 
end component;


component Collision is
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
           fall_cnt_fp : in integer range 1 to 500;
           
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
end component;


component Life_Counter is
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
end component;


begin

    inverted_reset <= not btnCpuReset;

    clk_wiz_0_inst : clk_wiz_0
       port map (
        -- Clock out ports
        clk_out1 => pclk, -- Connect to the pclk signal
        -- Status and control signals
        reset => inverted_reset, -- Connect to the inverted reset signal
       -- Clock in ports
        clk_in1 => clk -- Connect to your input clock
    );
    
    
    VGA_Controller_inst : VGA_Controller 
        port map (
        pclk => pclk,
        Reset => inverted_reset,
        Color => s_Color,
        HS  => Hsync,
        VS  => Vsync,
        VGARed => vgaRed,
        VGAGreen => vgaGreen,
        VGABlue => vgaBlue,
        
       HCnt => s_HCnt ,
       VCnt => s_VCnt ,
       FCnt => s_FCnt ,
       FEnd => s_FEnd
    );
    
    Background_Object_inst : Background_Object 
    port map (
    
           pclk => pclk,
           reset => inverted_reset,
           HCnt => s_HCnt,
           VCnt => s_VCnt,
           FCnt => s_FCnt,
           FEnd => s_FEnd,
           Color => s_Col_bg,
           exist => open  
    );
    

    
    Priority_MUX_inst : Priority_MUX
           port map(
           pclk => pclk,
           Col_bg => s_Col_bg,
           Col_Player => s_Col_Player,        
           Col_f0 => s_Col_f0,        
           Col_f1 => s_Col_f1,  
           Col_f2 => s_Col_f2,
           Col_fp => s_Col_fp,
           Col_life => s_Col_life,
                 
           ex_bg => s1_ex_bg,
           ex_Player => s1_ex_Player,
           ex_f0 => s1_ex_f0,
           ex_f1 => s1_ex_f1,
           ex_f2 => s1_ex_f2,
           ex_fp => s1_ex_fp,
           ex_life => s_ex_life,
           
           Col_O => s_Color 
           );

 Player_inst : Player
    Port map ( 
           pclk => pclk,
           reset => inverted_reset,
           HCnt => s_HCnt,
           VCnt => s_VCnt,
           FCnt => s_FCnt,
           FEnd => s_FEnd,
           game_over => s_game_over,
           
           i_slow => s_slow,

           
           L_direction => btnL,
           R_direction => btnR,
           
           Color => s_Col_Player,
           exist => s_ex_Player);
           
  Fruit_0 : Fruit 
  generic map(
        id_Num => 0,
        rand_vec_start => "101010010011",
        ColorTest => X"F00",
        init_time => 0
)
  Port map ( 
           pclk => pclk,
           reset => inverted_reset,
           HCnt => s_HCnt,
           VCnt => s_VCnt,
           FCnt => s_FCnt,
           FEnd => s_FEnd,
           Color => s_Col_f0,
           exist => s_ex_f0,
           fallCnt => s_fallCnt_f0,
           game_over => s_game_over
           
);
           
  Fruit_1 : Fruit 
  generic map(
        id_Num => 1,
        rand_vec_start => "101001110010",
        ColorTest => X"00F",
        init_time => 3

)
  Port map ( 
           pclk => pclk,
           reset => inverted_reset,
           HCnt => s_HCnt,
           VCnt => s_VCnt,
           FCnt => s_FCnt,
           FEnd => s_FEnd,
           Color => s_Col_f1,
           exist => s_ex_f1,
           fallCnt => s_fallCnt_f1,
           game_over => s_game_over
           );
           
  Fruit_2 : Fruit 
  generic map(
        id_Num => 2,
        rand_vec_start => "111001110100",
        ColorTest => X"0F0",
        init_time => 5
)
  Port map ( 
           pclk => pclk,
           reset => inverted_reset,
           HCnt => s_HCnt,
           VCnt => s_VCnt,
           FCnt => s_FCnt,
           FEnd => s_FEnd,
           Color => s_Col_f2,
           exist => s_ex_f2,
           fallCnt => s_fallCnt_f2,
           game_over => s_game_over
           );
           
    poisonous_fruit_inst :  poisonous_fruit 
    generic map(
            id_Num => 0,
            rand_vec_start => "111010010011",
            ColorTest => X"FFF",
            init_time => 6)
    Port map( 
           pclk => pclk,
           reset => inverted_reset,
           HCnt => s_HCnt,
           VCnt => s_VCnt,
           FCnt => s_FCnt,
           FEnd => s_FEnd,
           Color => s_Col_fp,
           exist => s_ex_fp,
           fallCnt => s_fallCnt_fp,
           
           game_over =>s_game_over
           );           
           
           
   Collision_inst : Collision
    Port map( 
           pclk => pclk,
           Reset => inverted_reset,
           i_ex_bg => s_ex_bg,
           i_ex_Player => s_ex_Player,
           i_ex_f0 => s_ex_f0,
           i_ex_f1 => s_ex_f1,
           i_ex_f2 => s_ex_f2,
           i_ex_fp => s_ex_fp,
           
           fall_cnt_f0 => s_fallCnt_f0,
           fall_cnt_f1 => s_fallCnt_f1,
           fall_cnt_f2 => s_fallCnt_f2,
           fall_cnt_fp => s_fallCnt_fp,
           
           FCnt => s_FCnt,
           
           o_ex_bg => s1_ex_bg,
           o_ex_Player => s1_ex_Player,
           o_ex_f0 => s1_ex_f0,
           o_ex_f1 => s1_ex_f1,
           o_ex_f2 => s1_ex_f2,
           o_ex_fp => s1_ex_fp,
           
           o_slow => s_slow,

       
           point => open,
           life => s_life,
           game_over => s_game_over,
           
           Col_O => open
           );
           
  Life_Counter_inst : Life_Counter 
  Port map ( 
           pclk => pclk,
           reset => inverted_reset,
           HCnt => s_HCnt,
           VCnt => s_VCnt,
           FCnt => s_FCnt,
           FEnd => s_FEnd,
           
           life => s_life,
           Color => s_Col_life,
           exist => s_ex_life
           );
                      
end Behavioral;
