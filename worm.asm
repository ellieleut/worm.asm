;
;Ellie Leutenegger ECE109 001 04/10/2023
;This program allows the user to control a worm around the display screen
;using multiple key commands. The user can also control the color of the line and the
;color of the worm changes every 5 moves. If enter is pressed, the screen is cleared.
;If q is pressed, the program quits. 
;

	.ORIG x3000 
	
		;clear registers
START		AND R0, R0, #0	
			AND R1, R1, #0
			AND R2, R2, #0
			AND R3, R3, #0
			AND R4, R4, #0
			AND R5, R5, #0
			AND R6, R6, #0
			
	;obtain a character from user to determine placement and color
			LD R5, CENTER
			LD R1, WHICOLOR
COMMAND		GETC
				
			LD R6, w			;Check if w		
    		ADD R6, R6, R0		;Add the negated number to input
  				BRz UP		      	;Branch if the result is zero
			LD R6, a			;Check if a	
    		ADD R6, R6, R0		
  				BRz LEFT	      	
			LD R6, s			;Check if s	
    		ADD R6, R6, R0		
  				BRz DOWN	      		
			LD R6, d			;Check if d	
    		ADD R6, R6, R0		
  				BRz RIGHT	      				
					LD R6, r			;Check if red		
    				ADD R6, R6, R0		
  						BRz RED		      	
					LD R6, g			;Check if green	
    				ADD R6, R6, R0		
  						BRz GREEN	      		
					LD R6, b			;Check if blue
    				ADD R6, R6, R0		
  						BRz BLUE	      		
					LD R6, y			;Check if yellow
    				ADD R6, R6, R0		
  						BRz YELLOW	      	
					LD R6, space		;Check if space for white
    				ADD R6, R6, R0		
  						BRz WHITE	      				
			LD R6, enter		;Check if enter for clear the screen
    		ADD R6, R6, R0		
  				BRz CLEAR	      				
			LD R6, q			;Check if q
    		ADD R6, R6, R0		
  				BRz QUIT	      				
  					BR COMMAND
	
UP			LD R6, NEG512
			ADD R5, R5, R6	
			JSR PAINT
			JSR COLCOUNT
			JSR CHECKy
				BR COMMAND			
LEFT		ADD R5, R5, #-4		
			JSR PAINT
			JSR COLCOUNT
			JSR CHECKx
				BR COMMAND
DOWN		LD R6, POS512
			ADD R5, R5, R6	
			JSR PAINT
			JSR COLCOUNT
			JSR CHECKy
				BR COMMAND
RIGHT		ADD R5, R5, #4					
			JSR PAINT
			JSR COLCOUNT
			JSR CHECKx
				BR COMMAND
	RED			LD R1, REDCOLOR
				JSR PAINT
					BR COMMAND
	GREEN		LD R1, GRECOLOR
				JSR PAINT
					BR COMMAND
	BLUE		LD R1, BLUCOLOR
				JSR PAINT
					BR COMMAND
	YELLOW		LD R1, YELCOLOR
				JSR PAINT
					BR COMMAND
	WHITE		LD R1, WHICOLOR
				JSR PAINT
					BR COMMAND

CLEAR			JSR CLEARSCN	
				BR START
QUIT		HALT
ERROR		LEA R0, PROMPT		;load R0 with address of quit string
			PUTS				;print to console		
				HALT
				BR COMMAND

	;prompts
PROMPT 	.STRINGZ	"WORMS CAN'T LEAVE!\n"

	;commands
w		.FILL	#-119
a		.FILL	#-97
s		.FILL	#-115
d		.FILL	#-100
r		.FILL	#-114
g		.FILL	#-103
b		.FILL	#-98
y		.FILL	#-121
space	.FILL	#-32
enter	.FILL	#-10
q		.FILL	#-113

	;colors
WHICOLOR .FILL	x7FFF
BLACOLOR .FILL	x0000
REDCOLOR .FILL	x7C00
GRECOLOR .FILL	x03E0
BLUCOLOR .FILL	x001F
YELCOLOR .FILL	x7FED
	
	;numbers
NEGONE	.FILL	#-1
ONE		.FILL	#1
NEGFOUR	.FILL	#-4
FOUR	.FILL	#4
NEG5	.FILL	#-5
NEG10	.FILL	#-10
POS15	.FILL	#15
NEG15	.FILL	#-15
POS16	.FILL	#16
NEG16	.FILL	#-16
NEG20	.FILL	#-20
NEG25	.FILL	#-25
NEG30	.FILL	#-30
ROWSKIP	.FILL	#124
NEG128	.FILL	#-128
POS128	.FILL	#128
NEG512	.FILL	#-512
POS512	.FILL	#512

	;coordinates
