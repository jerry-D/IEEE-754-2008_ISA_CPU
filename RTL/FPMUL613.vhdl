-- FPMUL613.vhdl
-- vagrant@vagrant-ubuntu-trusty-32:~/flopoco-3.0.beta5$ ./flopoco -name=FPMul613 -frequency=120 -useHardMult=no FPMult 6 13 13
-- Updating entity name to: FPMul613
-- 
-- Final report:
-- Entity SmallMultTableP3x3r6XuYu
--    Not pipelined
-- Entity Compressor_6_3
--    Not pipelined
-- Entity Compressor_14_3
--    Not pipelined
-- Entity Compressor_23_3
--    Not pipelined
-- Entity Compressor_13_3
--    Not pipelined
-- Entity Compressor_3_2
--    Not pipelined
-- |   |---Entity IntAdder_26_f120_uid88
-- |   |      Not pipelined
-- |---Entity IntMultiplier_UsingDSP_14_14_28_unsigned_uid4
-- |      Not pipelined
-- |---Entity IntAdder_21_f120_uid96
-- |      Not pipelined
-- Entity FPMul613
--    Not pipelined
-- Output file: flopoco.vhdl
-- vagrant@vagrant-ubuntu-trusty-32:~/flopoco-3.0.beta5$ cat flopoco.vhdl
--------------------------------------------------------------------------------
--                          SmallMultTableP3x3r6XuYu
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin (2007-2012)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
entity SmallMultTableP3x3r6XuYu is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(5 downto 0);
          Y : out  std_logic_vector(5 downto 0)   );
end entity;

architecture arch of SmallMultTableP3x3r6XuYu is
begin
  with X select  Y <=
   "000000" when "000000",
   "000000" when "000001",
   "000000" when "000010",
   "000000" when "000011",
   "000000" when "000100",
   "000000" when "000101",
   "000000" when "000110",
   "000000" when "000111",
   "000000" when "001000",
   "000001" when "001001",
   "000010" when "001010",
   "000011" when "001011",
   "000100" when "001100",
   "000101" when "001101",
   "000110" when "001110",
   "000111" when "001111",
   "000000" when "010000",
   "000010" when "010001",
   "000100" when "010010",
   "000110" when "010011",
   "001000" when "010100",
   "001010" when "010101",
   "001100" when "010110",
   "001110" when "010111",
   "000000" when "011000",
   "000011" when "011001",
   "000110" when "011010",
   "001001" when "011011",
   "001100" when "011100",
   "001111" when "011101",
   "010010" when "011110",
   "010101" when "011111",
   "000000" when "100000",
   "000100" when "100001",
   "001000" when "100010",
   "001100" when "100011",
   "010000" when "100100",
   "010100" when "100101",
   "011000" when "100110",
   "011100" when "100111",
   "000000" when "101000",
   "000101" when "101001",
   "001010" when "101010",
   "001111" when "101011",
   "010100" when "101100",
   "011001" when "101101",
   "011110" when "101110",
   "100011" when "101111",
   "000000" when "110000",
   "000110" when "110001",
   "001100" when "110010",
   "010010" when "110011",
   "011000" when "110100",
   "011110" when "110101",
   "100100" when "110110",
   "101010" when "110111",
   "000000" when "111000",
   "000111" when "111001",
   "001110" when "111010",
   "010101" when "111011",
   "011100" when "111100",
   "100011" when "111101",
   "101010" when "111110",
   "110001" when "111111",
   "------" when others;
end architecture;

