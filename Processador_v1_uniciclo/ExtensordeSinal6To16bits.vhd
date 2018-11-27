LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;  
USE ieee.std_logic_unsigned.all;

ENTITY ExtensordeSinal6To16bits IS
	PORT(
		ENTRADA : IN STD_LOGIC_VECTOR(5 DOWNTO 0); 
		SAIDA   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
	
END ExtensordeSinal6To16bits;

ARCHITECTURE BEHAVIOR OF ExtensordeSinal6To16bits IS

	BEGIN
		PROCESS(ENTRADA)
			BEGIN
				IF ENTRADA(5) = '0' THEN
					SAIDA <= ("0000000000") & ENTRADA;
				ELSE
					SAIDA <= ("1111111111") & ENTRADA;
				END IF;
		END PROCESS;
		
END BEHAVIOR;