CENTER	.FILL	xDF40
CURCORD	.FILL	xDF40	;R5
TOPLEFT	.FILL	xC000
BOTLEFT	.FILL	xFD00
TOTPIX	.FILL 	x3DFF
		
		;JSR for painting (1)
PAINT			ST R0, SAVER0
				ST R1, SAVER1
				ST R2, SAVER3
				ST R3, SAVER3
				ST R4, SAVER4
				ST R5, SAVER5
				ST R6, SAVER6
				ST R7, SAVER7
			LD R6, FOUR
	VERT	LD R3, FOUR
	HORI		
			STR R1, R5, #0		;store pixel color into the coordinate
			ADD R5, R5, #1		
			ADD R3, R3, #-1		;subtracts one from the pointer counter
			BRnp HORI			;if counter is not depleted, keep going
			
			LD R2, ROWSKIP
			ADD R5, R5, R2
			ADD R6, R6, #-1
			BRp VERT
				LD R0, SAVER0
				LD R1, SAVER1
				LD R2, SAVER2
				LD R3, SAVER3
				LD R4, SAVER4
				LD R5, SAVER5
				LD R6, SAVER6
				LD R7, SAVER7		
			RET
		;JSR for clear screen (2)
CLEARSCN		ST R0, SAVER0
				ST R1, SAVER1
				ST R2, SAVER3
				ST R3, SAVER3
				ST R4, SAVER4
				ST R5, SAVER5
				ST R6, SAVER6
				ST R7, SAVER7
			LD R1, BLACOLOR
			LD R5, TOPLEFT
			LD R3, TOTPIX	
LOOPC		STR R1, R5, #0		;store black
			ADD R5, R5, #1		;start at top left
			ADD R3, R3, #-1		;subtracts one from the pointer counter for entire screen
			BRnp LOOPC			;if counter is not depleted, keep going
				LD R0, SAVER0
				LD R1, SAVER1
				LD R2, SAVER2
				LD R3, SAVER3
				LD R4, SAVER4
				LD R5, SAVER5
				LD R6, SAVER6
				LD R7, SAVER7
			RET
		;JSR for checking x coordinate (3)				
CHECKx		LD R6, a			;Check if a	
    		ADD R6, R6, R0		
  				BRz SUBx			;if left is pressed, subtract one from the counter
			ADD R3, R3, #1			;otherwise, add one to the counter
				BR CHECK1
SUBx		ADD R3, R3, #-1
CHECK1		LD R6, POS16			;if the counter has -16 (left x limit) go to
			ADD R6, R6, R3			;worms can't leave message
			BRz ERROR
			LD R6, NEG15			;if the counter has -15 (right x limit) go to
			ADD R6, R6, R3			;worms can't leave message
			BRz ERROR
			RET						;otherwise good to go: return back
		;JSR for checking x coordinate (4)				
CHECKy		LD R6, s			;Check if s
    		ADD R6, R6, R0		
  				BRz SUBy
			ADD R4, R4, #1
				BR CHECK2
SUBy		ADD R4, R4, #-1
CHECK2		LD R6, POS15
			ADD R6, R6, R4
			BRz ERROR
			LD R6, NEG16
			ADD R6, R6, R4
			BRz ERROR		
			RET	
			;JSR for color change (5) 
COLCOUNT		;LD R2, SAVER2
;COLCHANGE		ADD R2, R2, #1
			LD R6, NEG5
			ADD R6, R6, R2
				BRz RED
			LD R6, NEG10
			ADD R6, R6, R2
				BRz GREEN
			;LD R6, NEG15
			;ADD R6, R6, R2
				;BRz BLUE	
			;LD R6, NEG20
			;ADD R6, R6, R2
				;BRz YELLOW
			;LD R6, NEG25
			;ADD R6, R6, R2
				;BRz WHITE
			;LD R6, NEG30
			;ADD R6, R6, R2
				;BRz RESTART
;RESTART		;AND R2, R2, #0
				;BR COLCHANGE
				;ST R2, SAVER2
			RET
;memory for JSR
	SAVER0	.FILL	x00
	SAVER1	.FILL	x00
	SAVER2	.FILL	x00
	SAVER3	.FILL	x00
	SAVER4	.FILL	x00
	SAVER5	.FILL	x00
	SAVER6	.FILL	x00
	SAVER7	.FILL	x00
	
.END