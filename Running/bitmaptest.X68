    ORG    $1000

START:

    MOVE.L  #17,D1
    MOVE.L  #92,D0
    TRAP    #15

    MOVE.L  #50,D0
    TRAP    #15
    LEA     title,A1
    MOVE.L  #51,D0
    TRAP    #15
    
    LEA     SPRITE_DATA,A1
    MOVE.L  #1974,D2
    MOVE.L  #53,D0
    TRAP #15
    
LOOP:
  
    MOVE.W #11, D0         ; Clear the screen
    MOVE.W #$FF00,D1
    TRAP #15              ; Call graphics clear

    LEA SPRITE_DATA, A3   ; Load address of sprite data
    MOVE.W  WIDTH,D3
    ADD.W   Z,D3
    BSR     RESETTREE
    MOVE.W  D3,X
    MOVE.W  #400,Y
    
    MOVE.L  #50,D0
    TRAP    #15
    
    ADDA.L      #$33,A3
DRAW_SPRITE:
    MOVE.W #0, D5         ; Row counter
    
ROW_LOOP:
    MOVE.W #0, D7         ; Column counter

COL_LOOP:

    EOR.L		d6,d6				* clear the longword
	MOVE.b	(a3)+,d6			* get the blue byte
	SWAP		d6				* move it to the high word
	MOVE.b	(a3)+,d6			* get the green byte
	ROL.w		#8,d6				* move it to the high byte
	MOVE.b	(a3)+,d6			* get the red byte

    
    CMP.L #0, D6           ; Test bit in the byte
    BEQ SKIP_PIXEL        ; If 0, skip drawing pixel

    MOVE.L  D6, D1
    MOVE.L  #80,D0
    TRAP #15
    
    MOVE.L  D6, D1
    MOVE.L  #81,D0
    TRAP #15

    CLR.L   D1
    MOVE.W X, D1         ; X position
    MOVE.W Y, D2         ; Y position
    MOVE.W X, D3         ; X position
    ADD.W  SCALER ,D3
    MOVE.W Y, D4         ; Y position
    SUB.W  SCALER ,D4
    
    MOVE.L  #87,D0
    TRAP #15              ; Plot pixel using TRAP #15

SKIP_PIXEL:
    MOVE.W SCALER,D2
    ADD.W D2, X         ; Move to the next pixel column
    ADDQ.W #1, D7
    ADDQ.W #4, D5
    CMP.W #ROWC, D7
    BLT COL_LOOP          ; Continue to draw row

    MOVE.W  D2,D3
    MULU.W  #ROWC,D3
    MOVE.W  D3,WIDTH
    NEG.W   WIDTH
    
    SUB.W D3, X         ; Reset X position for the next row
    SUB.W D2, Y         ; Move down to the next row
  
    CMP.W #2400, D5
    BLT ROW_LOOP          ; Continue to the next row

END_LOOP:
    MOVE.L  #94,D0
    TRAP    #15
    ADDQ.W  #2,Z
    BRA START                    ; Infinite loop to keep the display on
    
RESETTREE:
    CMP.W   #640,D3
    BGE     RESETZ
    RTS
RESETZ:
    MOVE.W  #0, Z
    ADD.W   #1, I
    MOVE.W  I,D2
    BSR     CHECKI
    RTS
CHECKI:
    CMP     #2,D2
    BGE     ADDSCALER
    RTS    
ADDSCALER:
    MOVE.W  SCALER,D4
    ADD.W   #1,D4
    MOVE.W  D4,SCALER
    RTS
    
X   DC.W    -80
Y   DC.W    400
Z   DC.W    0
I   DC.W    0
ROWC    EQU    16
COLC    EQU    8
SCALER DC.W  5
WIDTH   DC.W    $FFB0

title
	dc.b	'tree2.bmp',0
list
	dc.b	'*.bmp',0				* file type list
	ds.w	0					* ensure even


SPRITE_DATA:



    END START





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
