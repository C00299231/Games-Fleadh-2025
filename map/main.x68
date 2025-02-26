; this file contains the map game loop, and some other stuff

; first init for map
mapInit:
    move.w #1, lvlType
    move.w #0, lvlIndex
	
	    ; Place the Player at the center of the screen
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  screenW,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on X Axis
    MOVE.L  D1,         playerX    ; Players X Position
    move.l d1, centerx

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  screenH,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    move.l d1, centerY
    ;add.l cellYoffset, d1
    MOVE.L  D1,         playerY    ; Players Y Position
    

    

    jsr initializeCell
    jsr initDraw
    jsr initAllEnemies

	bra loop

; subsequent inits for map
mapNotFirstInit:
    move.w #1, lvlType
    add.w #1, lvlIndex
    move.l centerX, playerX
    move.l centerY, playerY
    ;add.l cellYoffset, playerY

    jsr initAllEnemies

    bra loop

loop:
    ;jsr clearscreen
    jsr map ; if in map, do map stuff
    ; if in battle, do battle stuff

    bra endLoop
endLoop:
    tst currentHealth
    bne end
    bra loop        ; loop

map:
    jsr draw
    jsr testinput
    
    ; test paused
    tst.b isPaused
    bne paused

    ; process
    jsr increment
    jsr processEnemies
    ;jsr enemyColCheck
    ;jsr collision
    rts

battle:
    rts

collision:
    jsr zone1collision
    jsr zone2collision
    jsr zone3collision
    jsr zone4collision
    rts

paused:
    bra endLoop
    
clearscreen:
	; Clear the screen
    MOVE.B	#tccrs,D0          ; Set Cursor Position
	MOVE.W	#$FF00,     D1          ; Clear contents
	TRAP    #15
	rts

wasteTime:
    ; value put into d5, keep subtracting 1 until d5 contains 0
    ; takes a lot of time to process
    sub #1, d5
    cmp #0, d5
    bne wasteTime
    rts

togglePause:
    move.b isPaused, d5
    not.b d5
    move.b d5, isPaused
    rts


; heal up by one hp
heal:
    move.l currentHealth, d2
    cmp.l maxHealth, d2
    beq endHeal
    add.l #1, d2
    move.l d2, currentHealth
    bra endHeal
endHeal:
    rts

takeDmg:
    move.l currentHealth, d1
    sub.l #1, d1
    move.l d1, currentHealth
    rts

; runs if game is cut short w/ ESC key
end:
    jsr clearscreen
    
    lea endmsg, a1
    jsr print
	simhalt

testMsg dc.b 'test',0


inputkeys dc.b 20,87,65,83,68,0

currentkey ds.l 01
lastkey ds.l 01
isPaused ds.b 01

playerX ds.l 01
playerY ds.l 01

centerX ds.l 01
centerY ds.l 01

currentPts dc.l 0

currentHealth dc.l 200
maxHealth dc.l 200

screenW        DS.w    01  ; Reserve Space for Screen Width
screenH        DS.w    01  ; Reserve Space for Screen Height

lvlIndex dc.w 0






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
