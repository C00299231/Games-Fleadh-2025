; this file contains the main game loop

init:
    
	
	    ; Place the Player at the center of the screen
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  screenW,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on X Axis
    MOVE.L  D1,         playerX    ; Players X Position
    move.l d1, centerx

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  screenH,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         playerY    ; Players Y Position
    move.l d1, centerY

    jsr initializeCell
    ;move.w #1, enemyDir
    jsr initDraw
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
    jsr collision
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

testinput:
    ; getting previous key
    move.b currentkey, lastkey

    ; set d1 to $0000 0000
    move.l #0, d1

    ; put "get input" code into d0
    move.b #tcinp, d0
    trap #15
    move.b d1, currentkey
    trap #15
    
    ; AT THIS POINT, CURRENT KEY CONTAINS THE CURRENT/LAST KEY PRESSED,
    ; AND D1 CONTAINS WHETHER OR NOT IT IS STILL PRESSED
    
    ; test if no input
    cmpi.b #0, d1
    beq noinput     ; if no input, move to noinput
    
    jsr yesinput    ; if input, go to yesinput
    jsr endinput    ; then, go to endinput
    
    rts             ; return to loop

noinput:
    ; go back to loop
    move.b #0, currentKey
    move.b #0, lastkey
    rts

yesinput:
    ; at this point, keycode in currentkey is pressed

    cmpi.b #escapeKey, currentkey
    beq escapepressed
    cmpi.b #key0, currentKey
    beq key0pressed
    
    ; test paused (pause has different inputs)
    tst.b isPaused
    bne pausedInput

    ; TEST - take damage
    cmpi.b #zKey, currentKey
    beq zPressed
    ;beq takeDmg

    ; normal movement buttons [check timer first]
    move.w playerTime, d5
    jsr checkIncrement
    bne endInput

    cmpi.b #wkey, currentkey ; W:UP
    beq wpressed
    cmpi.b #akey, currentkey ; A:LEFT
    beq apressed
    cmpi.b #skey, currentkey ; S:DOWN
    beq spressed
    cmpi.b #dkey, currentkey ; D:RIGHT
    beq dpressed

    RTS

pausedInput:
    cmpi.b #key1, currentkey
    beq key1pressed

    cmpi.b #key2, currentkey
    beq key2pressed

    cmpi.b #key3, currentkey
    beq key3pressed

    rts

endInput:
    rts

; INPUTS
escapePressed:
    move.b lastkey, d5
    cmp.b currentKey, d5
    bne escapeJustPressed
    rts
; runs if escape is pressed this frame, but not prev frame
escapeJustPressed:
    jsr togglePause
    rts

key0pressed:
    move.b lastkey, d5
    cmp.b currentKey, d5
    bne key0justPressed
    rts
key0justPressed:
    jsr toggleFullScreen
    rts

togglePause:
    move.b isPaused, d5
    not.b d5
    move.b d5, isPaused
    rts


zPressed:
    move.b lastkey, d5
    cmp.b currentKey, d5
    bne toggleFollow ; z just pressed
    rts

key1pressed: ; restart
    jsr togglePause
    bra init
key2pressed: ; quit
    jsr togglePause
    bra end
key3pressed: ; main menu
    jsr togglePause
    jsr clearscreen
    bra start

; MOVEMENT INPUT: MUST STAY WITHIN CELL BOUNDARIES
wpressed:
    move.l playerY, d3 ; check boundary with proposed movement
    sub.l #1, D3
    cmp.l celltlY, d3
    beq endMovement

    sub.l #1, playerY
    rts
apressed:
    move.l playerX, d3 ; check boundary with proposed movement
    sub.l #1, D3
    cmp.l celltlX, d3
    beq endMovement

    sub.l #1, playerX
    rts
spressed:
    move.l playerY, d3 ; check boundary with proposed movement
    add.l #1, D3
    add.l #playerH, d3 ; player size taken into consideration
    cmp.l cellBrY, d3
    beq endMovement

    add.l #1, playerY
    rts
dpressed:
    move.l playerX, d3 ; check boundary with proposed movement
    add.l #1, D3
    add.l #playerW, d3 ; player size taken into consideration
    cmp.l cellBrX, d3
    beq endMovement

    add.l #1, playerX
    rts

endMovement:
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


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
