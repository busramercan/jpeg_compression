
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity filter_tb is
--  Port ( );
end filter_tb;

architecture Behavioral of filter_tb is

component filter is
    generic( --16 tane block data, 1 tane belirleyici, 1 tane block no = 18 data
        TOTAL_DATA : integer := 16 --16 + 2 data
    ); 
  port (
    FPGA_SIDE_addr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    FPGA_SIDE_clk : out STD_LOGIC;
    FPGA_SIDE_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    FPGA_SIDE_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    FPGA_SIDE_en : out STD_LOGIC;
    FPGA_SIDE_rst : out STD_LOGIC;
    FPGA_SIDE_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    clk : in STD_LOGIC
  );
end component;

signal clk_s : std_logic := '0';


signal FPGA_SIDE_addr :  STD_LOGIC_VECTOR ( 31 downto 0 );  
signal FPGA_SIDE_clk :  STD_LOGIC;                          
signal FPGA_SIDE_din :  STD_LOGIC_VECTOR ( 31 downto 0 );   
signal FPGA_SIDE_dout : STD_LOGIC_VECTOR ( 31 downto 0 );   
signal FPGA_SIDE_en :  STD_LOGIC;                           
signal FPGA_SIDE_rst :  STD_LOGIC;                          
signal FPGA_SIDE_we :  STD_LOGIC_VECTOR ( 3 downto 0 );     




begin


filter_ins : filter
    generic map( --16 tane block data, 1 tane belirleyici, 1 tane block no = 18 data
        TOTAL_DATA => 16
    )
  port map(
    FPGA_SIDE_addr => FPGA_SIDE_addr,
    FPGA_SIDE_clk => FPGA_SIDE_clk,
    FPGA_SIDE_din => FPGA_SIDE_din,
    FPGA_SIDE_dout => FPGA_SIDE_dout, 
    FPGA_SIDE_en => FPGA_SIDE_en,
    FPGA_SIDE_rst => FPGA_SIDE_rst,
    FPGA_SIDE_we => FPGA_SIDE_we,
    clk => clk_s
  );

process begin
    clk_s <= not clk_s;
    wait for 5 ns;     
end process;

end Behavioral;
