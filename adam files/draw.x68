; this file contains all draw functions

initDraw:
    ; get health rectangle bounds

    ;HEIGHT
    move.w screenH, d1
    sub.l #120, d1
    move.l d1, healthTlY
    add.l #15, d1
    move.l d1, healthBrY

    ;WIDTH
    move.l centerX, d1
    ;move.l maxHealth, d2
    ;divu #2, d2
    sub.l maxHealth, d1
    move.l d1, healthTlX

    add.l maxhealth, d1
    move.l d1, healthBrX
    
    rts


draw:
     ; Enable back buffer
    MOVE.B  #94,        D0
    TRAP    #15

    jsr drawBg
    jsr drawCell
    jsr drawPlayer
    jsr drawEnemy
    jsr drawText
    jsr drawHealth
    rts

drawHealth:
    move.l #color3, d1
    jsr setPenColour
    move.l #color2, d1
    jsr setFillColour

    move.l healthTlX, d1
    move.l healthTlY, d2

    move.l healthBrX, d3
    move.l healthBrY, d4
    jsr drawRect

    ; DRAW FULL PART OF HP BAR
    move.l healthtlX, d3
    add.l currentHealth, d3

    move.l #color3, d1 ; change colour
    jsr setFillColour

    move.l healthTlX, d1 ; set value in d1 back to what its supposed to be
    jsr drawRect
    rts

drawText:
    ; set fill colour
    move.l #color1, d1
    jsr setFillColour
    ; PLAYER SCORE MSG
    move.w #$0201, d1
    jsr setCursor
    lea pointsMsg, a1
    jsr print
    ; PLAYER SCORE
    move.l #$e01, d1
    jsr setCursor
    move.l currentPts, d1
    jsr printNum

    ; HEALTH
    move.w #$0718, d1
    jsr setCursor
    lea healthMsg, a1
    jsr print


    ; reset cursor
    move.l #0, d1
    jsr setCursor
    rts

drawBg:
    ; set colours
    move.l #color2, d1
    jsr setPenColour
    move.l #color1, d1
    jsr setFillColour

    ; clear d3 and d4 (screen W and H are words)
    clr.l d3
    clr.l d4

    ; put the stuff in the registers, draw rect
    move.l #0, d1
    move.l #0, d2
    move.w screenW, d3
    move.w screenH, d4
    jsr drawRect
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

drawEnemy:
    tst.b enemyActive
    beq endDraw
    ; set colour
    move.l #color5, d1
    jsr setPenColour
    move.l #colorRed, d1
    jsr setFillColour

    ; set rect values
    move.l enemyX, d1
    move.l enemyY, d2
    move.l enemyX, d3
    move.l enemyY, d4
    add.l #enemyW, d3
    add.l #enemyH, d4

    jsr drawRect
    rts

drawCell:
    ;---------------draw main cell
    ; change colours
    move.l #color4, d1
    jsr setPenColour
    move.l #color2, d1
    jsr setFillColour

    move.l celltlX, d1
    move.l celltlY, d2
    move.l cellbrX, d3
    move.l cellbrY, d4
    jsr drawRect

    ;---------------draw zone 1
    ; change colours
    move.l #color4, d1
    jsr setPenColour
    move.l #color3, d1
    jsr setFillColour

    move.l zone1tlX, d1
    move.l zone1tlY, d2
    move.l zone1brX, d3
    move.l zone1brY, d4
    jsr drawRect

    ;---------------draw zone 2
    move.l zone2tlX, d1
    move.l zone2tlY, d2
    move.l zone2brX, d3
    move.l zone2brY, d4
    jsr drawRect
    

    ;---------------draw zone 3
    ; change colours
    move.l #color4, d1
    jsr setFillColour

    move.l zone3tlX, d1
    move.l zone3tlY, d2
    move.l zone3brX, d3
    move.l zone3brY, d4
    jsr drawRect

    ; done
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

print:
    move #13, d0
    trap #15
    rts

printNum:
    move #3, d0
    trap #15
    rts

drawRect:
    MOVE.B  #tcRect, d0
    TRAP    #15
    rts

setCursor:
    MOVE.B  #tcCrs, d0
    TRAP    #15
    rts

; INSTANT NEW LINE
crlf:
    move #6, d0
    move #13, d1
    trap #15
    move #10, d1
    trap #15
    rts

pauseMsg dc.b 'GAME PAUSED', 0
endMsg dc.b 'GAME OVER', 0
pointsMsg dc.b 'POINTS:', 0
healthMsg dc.b 'HEALTH:', 0

healthTlX ds.l 01
healthTlY ds.l 01
healthBrX ds.l 01
healthBrY ds.l 01

currentHpX ds.l 01

healthBarOffset dc.b 200



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
