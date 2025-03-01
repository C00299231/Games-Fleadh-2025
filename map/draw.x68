; this file contains all draw functions



initDraw:
    ; get health rectangle bounds

    ;HEIGHT
    move.w healthBarLocY, d1
    move.l d1, healthTlY
    add.l #15, d1
    move.l d1, healthBrY

    ;WIDTH
    clr.l d1
    move.w healthBarOffsetX, d1
    ;move.l maxHealth, d2
    ;divu #2, d2
    ;add.l maxHealth, d1
    move.l d1, healthTlX

    add.l maxhealth, d1
    move.l d1, healthBrX
    
    rts

getBackBuffer:
    ; retrieve back buffer
    MOVE.B  #94,        D0
    TRAP    #15
    rts

enableDoubleBuffer:
    ; Enable the screen back buffer(see easy 68k help)
	MOVE.B  #tcdbl,D0          ; 92 Enables Double Buffer
    MOVE.B  #17,        D1          ; Combine Tasks
	TRAP	#15                     ; Trap (Perform action)
    rts

disableDoubleBuffer:
    ; Enable the screen back buffer(see easy 68k help)
	MOVE.B  #tcdbl,D0          ; 92 Enables Double Buffer
    MOVE.B  #16,        D1          ; Combine Tasks
	TRAP	#15                     ; Trap (Perform action)
    rts

draw:
    jsr getBackBuffer

    jsr followCam
    jsr drawBg
    jsr drawEnemyHill
    jsr drawEnemies
    jsr drawEnemyDoor
    jsr drawCell
    
    jsr drawPlayer
    jsr drawText
    ;jsr drawHealth
    jsr drawPause
    rts

drawPause:
    tst.b isPaused
    beq endDrawPause

    move.l #color5, d1
    jsr setPenColour
    move.l #color1, d1
    jsr setFillColour

    ; make sure font is current
    move.l #color5, d1
    eor.l d2,d2                 ;clear d2 for no font styling 
    jsr setFontColour
    ; get rect bounds

    move.l centerX, d1
    move.l centerY, d2
    sub.l pauseHalfWidth, d1
    sub.l pauseHalfHeight, d2

    move.l centerX, d3
    move.l centerY, d4
    add.l pauseHalfWidth, d3
    add.l pauseHalfHeight, d4

    jsr drawUiRect

    ; draw text
    move.w #$2208, d1
    jsr setCursor
    lea pauseMsg, a1
    jsr print

    ; draw options
    move.w #$1c0c, d1
    jsr setCursor
    lea pauseOption1Msg, a1
    jsr print
    add.w #$2, d1
    jsr setCursor
    lea pauseOption2Msg, a1
    jsr print

    rts
endDrawPause:
    rts

drawHealth:
    move.l #color4, d1
    jsr setPenColour
    move.l #color2, d1
    jsr setFillColour

    move.l healthTlX, d1
    move.l healthTlY, d2

    move.l healthBrX, d3
    move.l healthBrY, d4
    jsr drawUiRect

    ; DRAW FULL PART OF HP BAR
    move.l healthtlX, d3
    add.l currentHealth, d3

    move.l #color3, d1 ; change colour
    jsr setFillColour

    move.l healthTlX, d1 ; set value in d1 back to what its supposed to be
    jsr drawUiRect
    rts

drawText:
    ; set colours
    move.l #color5, d1
    jsr setPenColour
    move.l #DEEPGREEN, d1
    jsr setFillColour


    ;ANTS REMAINING
    move.w #$200, d1
    add.b pointsRow, d1
    jsr setCursor
    lea antsRemainingMsg, a1
    CLR.L D1
    move.b antsRemaining, d1
    jsr printWithNum

    ; ANTHILL
    move.w #$101b, d1
    jsr setCursor
    lea attackMsg1, a1
    jsr print
    add.w #1, d1
    jsr setCursor
    lea attackMsg2, a1
    jsr print


    ; reset cursor
    move.l #0, d1
    jsr setCursor
    rts

drawBg:
    ; set colours
    move.l #brown, d1
    jsr setPenColour
    move.l #DEEPGREEN, d1
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
    rts

drawPlayer:
    ; Set white
    MOVE.L #color5, d1
    jsr setPenColour
    move.l #color1, d1
    jsr setFillColour
    
    ; Set X, Y, Width and Height
    MOVE.L  playerX,   D1          ; X
    MOVE.L  playerY,   D2          ; Y
    MOVE.L  playerX,   D3
    ADD.L   #playerW,   D3      ; Width
    MOVE.L  playerY,   D4 
    ADD.L   #playerH,   D4      ; Height
    
    ; Draw Player
    jsr drawRect
    RTS

