

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.numeric_std.all; -- use that, it's a better coding guideline
--use IEEE.STD_LOGIC_ARITH.ALL;

library work;
use work.common_package.all;
use work.huffman_coding_package.all;
use work.histogram_package.all;

entity filter is
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
end filter;

architecture STRUCTURE of filter is

component second_top is
    Generic(
        BLOCK_COUNT : integer := 1
    );
  Port (
 
  block_i : in logic_vector_array16;
  block_no_i : in integer;
  ready_i : in std_logic;
  data_done_i : in std_logic;
  bram_write_block_o : out huffman_coded;--write data to bram
  bram_write_done_i : in std_logic;
  bram_write_o : out std_logic;
  get_new_block_o : out std_logic;
  done_o : out std_logic;
  clk_i : in std_logic;
  rst_i : in std_logic
   );
end component;

    signal CLOCK_FREQUENCY : integer := 100_000_0000;
    --signal counter : integer := 0;
    signal clk_en : std_logic := '0';

    signal getMode : std_logic_vector(31 downto 0);

    signal block_s : logic_vector_array16;
        
    signal readCounter : unsigned(28 downto 0) := (others => '0');
    signal write_counter : unsigned(28 downto 0) := (others => '0'); 

    type mode is (waiting_mode, read_block_mode, end_of_read, process_mode, write_block_mode, end_of_write);         --state degerleri enum olarak tutuldu. mealy yapisi kullanildi
    signal current : mode := waiting_mode;
   
    signal lastAddress : std_logic_vector(31 downto 0) := x"00000000";
    signal waitCycle : integer := 30;
    signal filteringDone : std_logic := '0';
    --signal wait1Cycle : std_logic := '0';
    
    signal block_no : integer := 0;
    signal write_integer : integer := 0;
    signal ready_s : std_logic := '0';
    
    signal bram_write_block_s : huffman_coded;--write data to bram
    signal bram_write_done_s : std_logic;
    signal bram_write_s : std_logic;
    signal get_new_block_s : std_logic;
    signal process_done_s : std_logic;
    signal data_done_s : std_logic;
    
    signal process_out_block_s : huffman_coded;
    signal rst_s : std_logic := '0';
begin
    
    second_instance : second_top 
        Generic map(
            BLOCK_COUNT => 1
        )
      Port map(
     
      block_i => block_s,
      block_no_i => block_no,
      ready_i => ready_s,
      data_done_i => data_done_s,
      bram_write_block_o => bram_write_block_s,
      bram_write_done_i => bram_write_done_s,
      bram_write_o => bram_write_s,
      get_new_block_o => get_new_block_s,
      done_o => process_done_s,
      clk_i => clk,
      rst_i => rst_s
       );
    
    process (clk) 

    begin
        
        if(rising_edge(clk)) then
            getMode <= x"00000000";
            case (current) is
            when waiting_mode =>
                        
                FPGA_SIDE_we <= "0000";
                FPGA_SIDE_addr <= x"00000000";  
                getMode <= FPGA_SIDE_dout;
                if getMode = x"0000000A" then
                    current <= read_block_mode;
                end if;
                              
            when read_block_mode =>
                FPGA_SIDE_we <= "0000";
                FPGA_SIDE_addr <= std_logic_vector(unsigned(readCounter + 1)*"100");-- std_logic_vector(shift_left(readCounter+1,2));
               
               if(readCounter = 2) then
                    block_no <= to_integer(unsigned(FPGA_SIDE_dout));
                elsif(readCounter > 2) then
                    block_s(to_integer(readCounter - 3)) <= FPGA_SIDE_dout;
                end if;

                readCounter <= unsigned(readCounter + 1); 
                if(readCounter > TOTAL_DATA + 1) then
                    readCounter <= (others => '0');
                    current <= end_of_read; 
                    ready_s <= '1';
                end if;
            when end_of_read =>
                ready_s <= '0';
                --burada islemler yapilacak
                FPGA_SIDE_we <= "1111";
                FPGA_SIDE_addr <= x"00000000";
                FPGA_SIDE_din <= x"0000000B"; --okuma bitti
                current <= process_mode;
            when process_mode =>
                --wait for calculation
                FPGA_SIDE_we <= "0000";
                FPGA_SIDE_addr <= x"00000000";
                
                if(get_new_block_s = '1')then
                    current <= read_block_mode;
                elsif(bram_write_s = '1') then
                    current <= write_block_mode;
                    process_out_block_s <= bram_write_block_s;
                                           
                end if;
                
            when write_block_mode =>
                
                FPGA_SIDE_we <= "1111";
                FPGA_SIDE_addr <=  std_logic_vector(unsigned(write_counter + 1)*"100");--std_logic_vector(shift_left(writeCounter+1,2));
                FPGA_SIDE_din <= process_out_block_s(to_integer(write_counter)); 
                write_counter <= unsigned(write_counter + 1);
                if(write_counter > TOTAL_DATA ) then
                    write_counter <= (others => '0');
                    current <= end_of_write;
                    waitCycle <= 2;
                   -- filteringDone <= '1';
                end if;                  
                
            when end_of_write =>
                if(waitCycle > 0) then
                    FPGA_SIDE_we <= "1111";
                    FPGA_SIDE_addr <= x"00000000";
                    FPGA_SIDE_din <= x"0000000C"; --yazma bitti
                    waitCycle <= waitCycle - 1;    
                else
                    current <= process_mode;
                end if;  
                
  
                --waiting yerine bitti isaretlenecek
                --waitCycle := 3;
            end case;
            
        end if;
    end process;
    
    FPGA_SIDE_clk <= clk;
    FPGA_SIDE_en <= '1';
                --FPGA_SIDE_din <= x"FFAAFFFF";
                --FPGA_SIDE_addr <= x"00000000";
                
end STRUCTURE;
