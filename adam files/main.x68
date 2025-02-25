; this file contains the main game loop

init:
    ; Enable the screen back buffer(see easy 68k help)
	MOVE.B  #tcdbl,D0          ; 92 Enables Double Buffer
    MOVE.B  #17,        D1          ; Combine Tasks
	TRAP	#15                     ; Trap (Perform action)
	
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
    move.b #1, enemyDir
    jsr enemySetUp
    jsr initEnemy
    jsr initDraw

    move.b #$ff, isWaveOver

	bra loop

loop:
    ;jsr clearscreen
    jsr draw
    jsr testinput
    
    ; test paused
    tst.b isPaused
    bne paused

    ; process
    jsr increment
    jsr processEnemy
    jsr enemyColCheck
    jsr collision

    bra endLoop
endLoop:
    ;move #$300, d5
    ;jsr wasteTime
    tst currentHealth
    bne end
    bra loop        ; loop

collision:
    jsr zone1collision
    jsr zone2collision
    jsr zone3collision
    rts

paused:
    lea pauseMsg, a1
    jsr print
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

    ; OPTIONS (can input even if paused)
    cmpi.b #spacekey, currentkey
    beq spacepressed
    cmpi.b #escapekey, currentkey
    beq escapepressed
    
    ; test paused (cannot input if paused)
    tst.b isPaused
    bne endInput

    ; TEST - take damage
    cmpi.b #enterKey, currentKey
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

    rts

endInput:
    rts

; INPUTS
spacepressed:
    move.b lastkey, d5
    cmp.b currentKey, d5
    bne spaceJustPressed
    ;jsr takeDmg
    rts

escapepressed:
    bra end

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
    sub.l enemyDamage, d1
    move.l d1, currentHealth
    rts

; INPUTS SPECIAL

; runs if space is pressed this frame, but not prev frame
spaceJustPressed:

    move.b isPaused, d5
    not.b d5
    move.b d5, isPaused
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

isWaveOver dc.b 0

screenW        DS.w    01  ; Reserve Space for Screen Width
screenH        DS.w    01  ; Reserve Space for Screen Height


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
