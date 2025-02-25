; this file starts the program.
; contains the title screen, includes all other files

	org $1000
start:
    bra firstInit

firstInit:
    MOVE.B  #tcScreen, D0           ; access screen information
    MOVE.L  #tcScreenSize, D1       ; placing 0 in D1 triggers loading screen size information
    TRAP    #15                     ; interpret D0 and D1 for screen size
    MOVE.W  D1,         screenH     ; place screen height in memory location
    SWAP    D1                      ; Swap top and bottom word to retrive screen size
    MOVE.W  D1,         screenW     ; place screen width in memory location
    
	move.b #$00, isPaused
	
	move #tcFont, d0
    move.l #color5, d1
    trap #15
	
	bra title

title:
    jsr drawBg
    
    move.w #$1f0d, d1
    jsr setCursor
    lea titlemsg, a1
    jsr print
    
    move.w #$1c0f, d1
    jsr setCursor
    lea title2msg, a1
    jsr print
    
    
    bra titleLoop
    
titleLoop:
    
    
    ; put "get input" code into d0
    move.l #enterKey, d1
    move.b #tcinp, d0
    trap #15
    
    tst.b d1
    bne init
    bra titleLoop


titleMsg dc.b '- CELL DEFENDER -',0

title2msg dc.b 'Press "enter" to start...',0

; include other files 
 include "main.x68"
 include "shapeSizes.x68"
 include "trapCodes.x68"
 include "inputKeyCodes.x68"
 include "colours.x68"
 include "cell.x68"
 include "draw.x68"
 include "enemies.x68"
 include "timings.x68"

	end start



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
