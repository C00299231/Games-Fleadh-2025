; this file starts the program.
; contains the title screen, includes all other files

	org $1000
start:
    jsr loadAllSounds
    move.b  #50, d0
    trap       #15
    bra nextInit
    
nextInit:
    ; resetBackground
    move.l #320, titleBgStartPos

    ; song
    jsr stop_song
    jsr MENU_SONG_LOAD
    jsr play_song

    ; reset achievements
    jsr resetAchievements

    ; reset values 
    move.b  #0,enemiesToDefeat
    lea     hillHPArray,a1
    move.l  #$64646464, (a1)
    clr.l   perfectDefenceAmount
    clr.l   totalKills
    move.b  #5,     antsRemaining
    move.B  #0,     totalHillsDefended
    move.b  #3,     firstWaveTutAmt
	move.w  #0,     lvlType
    move.b  #$FF,   tutorialMeleeTimer
    move.b  #$FF,   tutorialThrowTimer
    move.b  #0,     showThrowMSG
    
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
    jsr drawTitleBg
    
    ; change colours
    clr.l d2
    move.l #deepgreen, d1
    jsr setFontColour
    move.l #sky, d1
    jsr setFillColour

    ; print messages
    move.w #$07, d1
    jsr setCursor
    jsr printArt
    
    move.w #$1a11, d1
    jsr setCursor
    lea title2msg, a1
    jsr print
    
    clr.l d2
    move.l #color5, d1
    jsr setFontColour
    move.l #deepgreen, d1
    jsr setFillColour

    ; move the cursor to the bottom
    move.w #$1f1E,D1
    jsr setCursor
    bsr getHighScore    ; branch to get the highscore
    move.l  highscore,d1    ; load the new highscore into d1
    lea highscoremsg, a1    ; load the message and then print
    jsr printWithNum

    bra titleLoop
    
titleLoop:    
    jsr testInput       ; test for input
    
    bra titleLoop       ; branch back to loop

move2difficulty:
    jsr enableDoubleBuffer
    lea titleBgStartPos, a2

move2difficultyLoop: ; make the screen go down
    jsr getBackBuffer

    sub.l #3, (a2)

    jsr drawTitleBg
    
    move.l #1, d3
    jsr newDelay

    cmp.l #$FFFFFFD8, (a2)
    ble DIFFICULTY_SELECT

    bra move2difficultyLoop


drawTitleBg:
    ;----------------------SKY
    ; set colours
    move.l #sky, d1
    jsr setPenColour
    move.l #sky, d1
    jsr setFillColour

    ; clear d3 and d4 (screen W and H are words)
    clr.l d3
    clr.l d4

    ; put the stuff in the registers, draw rect
    move.l #0, d1
    move.l #0, d2
    move.w screenW, d3
    move.w screenH, d4
    jsr drawUiRect

    ;----------------------GRASS
    ; set colours
    move.l #green, d1
    jsr setPenColour
    move.l #green, d1
    jsr setFillColour

    ; put the stuff in the registers, draw rect
    move.l #0, d1
    move.l titleBgStartPos, d2
    jsr drawUiRect

    ;----------------------DIRT
    ; set colours
    move.l #deepgreen, d1
    jsr setPenColour
    move.l #deepgreen, d1
    jsr setFillColour

    ; put the stuff in the registers, draw rect
    move.l #0, d1
    add.l #40, d2
    jsr drawUiRect
    rts

getHighScore:

    ;open the file
    move.b  #51,d0
    lea     txt,a1      ; load the file into a1
    trap    #15         
    move.l  d1,fileId   ; save the id of the file
    
    ; read the file
    move.l  fileId,d1       ; get the file id
    move.b  #53,d0  
    lea     highscoreFile,a1        ; load the memory address that the file points to.
    move.b  #4,d2                   ; load the amount of bytes to read, 
    trap    #15                     ;  so 4 bytes for 1 long of score.
    
    move.l  (a1),highscore          ; move the score from the file into highscore to display it
    
    rts


title1Msg dc.b '- ANT-TOPIA -',0

title2msg dc.b 'Press "enter/(A)" to start...',0

highscoremsg dc.w 'Highscore: ',0

highscore   dc.l   0
txt     dc.b        'highscore.txt',0
fileId  dc.l        0
highscoreFile   dc.l    0

titleBgStartPos dc.l 320

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
 include "battle/acornThrow.x68"
 include "battle/drawHUD.x68"
 
 include "score.x68"
 include "asciiArt.x68"
 include "achievements.x68"

	end start
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