drawEnemies:
    jsr setRedEnemy

    jsr getEnemy1
    jsr drawEnemy

    jsr setBlueEnemy

    jsr getEnemy2
    jsr drawEnemy

    jsr setRedEnemy

    jsr getEnemy3
    jsr drawEnemy

    jsr setBlueEnemy

    jsr getEnemy4
    jsr drawEnemy

setRedEnemy:
    ; set colour
    move.l #red, d1
    jsr setPenColour
    move.l #red, d1
    jsr setFillColour
    rts

setBlueEnemy:
    ; set colour
    move.l #blue, d1
    jsr setPenColour
    move.l #blue, d1
    jsr setFillColour
    rts

drawEnemy:
    

    ; set rect values
    jsr prepareEnemyDraw
    add.l #enemyW, d3
    add.l #enemyH, d4

    jsr drawRect

    jsr prepareEnemyDraw
    

    ; DRAW LINES

    ; left lines
    sub.l #3, d3
    sub.l #7, d4
    jsr drawLine

    add.l #5, D2
    sub.l #3, d3
    add.l #12, d4
    jsr drawLine

    add.l #7, D2
    add.l #3, d3
    add.l #14, d4
    jsr drawLine

    ; prepare for right lines
    jsr prepareEnemyDraw
    add.l #enemyW, d1
    add.l #enemyW, d3

    ; right lines
    add.l #3, d3
    sub.l #7, d4
    jsr drawLine

    add.l #5, D2
    add.l #3, d3
    add.l #12, d4
    jsr drawLine

    add.l #7, D2
    sub.l #3, d3
    add.l #14, d4
    jsr drawLine


    rts

prepareEnemyDraw:
    move.l enemyX, d1
    move.l enemyY, d2
    move.l enemyX, d3
    move.l enemyY, d4
    rts

drawCell:
    ;---------------draw main cell
    ; change colours
    move.l #green, d1
    jsr setPenColour
    move.l #green, d1
    jsr setFillColour

    move.l celltlX, d1
    move.l celltlY, d2
    move.l cellbrX, d3
    move.l cellbrY, d4
    jsr drawRect

    ;---------------draw zone 1
    ; change colours
    move.l zone1pen, d1
    jsr setPenColour
    
    move.l zone1tlX, d1
    move.l zone1tlY, d2
    move.l zone1brX, d3
    move.l zone1brY, d4
    jsr drawAntHill
    
    ;---------------draw zone 2
    ; change colours
    move.l zone2pen, d1
    jsr setPenColour

    move.l zone2tlX, d1
    move.l zone2tlY, d2
    move.l zone2brX, d3
    move.l zone2brY, d4
    jsr drawAntHill
    
    ;---------------draw zone 3
    ; change colours
    move.l zone3pen, d1
    jsr setPenColour

    move.l zone3tlX, d1
    move.l zone3tlY, d2
    move.l zone3brX, d3
    move.l zone3brY, d4
    jsr drawAntHill

    ;---------------draw zone 4
    ; change colours
    move.l zone4pen, d1
    jsr setPenColour

    move.l zone4tlX, d1
    move.l zone4tlY, d2
    move.l zone4brX, d3
    move.l zone4brY, d4
    jsr drawAntHill

    ; done
    RTS

drawEnemyHill:
    move.l #brown, d1
    jsr setPenColour
    move.l #dirt, d1
    jsr setFillColour
    ; base: top middle
    move.l centerX, d1
    move.l #0, d2
    move.l centerX, d3
    move.l #0, d4

    ; box 1
    sub.l #90, d1
    add.l #90, d3
    add.l #30, d4
    jsr drawRect
    
    ; box 2
    add.l #20, d1
    sub.l #20, d3
    add.l #30, d4
    jsr drawRect

    ; save d1
    move.l d1, d5
    move.l #dirt, d1
    jsr setPenColour
    move.l #brown, d1
    jsr setFillColour
    move.l d5, d1

    ; door opening (cover drawn later)
    
    add.l #50, d1
    sub.l #50, d3
    jsr drawRect
    rts

drawEnemyDoor:
    move.l #dirt, d1
    jsr setPenColour
    move.l #dirt, d1
    jsr setFillColour

    ; base: top middle
    move.l centerX, d1
    move.l #0, d2
    move.l centerX, d3
    move.l #0, d4

    ; edit
    sub.l #20, d1
    add.l #20, d3
    add.l #30, d4
    jsr drawRect
    rts

