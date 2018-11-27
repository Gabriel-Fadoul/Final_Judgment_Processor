LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY DataPath IS
	PORT
	(
		--------Clock Geral do Sistema-------------------------------
		Clock_Sistema:               in  std_logic
		-------------------------------------------------------------
	);
END DataPath;


ARCHITECTURE behavior OF DataPath IS

	COMPONENT PC IS
		PORT
		(
			--ativo : IN STD_LOGIC;
			clk :  IN  STD_LOGIC;
			pin :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
			pout : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
			
		);
	END COMPONENT;

	COMPONENT SomadorPC IS
		PORT
		(
			entrada : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
			saida : 	 out STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT memoria_ROM2 IS 
		PORT
		(
			clk: 		IN  STD_LOGIC;
			entrada: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			rom_out: out std_logic_vector(15 downto 0);
			op : 		OUT STD_LOGIC_VECTOR(3  DOWNTO 0);
			rd : 		OUT STD_LOGIC_VECTOR(2  DOWNTO 0);
			rt : 		OUT STD_LOGIC_VECTOR(2  DOWNTO 0);
			rs : 		OUT STD_LOGIC_VECTOR(2  DOWNTO 0);
			funct : 	OUT STD_LOGIC_VECTOR(2  DOWNTO 0);
			tipoi : 	OUT STD_LOGIC_VECTOR(5  DOWNTO 0);
			jump : 	out STD_LOGIC_VECTOR(11 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT Multiplexador2x1 IS
		PORT( 
		SIGNAL A,B  : IN   STD_LOGIC_VECTOR(2 DOWNTO 0);
		SIGNAL S	   : IN   STD_LOGIC;
		SIGNAL SAIDA: OUT  STD_LOGIC_VECTOR(2 DOWNTO 0)
		) ;
END COMPONENT;
	
	COMPONENT UnidadedeControle IS
		PORT(
			 entrada : 		in std_logic_vector (3 DOWNTO 0);
			 regdest : 		out std_logic; 
			 origalu : 		out std_logic; 
			 memparareg : 	out std_logic;	
			 escrevereg :  out std_logic;	
			 lemem : 		out std_logic;	
			 escrevemem :  out std_logic;	
			 branch : 		out std_logic;	
			 aluop1 :      out std_logic;
			 aluop0 : 		out std_logic	
			);
END COMPONENT;

	COMPONENT BancoRegistradores IS
		PORT(
			Clock:  in  std_logic;
			EscReg: in  std_logic; 							 -- Sinal da unidade de controle
			RegA:   out std_logic_vector (15 downto 0);
		   RegB:   out std_logic_vector (15 downto 0); 
		   Data:   in  std_logic_vector (15 downto 0); -- Dado a ser escrito
			RegDst: in  std_logic_vector (2  downto 0);  -- Registrador de destino
			LeReg1: in  std_logic_vector (2  downto 0);  -- Endereço do resgistrador 1
			LeReg2: in  std_logic_vector (2  downto 0)   -- Endereço do resgistrador 2
		);
END COMPONENT;

	COMPONENT ExtensordeSinal6To16bits IS
		PORT
		(
			ENTRADA : IN STD_LOGIC_VECTOR(5 DOWNTO 0); 
			SAIDA   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	
	END COMPONENT;
	COMPONENT ShiftEsquerda IS 

	PORT(
		VALOR: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		SAIDA: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
	
	END COMPONENT;	
		
		
		-------Entrada e Saida do PC---------------------------------
		SIGNAL SomadorToPc: 			        	  std_logic_vector(15 downto 0);
		SIGNAL SaidaPc: 			  			  	  std_logic_vector(15 downto 0);
		-------------------------------------------------------------
		
		-------Saidas do Banco de Registradores----------------------
		SIGNAL SaidaRegA:  			  		  	  std_logic_vector(15 downto 0);
		SIGNAL SaidaRegB:  			  		  	  std_logic_vector(15 downto 0);
		
		--------Saidas da Memoria de instrução-----------------------
		SIGNAL Instruction_to_multiplexador:	   std_logic_vector(2  downto 0);
		SIGNAL Instruction_to_Control:   	      std_logic_vector(3  downto 0);
		SIGNAL Instruction_to_register1:   	      std_logic_vector(2  downto 0);
		SIGNAL Instruction_to_register2:   	      std_logic_vector(2  downto 0);
		SIGNAL Instruction_to_controlULA:   	   std_logic_vector(2  downto 0);
		SIGNAL Instruction_to_extensorDeSinal:   	std_logic_vector(5  downto 0);
		SIGNAL Instruction_to_Jump:			  	   std_logic_vector(11 downto 0);
		--------------------------------------------------------------
		
		---------Saída Geral da ROM-----------------------------------
		SIGNAL Instruct_out:                	   std_logic_vector(15 downto 0);
		--------------------------------------------------------------
		
		--------Saída do Multiplexador1-------------------------------
		SIGNAL multiplexador_to_writeRegister:    std_logic_vector(2  downto 0);
		--------------------------------------------------------------
		
		--------Dados Para o Banco De Registradores--------------------
		SIGNAL Data_to_writeRegister: 		      std_logic_vector(15 downto 0);
		--------------------------------------------------------------
		
		-------- Flags da Unidade de controle-------------------------
		SIGNAL Flag_regdest:					     std_logic;
		SIGNAL Flag_origialu:					  std_logic;
		SIGNAL Flag_memparareg:					  std_logic;
		SIGNAL Flag_escrevereg:					  std_logic;
		SIGNAL Flag_lemem:						  std_logic;
		SIGNAL Flag_escrevemem:					  std_logic;
		SIGNAL Flag_branch: 						  std_logic;
		SIGNAL Flag_aluop1: 	  					  std_logic;
		SIGNAL Flag_aluop0: 	 					  std_logic;
		---------------------------------------------------------------
		
		--------Saida do Extensor de sinal-------------------
		SIGNAL Saida_extensor:                std_logic_vector(15 downto 0);
		---------------------------------------------------------------
		
		--------Saida do SLL para componente SOMADOR DA ULA------------
		SIGNAL Saida_SLL_to_SumUla:           std_logic_vector(15 downto 0);

BEGIN		
G1: PC           		        port map (Clock_Sistema, SomadorToPc, SaidaPc);
G2: SomadorPC    		        port map (SaidaPc, SomadorToPc);
G3: memoria_ROM2 		        port map (Clock_Sistema, SaidaPc, Instruct_out, Instruction_to_Control, Instruction_to_register1, Instruction_to_register2, 
													Instruction_to_multiplexador,Instruction_to_controlULA, Instruction_to_extensorDeSinal, Instruction_to_Jump);											
G4: UnidadedeControle        port map (Instruction_to_Control, Flag_regdest, Flag_origialu, Flag_memparareg, Flag_escrevereg, Flag_lemem, Flag_escrevemem,
													Flag_branch, Flag_aluop1, Flag_aluop0);								 											
G5: Multiplexador2x1     	  port map (Instruction_to_register2,Instruction_to_multiplexador,Flag_regdest,multiplexador_to_writeRegister);
G6: BancoRegistradores 		  port map (Clock_Sistema, Flag_escrevereg, SaidaRegA,SaidaRegB,Data_to_writeRegister, multiplexador_to_writeRegister,
													Instruction_to_register1, Instruction_to_register2);
G7: ExtensordeSinal6To16bits port map (Instruction_to_extensorDeSinal,Saida_extensor);
G8: ShiftEsquerda            port map (Saida_extensor, Saida_SLL_to_SumUla);
END behavior;
