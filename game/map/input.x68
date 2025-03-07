lvlType dc.w 0

; types:
; 0: menu
; 1: map
; 2: run

testinput:
    ; getting previous key
    move.l currentkey, lastkey

    cmp.w #1, lvlType
    IF <EQ> THEN
        BSR mapMoveInput ; happens in map
    endi
    

    ; set d1 to $0000 0000
    clr.l d1

    ; put "get input" code into d0
    move.b #tcinp, d0
    trap #15
    clr.l d2
    move.b d1, d2
    move.l d2, currentkey
    trap #15
    
    ; AT THIS POINT, CURRENT KEY CONTAINS THE CURRENT/LAST KEY PRESSED,
    ; AND D1 CONTAINS WHETHER OR NOT IT IS STILL PRESSED

    ; test if no input
    cmpi.b #0, d1
    beq noinput     ; if no input, move to noinput

    ;jsr printKeyCode

    ; bring currentKey into d2, lastKey into d3
    move.l currentKey, d2
    move.l lastKey, d3

    jsr commonInput ; happens in game and menu

    TST.w lvlType
    IF <EQ> THEN
        BSR menuInput ; happens in menu
        rts
    endi

    jsr notMenuInput

    cmp.w #1, lvlType
    IF <EQ> THEN
        BSR mapInput ; happens in map
        rts
    endi
    cmp.w #2, lvlType
    IF <EQ> THEN
        BSR battleInput ; happens in run
        rts
    ENDI
    cmp.w #3, lvlType
    IF <EQ> THEN
        BSR diffInput ; happens in diff selection
    ENDI

    
    rts             ; return to loop

noinput:
    ; go back to loop
    move.l #0, currentKey
    move.l #0, lastkey
    rts

inputType dc.w 1

commonInput:
    ; at this point, keycode in currentkey is pressed

    cmpi.l #key0, currentKey ; fullscreen
    beq key0pressed
    rts

notMenuInput:
    ; OPTIONS
    cmpi.l #escapeKey, currentKey ; pause
    beq escapepressed

    tst.b isPaused
    bne pausedInput
    RTS

menuInput:
    ; at this point, whatever keycode is in currentkey is pressed

    cmpi.l #enterKey, currentkey
    if <ne> then
        rts
    endi

    ; here, currentkey is enterKey

    cmpi.l #enterkey, lastkey
    if <eq> then
        rts
    endi

    ; from here, enterKey is just pressed
    bra move2difficulty
diffInput:
    cmpi.l #Dkey, currentkey
    beq   rightSelected
    cmpi.l #Akey, currentkey
    beq   leftSelected

    cmpi.l #enterKey, currentkey
    beq    enterPressed
    ; key is enterKey

    rts

mapinput:
    ; at this point, keycode in currentkey is pressed

    ; map buttons
    cmpi.l #zKey, currentkey
    beq zPressed

    cmpi.l #pKey, currentKey
    beq testKeyPressed

    ; only when not paused

    cmpi.l #enterKey, currentkey
    beq collision

    ; movement input
    ;bsr mapMoveInput

    RTS

mapMoveInput:
    move.l #wasdKeys, d1
    move.b #tcinp, d0
    trap #15

    BTST.L  #24,D1
    IF <NE> THEN
        BSR    wPressed
    ENDI

    BTST.L  #16,D1
    IF <NE> THEN
        BSR    aPressed
    ENDI

    BTST.L  #8,D1
    IF <NE> THEN
        BSR    sPressed
    ENDI

    BTST.L  #0,D1
    IF <NE> THEN
        BSR    dPressed
    ENDI

    rts

pausedInput:
    cmpi.l #key1, currentkey
    beq key1pressed

    cmpi.l #key2, currentkey
    beq key2pressed

    rts

endInput:
    rts

; INPUTS
escapePressed:
    move.l currentKey, d2
    cmp.l lastKey, d2
    bne escapeJustPressed
    rts
escapeJustPressed:
    jsr togglePause
    rts

testKeyPressed:
    rts

enterPressed:
    move.l currentKey, d2
    cmp.l lastKey, d2
    bne enterJustPressed
    rts
enterJustPressed:
    jsr checkDifSelected
    rts

rightSelected:
    move.l currentKey, d2
    cmp.l lastKey, d2
    bne rightJustPressed
    rts
rightJustPressed:
    cmp.b #2, selectedIndex
    IF <LT> THEN
        addi.b #1, selectedIndex
    ENDI
    rts

leftSelected:
    move.l currentKey, d2
    cmp.l lastKey, d2
    bne leftJustPressed
    rts
leftJustPressed:
    cmp.b #0, selectedIndex
    IF <GT> THEN
        subi.b #1, selectedIndex
    ENDI
    rts

key0pressed:
    move.l currentKey, d2
    cmp.l lastKey, d2
    bne key0justPressed
    rts
key0justPressed:
    jsr toggleFullScreen
    rts

zPressed:
    move.l currentKey, d2
    cmp.l lastKey, d2
    bne toggleFollow ; z just pressed
    rts

key2pressed: ; quit
    jsr togglePause
    bra end
key1pressed: ; main menu
    jsr togglePause
    jsr clearscreen
    jsr disableDoubleBuffer
    bra nextInit

; MOVEMENT INPUT: MUST STAY WITHIN CELL BOUNDARIES
wpressed:
    move.l playerY, d3 ; check boundary with proposed movement
    sub.l #playerYspeed, D3
    cmp.l celltlY, d3
    ble endMovement

    sub.l #playerYspeed, playerY
    rts
apressed:
    move.l playerX, d3 ; check boundary with proposed movement
    sub.l #playerXspeed, D3
    cmp.l celltlX, d3
    ble endMovement

    sub.l #playerXspeed, playerX
    rts
spressed:
    move.l playerY, d3 ; check boundary with proposed movement
    add.l #playerYspeed, D3
    add.l #playerH, d3 ; player size taken into consideration
    cmp.l cellBrY, d3
    bge endMovement

    add.l #playerYspeed, playerY
    rts
dpressed:
    move.l playerX, d3 ; check boundary with proposed movement
    add.l #playerXspeed, D3
    add.l #playerW, d3 ; player size taken into consideration
    cmp.l cellBrX, d3
    bge endMovement

    add.l #playerXspeed, playerX
    rts

endMovement:
    rts

playerXspeed equ 3
playerYspeed equ 2

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
