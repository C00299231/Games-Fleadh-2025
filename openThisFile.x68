; this file starts the program.
; contains the title screen, includes all other files

	org $1000
start:
    
    jsr loadAllSounds

    bra nextInit
    
nextInit:
    ; song
    jsr stop_song
    jsr MENU_SONG_LOAD
    jsr play_song

    move.b  #0,enemiesToDefeat
    lea     hillHPArray,a1
    move.l  #$64646464, (a1)
    ;move.b  #100,(a1)+
    ;move.b  #100,(a1)+
    ;move.b  #100,(a1)+
    ;move.b  #100,(a1)+
    clr.l   perfectDefenceAmount
    clr.l   totalKills
    move.b  #5,antsRemaining
    move.B  #0,totalHillsDefended

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
    
    move.w #$07, d1
    jsr setCursor
    ;lea titleArt, a1
    jsr printArt
    
    ; draw ants
    move.l #100, player_x
    move.l #100, player_y
    
    move.w #$1a11, d1
    jsr setCursor
    lea title2msg, a1
    jsr print
    
    
    bra titleLoop
    
titleLoop:
     ; get back buffer0
    ;MOVE.B  #94,        D0
    ;TRAP    #15
    
    jsr testInput
    
    bra titleLoop


title1Msg dc.b '- ANT-TOPIA -',0

title2msg dc.b 'Press "enter/(A)" to start...',0

; include other files 
 include "difficultySelect.x68"
 include "map/main.x68"
 include "map/shapeSizes.x68"
 include "map/trapCodes.x68"
 include "map/inputKeyCodes.x68"
 include "map/colours2.x68"
 include "map/cell.x68"
 include "map/draw.x68"
 include "map/enemies.x68"
 include "map/timings.x68"
 include "map/enemyManager.x68"
 include "map/camera.x68"
 include "map/input.x68"

 include "battle/battleView.x68"
 include "battle/soundFiles.x68"
 
 include "score.x68"
 include "asciiArt.x68"

	end start






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
