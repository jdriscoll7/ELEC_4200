library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity moore_model is 

    port(CLK     : in STD_LOGIC;
         RST     : in STD_LOGIC;
         PB      : in STD_LOGIC;
         Cout    : out STD_LOGIC_VECTOR(1 downto 0);
         Oout    : out STD_LOGIC_VECTOR(3 downto 0));
         
end moore_model;


architecture behavorial of moore_model is
    
    -- Enumerate states for the model representation.
    type model_state is ('0', '1', '2', '3');
    
    -- Signal for storing current and next state (initialize to 0).
    signal current_state : model_state := '0';
    
    -- Signal for one-shot/enable signals.
    signal X, Y, Z, EN : STD_LOGIC;
    
    -- Signals for outputs.
    signal c_out : STD_LOGIC_VECTOR(1 downto 0);
    signal o_out : STD_LOGIC_VECTOR(3 downto 0);
    
begin
    
    -- Handles enable and reset conditions.
    state_transition : process(CLK) is
    begin
        
        -- Reset condition.
        if rising_edge(CLK) then 
            if (RST = '1') then
                current_state <= '0';
            elsif (EN = '1') then
                case current_state is
                    when '0' => current_state <= '1';
                    when '1' => current_state <= '2';
                    when '2' => current_state <= '3';
                    when '3' => current_state <= '0';
                end case;
            end if;
        end if;
    end process state_transition;
    
    
    -- Determine outputs.
    outputs : process(current_state) is
    begin
        case current_state is
            when '0' => c_out <= "00";
                        o_out <= "1110";
            when '1' => c_out <= "01";
                        o_out <= "1101";            
            when '2' => c_out <= "10";
                        o_out <= "1011";
            when '3' => c_out <= "11";
                        o_out <= "0111";
        end case;
    end process outputs;

    -- Write the outputs.
    Cout <= c_out;
    Oout <= o_out;

    -- One-shot model copied from lab_2 template.
    
    ---------------------Begin digital one-shot model---------------------

    -- First D flip-flop of the one-shot circuit
    ONESHOTFF1 : process (CLK)
                 begin	
                    if rising_edge(CLK) then	-- trigger on rising clock edge
                        X <= PB;			    -- PB = D-input, X = Q-output	
                    end if;
                end process;
                
    -- Second D flip-flop of the one-shot circuit
    ONESHOTFF2 : process (CLK)
                 begin	
                    if rising_edge(CLK) then	-- trigger on rising clock edge
                        Y <= X;			        -- X = D-input, Y = Q-output	
                    end if;
                end process;

    -- Third D flip-flop of the one-shot circuit
    ONESHOTFF3 : process (CLK)
                 begin	
                    if rising_edge(CLK) then	-- trigger on rising clock edge
                        Z <= Y;			        -- Y = D-input, Z = Q-output	
                    end if;
                end process;

    --Create enable signal with the output of the oneshot
    EN <= Y and not Z;

    ---------------------End digital one-shot code---------------------
    
    

end behavorial;