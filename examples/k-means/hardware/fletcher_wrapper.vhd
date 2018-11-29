-- Copyright 2018 Delft University of Technology
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- This file was automatically generated by FletchGen. Modify this file
-- at your own risk.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

library work;
use work.Arrow.all;
use work.Columns.all;
use work.Interconnect.all;
use work.Wrapper.all;
use work.Utils.all;

entity fletcher_wrapper is
  generic(
    BUS_ADDR_WIDTH                             : natural;
    BUS_DATA_WIDTH                             : natural;
    BUS_STROBE_WIDTH                           : natural;
    BUS_LEN_WIDTH                              : natural;
    BUS_BURST_STEP_LEN                         : natural;
    BUS_BURST_MAX_LEN                          : natural;
    ---------------------------------------------------------------------------
    INDEX_WIDTH                                : natural;
    ---------------------------------------------------------------------------
    NUM_ARROW_BUFFERS                          : natural;
    DATA_WIDTH                                 : natural;
    DIMENSION                                  : natural;
    CENTROIDS                                  : natural;
    CENTROID_REGS                              : natural;
    NUM_REGS                                   : natural;
    NUM_USER_REGS                              : natural;
    REG_WIDTH                                  : natural;
    ---------------------------------------------------------------------------
    TAG_WIDTH                                  : natural
  );
  port(
    acc_reset                                  : in std_logic;
    bus_clk                                    : in std_logic;
    bus_reset                                  : in std_logic;
    acc_clk                                    : in std_logic;
    ---------------------------------------------------------------------------
    mst_rreq_valid                             : out std_logic;
    mst_rreq_ready                             : in std_logic;
    mst_rreq_addr                              : out std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
    mst_rreq_len                               : out std_logic_vector(BUS_LEN_WIDTH-1 downto 0);
    ---------------------------------------------------------------------------
    mst_rdat_valid                             : in std_logic;
    mst_rdat_ready                             : out std_logic;
    mst_rdat_data                              : in std_logic_vector(BUS_DATA_WIDTH-1 downto 0);
    mst_rdat_last                              : in std_logic;
    ---------------------------------------------------------------------------
    mst_wreq_valid                             : out std_logic;
    mst_wreq_len                               : out std_logic_vector(BUS_LEN_WIDTH-1 downto 0);
    mst_wreq_addr                              : out std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
    mst_wreq_ready                             : in std_logic;
    ---------------------------------------------------------------------------
    mst_wdat_valid                             : out std_logic;
    mst_wdat_ready                             : in std_logic;
    mst_wdat_data                              : out std_logic_vector(BUS_DATA_WIDTH-1 downto 0);
    mst_wdat_strobe                            : out std_logic_vector(BUS_STROBE_WIDTH-1 downto 0);
    mst_wdat_last                              : out std_logic;
    ---------------------------------------------------------------------------
    regs_in                                    : in std_logic_vector(NUM_REGS*REG_WIDTH-1 downto 0);
    regs_out                                   : out std_logic_vector(NUM_REGS*REG_WIDTH-1 downto 0);
    regs_out_en                                : out std_logic_vector(NUM_REGS-1 downto 0)
  );
end fletcher_wrapper;