drawAntHill: ; d1 thru 4 are already assigned


    ; store d1
    move.l d1, d5

    move.l #dirt, d1
    jsr setFillColour

    move.l d5, d1
    
    jsr drawRect
    add #5, D1
    sub #2, D2
    sub #5, D3
    sub #12, D4
    jsr drawRect
    
    add #5, D1
    sub #2, D2
    sub #5, D3
    sub #12, D4
    jsr drawRect
    
    add #5, D1
    sub #2, D2
    sub #5, D3
    sub #12, D4
    jsr drawRect

    ; store d1
    move.l d1, d5
    move.l #brown, d1
    jsr setFillColour

    move.l d5, d1
    add #7, D1
    add #3, D2
    sub #7, D3
    sub #5, D4
    jsr drawRect
    
    rts


endDraw:
    rts

setPenColour:
    move.b #tcPenClr, d0
    trap #15
    rts

setFillColour:
    move.b #tcPenFil, d0
    trap #15
    rts

setFontColour:
    move.b #tcFont, d0
    trap #15
    rts

print:
    move #13, d0
    trap #15
    rts

printWithNum:
    move #14, d0
    trap #15
    jsr printNum
    jsr crlf
    rts

printNum:
    move #3, d0
    trap #15
    rts

drawLine:
    ; if not follow, draw like normal
    tst.w isFollow
    beq drawUiLine

    ; offset by camera
    sub.l cameraX, d1
    sub.l cameraY, d2
    sub.l cameraX, d3
    sub.l cameraY, d4
    ; zoom by camera
    mulu cameraZoom, d1
    mulu cameraZoom, d2
    mulu cameraZoom, d3
    mulu cameraZoom, d4

    move.b #tcline, d0
    trap #15

    ; UN-zoom by camera
    divu cameraZoom, d1
    divu cameraZoom, d2
    divu cameraZoom, d3
    divu cameraZoom, d4
    ; UN-offset by camera
    add.l cameraX, d1
    add.l cameraY, d2
    add.l cameraX, d3
    add.l cameraY, d4
    rts

drawUiLine:
    move.b #tcLine, d0
    trap #15
    rts

drawRect:
    ; if not follow, draw like normal
    tst.w isFollow
    beq drawUiRect

    ; offset by camera
    sub.l cameraX, d1
    sub.l cameraY, d2
    sub.l cameraX, d3
    sub.l cameraY, d4
    ; zoom by camera
    mulu cameraZoom, d1
    mulu cameraZoom, d2
    mulu cameraZoom, d3
    mulu cameraZoom, d4

    move.b #tcRect, d0
    trap #15

    ; UN-zoom by camera
    divu cameraZoom, d1
    divu cameraZoom, d2
    divu cameraZoom, d3
    divu cameraZoom, d4
    ; UN-offset by camera
    add.l cameraX, d1
    add.l cameraY, d2
    add.l cameraX, d3
    add.l cameraY, d4
    rts

drawUiRect:
    MOVE.B  #tcRect, d0
    TRAP    #15
    rts

setCursor:
    MOVE.B  #tcCrs, d0
    TRAP    #15
    rts

toggleFullScreen:
    clr.l d1
    move.w isFullScreen, d1
    cmpi.b #1, d1
    beq goFullScreen

    ; go windowed
    move.l #1, d1
    jsr setFullScreen

    bra endToggleFullScreen
goFullScreen:
    add.b #1, d1
    jsr setFullScreen
    bra endToggleFullScreen
endToggleFullScreen:
    move.w d1, isFullScreen

setFullScreen:
    move #tcFullScreen, d0
    trap #15
    rts

; INSTANT NEW LINE
crlf:
    move #6, d0
    move #13, d1
    trap #15
    move #10, d1
    trap #15
    rts

isFullScreen dc.w 1

endMsg dc.b 'GAME OVER', 0
antsRemainingMsg dc.b 'ANTS REMAINING: ', 0
healthMsg dc.b 'HEALTH:', 0

healthTlX ds.l 01
healthTlY ds.l 01
healthBrX ds.l 01
healthBrY ds.l 01

currentHpX ds.l 01

; health stuff
healthBarOffsetX dc.w 80
healthBarLocY dc.w 16

healthRow dc.b 01
pointsRow dc.b 03

; pause stuff
pauseHalfWidth dc.l 110
pauseHalfHeight dc.l 130
pauseMsg dc.b 'GAME PAUSED!', 0
pauseOption2Msg dc.b '[2] main menu',0
pauseOption1Msg dc.b '[1] exit game',0

; move to level stuff
attackMsg1 dc.b 'AN ANTHILL IS UNDER ATTACK!',0
attackMsg2 dc.b 'MOVE TOWARD IT AND PRESS "ENTER" TO DEFEND IT!',0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