--------------------------------------------------------------------------------
--                               Compressor_6_3
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Popa, Illyes Kinga, 2012
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Compressor_6_3 is
   port ( X0 : in  std_logic_vector(5 downto 0);
          R : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of Compressor_6_3 is
signal X :  std_logic_vector(5 downto 0);
begin
   X <=X0 ;
   with X select R <=
      "000" when "000000",
      "001" when "000001",
      "001" when "000010",
      "010" when "000011",
      "001" when "000100",
      "010" when "000101",
      "010" when "000110",
      "011" when "000111",
      "001" when "001000",
      "010" when "001001",
      "010" when "001010",
      "011" when "001011",
      "010" when "001100",
      "011" when "001101",
      "011" when "001110",
      "100" when "001111",
      "001" when "010000",
      "010" when "010001",
      "010" when "010010",
      "011" when "010011",
      "010" when "010100",
      "011" when "010101",
      "011" when "010110",
      "100" when "010111",
      "010" when "011000",
      "011" when "011001",
      "011" when "011010",
      "100" when "011011",
      "011" when "011100",
      "100" when "011101",
      "100" when "011110",
      "101" when "011111",
      "001" when "100000",
      "010" when "100001",
      "010" when "100010",
      "011" when "100011",
      "010" when "100100",
      "011" when "100101",
      "011" when "100110",
      "100" when "100111",
      "010" when "101000",
      "011" when "101001",
      "011" when "101010",
      "100" when "101011",
      "011" when "101100",
      "100" when "101101",
      "100" when "101110",
      "101" when "101111",
      "010" when "110000",
      "011" when "110001",
      "011" when "110010",
      "100" when "110011",
      "011" when "110100",
      "100" when "110101",
      "100" when "110110",
      "101" when "110111",
      "011" when "111000",
      "100" when "111001",
      "100" when "111010",
      "101" when "111011",
      "100" when "111100",
      "101" when "111101",
      "101" when "111110",
      "110" when "111111",
      "---" when others;

end architecture;

--------------------------------------------------------------------------------
--                              Compressor_14_3
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Popa, Illyes Kinga, 2012
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Compressor_14_3 is
   port ( X0 : in  std_logic_vector(3 downto 0);
          X1 : in  std_logic_vector(0 downto 0);
          R : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of Compressor_14_3 is
signal X :  std_logic_vector(4 downto 0);
begin
   X <=X1 & X0 ;
   with X select R <=
      "000" when "00000",
      "001" when "00001",
      "001" when "00010",
      "010" when "00011",
      "001" when "00100",
      "010" when "00101",
      "010" when "00110",
      "011" when "00111",
      "001" when "01000",
      "010" when "01001",
      "010" when "01010",
      "011" when "01011",
      "010" when "01100",
      "011" when "01101",
      "011" when "01110",
      "100" when "01111",
      "010" when "10000",
      "011" when "10001",
      "011" when "10010",
      "100" when "10011",
      "011" when "10100",
      "100" when "10101",
      "100" when "10110",
      "101" when "10111",
      "011" when "11000",
      "100" when "11001",
      "100" when "11010",
      "101" when "11011",
      "100" when "11100",
      "101" when "11101",
      "101" when "11110",
      "110" when "11111",
      "---" when others;

end architecture;

--------------------------------------------------------------------------------
--                              Compressor_23_3
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Popa, Illyes Kinga, 2012
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Compressor_23_3 is
   port ( X0 : in  std_logic_vector(2 downto 0);
          X1 : in  std_logic_vector(1 downto 0);
          R : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of Compressor_23_3 is
signal X :  std_logic_vector(4 downto 0);
begin
   X <=X1 & X0 ;
   with X select R <=
      "000" when "00000",
      "001" when "00001",
      "001" when "00010",
      "010" when "00011",
      "001" when "00100",
      "010" when "00101",
      "010" when "00110",
      "011" when "00111",
      "010" when "01000",
      "011" when "01001",
      "011" when "01010",
      "100" when "01011",
      "011" when "01100",
      "100" when "01101",
      "100" when "01110",
      "101" when "01111",
      "010" when "10000",
      "011" when "10001",
      "011" when "10010",
      "100" when "10011",
      "011" when "10100",
      "100" when "10101",
      "100" when "10110",
      "101" when "10111",
      "100" when "11000",
      "101" when "11001",
      "101" when "11010",
      "110" when "11011",
      "101" when "11100",
      "110" when "11101",
      "110" when "11110",
      "111" when "11111",
      "---" when others;

end architecture;

--------------------------------------------------------------------------------
--                              Compressor_13_3
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Popa, Illyes Kinga, 2012
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Compressor_13_3 is
   port ( X0 : in  std_logic_vector(2 downto 0);
          X1 : in  std_logic_vector(0 downto 0);
          R : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of Compressor_13_3 is
signal X :  std_logic_vector(3 downto 0);
begin
   X <=X1 & X0 ;
   with X select R <=
      "000" when "0000",
      "001" when "0001",
      "001" when "0010",
      "010" when "0011",
      "001" when "0100",
      "010" when "0101",
      "010" when "0110",
      "011" when "0111",
      "010" when "1000",
      "011" when "1001",
      "011" when "1010",
      "100" when "1011",
      "011" when "1100",
      "100" when "1101",
      "100" when "1110",
      "101" when "1111",
      "---" when others;

end architecture;

--------------------------------------------------------------------------------
--                               Compressor_3_2
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Popa, Illyes Kinga, 2012
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Compressor_3_2 is
   port ( X0 : in  std_logic_vector(2 downto 0);
          R : out  std_logic_vector(1 downto 0)   );
end entity;

architecture arch of Compressor_3_2 is
signal X :  std_logic_vector(2 downto 0);
begin
   X <=X0 ;
   with X select R <=
      "00" when "000",
      "01" when "001",
      "01" when "010",
      "10" when "011",
      "01" when "100",
      "10" when "101",
      "10" when "110",
      "11" when "111",
      "--" when others;

end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_26_f120_uid88
--                    (IntAdderAlternative_26_f120_uid92)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_26_f120_uid88 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(25 downto 0);
          Y : in  std_logic_vector(25 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(25 downto 0)   );
end entity;

architecture arch of IntAdder_26_f120_uid88 is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Alternative
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--               IntMultiplier_UsingDSP_14_14_28_unsigned_uid4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin, Kinga Illyes, Bogdan Popa, Bogdan Pasca, 2012
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity IntMultiplier_UsingDSP_14_14_28_unsigned_uid4 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(13 downto 0);
          Y : in  std_logic_vector(13 downto 0);
          R : out  std_logic_vector(27 downto 0)   );
end entity;

architecture arch of IntMultiplier_UsingDSP_14_14_28_unsigned_uid4 is
   component Compressor_13_3 is
      port ( X0 : in  std_logic_vector(2 downto 0);
             X1 : in  std_logic_vector(0 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component Compressor_14_3 is
      port ( X0 : in  std_logic_vector(3 downto 0);
             X1 : in  std_logic_vector(0 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component Compressor_23_3 is
      port ( X0 : in  std_logic_vector(2 downto 0);
             X1 : in  std_logic_vector(1 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component Compressor_3_2 is
      port ( X0 : in  std_logic_vector(2 downto 0);
             R : out  std_logic_vector(1 downto 0)   );
   end component;

   component Compressor_6_3 is
      port ( X0 : in  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component IntAdder_26_f120_uid88 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(25 downto 0);
             Y : in  std_logic_vector(25 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(25 downto 0)   );
   end component;

   component SmallMultTableP3x3r6XuYu is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(5 downto 0);
             Y : out  std_logic_vector(5 downto 0)   );
   end component;

signal XX_m5 :  std_logic_vector(13 downto 0);
signal YY_m5 :  std_logic_vector(13 downto 0);
signal Xp_m5b7 :  std_logic_vector(14 downto 0);
signal Yp_m5b7 :  std_logic_vector(14 downto 0);
signal x_m5b7_0 :  std_logic_vector(2 downto 0);
signal x_m5b7_1 :  std_logic_vector(2 downto 0);
signal x_m5b7_2 :  std_logic_vector(2 downto 0);
signal x_m5b7_3 :  std_logic_vector(2 downto 0);
signal x_m5b7_4 :  std_logic_vector(2 downto 0);
signal y_m5b7_0 :  std_logic_vector(2 downto 0);
signal y_m5b7_1 :  std_logic_vector(2 downto 0);
signal y_m5b7_2 :  std_logic_vector(2 downto 0);
signal y_m5b7_3 :  std_logic_vector(2 downto 0);
signal y_m5b7_4 :  std_logic_vector(2 downto 0);
signal Y0X0_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X0Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w0_0 :  std_logic;
signal heap_bh6_w1_0 :  std_logic;
signal heap_bh6_w2_0 :  std_logic;
signal heap_bh6_w3_0 :  std_logic;
signal Y0X1_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X1Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w2_1 :  std_logic;
signal heap_bh6_w3_1 :  std_logic;
signal heap_bh6_w4_0 :  std_logic;
signal heap_bh6_w5_0 :  std_logic;
signal heap_bh6_w6_0 :  std_logic;
signal Y0X2_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X2Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w5_1 :  std_logic;
signal heap_bh6_w6_1 :  std_logic;
signal heap_bh6_w7_0 :  std_logic;
signal heap_bh6_w8_0 :  std_logic;
signal heap_bh6_w9_0 :  std_logic;
signal Y0X3_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X3Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w8_1 :  std_logic;
signal heap_bh6_w9_1 :  std_logic;
signal heap_bh6_w10_0 :  std_logic;
signal heap_bh6_w11_0 :  std_logic;
signal heap_bh6_w12_0 :  std_logic;
signal Y0X4_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X4Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w11_1 :  std_logic;
signal heap_bh6_w12_1 :  std_logic;
signal heap_bh6_w13_0 :  std_logic;
signal heap_bh6_w14_0 :  std_logic;
signal heap_bh6_w15_0 :  std_logic;
signal Y1X0_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X0Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w2_2 :  std_logic;
signal heap_bh6_w3_2 :  std_logic;
signal heap_bh6_w4_1 :  std_logic;
signal heap_bh6_w5_2 :  std_logic;
signal heap_bh6_w6_2 :  std_logic;
signal Y1X1_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X1Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w4_2 :  std_logic;
signal heap_bh6_w5_3 :  std_logic;
signal heap_bh6_w6_3 :  std_logic;
signal heap_bh6_w7_1 :  std_logic;
signal heap_bh6_w8_2 :  std_logic;
signal heap_bh6_w9_2 :  std_logic;
signal Y1X2_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X2Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w7_2 :  std_logic;
signal heap_bh6_w8_3 :  std_logic;
signal heap_bh6_w9_3 :  std_logic;
signal heap_bh6_w10_1 :  std_logic;
signal heap_bh6_w11_2 :  std_logic;
signal heap_bh6_w12_2 :  std_logic;
signal Y1X3_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X3Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w10_2 :  std_logic;
signal heap_bh6_w11_3 :  std_logic;
signal heap_bh6_w12_3 :  std_logic;
signal heap_bh6_w13_1 :  std_logic;
signal heap_bh6_w14_1 :  std_logic;
signal heap_bh6_w15_1 :  std_logic;
signal Y1X4_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X4Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w13_2 :  std_logic;
signal heap_bh6_w14_2 :  std_logic;
signal heap_bh6_w15_2 :  std_logic;
signal heap_bh6_w16_0 :  std_logic;
signal heap_bh6_w17_0 :  std_logic;
signal heap_bh6_w18_0 :  std_logic;
signal Y2X0_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X0Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w5_4 :  std_logic;
signal heap_bh6_w6_4 :  std_logic;
signal heap_bh6_w7_3 :  std_logic;
signal heap_bh6_w8_4 :  std_logic;
signal heap_bh6_w9_4 :  std_logic;
signal Y2X1_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X1Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w7_4 :  std_logic;
signal heap_bh6_w8_5 :  std_logic;
signal heap_bh6_w9_5 :  std_logic;
signal heap_bh6_w10_3 :  std_logic;
signal heap_bh6_w11_4 :  std_logic;
signal heap_bh6_w12_4 :  std_logic;
signal Y2X2_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X2Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w10_4 :  std_logic;
signal heap_bh6_w11_5 :  std_logic;
signal heap_bh6_w12_5 :  std_logic;
signal heap_bh6_w13_3 :  std_logic;
signal heap_bh6_w14_3 :  std_logic;
signal heap_bh6_w15_3 :  std_logic;
signal Y2X3_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X3Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w13_4 :  std_logic;
signal heap_bh6_w14_4 :  std_logic;
signal heap_bh6_w15_4 :  std_logic;
signal heap_bh6_w16_1 :  std_logic;
signal heap_bh6_w17_1 :  std_logic;
signal heap_bh6_w18_1 :  std_logic;
signal Y2X4_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X4Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w16_2 :  std_logic;
signal heap_bh6_w17_2 :  std_logic;
signal heap_bh6_w18_2 :  std_logic;
signal heap_bh6_w19_0 :  std_logic;
signal heap_bh6_w20_0 :  std_logic;
signal heap_bh6_w21_0 :  std_logic;
signal Y3X0_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X0Y3_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w8_6 :  std_logic;
signal heap_bh6_w9_6 :  std_logic;
signal heap_bh6_w10_5 :  std_logic;
signal heap_bh6_w11_6 :  std_logic;
signal heap_bh6_w12_6 :  std_logic;
signal Y3X1_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X1Y3_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w10_6 :  std_logic;
signal heap_bh6_w11_7 :  std_logic;
signal heap_bh6_w12_7 :  std_logic;
signal heap_bh6_w13_5 :  std_logic;
signal heap_bh6_w14_5 :  std_logic;
signal heap_bh6_w15_5 :  std_logic;
signal Y3X2_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X2Y3_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w13_6 :  std_logic;
signal heap_bh6_w14_6 :  std_logic;
signal heap_bh6_w15_6 :  std_logic;
signal heap_bh6_w16_3 :  std_logic;
signal heap_bh6_w17_3 :  std_logic;
signal heap_bh6_w18_3 :  std_logic;
signal Y3X3_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X3Y3_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w16_4 :  std_logic;
signal heap_bh6_w17_4 :  std_logic;
signal heap_bh6_w18_4 :  std_logic;
signal heap_bh6_w19_1 :  std_logic;
signal heap_bh6_w20_1 :  std_logic;
signal heap_bh6_w21_1 :  std_logic;
signal Y3X4_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X4Y3_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w19_2 :  std_logic;
signal heap_bh6_w20_2 :  std_logic;
signal heap_bh6_w21_2 :  std_logic;
signal heap_bh6_w22_0 :  std_logic;
signal heap_bh6_w23_0 :  std_logic;
signal heap_bh6_w24_0 :  std_logic;
signal Y4X0_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X0Y4_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w11_8 :  std_logic;
signal heap_bh6_w12_8 :  std_logic;
signal heap_bh6_w13_7 :  std_logic;
signal heap_bh6_w14_7 :  std_logic;
signal heap_bh6_w15_7 :  std_logic;
signal Y4X1_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X1Y4_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w13_8 :  std_logic;
signal heap_bh6_w14_8 :  std_logic;
signal heap_bh6_w15_8 :  std_logic;
signal heap_bh6_w16_5 :  std_logic;
signal heap_bh6_w17_5 :  std_logic;
signal heap_bh6_w18_5 :  std_logic;
signal Y4X2_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X2Y4_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w16_6 :  std_logic;
signal heap_bh6_w17_6 :  std_logic;
signal heap_bh6_w18_6 :  std_logic;
signal heap_bh6_w19_3 :  std_logic;
signal heap_bh6_w20_3 :  std_logic;
signal heap_bh6_w21_3 :  std_logic;
signal Y4X3_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X3Y4_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w19_4 :  std_logic;
signal heap_bh6_w20_4 :  std_logic;
signal heap_bh6_w21_4 :  std_logic;
signal heap_bh6_w22_1 :  std_logic;
signal heap_bh6_w23_1 :  std_logic;
signal heap_bh6_w24_1 :  std_logic;
signal Y4X4_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X4Y4_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w22_2 :  std_logic;
signal heap_bh6_w23_2 :  std_logic;
signal heap_bh6_w24_2 :  std_logic;
signal heap_bh6_w25_0 :  std_logic;
signal heap_bh6_w26_0 :  std_logic;
signal heap_bh6_w27_0 :  std_logic;
signal tempR_bh6_0 :  std_logic_vector(1 downto 0);
signal CompressorIn_bh6_0_0 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_0_0 :  std_logic_vector(2 downto 0);
signal heap_bh6_w8_7 :  std_logic;
signal heap_bh6_w9_7 :  std_logic;
signal heap_bh6_w10_7 :  std_logic;
signal CompressorIn_bh6_1_1 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_1_1 :  std_logic_vector(2 downto 0);
signal heap_bh6_w9_8 :  std_logic;
signal heap_bh6_w10_8 :  std_logic;
signal heap_bh6_w11_9 :  std_logic;
signal CompressorIn_bh6_2_2 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_2_2 :  std_logic_vector(2 downto 0);
signal heap_bh6_w10_9 :  std_logic;
signal heap_bh6_w11_10 :  std_logic;
signal heap_bh6_w12_9 :  std_logic;
signal CompressorIn_bh6_3_3 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_3_3 :  std_logic_vector(2 downto 0);
signal heap_bh6_w11_11 :  std_logic;
signal heap_bh6_w12_10 :  std_logic;
signal heap_bh6_w13_9 :  std_logic;
signal CompressorIn_bh6_4_4 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_4_4 :  std_logic_vector(2 downto 0);
signal heap_bh6_w12_11 :  std_logic;
signal heap_bh6_w13_10 :  std_logic;
signal heap_bh6_w14_9 :  std_logic;
signal CompressorIn_bh6_5_5 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_5_5 :  std_logic_vector(2 downto 0);
signal heap_bh6_w13_11 :  std_logic;
signal heap_bh6_w14_10 :  std_logic;
signal heap_bh6_w15_9 :  std_logic;
signal CompressorIn_bh6_6_6 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_6_6 :  std_logic_vector(2 downto 0);
signal heap_bh6_w14_11 :  std_logic;
signal heap_bh6_w15_10 :  std_logic;
signal heap_bh6_w16_7 :  std_logic;
signal CompressorIn_bh6_7_7 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_7_7 :  std_logic_vector(2 downto 0);
signal heap_bh6_w15_11 :  std_logic;
signal heap_bh6_w16_8 :  std_logic;
signal heap_bh6_w17_7 :  std_logic;
signal CompressorIn_bh6_8_8 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_8_8 :  std_logic_vector(2 downto 0);
signal heap_bh6_w16_9 :  std_logic;
signal heap_bh6_w17_8 :  std_logic;
signal heap_bh6_w18_7 :  std_logic;
signal CompressorIn_bh6_9_9 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_9_9 :  std_logic_vector(2 downto 0);
signal heap_bh6_w17_9 :  std_logic;
signal heap_bh6_w18_8 :  std_logic;
signal heap_bh6_w19_5 :  std_logic;
signal CompressorIn_bh6_10_10 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_10_10 :  std_logic_vector(2 downto 0);
signal heap_bh6_w18_9 :  std_logic;
signal heap_bh6_w19_6 :  std_logic;
signal heap_bh6_w20_5 :  std_logic;
signal CompressorIn_bh6_11_11 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_11_12 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_11_11 :  std_logic_vector(2 downto 0);
signal heap_bh6_w5_5 :  std_logic;
signal heap_bh6_w6_5 :  std_logic;
signal heap_bh6_w7_5 :  std_logic;
signal CompressorIn_bh6_12_13 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_12_14 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_12_12 :  std_logic_vector(2 downto 0);
signal heap_bh6_w6_6 :  std_logic;
signal heap_bh6_w7_6 :  std_logic;
signal heap_bh6_w8_8 :  std_logic;
signal CompressorIn_bh6_13_15 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_13_16 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_13_13 :  std_logic_vector(2 downto 0);
signal heap_bh6_w7_7 :  std_logic;
signal heap_bh6_w8_9 :  std_logic;
signal heap_bh6_w9_9 :  std_logic;
signal CompressorIn_bh6_14_17 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_14_18 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_14_14 :  std_logic_vector(2 downto 0);
signal heap_bh6_w19_7 :  std_logic;
signal heap_bh6_w20_6 :  std_logic;
signal heap_bh6_w21_5 :  std_logic;
signal CompressorIn_bh6_15_19 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_15_20 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_15_15 :  std_logic_vector(2 downto 0);
signal heap_bh6_w20_7 :  std_logic;
signal heap_bh6_w21_6 :  std_logic;
signal heap_bh6_w22_3 :  std_logic;
signal CompressorIn_bh6_16_21 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_16_22 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_16_16 :  std_logic_vector(2 downto 0);
signal heap_bh6_w21_7 :  std_logic;
signal heap_bh6_w22_4 :  std_logic;
signal heap_bh6_w23_3 :  std_logic;
signal CompressorIn_bh6_17_23 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_17_24 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_17_17 :  std_logic_vector(2 downto 0);
signal heap_bh6_w2_3 :  std_logic;
signal heap_bh6_w3_3 :  std_logic;
signal heap_bh6_w4_3 :  std_logic;
signal CompressorIn_bh6_18_25 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_18_26 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_18_18 :  std_logic_vector(2 downto 0);
signal heap_bh6_w11_12 :  std_logic;
signal heap_bh6_w12_12 :  std_logic;
signal heap_bh6_w13_12 :  std_logic;
signal CompressorIn_bh6_19_27 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_19_28 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_19_19 :  std_logic_vector(2 downto 0);
signal heap_bh6_w13_13 :  std_logic;
signal heap_bh6_w14_12 :  std_logic;
signal heap_bh6_w15_12 :  std_logic;
signal CompressorIn_bh6_20_29 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_20_30 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_20_20 :  std_logic_vector(2 downto 0);
signal heap_bh6_w23_4 :  std_logic;
signal heap_bh6_w24_3 :  std_logic;
signal heap_bh6_w25_1 :  std_logic;
signal CompressorIn_bh6_21_31 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_21_32 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_21_21 :  std_logic_vector(2 downto 0);
signal heap_bh6_w4_4 :  std_logic;
signal heap_bh6_w5_6 :  std_logic;
signal heap_bh6_w6_7 :  std_logic;
signal CompressorIn_bh6_22_33 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_22_34 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_22_22 :  std_logic_vector(2 downto 0);
signal heap_bh6_w15_13 :  std_logic;
signal heap_bh6_w16_10 :  std_logic;
signal heap_bh6_w17_10 :  std_logic;
signal tempR_bh6_1 :  std_logic;
signal CompressorIn_bh6_23_35 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_23_36 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_23_23 :  std_logic_vector(2 downto 0);
signal heap_bh6_w9_10 :  std_logic;
signal heap_bh6_w10_10 :  std_logic;
signal heap_bh6_w11_13 :  std_logic;
signal CompressorIn_bh6_24_37 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_24_38 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_24_24 :  std_logic_vector(2 downto 0);
signal heap_bh6_w11_14 :  std_logic;
signal heap_bh6_w12_13 :  std_logic;
signal heap_bh6_w13_14 :  std_logic;
signal CompressorIn_bh6_25_39 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_25_40 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_25_25 :  std_logic_vector(2 downto 0);
signal heap_bh6_w12_14 :  std_logic;
signal heap_bh6_w13_15 :  std_logic;
signal heap_bh6_w14_13 :  std_logic;
signal CompressorIn_bh6_26_41 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_26_42 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_26_26 :  std_logic_vector(2 downto 0);
signal heap_bh6_w13_16 :  std_logic;
signal heap_bh6_w14_14 :  std_logic;
signal heap_bh6_w15_14 :  std_logic;
signal CompressorIn_bh6_27_43 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_27_44 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_27_27 :  std_logic_vector(2 downto 0);
signal heap_bh6_w14_15 :  std_logic;
signal heap_bh6_w15_15 :  std_logic;
signal heap_bh6_w16_11 :  std_logic;
signal CompressorIn_bh6_28_45 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_28_46 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_28_28 :  std_logic_vector(2 downto 0);
signal heap_bh6_w15_16 :  std_logic;
signal heap_bh6_w16_12 :  std_logic;
signal heap_bh6_w17_11 :  std_logic;
signal CompressorIn_bh6_29_47 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_29_48 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_29_29 :  std_logic_vector(2 downto 0);
signal heap_bh6_w17_12 :  std_logic;
signal heap_bh6_w18_10 :  std_logic;
signal heap_bh6_w19_8 :  std_logic;
signal CompressorIn_bh6_30_49 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_30_50 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_30_30 :  std_logic_vector(2 downto 0);
signal heap_bh6_w19_9 :  std_logic;
signal heap_bh6_w20_8 :  std_logic;
signal heap_bh6_w21_8 :  std_logic;
signal CompressorIn_bh6_31_51 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_31_52 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_31_31 :  std_logic_vector(2 downto 0);
signal heap_bh6_w22_5 :  std_logic;
signal heap_bh6_w23_5 :  std_logic;
signal heap_bh6_w24_4 :  std_logic;
signal CompressorIn_bh6_32_53 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_32_54 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_32_32 :  std_logic_vector(2 downto 0);
signal heap_bh6_w6_8 :  std_logic;
signal heap_bh6_w7_8 :  std_logic;
signal heap_bh6_w8_10 :  std_logic;
signal CompressorIn_bh6_33_55 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_33_56 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_33_33 :  std_logic_vector(2 downto 0);
signal heap_bh6_w16_13 :  std_logic;
signal heap_bh6_w17_13 :  std_logic;
signal heap_bh6_w18_11 :  std_logic;
signal CompressorIn_bh6_34_57 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh6_34_34 :  std_logic_vector(1 downto 0);
signal heap_bh6_w8_11 :  std_logic;
signal heap_bh6_w9_11 :  std_logic;
signal CompressorIn_bh6_35_58 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh6_35_35 :  std_logic_vector(1 downto 0);
signal heap_bh6_w10_11 :  std_logic;
signal heap_bh6_w11_15 :  std_logic;
signal CompressorIn_bh6_36_59 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh6_36_36 :  std_logic_vector(1 downto 0);
signal heap_bh6_w18_12 :  std_logic;
signal heap_bh6_w19_10 :  std_logic;
signal CompressorIn_bh6_37_60 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh6_37_37 :  std_logic_vector(1 downto 0);
signal heap_bh6_w21_9 :  std_logic;
signal heap_bh6_w22_6 :  std_logic;
signal CompressorIn_bh6_38_61 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_38_62 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_38_38 :  std_logic_vector(2 downto 0);
signal heap_bh6_w11_16 :  std_logic;
signal heap_bh6_w12_15 :  std_logic;
signal heap_bh6_w13_17 :  std_logic;
signal CompressorIn_bh6_39_63 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_39_64 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_39_39 :  std_logic_vector(2 downto 0);
signal heap_bh6_w13_18 :  std_logic;
signal heap_bh6_w14_16 :  std_logic;
signal heap_bh6_w15_17 :  std_logic;
signal CompressorIn_bh6_40_65 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_40_66 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_40_40 :  std_logic_vector(2 downto 0);
signal heap_bh6_w15_18 :  std_logic;
signal heap_bh6_w16_14 :  std_logic;
signal heap_bh6_w17_14 :  std_logic;
signal CompressorIn_bh6_41_67 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_41_68 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_41_41 :  std_logic_vector(2 downto 0);
signal heap_bh6_w17_15 :  std_logic;
signal heap_bh6_w18_13 :  std_logic;
signal heap_bh6_w19_11 :  std_logic;
signal CompressorIn_bh6_42_69 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_42_70 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_42_42 :  std_logic_vector(2 downto 0);
signal heap_bh6_w19_12 :  std_logic;
signal heap_bh6_w20_9 :  std_logic;
signal heap_bh6_w21_10 :  std_logic;
signal CompressorIn_bh6_43_71 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_43_72 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_43_43 :  std_logic_vector(2 downto 0);
signal heap_bh6_w24_5 :  std_logic;
signal heap_bh6_w25_2 :  std_logic;
signal heap_bh6_w26_1 :  std_logic;
signal CompressorIn_bh6_44_73 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_44_74 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_44_44 :  std_logic_vector(2 downto 0);
signal heap_bh6_w21_11 :  std_logic;
signal heap_bh6_w22_7 :  std_logic;
signal heap_bh6_w23_6 :  std_logic;
signal CompressorIn_bh6_45_75 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_45_76 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_45_45 :  std_logic_vector(2 downto 0);
signal heap_bh6_w23_7 :  std_logic;
signal heap_bh6_w24_6 :  std_logic;
signal heap_bh6_w25_3 :  std_logic;
signal finalAdderIn0_bh6 :  std_logic_vector(25 downto 0);
signal finalAdderIn1_bh6 :  std_logic_vector(25 downto 0);
signal finalAdderCin_bh6 :  std_logic;
signal finalAdderOut_bh6 :  std_logic_vector(25 downto 0);
signal CompressionResult6 :  std_logic_vector(28 downto 0);
attribute rom_extract: string;
attribute rom_style: string;
attribute rom_extract of SmallMultTableP3x3r6XuYu: component is "yes";
attribute rom_style of SmallMultTableP3x3r6XuYu: component is "distributed";
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   XX_m5 <= X ;
   YY_m5 <= Y ;
   -- code generated by IntMultiplier::buildHeapLogicOnly()
   -- buildheaplogiconly called for lsbX=0 lsbY=0 msbX=14 msbY=14
   Xp_m5b7 <= XX_m5(13 downto 0) & "0";
   Yp_m5b7 <= YY_m5(13 downto 0) & "0";
   x_m5b7_0 <= Xp_m5b7(2 downto 0);
   x_m5b7_1 <= Xp_m5b7(5 downto 3);
   x_m5b7_2 <= Xp_m5b7(8 downto 6);
   x_m5b7_3 <= Xp_m5b7(11 downto 9);
   x_m5b7_4 <= Xp_m5b7(14 downto 12);
   y_m5b7_0 <= Yp_m5b7(2 downto 0);
   y_m5b7_1 <= Yp_m5b7(5 downto 3);
   y_m5b7_2 <= Yp_m5b7(8 downto 6);
   y_m5b7_3 <= Yp_m5b7(11 downto 9);
   y_m5b7_4 <= Yp_m5b7(14 downto 12);
   ----------------Synchro barrier, entering cycle 0----------------
   -- Partial product row number 0
   Y0X0_7_m5 <= y_m5b7_0 & x_m5b7_0;
   PP_m5_7X0Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X0_7_m5,
                 Y => PP7X0Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w0_0 <= PP7X0Y0_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w1_0 <= PP7X0Y0_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w2_0 <= PP7X0Y0_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w3_0 <= PP7X0Y0_m5(5); -- cycle= 0 cp= 5.656e-10

   Y0X1_7_m5 <= y_m5b7_0 & x_m5b7_1;
   PP_m5_7X1Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X1_7_m5,
                 Y => PP7X1Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w2_1 <= PP7X1Y0_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w3_1 <= PP7X1Y0_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w4_0 <= PP7X1Y0_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w5_0 <= PP7X1Y0_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w6_0 <= PP7X1Y0_m5(5); -- cycle= 0 cp= 5.656e-10

   Y0X2_7_m5 <= y_m5b7_0 & x_m5b7_2;
   PP_m5_7X2Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X2_7_m5,
                 Y => PP7X2Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w5_1 <= PP7X2Y0_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w6_1 <= PP7X2Y0_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w7_0 <= PP7X2Y0_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w8_0 <= PP7X2Y0_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w9_0 <= PP7X2Y0_m5(5); -- cycle= 0 cp= 5.656e-10

   Y0X3_7_m5 <= y_m5b7_0 & x_m5b7_3;
   PP_m5_7X3Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X3_7_m5,
                 Y => PP7X3Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w8_1 <= PP7X3Y0_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w9_1 <= PP7X3Y0_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w10_0 <= PP7X3Y0_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w11_0 <= PP7X3Y0_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w12_0 <= PP7X3Y0_m5(5); -- cycle= 0 cp= 5.656e-10

   Y0X4_7_m5 <= y_m5b7_0 & x_m5b7_4;
   PP_m5_7X4Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X4_7_m5,
                 Y => PP7X4Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w11_1 <= PP7X4Y0_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w12_1 <= PP7X4Y0_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w13_0 <= PP7X4Y0_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w14_0 <= PP7X4Y0_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w15_0 <= PP7X4Y0_m5(5); -- cycle= 0 cp= 5.656e-10

   -- Partial product row number 1
   Y1X0_7_m5 <= y_m5b7_1 & x_m5b7_0;
   PP_m5_7X0Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X0_7_m5,
                 Y => PP7X0Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w2_2 <= PP7X0Y1_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w3_2 <= PP7X0Y1_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w4_1 <= PP7X0Y1_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w5_2 <= PP7X0Y1_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w6_2 <= PP7X0Y1_m5(5); -- cycle= 0 cp= 5.656e-10

   Y1X1_7_m5 <= y_m5b7_1 & x_m5b7_1;
   PP_m5_7X1Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X1_7_m5,
                 Y => PP7X1Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w4_2 <= PP7X1Y1_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w5_3 <= PP7X1Y1_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w6_3 <= PP7X1Y1_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w7_1 <= PP7X1Y1_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w8_2 <= PP7X1Y1_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w9_2 <= PP7X1Y1_m5(5); -- cycle= 0 cp= 5.656e-10

   Y1X2_7_m5 <= y_m5b7_1 & x_m5b7_2;
   PP_m5_7X2Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X2_7_m5,
                 Y => PP7X2Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w7_2 <= PP7X2Y1_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w8_3 <= PP7X2Y1_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w9_3 <= PP7X2Y1_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w10_1 <= PP7X2Y1_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w11_2 <= PP7X2Y1_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w12_2 <= PP7X2Y1_m5(5); -- cycle= 0 cp= 5.656e-10

   Y1X3_7_m5 <= y_m5b7_1 & x_m5b7_3;
   PP_m5_7X3Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X3_7_m5,
                 Y => PP7X3Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w10_2 <= PP7X3Y1_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w11_3 <= PP7X3Y1_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w12_3 <= PP7X3Y1_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w13_1 <= PP7X3Y1_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w14_1 <= PP7X3Y1_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w15_1 <= PP7X3Y1_m5(5); -- cycle= 0 cp= 5.656e-10

   Y1X4_7_m5 <= y_m5b7_1 & x_m5b7_4;
   PP_m5_7X4Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X4_7_m5,
                 Y => PP7X4Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w13_2 <= PP7X4Y1_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w14_2 <= PP7X4Y1_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w15_2 <= PP7X4Y1_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w16_0 <= PP7X4Y1_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w17_0 <= PP7X4Y1_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w18_0 <= PP7X4Y1_m5(5); -- cycle= 0 cp= 5.656e-10

   -- Partial product row number 2
   Y2X0_7_m5 <= y_m5b7_2 & x_m5b7_0;
   PP_m5_7X0Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X0_7_m5,
                 Y => PP7X0Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w5_4 <= PP7X0Y2_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w6_4 <= PP7X0Y2_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w7_3 <= PP7X0Y2_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w8_4 <= PP7X0Y2_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w9_4 <= PP7X0Y2_m5(5); -- cycle= 0 cp= 5.656e-10

   Y2X1_7_m5 <= y_m5b7_2 & x_m5b7_1;
   PP_m5_7X1Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X1_7_m5,
                 Y => PP7X1Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w7_4 <= PP7X1Y2_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w8_5 <= PP7X1Y2_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w9_5 <= PP7X1Y2_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w10_3 <= PP7X1Y2_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w11_4 <= PP7X1Y2_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w12_4 <= PP7X1Y2_m5(5); -- cycle= 0 cp= 5.656e-10

   Y2X2_7_m5 <= y_m5b7_2 & x_m5b7_2;
   PP_m5_7X2Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X2_7_m5,
                 Y => PP7X2Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w10_4 <= PP7X2Y2_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w11_5 <= PP7X2Y2_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w12_5 <= PP7X2Y2_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w13_3 <= PP7X2Y2_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w14_3 <= PP7X2Y2_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w15_3 <= PP7X2Y2_m5(5); -- cycle= 0 cp= 5.656e-10

   Y2X3_7_m5 <= y_m5b7_2 & x_m5b7_3;
   PP_m5_7X3Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X3_7_m5,
                 Y => PP7X3Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w13_4 <= PP7X3Y2_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w14_4 <= PP7X3Y2_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w15_4 <= PP7X3Y2_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w16_1 <= PP7X3Y2_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w17_1 <= PP7X3Y2_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w18_1 <= PP7X3Y2_m5(5); -- cycle= 0 cp= 5.656e-10

   Y2X4_7_m5 <= y_m5b7_2 & x_m5b7_4;
   PP_m5_7X4Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X4_7_m5,
                 Y => PP7X4Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w16_2 <= PP7X4Y2_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w17_2 <= PP7X4Y2_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w18_2 <= PP7X4Y2_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w19_0 <= PP7X4Y2_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w20_0 <= PP7X4Y2_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w21_0 <= PP7X4Y2_m5(5); -- cycle= 0 cp= 5.656e-10

   -- Partial product row number 3
   Y3X0_7_m5 <= y_m5b7_3 & x_m5b7_0;
   PP_m5_7X0Y3_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y3X0_7_m5,
                 Y => PP7X0Y3_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w8_6 <= PP7X0Y3_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w9_6 <= PP7X0Y3_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w10_5 <= PP7X0Y3_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w11_6 <= PP7X0Y3_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w12_6 <= PP7X0Y3_m5(5); -- cycle= 0 cp= 5.656e-10

   Y3X1_7_m5 <= y_m5b7_3 & x_m5b7_1;
   PP_m5_7X1Y3_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y3X1_7_m5,
                 Y => PP7X1Y3_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w10_6 <= PP7X1Y3_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w11_7 <= PP7X1Y3_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w12_7 <= PP7X1Y3_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w13_5 <= PP7X1Y3_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w14_5 <= PP7X1Y3_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w15_5 <= PP7X1Y3_m5(5); -- cycle= 0 cp= 5.656e-10

   Y3X2_7_m5 <= y_m5b7_3 & x_m5b7_2;
   PP_m5_7X2Y3_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y3X2_7_m5,
                 Y => PP7X2Y3_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w13_6 <= PP7X2Y3_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w14_6 <= PP7X2Y3_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w15_6 <= PP7X2Y3_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w16_3 <= PP7X2Y3_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w17_3 <= PP7X2Y3_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w18_3 <= PP7X2Y3_m5(5); -- cycle= 0 cp= 5.656e-10

   Y3X3_7_m5 <= y_m5b7_3 & x_m5b7_3;
   PP_m5_7X3Y3_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y3X3_7_m5,
                 Y => PP7X3Y3_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w16_4 <= PP7X3Y3_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w17_4 <= PP7X3Y3_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w18_4 <= PP7X3Y3_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w19_1 <= PP7X3Y3_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w20_1 <= PP7X3Y3_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w21_1 <= PP7X3Y3_m5(5); -- cycle= 0 cp= 5.656e-10

   Y3X4_7_m5 <= y_m5b7_3 & x_m5b7_4;
   PP_m5_7X4Y3_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y3X4_7_m5,
                 Y => PP7X4Y3_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w19_2 <= PP7X4Y3_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w20_2 <= PP7X4Y3_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w21_2 <= PP7X4Y3_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w22_0 <= PP7X4Y3_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w23_0 <= PP7X4Y3_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w24_0 <= PP7X4Y3_m5(5); -- cycle= 0 cp= 5.656e-10

   -- Partial product row number 4
   Y4X0_7_m5 <= y_m5b7_4 & x_m5b7_0;
   PP_m5_7X0Y4_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y4X0_7_m5,
                 Y => PP7X0Y4_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w11_8 <= PP7X0Y4_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w12_8 <= PP7X0Y4_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w13_7 <= PP7X0Y4_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w14_7 <= PP7X0Y4_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w15_7 <= PP7X0Y4_m5(5); -- cycle= 0 cp= 5.656e-10

   Y4X1_7_m5 <= y_m5b7_4 & x_m5b7_1;
   PP_m5_7X1Y4_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y4X1_7_m5,
                 Y => PP7X1Y4_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w13_8 <= PP7X1Y4_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w14_8 <= PP7X1Y4_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w15_8 <= PP7X1Y4_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w16_5 <= PP7X1Y4_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w17_5 <= PP7X1Y4_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w18_5 <= PP7X1Y4_m5(5); -- cycle= 0 cp= 5.656e-10

   Y4X2_7_m5 <= y_m5b7_4 & x_m5b7_2;
   PP_m5_7X2Y4_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y4X2_7_m5,
                 Y => PP7X2Y4_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w16_6 <= PP7X2Y4_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w17_6 <= PP7X2Y4_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w18_6 <= PP7X2Y4_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w19_3 <= PP7X2Y4_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w20_3 <= PP7X2Y4_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w21_3 <= PP7X2Y4_m5(5); -- cycle= 0 cp= 5.656e-10

   Y4X3_7_m5 <= y_m5b7_4 & x_m5b7_3;
   PP_m5_7X3Y4_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y4X3_7_m5,
                 Y => PP7X3Y4_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w19_4 <= PP7X3Y4_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w20_4 <= PP7X3Y4_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w21_4 <= PP7X3Y4_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w22_1 <= PP7X3Y4_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w23_1 <= PP7X3Y4_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w24_1 <= PP7X3Y4_m5(5); -- cycle= 0 cp= 5.656e-10

   Y4X4_7_m5 <= y_m5b7_4 & x_m5b7_4;
   PP_m5_7X4Y4_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y4X4_7_m5,
                 Y => PP7X4Y4_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w22_2 <= PP7X4Y4_m5(0); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w23_2 <= PP7X4Y4_m5(1); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w24_2 <= PP7X4Y4_m5(2); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w25_0 <= PP7X4Y4_m5(3); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w26_0 <= PP7X4Y4_m5(4); -- cycle= 0 cp= 5.656e-10
   heap_bh6_w27_0 <= PP7X4Y4_m5(5); -- cycle= 0 cp= 5.656e-10


   -- Beginning of code generated by BitHeap::generateCompressorVHDL
   -- code generated by BitHeap::generateSupertileVHDL()
   ----------------Synchro barrier, entering cycle 0----------------

   -- Adding the constant bits
      -- All the constant bits are zero, nothing to add

   ----------------Synchro barrier, entering cycle 0----------------
   ----------------Synchro barrier, entering cycle 0----------------
   tempR_bh6_0 <= heap_bh6_w1_0 & heap_bh6_w0_0; -- already compressed

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_0_0 <= heap_bh6_w8_6 & heap_bh6_w8_5 & heap_bh6_w8_4 & heap_bh6_w8_3 & heap_bh6_w8_2 & heap_bh6_w8_1;
   Compressor_bh6_0: Compressor_6_3
      port map ( R => CompressorOut_bh6_0_0   ,
                 X0 => CompressorIn_bh6_0_0);
   heap_bh6_w8_7 <= CompressorOut_bh6_0_0(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w9_7 <= CompressorOut_bh6_0_0(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w10_7 <= CompressorOut_bh6_0_0(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_1_1 <= heap_bh6_w9_6 & heap_bh6_w9_5 & heap_bh6_w9_4 & heap_bh6_w9_3 & heap_bh6_w9_2 & heap_bh6_w9_1;
   Compressor_bh6_1: Compressor_6_3
      port map ( R => CompressorOut_bh6_1_1   ,
                 X0 => CompressorIn_bh6_1_1);
   heap_bh6_w9_8 <= CompressorOut_bh6_1_1(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w10_8 <= CompressorOut_bh6_1_1(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w11_9 <= CompressorOut_bh6_1_1(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_2_2 <= heap_bh6_w10_6 & heap_bh6_w10_5 & heap_bh6_w10_4 & heap_bh6_w10_3 & heap_bh6_w10_2 & heap_bh6_w10_1;
   Compressor_bh6_2: Compressor_6_3
      port map ( R => CompressorOut_bh6_2_2   ,
                 X0 => CompressorIn_bh6_2_2);
   heap_bh6_w10_9 <= CompressorOut_bh6_2_2(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w11_10 <= CompressorOut_bh6_2_2(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w12_9 <= CompressorOut_bh6_2_2(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_3_3 <= heap_bh6_w11_8 & heap_bh6_w11_7 & heap_bh6_w11_6 & heap_bh6_w11_5 & heap_bh6_w11_4 & heap_bh6_w11_3;
   Compressor_bh6_3: Compressor_6_3
      port map ( R => CompressorOut_bh6_3_3   ,
                 X0 => CompressorIn_bh6_3_3);
   heap_bh6_w11_11 <= CompressorOut_bh6_3_3(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w12_10 <= CompressorOut_bh6_3_3(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w13_9 <= CompressorOut_bh6_3_3(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_4_4 <= heap_bh6_w12_8 & heap_bh6_w12_7 & heap_bh6_w12_6 & heap_bh6_w12_5 & heap_bh6_w12_4 & heap_bh6_w12_3;
   Compressor_bh6_4: Compressor_6_3
      port map ( R => CompressorOut_bh6_4_4   ,
                 X0 => CompressorIn_bh6_4_4);
   heap_bh6_w12_11 <= CompressorOut_bh6_4_4(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w13_10 <= CompressorOut_bh6_4_4(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w14_9 <= CompressorOut_bh6_4_4(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_5_5 <= heap_bh6_w13_8 & heap_bh6_w13_7 & heap_bh6_w13_6 & heap_bh6_w13_5 & heap_bh6_w13_4 & heap_bh6_w13_3;
   Compressor_bh6_5: Compressor_6_3
      port map ( R => CompressorOut_bh6_5_5   ,
                 X0 => CompressorIn_bh6_5_5);
   heap_bh6_w13_11 <= CompressorOut_bh6_5_5(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w14_10 <= CompressorOut_bh6_5_5(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w15_9 <= CompressorOut_bh6_5_5(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_6_6 <= heap_bh6_w14_8 & heap_bh6_w14_7 & heap_bh6_w14_6 & heap_bh6_w14_5 & heap_bh6_w14_4 & heap_bh6_w14_3;
   Compressor_bh6_6: Compressor_6_3
      port map ( R => CompressorOut_bh6_6_6   ,
                 X0 => CompressorIn_bh6_6_6);
   heap_bh6_w14_11 <= CompressorOut_bh6_6_6(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w15_10 <= CompressorOut_bh6_6_6(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w16_7 <= CompressorOut_bh6_6_6(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_7_7 <= heap_bh6_w15_8 & heap_bh6_w15_7 & heap_bh6_w15_6 & heap_bh6_w15_5 & heap_bh6_w15_4 & heap_bh6_w15_3;
   Compressor_bh6_7: Compressor_6_3
      port map ( R => CompressorOut_bh6_7_7   ,
                 X0 => CompressorIn_bh6_7_7);
   heap_bh6_w15_11 <= CompressorOut_bh6_7_7(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w16_8 <= CompressorOut_bh6_7_7(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w17_7 <= CompressorOut_bh6_7_7(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_8_8 <= heap_bh6_w16_6 & heap_bh6_w16_5 & heap_bh6_w16_4 & heap_bh6_w16_3 & heap_bh6_w16_2 & heap_bh6_w16_1;
   Compressor_bh6_8: Compressor_6_3
      port map ( R => CompressorOut_bh6_8_8   ,
                 X0 => CompressorIn_bh6_8_8);
   heap_bh6_w16_9 <= CompressorOut_bh6_8_8(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w17_8 <= CompressorOut_bh6_8_8(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w18_7 <= CompressorOut_bh6_8_8(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_9_9 <= heap_bh6_w17_6 & heap_bh6_w17_5 & heap_bh6_w17_4 & heap_bh6_w17_3 & heap_bh6_w17_2 & heap_bh6_w17_1;
   Compressor_bh6_9: Compressor_6_3
      port map ( R => CompressorOut_bh6_9_9   ,
                 X0 => CompressorIn_bh6_9_9);
   heap_bh6_w17_9 <= CompressorOut_bh6_9_9(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w18_8 <= CompressorOut_bh6_9_9(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w19_5 <= CompressorOut_bh6_9_9(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_10_10 <= heap_bh6_w18_6 & heap_bh6_w18_5 & heap_bh6_w18_4 & heap_bh6_w18_3 & heap_bh6_w18_2 & heap_bh6_w18_1;
   Compressor_bh6_10: Compressor_6_3
      port map ( R => CompressorOut_bh6_10_10   ,
                 X0 => CompressorIn_bh6_10_10);
   heap_bh6_w18_9 <= CompressorOut_bh6_10_10(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w19_6 <= CompressorOut_bh6_10_10(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w20_5 <= CompressorOut_bh6_10_10(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_11_11 <= heap_bh6_w5_4 & heap_bh6_w5_3 & heap_bh6_w5_2 & heap_bh6_w5_1;
   CompressorIn_bh6_11_12(0) <= heap_bh6_w6_4;
   Compressor_bh6_11: Compressor_14_3
      port map ( R => CompressorOut_bh6_11_11   ,
                 X0 => CompressorIn_bh6_11_11,
                 X1 => CompressorIn_bh6_11_12);
   heap_bh6_w5_5 <= CompressorOut_bh6_11_11(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w6_5 <= CompressorOut_bh6_11_11(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w7_5 <= CompressorOut_bh6_11_11(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_12_13 <= heap_bh6_w6_3 & heap_bh6_w6_2 & heap_bh6_w6_1 & heap_bh6_w6_0;
   CompressorIn_bh6_12_14(0) <= heap_bh6_w7_4;
   Compressor_bh6_12: Compressor_14_3
      port map ( R => CompressorOut_bh6_12_12   ,
                 X0 => CompressorIn_bh6_12_13,
                 X1 => CompressorIn_bh6_12_14);
   heap_bh6_w6_6 <= CompressorOut_bh6_12_12(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w7_6 <= CompressorOut_bh6_12_12(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w8_8 <= CompressorOut_bh6_12_12(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_13_15 <= heap_bh6_w7_3 & heap_bh6_w7_2 & heap_bh6_w7_1 & heap_bh6_w7_0;
   CompressorIn_bh6_13_16(0) <= heap_bh6_w8_0;
   Compressor_bh6_13: Compressor_14_3
      port map ( R => CompressorOut_bh6_13_13   ,
                 X0 => CompressorIn_bh6_13_15,
                 X1 => CompressorIn_bh6_13_16);
   heap_bh6_w7_7 <= CompressorOut_bh6_13_13(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w8_9 <= CompressorOut_bh6_13_13(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w9_9 <= CompressorOut_bh6_13_13(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_14_17 <= heap_bh6_w19_4 & heap_bh6_w19_3 & heap_bh6_w19_2 & heap_bh6_w19_1;
   CompressorIn_bh6_14_18(0) <= heap_bh6_w20_4;
   Compressor_bh6_14: Compressor_14_3
      port map ( R => CompressorOut_bh6_14_14   ,
                 X0 => CompressorIn_bh6_14_17,
                 X1 => CompressorIn_bh6_14_18);
   heap_bh6_w19_7 <= CompressorOut_bh6_14_14(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w20_6 <= CompressorOut_bh6_14_14(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w21_5 <= CompressorOut_bh6_14_14(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_15_19 <= heap_bh6_w20_3 & heap_bh6_w20_2 & heap_bh6_w20_1 & heap_bh6_w20_0;
   CompressorIn_bh6_15_20(0) <= heap_bh6_w21_4;
   Compressor_bh6_15: Compressor_14_3
      port map ( R => CompressorOut_bh6_15_15   ,
                 X0 => CompressorIn_bh6_15_19,
                 X1 => CompressorIn_bh6_15_20);
   heap_bh6_w20_7 <= CompressorOut_bh6_15_15(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w21_6 <= CompressorOut_bh6_15_15(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w22_3 <= CompressorOut_bh6_15_15(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_16_21 <= heap_bh6_w21_3 & heap_bh6_w21_2 & heap_bh6_w21_1 & heap_bh6_w21_0;
   CompressorIn_bh6_16_22(0) <= heap_bh6_w22_2;
   Compressor_bh6_16: Compressor_14_3
      port map ( R => CompressorOut_bh6_16_16   ,
                 X0 => CompressorIn_bh6_16_21,
                 X1 => CompressorIn_bh6_16_22);
   heap_bh6_w21_7 <= CompressorOut_bh6_16_16(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w22_4 <= CompressorOut_bh6_16_16(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w23_3 <= CompressorOut_bh6_16_16(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_17_23 <= heap_bh6_w2_2 & heap_bh6_w2_1 & heap_bh6_w2_0;
   CompressorIn_bh6_17_24 <= heap_bh6_w3_2 & heap_bh6_w3_1;
   Compressor_bh6_17: Compressor_23_3
      port map ( R => CompressorOut_bh6_17_17   ,
                 X0 => CompressorIn_bh6_17_23,
                 X1 => CompressorIn_bh6_17_24);
   heap_bh6_w2_3 <= CompressorOut_bh6_17_17(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w3_3 <= CompressorOut_bh6_17_17(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w4_3 <= CompressorOut_bh6_17_17(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_18_25 <= heap_bh6_w11_2 & heap_bh6_w11_1 & heap_bh6_w11_0;
   CompressorIn_bh6_18_26 <= heap_bh6_w12_2 & heap_bh6_w12_1;
   Compressor_bh6_18: Compressor_23_3
      port map ( R => CompressorOut_bh6_18_18   ,
                 X0 => CompressorIn_bh6_18_25,
                 X1 => CompressorIn_bh6_18_26);
   heap_bh6_w11_12 <= CompressorOut_bh6_18_18(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w12_12 <= CompressorOut_bh6_18_18(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w13_12 <= CompressorOut_bh6_18_18(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_19_27 <= heap_bh6_w13_2 & heap_bh6_w13_1 & heap_bh6_w13_0;
   CompressorIn_bh6_19_28 <= heap_bh6_w14_2 & heap_bh6_w14_1;
   Compressor_bh6_19: Compressor_23_3
      port map ( R => CompressorOut_bh6_19_19   ,
                 X0 => CompressorIn_bh6_19_27,
                 X1 => CompressorIn_bh6_19_28);
   heap_bh6_w13_13 <= CompressorOut_bh6_19_19(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w14_12 <= CompressorOut_bh6_19_19(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w15_12 <= CompressorOut_bh6_19_19(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_20_29 <= heap_bh6_w23_2 & heap_bh6_w23_1 & heap_bh6_w23_0;
   CompressorIn_bh6_20_30 <= heap_bh6_w24_2 & heap_bh6_w24_1;
   Compressor_bh6_20: Compressor_23_3
      port map ( R => CompressorOut_bh6_20_20   ,
                 X0 => CompressorIn_bh6_20_29,
                 X1 => CompressorIn_bh6_20_30);
   heap_bh6_w23_4 <= CompressorOut_bh6_20_20(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w24_3 <= CompressorOut_bh6_20_20(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w25_1 <= CompressorOut_bh6_20_20(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_21_31 <= heap_bh6_w4_2 & heap_bh6_w4_1 & heap_bh6_w4_0;
   CompressorIn_bh6_21_32(0) <= heap_bh6_w5_0;
   Compressor_bh6_21: Compressor_13_3
      port map ( R => CompressorOut_bh6_21_21   ,
                 X0 => CompressorIn_bh6_21_31,
                 X1 => CompressorIn_bh6_21_32);
   heap_bh6_w4_4 <= CompressorOut_bh6_21_21(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w5_6 <= CompressorOut_bh6_21_21(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w6_7 <= CompressorOut_bh6_21_21(2); -- cycle= 0 cp= 1.09632e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_22_33 <= heap_bh6_w15_2 & heap_bh6_w15_1 & heap_bh6_w15_0;
   CompressorIn_bh6_22_34(0) <= heap_bh6_w16_0;
   Compressor_bh6_22: Compressor_13_3
      port map ( R => CompressorOut_bh6_22_22   ,
                 X0 => CompressorIn_bh6_22_33,
                 X1 => CompressorIn_bh6_22_34);
   heap_bh6_w15_13 <= CompressorOut_bh6_22_22(0); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w16_10 <= CompressorOut_bh6_22_22(1); -- cycle= 0 cp= 1.09632e-09
   heap_bh6_w17_10 <= CompressorOut_bh6_22_22(2); -- cycle= 0 cp= 1.09632e-09
   ----------------Synchro barrier, entering cycle 0----------------
   tempR_bh6_1 <= heap_bh6_w2_3; -- already compressed

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_23_35 <= heap_bh6_w9_0 & heap_bh6_w9_9 & heap_bh6_w9_8 & heap_bh6_w9_7;
   CompressorIn_bh6_23_36(0) <= heap_bh6_w10_0;
   Compressor_bh6_23: Compressor_14_3
      port map ( R => CompressorOut_bh6_23_23   ,
                 X0 => CompressorIn_bh6_23_35,
                 X1 => CompressorIn_bh6_23_36);
   heap_bh6_w9_10 <= CompressorOut_bh6_23_23(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w10_10 <= CompressorOut_bh6_23_23(1); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w11_13 <= CompressorOut_bh6_23_23(2); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_24_37 <= heap_bh6_w11_12 & heap_bh6_w11_11 & heap_bh6_w11_10 & heap_bh6_w11_9;
   CompressorIn_bh6_24_38(0) <= heap_bh6_w12_0;
   Compressor_bh6_24: Compressor_14_3
      port map ( R => CompressorOut_bh6_24_24   ,
                 X0 => CompressorIn_bh6_24_37,
                 X1 => CompressorIn_bh6_24_38);
   heap_bh6_w11_14 <= CompressorOut_bh6_24_24(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w12_13 <= CompressorOut_bh6_24_24(1); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w13_14 <= CompressorOut_bh6_24_24(2); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_25_39 <= heap_bh6_w12_12 & heap_bh6_w12_11 & heap_bh6_w12_10 & heap_bh6_w12_9;
   CompressorIn_bh6_25_40(0) <= heap_bh6_w13_13;
   Compressor_bh6_25: Compressor_14_3
      port map ( R => CompressorOut_bh6_25_25   ,
                 X0 => CompressorIn_bh6_25_39,
                 X1 => CompressorIn_bh6_25_40);
   heap_bh6_w12_14 <= CompressorOut_bh6_25_25(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w13_15 <= CompressorOut_bh6_25_25(1); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w14_13 <= CompressorOut_bh6_25_25(2); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_26_41 <= heap_bh6_w13_12 & heap_bh6_w13_11 & heap_bh6_w13_10 & heap_bh6_w13_9;
   CompressorIn_bh6_26_42(0) <= heap_bh6_w14_0;
   Compressor_bh6_26: Compressor_14_3
      port map ( R => CompressorOut_bh6_26_26   ,
                 X0 => CompressorIn_bh6_26_41,
                 X1 => CompressorIn_bh6_26_42);
   heap_bh6_w13_16 <= CompressorOut_bh6_26_26(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w14_14 <= CompressorOut_bh6_26_26(1); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w15_14 <= CompressorOut_bh6_26_26(2); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_27_43 <= heap_bh6_w14_12 & heap_bh6_w14_11 & heap_bh6_w14_10 & heap_bh6_w14_9;
   CompressorIn_bh6_27_44(0) <= heap_bh6_w15_13;
   Compressor_bh6_27: Compressor_14_3
      port map ( R => CompressorOut_bh6_27_27   ,
                 X0 => CompressorIn_bh6_27_43,
                 X1 => CompressorIn_bh6_27_44);
   heap_bh6_w14_15 <= CompressorOut_bh6_27_27(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w15_15 <= CompressorOut_bh6_27_27(1); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w16_11 <= CompressorOut_bh6_27_27(2); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_28_45 <= heap_bh6_w15_12 & heap_bh6_w15_11 & heap_bh6_w15_10 & heap_bh6_w15_9;
   CompressorIn_bh6_28_46(0) <= heap_bh6_w16_10;
   Compressor_bh6_28: Compressor_14_3
      port map ( R => CompressorOut_bh6_28_28   ,
                 X0 => CompressorIn_bh6_28_45,
                 X1 => CompressorIn_bh6_28_46);
   heap_bh6_w15_16 <= CompressorOut_bh6_28_28(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w16_12 <= CompressorOut_bh6_28_28(1); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w17_11 <= CompressorOut_bh6_28_28(2); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_29_47 <= heap_bh6_w17_0 & heap_bh6_w17_10 & heap_bh6_w17_9 & heap_bh6_w17_8;
   CompressorIn_bh6_29_48(0) <= heap_bh6_w18_0;
   Compressor_bh6_29: Compressor_14_3
      port map ( R => CompressorOut_bh6_29_29   ,
                 X0 => CompressorIn_bh6_29_47,
                 X1 => CompressorIn_bh6_29_48);
   heap_bh6_w17_12 <= CompressorOut_bh6_29_29(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w18_10 <= CompressorOut_bh6_29_29(1); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w19_8 <= CompressorOut_bh6_29_29(2); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_30_49 <= heap_bh6_w19_0 & heap_bh6_w19_7 & heap_bh6_w19_6 & heap_bh6_w19_5;
   CompressorIn_bh6_30_50(0) <= heap_bh6_w20_7;
   Compressor_bh6_30: Compressor_14_3
      port map ( R => CompressorOut_bh6_30_30   ,
                 X0 => CompressorIn_bh6_30_49,
                 X1 => CompressorIn_bh6_30_50);
   heap_bh6_w19_9 <= CompressorOut_bh6_30_30(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w20_8 <= CompressorOut_bh6_30_30(1); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w21_8 <= CompressorOut_bh6_30_30(2); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_31_51 <= heap_bh6_w22_1 & heap_bh6_w22_0 & heap_bh6_w22_4 & heap_bh6_w22_3;
   CompressorIn_bh6_31_52(0) <= heap_bh6_w23_4;
   Compressor_bh6_31: Compressor_14_3
      port map ( R => CompressorOut_bh6_31_31   ,
                 X0 => CompressorIn_bh6_31_51,
                 X1 => CompressorIn_bh6_31_52);
   heap_bh6_w22_5 <= CompressorOut_bh6_31_31(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w23_5 <= CompressorOut_bh6_31_31(1); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w24_4 <= CompressorOut_bh6_31_31(2); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_32_53 <= heap_bh6_w6_7 & heap_bh6_w6_6 & heap_bh6_w6_5;
   CompressorIn_bh6_32_54 <= heap_bh6_w7_7 & heap_bh6_w7_6;
   Compressor_bh6_32: Compressor_23_3
      port map ( R => CompressorOut_bh6_32_32   ,
                 X0 => CompressorIn_bh6_32_53,
                 X1 => CompressorIn_bh6_32_54);
   heap_bh6_w6_8 <= CompressorOut_bh6_32_32(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w7_8 <= CompressorOut_bh6_32_32(1); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w8_10 <= CompressorOut_bh6_32_32(2); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_33_55 <= heap_bh6_w16_9 & heap_bh6_w16_8 & heap_bh6_w16_7;
   CompressorIn_bh6_33_56(0) <= heap_bh6_w17_7;
   Compressor_bh6_33: Compressor_13_3
      port map ( R => CompressorOut_bh6_33_33   ,
                 X0 => CompressorIn_bh6_33_55,
                 X1 => CompressorIn_bh6_33_56);
   heap_bh6_w16_13 <= CompressorOut_bh6_33_33(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w17_13 <= CompressorOut_bh6_33_33(1); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w18_11 <= CompressorOut_bh6_33_33(2); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_34_57 <= heap_bh6_w8_9 & heap_bh6_w8_8 & heap_bh6_w8_7;
   Compressor_bh6_34: Compressor_3_2
      port map ( R => CompressorOut_bh6_34_34   ,
                 X0 => CompressorIn_bh6_34_57);
   heap_bh6_w8_11 <= CompressorOut_bh6_34_34(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w9_11 <= CompressorOut_bh6_34_34(1); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_35_58 <= heap_bh6_w10_9 & heap_bh6_w10_8 & heap_bh6_w10_7;
   Compressor_bh6_35: Compressor_3_2
      port map ( R => CompressorOut_bh6_35_35   ,
                 X0 => CompressorIn_bh6_35_58);
   heap_bh6_w10_11 <= CompressorOut_bh6_35_35(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w11_15 <= CompressorOut_bh6_35_35(1); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_36_59 <= heap_bh6_w18_9 & heap_bh6_w18_8 & heap_bh6_w18_7;
   Compressor_bh6_36: Compressor_3_2
      port map ( R => CompressorOut_bh6_36_36   ,
                 X0 => CompressorIn_bh6_36_59);
   heap_bh6_w18_12 <= CompressorOut_bh6_36_36(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w19_10 <= CompressorOut_bh6_36_36(1); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_37_60 <= heap_bh6_w21_7 & heap_bh6_w21_6 & heap_bh6_w21_5;
   Compressor_bh6_37: Compressor_3_2
      port map ( R => CompressorOut_bh6_37_37   ,
                 X0 => CompressorIn_bh6_37_60);
   heap_bh6_w21_9 <= CompressorOut_bh6_37_37(0); -- cycle= 0 cp= 1.62704e-09
   heap_bh6_w22_6 <= CompressorOut_bh6_37_37(1); -- cycle= 0 cp= 1.62704e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_38_61 <= heap_bh6_w11_15 & heap_bh6_w11_14 & heap_bh6_w11_13;
   CompressorIn_bh6_38_62 <= heap_bh6_w12_14 & heap_bh6_w12_13;
   Compressor_bh6_38: Compressor_23_3
      port map ( R => CompressorOut_bh6_38_38   ,
                 X0 => CompressorIn_bh6_38_61,
                 X1 => CompressorIn_bh6_38_62);
   heap_bh6_w11_16 <= CompressorOut_bh6_38_38(0); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w12_15 <= CompressorOut_bh6_38_38(1); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w13_17 <= CompressorOut_bh6_38_38(2); -- cycle= 0 cp= 2.15776e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_39_63 <= heap_bh6_w13_16 & heap_bh6_w13_15 & heap_bh6_w13_14;
   CompressorIn_bh6_39_64 <= heap_bh6_w14_15 & heap_bh6_w14_14;
   Compressor_bh6_39: Compressor_23_3
      port map ( R => CompressorOut_bh6_39_39   ,
                 X0 => CompressorIn_bh6_39_63,
                 X1 => CompressorIn_bh6_39_64);
   heap_bh6_w13_18 <= CompressorOut_bh6_39_39(0); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w14_16 <= CompressorOut_bh6_39_39(1); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w15_17 <= CompressorOut_bh6_39_39(2); -- cycle= 0 cp= 2.15776e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_40_65 <= heap_bh6_w15_16 & heap_bh6_w15_15 & heap_bh6_w15_14;
   CompressorIn_bh6_40_66 <= heap_bh6_w16_13 & heap_bh6_w16_12;
   Compressor_bh6_40: Compressor_23_3
      port map ( R => CompressorOut_bh6_40_40   ,
                 X0 => CompressorIn_bh6_40_65,
                 X1 => CompressorIn_bh6_40_66);
   heap_bh6_w15_18 <= CompressorOut_bh6_40_40(0); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w16_14 <= CompressorOut_bh6_40_40(1); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w17_14 <= CompressorOut_bh6_40_40(2); -- cycle= 0 cp= 2.15776e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_41_67 <= heap_bh6_w17_13 & heap_bh6_w17_12 & heap_bh6_w17_11;
   CompressorIn_bh6_41_68 <= heap_bh6_w18_12 & heap_bh6_w18_11;
   Compressor_bh6_41: Compressor_23_3
      port map ( R => CompressorOut_bh6_41_41   ,
                 X0 => CompressorIn_bh6_41_67,
                 X1 => CompressorIn_bh6_41_68);
   heap_bh6_w17_15 <= CompressorOut_bh6_41_41(0); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w18_13 <= CompressorOut_bh6_41_41(1); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w19_11 <= CompressorOut_bh6_41_41(2); -- cycle= 0 cp= 2.15776e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_42_69 <= heap_bh6_w19_10 & heap_bh6_w19_9 & heap_bh6_w19_8;
   CompressorIn_bh6_42_70 <= heap_bh6_w20_6 & heap_bh6_w20_5;
   Compressor_bh6_42: Compressor_23_3
      port map ( R => CompressorOut_bh6_42_42   ,
                 X0 => CompressorIn_bh6_42_69,
                 X1 => CompressorIn_bh6_42_70);
   heap_bh6_w19_12 <= CompressorOut_bh6_42_42(0); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w20_9 <= CompressorOut_bh6_42_42(1); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w21_10 <= CompressorOut_bh6_42_42(2); -- cycle= 0 cp= 2.15776e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_43_71 <= heap_bh6_w24_0 & heap_bh6_w24_3 & heap_bh6_w24_4;
   CompressorIn_bh6_43_72 <= heap_bh6_w25_0 & heap_bh6_w25_1;
   Compressor_bh6_43: Compressor_23_3
      port map ( R => CompressorOut_bh6_43_43   ,
                 X0 => CompressorIn_bh6_43_71,
                 X1 => CompressorIn_bh6_43_72);
   heap_bh6_w24_5 <= CompressorOut_bh6_43_43(0); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w25_2 <= CompressorOut_bh6_43_43(1); -- cycle= 0 cp= 2.15776e-09
   heap_bh6_w26_1 <= CompressorOut_bh6_43_43(2); -- cycle= 0 cp= 2.15776e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_44_73 <= heap_bh6_w21_9 & heap_bh6_w21_8 & heap_bh6_w21_10;
   CompressorIn_bh6_44_74 <= heap_bh6_w22_6 & heap_bh6_w22_5;
   Compressor_bh6_44: Compressor_23_3
      port map ( R => CompressorOut_bh6_44_44   ,
                 X0 => CompressorIn_bh6_44_73,
                 X1 => CompressorIn_bh6_44_74);
   heap_bh6_w21_11 <= CompressorOut_bh6_44_44(0); -- cycle= 0 cp= 2.68848e-09
   heap_bh6_w22_7 <= CompressorOut_bh6_44_44(1); -- cycle= 0 cp= 2.68848e-09
   heap_bh6_w23_6 <= CompressorOut_bh6_44_44(2); -- cycle= 0 cp= 2.68848e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_45_75 <= heap_bh6_w23_3 & heap_bh6_w23_5 & heap_bh6_w23_6;
   CompressorIn_bh6_45_76(0) <= heap_bh6_w24_5;
   Compressor_bh6_45: Compressor_13_3
      port map ( R => CompressorOut_bh6_45_45   ,
                 X0 => CompressorIn_bh6_45_75,
                 X1 => CompressorIn_bh6_45_76);
   heap_bh6_w23_7 <= CompressorOut_bh6_45_45(0); -- cycle= 0 cp= 3.2192e-09
   heap_bh6_w24_6 <= CompressorOut_bh6_45_45(1); -- cycle= 0 cp= 3.2192e-09
   heap_bh6_w25_3 <= CompressorOut_bh6_45_45(2); -- cycle= 0 cp= 3.2192e-09
   ----------------Synchro barrier, entering cycle 0----------------
   finalAdderIn0_bh6 <= "0" & heap_bh6_w27_0 & heap_bh6_w26_0 & heap_bh6_w25_2 & heap_bh6_w24_6 & heap_bh6_w23_7 & heap_bh6_w22_7 & heap_bh6_w21_11 & heap_bh6_w20_8 & heap_bh6_w19_12 & heap_bh6_w18_10 & heap_bh6_w17_15 & heap_bh6_w16_11 & heap_bh6_w15_18 & heap_bh6_w14_13 & heap_bh6_w13_18 & heap_bh6_w12_15 & heap_bh6_w11_16 & heap_bh6_w10_11 & heap_bh6_w9_11 & heap_bh6_w8_11 & heap_bh6_w7_5 & heap_bh6_w6_8 & heap_bh6_w5_6 & heap_bh6_w4_4 & heap_bh6_w3_0;
   finalAdderIn1_bh6 <= "0" & '0' & heap_bh6_w26_1 & heap_bh6_w25_3 & '0' & '0' & '0' & '0' & heap_bh6_w20_9 & heap_bh6_w19_11 & heap_bh6_w18_13 & heap_bh6_w17_14 & heap_bh6_w16_14 & heap_bh6_w15_17 & heap_bh6_w14_16 & heap_bh6_w13_17 & '0' & '0' & heap_bh6_w10_10 & heap_bh6_w9_10 & heap_bh6_w8_10 & heap_bh6_w7_8 & '0' & heap_bh6_w5_5 & heap_bh6_w4_3 & heap_bh6_w3_3;
   finalAdderCin_bh6 <= '0';
   Adder_final6_0: IntAdder_26_f120_uid88  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => finalAdderCin_bh6,
                 R => finalAdderOut_bh6   ,
                 X => finalAdderIn0_bh6,
                 Y => finalAdderIn1_bh6);
   -- concatenate all the compressed chunks
   CompressionResult6 <= finalAdderOut_bh6 & tempR_bh6_1 & tempR_bh6_0;
   -- End of code generated by BitHeap::generateCompressorVHDL
   R <= CompressionResult6(27 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_21_f120_uid96
--                    (IntAdderAlternative_21_f120_uid100)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_21_f120_uid96 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(20 downto 0);
          Y : in  std_logic_vector(20 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(20 downto 0)   );
end entity;

architecture arch of IntAdder_21_f120_uid96 is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Alternative
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--                                  FPMul613
--                        (FPMult_6_13_6_13_6_13_uid2)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin 2008-2011
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPMul613 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(6+13+2 downto 0);
          Y : in  std_logic_vector(6+13+2 downto 0);
          R : out  std_logic_vector(6+13+2 downto 0)   );
end entity;

architecture arch of FPMul613 is
   component IntAdder_21_f120_uid96 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(20 downto 0);
             Y : in  std_logic_vector(20 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(20 downto 0)   );
   end component;

   component IntMultiplier_UsingDSP_14_14_28_unsigned_uid4 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(13 downto 0);
             Y : in  std_logic_vector(13 downto 0);
             R : out  std_logic_vector(27 downto 0)   );
   end component;

signal sign :  std_logic;
signal expX :  std_logic_vector(5 downto 0);
signal expY :  std_logic_vector(5 downto 0);
signal expSumPreSub :  std_logic_vector(7 downto 0);
signal bias :  std_logic_vector(7 downto 0);
signal expSum :  std_logic_vector(7 downto 0);
signal sigX :  std_logic_vector(13 downto 0);
signal sigY :  std_logic_vector(13 downto 0);
signal sigProd :  std_logic_vector(27 downto 0);
signal excSel :  std_logic_vector(3 downto 0);
signal exc :  std_logic_vector(1 downto 0);
signal norm :  std_logic;
signal expPostNorm :  std_logic_vector(7 downto 0);
signal sigProdExt :  std_logic_vector(27 downto 0);
signal expSig :  std_logic_vector(20 downto 0);
signal sticky :  std_logic;
signal guard :  std_logic;
signal round :  std_logic;
signal expSigPostRound :  std_logic_vector(20 downto 0);
signal excPostNorm :  std_logic_vector(1 downto 0);
signal finalExc :  std_logic_vector(1 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   sign <= X(19) xor Y(19);
   expX <= X(18 downto 13);
   expY <= Y(18 downto 13);
   expSumPreSub <= ("00" & expX) + ("00" & expY);
   bias <= CONV_STD_LOGIC_VECTOR(31,8);
   expSum <= expSumPreSub - bias;
   ----------------Synchro barrier, entering cycle 0----------------
   sigX <= "1" & X(12 downto 0);
   sigY <= "1" & Y(12 downto 0);
   SignificandMultiplication: IntMultiplier_UsingDSP_14_14_28_unsigned_uid4  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => sigProd,
                 X => sigX,
                 Y => sigY);
   ----------------Synchro barrier, entering cycle 0----------------
   excSel <= X(21 downto 20) & Y(21 downto 20);
   with excSel select
   exc <= "00" when  "0000" | "0001" | "0100",
          "01" when "0101",
          "10" when "0110" | "1001" | "1010" ,
          "11" when others;
   norm <= sigProd(27);
   -- exponent update
   expPostNorm <= expSum + ("0000000" & norm);
   -- significand normalization shift
   sigProdExt <= sigProd(26 downto 0) & "0" when norm='1' else
                         sigProd(25 downto 0) & "00";
   expSig <= expPostNorm & sigProdExt(27 downto 15);
   sticky <= sigProdExt(14);
   guard <= '0' when sigProdExt(13 downto 0)="00000000000000" else '1';
   round <= sticky and ( (guard and not(sigProdExt(15))) or (sigProdExt(15) ))  ;
   RoundingAdder: IntAdder_21_f120_uid96  -- pipelineDepth=0 maxInDelay=5.3256e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => round,
                 R => expSigPostRound   ,
                 X => expSig,
                 Y => "000000000000000000000");
   with expSigPostRound(20 downto 19) select
   excPostNorm <=  "01"  when  "00",
                               "10"             when "01",
                               "00"             when "11"|"10",
                               "11"             when others;
   with exc select
   finalExc <= exc when  "11"|"10"|"00",
                       excPostNorm when others;
   R <= finalExc & sign & expSigPostRound(18 downto 0);
end architecture;
