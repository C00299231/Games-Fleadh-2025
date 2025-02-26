lvlType dc.w 0

; types:
; 0: menu
; 1: map
; 2: run

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
    
    jsr commonInput ; happens in any level


    TST.w lvlType
    IF <EQ> THEN
        BSR menuInput ; happens in menu
    endi
    cmp.w #1, lvlType
    IF <EQ> THEN
        BSR mapInput ; happens in map
    endi
    cmp.w #2, lvlType
    IF <EQ> THEN
        BSR battleInput ; happens in run
    ENDI
    
    rts             ; return to loop

noinput:
    ; go back to loop
    move.b #0, currentKey
    move.b #0, lastkey
    rts

inputType dc.w 1

commonInput:
    ; at this point, keycode in currentkey is pressed

    ; OPTIONS
    cmpi.b #escapeKey, currentkey ; pause
    beq escapepressed
    cmpi.b #key0, currentKey ; fullscreen
    beq key0pressed

    tst.b isPaused
    bne pausedInput
    RTS

menuInput:
    cmpi.b #enterKey, currentKey
    beq mapInit
    rts

mapinput:
    ; at this point, keycode in currentkey is pressed

    ; map buttons
    cmpi.b #zKey, currentKey
    beq zPressed

    ; only move player if correct time
    move.w playerTime, d5
    jsr checkIncrement
    bne endInput

    ; only when not paused

    cmpi.b #enterKey, currentKey
    beq collision

    ; movement input
    bsr mapMoveInput

    ;cmpi.b #wkey, currentkey ; W:UP
    ;beq wpressed
    ;cmpi.b #akey, currentkey ; A:LEFT
    ;beq apressed
    ;cmpi.b #skey, currentkey ; S:DOWN
    ;beq spressed
    ;cmpi.b #dkey, currentkey ; D:RIGHT
    ;beq dpressed
    RTS

mapMoveInput:
    move.l #wasdKeys, d1
    move.b #tcinp, d0
    trap #15

    BTST.L  #24,D1
    IF <NE> THEN
        BSR    wPressed
    ENDI

    ;MOVE.L  CURRENT_KEY, D1
    BTST.L  #16,D1
    IF <NE> THEN
        BSR    aPressed
    ENDI

    ;MOVE.L  CURRENT_KEY, D1
    BTST.L  #8,D1
    IF <NE> THEN
        BSR    sPressed
    ENDI

    ;MOVE.L  CURRENT_KEY, D1
    BTST.L  #0,D1
    IF <NE> THEN
        BSR    dPressed
    ENDI

    rts

pausedInput:
    cmpi.b #key1, currentkey
    beq key1pressed

    cmpi.b #key2, currentkey
    beq key2pressed

    ;cmpi.b #key3, currentkey
    ;beq key3pressed

    rts

endInput:
    rts

; INPUTS
escapePressed:
    move.b lastkey, d5
    cmp.b currentKey, d5
    bne escapeJustPressed
    rts
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

zPressed:
    move.b lastkey, d5
    cmp.b currentKey, d5
    bne toggleFollow ; z just pressed
    rts

key1pressed: ; quit
    jsr togglePause
    bra end
key2pressed: ; main menu
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
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