architecture Implementation of fletcher_wrapper is

	constant EPC                                 : natural := BUS_DATA_WIDTH / DATA_WIDTH;

  -----------------------------------------------------------------------------
  -- Hardware Accelerated Function component.
  -- This component should be implemented by the user.
  component kmeans is
    generic(
      TAG_WIDTH                                  : natural;
      BUS_ADDR_WIDTH                             : natural;
      INDEX_WIDTH                                : natural;
      REG_WIDTH                                  : natural;
      NUM_USER_REGS                              : natural;
      DIMENSION                                  : natural;
      DATA_WIDTH                                 : natural;
      CENTROID_REGS                              : natural;
      CENTROIDS                                  : natural
    );
    port(
      point_out_ready                            : out std_logic;
      point_out_dimension_out_count              : in std_logic_vector(log2ceil(EPC + 1) - 1 downto 0); -- 3/4 for 64/32 bit
      point_out_dimension_out_data               : in std_logic_vector(511 downto 0);
      point_out_dimension_out_dvalid             : in std_logic;
      point_out_dimension_out_last               : in std_logic;
      point_out_dimension_out_ready              : out std_logic;
      point_out_dimension_out_valid              : in std_logic;
      point_out_length                           : in std_logic_vector(INDEX_WIDTH-1 downto 0);
      point_out_last                             : in std_logic;
      point_out_valid                            : in std_logic;
      point_cmd_valid                            : out std_logic;
      point_cmd_ready                            : in std_logic;
      point_cmd_firstIdx                         : out std_logic_vector(INDEX_WIDTH-1 downto 0);
      point_cmd_lastIdx                          : out std_logic_vector(INDEX_WIDTH-1 downto 0);
      point_cmd_tag                              : out std_logic_vector(TAG_WIDTH-1 downto 0);
      point_cmd_point_dimension_values_addr      : out std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
      point_cmd_point_offsets_addr               : out std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
      -------------------------------------------------------------------------
      acc_reset                                  : in std_logic;
      acc_clk                                    : in std_logic;
      -------------------------------------------------------------------------
      ctrl_done                                  : out std_logic;
      ctrl_busy                                  : out std_logic;
      ctrl_idle                                  : out std_logic;
      ctrl_reset                                 : in std_logic;
      ctrl_stop                                  : in std_logic;
      ctrl_start                                 : in std_logic;
      -------------------------------------------------------------------------
      idx_first                                  : in std_logic_vector(REG_WIDTH-1 downto 0);
      idx_last                                   : in std_logic_vector(REG_WIDTH-1 downto 0);
      reg_return0                                : out std_logic_vector(REG_WIDTH-1 downto 0);
      reg_return1                                : out std_logic_vector(REG_WIDTH-1 downto 0);
      -------------------------------------------------------------------------
      reg_point_dimension_values_addr            : in std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
      reg_point_offsets_addr                     : in std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
      user_regs_in                               : in std_logic_vector(NUM_USER_REGS * REG_WIDTH - 1 downto 0);
      user_regs_out                              : out std_logic_vector(NUM_USER_REGS * REG_WIDTH - 1 downto 0);
      user_regs_out_en                           : out std_logic_vector(NUM_USER_REGS - 1 downto 0)
    );
  end component;
  -----------------------------------------------------------------------------

  signal s_point_bus_rdat_data                 : std_logic_vector(BUS_DATA_WIDTH-1 downto 0);
  signal uctrl_done                            : std_logic;
  signal uctrl_busy                            : std_logic;
  signal uctrl_idle                            : std_logic;
  signal uctrl_reset                           : std_logic;
  signal uctrl_stop                            : std_logic;
  signal uctrl_start                           : std_logic;
  signal uctrl_control                         : std_logic_vector(REG_WIDTH-1 downto 0);
  signal uctrl_status                          : std_logic_vector(REG_WIDTH-1 downto 0);
  signal s_point_bus_rdat_last                 : std_logic;
  signal s_point_cmd_valid                     : std_logic;
  signal s_point_bus_rdat_ready                : std_logic;
  signal s_point_bus_rdat_valid                : std_logic;
  signal s_point_bus_rreq_len                  : std_logic_vector(BUS_LEN_WIDTH-1 downto 0);
  signal s_point_bus_rreq_ready                : std_logic;
  signal s_point_cmd_ready                     : std_logic;
  signal s_point_cmd_firstIdx                  : std_logic_vector(INDEX_WIDTH-1 downto 0);
  signal s_point_cmd_lastIdx                   : std_logic_vector(INDEX_WIDTH-1 downto 0);
  signal s_point_cmd_ctrl                      : std_logic_vector(2*BUS_ADDR_WIDTH-1 downto 0);
  signal s_point_cmd_tag                       : std_logic_vector(TAG_WIDTH-1 downto 0);
  signal s_point_out_valid                     : std_logic_vector(1 downto 0);
  signal s_point_out_ready                     : std_logic_vector(1 downto 0);
  signal s_point_out_last                      : std_logic_vector(1 downto 0);
  signal s_point_out_data                      : std_logic_vector(INDEX_WIDTH+511+log2ceil(EPC+1) downto 0);
  signal s_point_out_dvalid                    : std_logic_vector(1 downto 0);
  signal s_point_bus_rreq_valid                : std_logic;
  signal s_point_bus_rreq_addr                 : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
  -----------------------------------------------------------------------------
  signal s_bsv_rreq_len                        : std_logic_vector(BUS_LEN_WIDTH-1 downto 0);
  signal s_bsv_rreq_addr                       : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
  signal s_bsv_rreq_ready                      : std_logic_vector(0 downto 0);
  signal s_bsv_rreq_valid                      : std_logic_vector(0 downto 0);
  -----------------------------------------------------------------------------
  signal s_bsv_rdat_valid                      : std_logic_vector(0 downto 0);
  signal s_bsv_rdat_ready                      : std_logic_vector(0 downto 0);
  signal s_bsv_rdat_data                       : std_logic_vector(BUS_DATA_WIDTH-1 downto 0);
  signal s_bsv_rdat_last                       : std_logic_vector(0 downto 0);
