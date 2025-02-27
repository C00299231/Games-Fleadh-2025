; this file starts the program.
; contains the title screen, includes all other files

	org $1000
start:
    bra firstInit

firstInit:
    ; Enable the screen back buffer(see easy 68k help)
	MOVE.B  #tcdbl,D0          ; 92 Enables Double Buffer
    MOVE.B  #17,        D1          ; Combine Tasks
	TRAP	#15                     ; Trap (Perform action)
	
    bra nextInit
    
nextInit:
    ; song
    jsr stop_song
    jsr MENU_SONG_LOAD
    jsr play_song

	move.w #0, lvlType
    
    MOVE.B  #tcScreen, D0           ; access screen information
    MOVE.L  #tcScreenSize, D1       ; placing 0 in D1 triggers loading screen size information
    TRAP    #15                      ; interpret D0 and D1 for screen size
    MOVE.W  D1,         screenH     ; place screen height in memory location
    SWAP    D1                      ; Swap top and bottom word to retrive screen size
    MOVE.W  D1,         screenW     ; place screen width in memory location
    
	move.b #$00, isPaused

   
	
	clr.l d2
	move #tcFont, d0
    move.l #color5, d1
    trap #15
	
	bra title

title:
    jsr drawBg
    
    move.w #$220d, d1
    jsr setCursor
    lea title1msg, a1
    jsr print
    
    move.w #$1c0f, d1
    jsr setCursor
    lea title2msg, a1
    jsr print
    
    
    bra titleLoop
    
titleLoop:
     ; Enable back buffer
    MOVE.B  #94,        D0
    TRAP    #15
    
    jsr testInput
    
    bra titleLoop


title1Msg dc.b '- ANTOPIA -',0

title2msg dc.b 'Press "enter" to start...',0

; include other files 
 include "map/main.x68"
 include "map/shapeSizes.x68"
 include "map/trapCodes.x68"
 include "map/inputKeyCodes.x68"
 include "map/colours.x68"
 include "map/cell.x68"
 include "map/draw.x68"
 include "map/enemies.x68"
 include "map/timings.x68"
 include "map/enemyManager.x68"
 include "map/camera.x68"
 include "map/input.x68"

 include "battle/battleView.x68"
 
 include "score.x68"

	end start



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
