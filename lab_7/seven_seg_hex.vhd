library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_decoder is

    port(D        : in  STD_LOGIC_VECTOR(3 downto 0);
         segments : out STD_LOGIC_VECTOR(6 downto 0));
         
end hex_decoder;


architecture behavioral of hex_decoder is

    -- Constants for 7-Segment Display characters.
    constant DISP_0  : STD_LOGIC_VECTOR(6 downto 0) := "1000000";
    constant DISP_1  : STD_LOGIC_VECTOR(6 downto 0) := "1111001";
    constant DISP_2  : STD_LOGIC_VECTOR(6 downto 0) := "0100100";
    constant DISP_3  : STD_LOGIC_VECTOR(6 downto 0) := "0110000";
    constant DISP_4  : STD_LOGIC_VECTOR(6 downto 0) := "0011001";
    constant DISP_5  : STD_LOGIC_VECTOR(6 downto 0) := "0010010";
    constant DISP_6  : STD_LOGIC_VECTOR(6 downto 0) := "0000010";
    constant DISP_7  : STD_LOGIC_VECTOR(6 downto 0) := "1111000";
    constant DISP_8  : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
    constant DISP_9  : STD_LOGIC_VECTOR(6 downto 0) := "001X000";
    constant DISP_A  : STD_LOGIC_VECTOR(6 downto 0) := "0001000";
    constant DISP_B  : STD_LOGIC_VECTOR(6 downto 0) := "0000011";
    constant DISP_C  : STD_LOGIC_VECTOR(6 downto 0) := "1000110";
    constant DISP_D  : STD_LOGIC_VECTOR(6 downto 0) := "0100001";
    constant DISP_E  : STD_LOGIC_VECTOR(6 downto 0) := "0000110";
    constant DISP_F  : STD_LOGIC_VECTOR(6 downto 0) := "0001110";
    constant UNKNOWN : STD_LOGIC_VECTOR(6 downto 0) := "XXXXXXX";
    
begin
    
    decode_d : process(D)
    begin
        case D is
            when "0000" => segments <= DISP_0;
            when "0001" => segments <= DISP_1;
            when "0010" => segments <= DISP_2;
            when "0011" => segments <= DISP_3;
            when "0100" => segments <= DISP_4;
            when "0101" => segments <= DISP_5;
            when "0110" => segments <= DISP_6;
            when "0111" => segments <= DISP_7;
            when "1000" => segments <= DISP_8;
            when "1001" => segments <= DISP_9;
            when "1010" => segments <= DISP_A;
            when "1011" => segments <= DISP_B;
            when "1100" => segments <= DISP_C;
            when "1101" => segments <= DISP_D;
            when "1110" => segments <= DISP_E;
            when "1111" => segments <= DISP_F;
            when others => segments <= UNKNOWN;
        end case;
    end process decode_d;
    
end behavioral; 