begin
  -- ColumnReader instance generated from Arrow schema field:
  -- point: list<dimension: double not null> not null
  point_read_inst: ColumnReader
    generic map (
      CFG                                      => "listprim(" & integer'image(DATA_WIDTH) & ";epc=" & integer'image(EPC) & ")",
      BUS_ADDR_WIDTH                           => BUS_ADDR_WIDTH,
      BUS_LEN_WIDTH                            => BUS_LEN_WIDTH,
      BUS_DATA_WIDTH                           => BUS_DATA_WIDTH,
      BUS_BURST_STEP_LEN                       => BUS_BURST_STEP_LEN,
      BUS_BURST_MAX_LEN                        => BUS_BURST_MAX_LEN,
      INDEX_WIDTH                              => INDEX_WIDTH
    )
    port map (
      bus_clk                                  => bus_clk,
      bus_reset                                => bus_reset,
      acc_clk                                  => acc_clk,
      acc_reset                                => acc_reset,
      cmd_valid                                => s_point_cmd_valid,
      cmd_ready                                => s_point_cmd_ready,
      cmd_firstIdx                             => s_point_cmd_firstIdx,
      cmd_lastIdx                              => s_point_cmd_lastIdx,
      cmd_ctrl                                 => s_point_cmd_ctrl,
      cmd_tag                                  => s_point_cmd_tag,
      out_valid                                => s_point_out_valid,
      out_ready                                => s_point_out_ready,
      out_last                                 => s_point_out_last,
      out_data                                 => s_point_out_data,
      out_dvalid                               => s_point_out_dvalid,
      bus_rreq_valid                           => s_point_bus_rreq_valid,
      bus_rreq_ready                           => s_point_bus_rreq_ready,
      bus_rreq_addr                            => s_point_bus_rreq_addr,
      bus_rreq_len                             => s_point_bus_rreq_len,
      bus_rdat_valid                           => s_point_bus_rdat_valid,
      bus_rdat_ready                           => s_point_bus_rdat_ready,
      bus_rdat_data                            => s_point_bus_rdat_data,
      bus_rdat_last                            => s_point_bus_rdat_last
    );

  -- Controller instance.
  UserCoreController_inst: UserCoreController
    generic map (
      REG_WIDTH                                => REG_WIDTH
    )
    port map (
      acc_clk                                  => acc_clk,
      acc_reset                                => acc_reset,
      bus_clk                                  => bus_clk,
      bus_reset                                => bus_reset,
      status                                   => regs_out(2*REG_WIDTH-1 downto REG_WIDTH),
      control                                  => regs_in(REG_WIDTH-1 downto 0),
      start                                    => uctrl_start,
      stop                                     => uctrl_stop,
      reset                                    => uctrl_reset,
      idle                                     => uctrl_idle,
      busy                                     => uctrl_busy,
      done                                     => uctrl_done
    );

  -- Hardware Accelerated Function instance.
  kmeans_inst: kmeans
    generic map (
      TAG_WIDTH                                => TAG_WIDTH,
      BUS_ADDR_WIDTH                           => BUS_ADDR_WIDTH,
      INDEX_WIDTH                              => INDEX_WIDTH,
      REG_WIDTH                                => REG_WIDTH,
      NUM_USER_REGS                            => NUM_USER_REGS,
      DIMENSION                                => DIMENSION,
      DATA_WIDTH                               => DATA_WIDTH,
      CENTROID_REGS                            => CENTROID_REGS,
      CENTROIDS                                => CENTROIDS
    )
    port map (
      acc_clk                                  => acc_clk,
      acc_reset                                => acc_reset,
      ctrl_start                               => uctrl_start,
      ctrl_stop                                => uctrl_stop,
      ctrl_reset                               => uctrl_reset,
      ctrl_idle                                => uctrl_idle,
      ctrl_busy                                => uctrl_busy,
      ctrl_done                                => uctrl_done,
      point_out_valid                          => s_point_out_valid(0),
      point_out_ready                          => s_point_out_ready(0),
      point_out_last                           => s_point_out_last(0),
      point_out_length                         => s_point_out_data(INDEX_WIDTH-1 downto 0),
      point_out_dimension_out_valid            => s_point_out_valid(1),
      point_out_dimension_out_ready            => s_point_out_ready(1),
      point_out_dimension_out_last             => s_point_out_last(1),
      point_out_dimension_out_dvalid           => s_point_out_dvalid(1),
      point_out_dimension_out_data             => s_point_out_data(INDEX_WIDTH+511 downto INDEX_WIDTH),
      point_out_dimension_out_count            => s_point_out_data(s_point_out_data'length-1 downto INDEX_WIDTH+512),
      point_cmd_valid                          => s_point_cmd_valid,
      point_cmd_ready                          => s_point_cmd_ready,
      point_cmd_firstIdx                       => s_point_cmd_firstIdx(INDEX_WIDTH-1 downto 0),
      point_cmd_lastIdx                        => s_point_cmd_lastIdx(INDEX_WIDTH-1 downto 0),
      point_cmd_tag                            => s_point_cmd_tag(TAG_WIDTH-1 downto 0),
      point_cmd_point_offsets_addr             => s_point_cmd_ctrl(BUS_ADDR_WIDTH-1 downto 0),
      point_cmd_point_dimension_values_addr    => s_point_cmd_ctrl(BUS_ADDR_WIDTH+BUS_ADDR_WIDTH-1 downto BUS_ADDR_WIDTH),
      idx_first                                => regs_in(5*REG_WIDTH-1 downto 4*REG_WIDTH),
      idx_last                                 => regs_in(6*REG_WIDTH-1 downto 5*REG_WIDTH),
      reg_return0                              => regs_out(3*REG_WIDTH-1 downto 2*REG_WIDTH),
      reg_return1                              => regs_out(4*REG_WIDTH-1 downto 3*REG_WIDTH),
      reg_point_dimension_values_addr          => regs_in(10*REG_WIDTH-1 downto 8*REG_WIDTH),
      reg_point_offsets_addr                   => regs_in(8*REG_WIDTH-1 downto 6*REG_WIDTH),
      user_regs_in                             => regs_in(NUM_REGS*REG_WIDTH-1 downto (NUM_REGS-NUM_USER_REGS)*REG_WIDTH),
      user_regs_out                            => regs_out(NUM_REGS*REG_WIDTH-1 downto (NUM_REGS-NUM_USER_REGS)*REG_WIDTH),
      user_regs_out_en                         => regs_out_en(NUM_REGS - 1 downto (NUM_REGS-NUM_USER_REGS))
    );

  -- Arbiter instance generated to serve 1 column readers.
  BusReadArbiterVec_inst: BusReadArbiterVec
    generic map (
      BUS_ADDR_WIDTH                           => BUS_ADDR_WIDTH,
      BUS_LEN_WIDTH                            => BUS_LEN_WIDTH,
      BUS_DATA_WIDTH                           => BUS_DATA_WIDTH,
      NUM_SLAVE_PORTS                          => 1
    )
    port map (
      bus_clk                                  => bus_clk,
      bus_reset                                => bus_reset,
      bsv_rreq_valid                           => s_bsv_rreq_valid,
      bsv_rreq_ready                           => s_bsv_rreq_ready,
      bsv_rreq_addr                            => s_bsv_rreq_addr,
      bsv_rreq_len                             => s_bsv_rreq_len,
      bsv_rdat_valid                           => s_bsv_rdat_valid,
      bsv_rdat_ready                           => s_bsv_rdat_ready,
      bsv_rdat_data                            => s_bsv_rdat_data,
      bsv_rdat_last                            => s_bsv_rdat_last,
      mst_rreq_valid                           => mst_rreq_valid,
      mst_rreq_ready                           => mst_rreq_ready,
      mst_rreq_addr                            => mst_rreq_addr,
      mst_rreq_len                             => mst_rreq_len,
      mst_rdat_valid                           => mst_rdat_valid,
      mst_rdat_ready                           => mst_rdat_ready,
      mst_rdat_data                            => mst_rdat_data,
      mst_rdat_last                            => mst_rdat_last
    );


  s_bsv_rreq_addr(BUS_ADDR_WIDTH-1 downto 0)   <= s_point_bus_rreq_addr;
  s_bsv_rreq_len(BUS_LEN_WIDTH-1 downto 0)     <= s_point_bus_rreq_len;
  s_point_bus_rreq_ready                       <= s_bsv_rreq_ready(0);
  s_bsv_rreq_valid(0)                          <= s_point_bus_rreq_valid;
  -----------------------------------------------------------------------------
  s_point_bus_rdat_data                        <= s_bsv_rdat_data(BUS_DATA_WIDTH-1 downto 0);
  s_point_bus_rdat_last                        <= s_bsv_rdat_last(0);
  s_bsv_rdat_ready(0)                          <= s_point_bus_rdat_ready;
  s_point_bus_rdat_valid                       <= s_bsv_rdat_valid(0);
  -----------------------------------------------------------------------------
  mst_wdat_valid                               <='0';
  mst_wreq_valid                               <='0';
  regs_out_en(0)                               <='0';  -- control
  regs_out_en(1)                               <='1';  -- status
  regs_out_en(2)                               <='1';  -- ret 0
  regs_out_en(3)                               <='1';  -- ret 1
  regs_out_en(5 downto 4) <= (others => '0'); -- first & last
  regs_out_en(9 downto 6) <= (others => '0'); -- column addresses

end architecture;

