--------------------------------------------------------------------------------
-- PicoBlaze UART Transceiver
--
--  CLK_DIV_X16         UART clock divider x16; use "27" for 115200 Bd  @  50 MHz system clock (CLK)
--
--  CLK                 system clock
--  UART_RX_I           UART serial input
--  UART_TX_O           UART serial output
--
--  UART_WRITE          write data  to  UART buffer (signal from PicoBlaze output MUX)
--  UART_READ            read data from UART buffer (signal from PicoBlaze output MUX)
--
--  UART_RESET_REG      Reset IN reg (signal from PicoBlaze output MUX); (0) Tx, (1) Rx
--  UART_DATA_IN_REG    Data IN reg (signal from PicoBlaze output MUX)
--
--  UART_STATUS_REG     Status OUT reg (signal to PicoBlaze input MUX)
--                      (0) = TX_data_present;
--                      (1) = TX_half_full;
--                      (2) = TX_full;
--                      (3) = RX_data_present;
--                      (4) = RX_half_full;
--                      (5) = RX_full;
--
--  UART_DATA_OUT_REG   Data OUT reg (signal to PicoBlaze input MUX)
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY uart_block IS
  GENERIC(
    CLK_DIV_X16         : POSITIVE := 27                                -- "27" for 115200 Bd  @  50 MHz CLK
  );
  PORT(
    CLK                 : IN  STD_LOGIC;                                -- system clock
    UART_RX_I           : IN  STD_LOGIC;                                -- UART serial input
    UART_TX_O           : OUT STD_LOGIC;                                -- UART serial output
    UART_WRITE          : IN  STD_LOGIC;                                -- write data  to  UART buffer (signal from PicoBlaze output MUX)
    UART_READ           : IN  STD_LOGIC;                                --  read data from UART buffer (signal from PicoBlaze output MUX)
    UART_RESET_REG      : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);             -- Reset IN reg (signal from PicoBlaze output MUX); (0) Tx, (1) Rx
    UART_DATA_IN_REG    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);             -- Data IN reg (signal from PicoBlaze output MUX)
    UART_STATUS_REG     : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);             -- Status OUT reg (signal to PicoBlaze input MUX)
    UART_DATA_OUT_REG   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)              -- Data OUT reg (signal to PicoBlaze input MUX)
  );
END uart_block;
--------------------------------------------------------------------------------
ARCHITECTURE Structural OF uart_block IS
--------------------------------------------------------------------------------

  SIGNAL ce_uart            : STD_LOGIC;

--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------

  ce_gen_i : ENTITY work.ce_gen
  GENERIC MAP(
    DIV_FACT                => CLK_DIV_X16
  )
  PORT MAP(
    CLK                     => CLK,
    SRST                    => '0',
    CE                      => '1',
    CE_O                    => ce_uart
  );

  ------------------------------------------------------------------------------

  uart_tx6_i : ENTITY work.uart_tx6
  PORT MAP(
    data_in                 => UART_DATA_IN_REG,
    en_16_x_baud            => ce_uart,
    serial_out              => UART_TX_O,
    buffer_write            => UART_WRITE,
    buffer_data_present     => UART_STATUS_REG(0),
    buffer_half_full        => UART_STATUS_REG(1),
    buffer_full             => UART_STATUS_REG(2),
    buffer_reset            => UART_RESET_REG(0),
    clk                     => CLK
  );

  ---------------------------------------------------------------------

  uart_rx6_i : ENTITY work.uart_rx6
  PORT MAP(
    serial_in               => UART_RX_I,
    en_16_x_baud            => ce_uart,
    data_out                => UART_DATA_OUT_REG,
    buffer_read             => UART_READ,
    buffer_data_present     => UART_STATUS_REG(3),
    buffer_half_full        => UART_STATUS_REG(4),
    buffer_full             => UART_STATUS_REG(5),
    buffer_reset            => UART_RESET_REG(1),
    clk                     => CLK
  );

--------------------------------------------------------------------------------
END Structural;
--------------------------------------------------------------------------------
