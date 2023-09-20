--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
--Date        : Thu Aug 17 19:20:49 2023
--Host        : DESKTOP-JTR0CVI running 64-bit major release  (build 9200)
--Command     : generate_target zynq_design_wrapper.bd
--Design      : zynq_design_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity zynq_design_wrapper is
  port (
    DDR_0_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_0_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_0_cas_n : inout STD_LOGIC;
    DDR_0_ck_n : inout STD_LOGIC;
    DDR_0_ck_p : inout STD_LOGIC;
    DDR_0_cke : inout STD_LOGIC;
    DDR_0_cs_n : inout STD_LOGIC;
    DDR_0_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_0_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_0_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_0_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_0_odt : inout STD_LOGIC;
    DDR_0_ras_n : inout STD_LOGIC;
    DDR_0_reset_n : inout STD_LOGIC;
    DDR_0_we_n : inout STD_LOGIC;
    FIXED_IO_0_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_0_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_0_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_0_ps_clk : inout STD_LOGIC;
    FIXED_IO_0_ps_porb : inout STD_LOGIC;
    FIXED_IO_0_ps_srstb : inout STD_LOGIC;
    clk : in std_logic
  );
end zynq_design_wrapper;

architecture STRUCTURE of zynq_design_wrapper is
  component zynq_design is
  port (
    DDR_0_cas_n : inout STD_LOGIC;
    DDR_0_cke : inout STD_LOGIC;
    DDR_0_ck_n : inout STD_LOGIC;
    DDR_0_ck_p : inout STD_LOGIC;
    DDR_0_cs_n : inout STD_LOGIC;
    DDR_0_reset_n : inout STD_LOGIC;
    DDR_0_odt : inout STD_LOGIC;
    DDR_0_ras_n : inout STD_LOGIC;
    DDR_0_we_n : inout STD_LOGIC;
    DDR_0_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_0_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_0_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_0_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_0_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_0_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_0_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_0_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_0_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_0_ps_srstb : inout STD_LOGIC;
    FIXED_IO_0_ps_clk : inout STD_LOGIC;
    FIXED_IO_0_ps_porb : inout STD_LOGIC;
    BRAM_PORTB_0_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_0_clk : in STD_LOGIC;
    BRAM_PORTB_0_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_0_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_0_en : in STD_LOGIC;
    BRAM_PORTB_0_rst : in STD_LOGIC;
    BRAM_PORTB_0_we : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component zynq_design;
  
      signal FPGA_SIDE_addr :  STD_LOGIC_VECTOR ( 31 downto 0 );
  signal FPGA_SIDE_clk :  STD_LOGIC;
  signal FPGA_SIDE_din :  STD_LOGIC_VECTOR ( 31 downto 0 );
  signal FPGA_SIDE_dout :  STD_LOGIC_VECTOR ( 31 downto 0);
  signal FPGA_SIDE_en :  STD_LOGIC;
  signal FPGA_SIDE_rst : STD_LOGIC;
  signal FPGA_SIDE_we :  STD_LOGIC_VECTOR ( 3 downto 0 );
--   signal clk : STD_LOGIC := '1';
 component filter is
  port(
    FPGA_SIDE_addr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    FPGA_SIDE_clk : out STD_LOGIC;
    FPGA_SIDE_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    FPGA_SIDE_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    FPGA_SIDE_en : out STD_LOGIC;
    FPGA_SIDE_rst : out STD_LOGIC;
    FPGA_SIDE_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    clk : in STD_LOGIC
  );
  end component filter;
 
begin
zynq_design_i: component zynq_design
     port map (
     BRAM_PORTB_0_addr => FPGA_SIDE_addr,
     BRAM_PORTB_0_clk => FPGA_SIDE_clk,
     BRAM_PORTB_0_din =>FPGA_SIDE_din,
     BRAM_PORTB_0_dout => FPGA_SIDE_dout,
     BRAM_PORTB_0_en => FPGA_SIDE_en,
     BRAM_PORTB_0_rst =>FPGA_SIDE_rst,
     BRAM_PORTB_0_we =>FPGA_SIDE_we,
      DDR_0_addr(14 downto 0) => DDR_0_addr(14 downto 0),
      DDR_0_ba(2 downto 0) => DDR_0_ba(2 downto 0),
      DDR_0_cas_n => DDR_0_cas_n,
      DDR_0_ck_n => DDR_0_ck_n,
      DDR_0_ck_p => DDR_0_ck_p,
      DDR_0_cke => DDR_0_cke,
      DDR_0_cs_n => DDR_0_cs_n,
      DDR_0_dm(3 downto 0) => DDR_0_dm(3 downto 0),
      DDR_0_dq(31 downto 0) => DDR_0_dq(31 downto 0),
      DDR_0_dqs_n(3 downto 0) => DDR_0_dqs_n(3 downto 0),
      DDR_0_dqs_p(3 downto 0) => DDR_0_dqs_p(3 downto 0),
      DDR_0_odt => DDR_0_odt,
      DDR_0_ras_n => DDR_0_ras_n,
      DDR_0_reset_n => DDR_0_reset_n,
      DDR_0_we_n => DDR_0_we_n,
      FIXED_IO_0_ddr_vrn => FIXED_IO_0_ddr_vrn,
      FIXED_IO_0_ddr_vrp => FIXED_IO_0_ddr_vrp,
      FIXED_IO_0_mio(53 downto 0) => FIXED_IO_0_mio(53 downto 0),
      FIXED_IO_0_ps_clk => FIXED_IO_0_ps_clk,
      FIXED_IO_0_ps_porb => FIXED_IO_0_ps_porb,
      FIXED_IO_0_ps_srstb => FIXED_IO_0_ps_srstb
    );
    
    filter_new: filter
      port map(
          FPGA_SIDE_addr(31 downto 0) => FPGA_SIDE_addr(31 downto 0),
          FPGA_SIDE_clk => FPGA_SIDE_clk,
          FPGA_SIDE_din(31 downto 0) => FPGA_SIDE_din(31 downto 0),
          FPGA_SIDE_dout(31 downto 0) => FPGA_SIDE_dout(31 downto 0),
          FPGA_SIDE_en => FPGA_SIDE_en,
          FPGA_SIDE_rst => FPGA_SIDE_rst,
          FPGA_SIDE_we(3 downto 0) => FPGA_SIDE_we(3 downto 0),
          clk => clk
      );

end STRUCTURE;
