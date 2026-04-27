; SEL0433 -- Aplicação de Microprocessadores
; Lucas Manoel e Gabriel Nardelli
; 15471884 e 15453960
; Docente: Pedro de Oliveira de Conceição Junior 
; Projeto 1 - Entrega Final 
; Observações:
; 1. Para melhor visualização do resultado utilize um uptade frequency <=10Hz
; 2. O ponto decimal indica o sentido horário. 



ORG 0000h

    JMP main




ORG 001Bh

    JMP LOOP_TIMER



ORG 0100h

segmentos:
		db 0C0h ; 0
		db 0F9h ; 1
		db 0A4h ; 2
		db 0B0h ; 3
		db 99h ; 4
		db 92h ; 5
		db 82h ; 6
		db 0F8h ; 7 
		db 80h; 8 
		db 90h; 9
;Tabela para o display de sete segmentos do checkpoint 1 

ORG 0030h

main:

		MOV SP,   #3Fh; Movendo stack pointer para uma área "mais segura" evitando conflito com os registradores de banco 0 e com as variáveis de uso geral na RAM interna
		MOV TMOD, #01100000b; Ativando incremento de contagem por evento externo (C/T1 = 1) e Modo 2 pois possui reload automático com um registrador para contagem (TLx) e outro para reiniciar (THx)
		MOV R0,   #0          ; Variavel de processo (Contador de Voltas)
		ACALL RESET_CONTADOR  ; Sub-rotina dedicada para resetar a contagem evitando overflow após o 9. 
; IE (Interrupt Enable) - habilita 8 bits do registrador IE:
;  7  6  5 4  3   2   1   0
;  EA -  - ES T1 INT1 T0 INT0
;Sendo:EA=1 habilita interrupções
;      ES=1 hab. Interrup. serial
;		  ET1=1 hab. interrup Timer 1
;    EX1=1 hab. interrup externa 1
;      ET0=1 hab. interrup Timer 0
;    EX0=1 hab. interrup externa 0
;Exemplo: MOV IE, #10001101b
; significa hab. interrupções e...
; usar somente as interupções:
; INT0, INT1 e T1

; Outra forma: bit a bit 
; SETB EA; SETB ET1; SETB EX0 ; etc
;----------------------------------
		
		MOV IE,   #10001000b; EA=1(Habilita as interrupções), ET1=1 (Habilita interrupção no timer1)
		MOV TCON, #01000000b; TR1 = 1 (como GATE=0 (em TMOD) , o C/T1 contará quando o Bit TR1 (em TCON) for = 1)



		SETB P2.0             ; Configurando SW0 como entrada
		CLR  P3.4             ; Habilita display
		CLR  F0               ; Sentido inicial
		SETB P3.0             ; Muda sentido ou mantém
		CLR  P3.1							; Muda sentido ou mantém 



LOOP_PRINCIPAL:

		ACALL VERIFICA_CHAVE
		ACALL ATUALIZA_VOLTAS
		SJMP LOOP_PRINCIPAL

RESET_CONTADOR:

		CLR  TR1              ; Para o temporizador
		MOV  R0,   #0         ; Zera a variavel de processo
		MOV  TH1,  #0FFh      ; Recarrega para estourar a cada 1 pulso
		MOV  TL1,  #0FFh
		SETB TR1              ; Reinicia a contagem

		RET

ATUALIZA_VOLTAS:

     MOV  DPTR, #segmentos; Aponta DPTR para o ínicio da tabela.
		MOV  A, R0; Valor de R0(número de voltas) vai para o acumulador 
		MOVC A, @A+DPTR; Busca na memória o segmento desejado 
		MOV C, F0; Move F0 para o carry a fi       
		MOV  ACC.7, C; Joga o valor de F0 para o bit 7 do acumulador 
		MOV  P1, A;o bit 7 do acumulador agora se torna o bit 7 de P1 que é o ponto decimal, se F0 = 0 -> ponto apagado, se F0 = 1 -> ponto aceso

     RET

VERIFICA_CHAVE:

     MOV  C, P2.0; o carry recebe o estado atual da chave          
		JB   F0, MANTEM; se F0 = 1, precisamos testar se a chave mudou pra 0, se F0 = 0 muda só se a chave tiver em 1 (C = 1)
		JNC  FIM_VERIFICA; P2.0 = 0 -> sem mudança
		SJMP MUDOU


MANTEM:
; F0=1: mudou somente se P2.0=0 (C=0)
		JC   FIM_VERIFICA; P2.0=1 -> sem mudanca     

MUDOU:

     CPL  F0                ; Inverte sentido
		CPL  P3.0
		CPL  P3.1
		
		ACALL RESET_CONTADOR   

FIM_VERIFICA:

    	RET

LOOP_TIMER:

     PUSH ACC               ; Salva contexto
		INC  R0                ; Incrementa variavel de processo
		MOV  A, R0
		CJNE A, #10, FIM_LOOP  ; Comparação da variavel com 10
		ACALL RESET_CONTADOR   ; Se chegou aqui é porque chegou em 10, logo deve zerar R0 e reiniciar a contagem

FIM_LOOP:

     POP  ACC; Acumulador volta a ter o valor que tinha antes da interrupção
		RETI

END