library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_Background is
    Port ( 
           pclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           HCnt : in integer;
           VCnt : in integer;
           FCnt : in integer;
           FEnd : in STD_LOGIC;
           
           Color : out STD_LOGIC_VECTOR (11 downto 0);
           exist : out boolean);end Test_Background;

architecture Behavioral of Test_Background is


component Object is
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
end component ;

    signal s_pclk : STD_LOGIC;
    signal s_reset: STD_LOGIC;
    signal s_HCnt : Integer ;
    signal s_VCnt : Integer ;
    signal s_FCnt : Integer ;
    signal s_FEnd : STD_LOGIC;

    signal s_Color: STD_LOGIC_VECTOR (11 downto 0);
    signal s_exist: boolean;
    
    signal s_Color_1: STD_LOGIC_VECTOR (11 downto 0);
    signal s_Color_2: STD_LOGIC_VECTOR (11 downto 0);
    
    signal X_1 : integer := 10;
    signal X_2 : integer := 20;
    signal X_3 : integer := 30;
    signal X_4 : integer := 40;
    signal X_5 : integer := 50;
    
    signal Y_1 : integer := 10;
    signal Y_2 : integer := 20;
    signal Y_3 : integer := 30;
    signal Y_4 : integer := 40;
    signal Y_5 : integer := 50;

    signal counter : integer range 0 to 1 := 0;
   
begin

star_1 : Object 
generic map(
    H_Pos_L => X_1,
    V_Pos_L => Y_1
)
Port map(
           pclk => pclk,
           reset => reset,
           HCnt => HCnt,
           VCnt => VCnt,
           FCnt => FCnt,
           FEnd => FEnd,           
           Color => s_Color_1,
           exist => exist
);

star_2 : Object 
generic map(
    H_Pos_L => X_1,
    V_Pos_L => Y_1
)
Port map(
           pclk => pclk,
           reset => reset,
           HCnt => HCnt,
           VCnt => VCnt,
           FCnt => FCnt,
           FEnd => FEnd,           
           Color => s_Color_2,
           exist => exist
);


--REGXr: 
--   for I in 0 to 5 generate
--      star : Object
--generic map(
--    H_Pos_L => I * 10,
--    V_Pos_L => I * 10 
--)      
--Port map(
--           pclk => s_pclk,
--           reset => s_reset,
--           HCnt => s_HCnt,
--           VCnt => s_VCnt,
--           FCnt => s_FCnt,
--           FEnd => s_FEnd,           
--           Color => s_Color,
--           exist => s_exist);
--   end generate REGXr;

    displaying_Stars: process(FCnt)    
    begin
        if rising_edge(FCnt) then
        
            case counter is
                when 0 =>
                     s_Color <= s_Color_1;
                     counter <= 1;
                when others =>
                     s_Color <= s_Color_2;
                     counter <= 0;
            end case;                
        
        end if;
    end process;
end Behavioral;
