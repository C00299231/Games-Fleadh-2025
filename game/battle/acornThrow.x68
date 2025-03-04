*-----------------------------------------------------------
* Title      : throw attack  
* Written by : Oliwier Jakubiec
* Date       : 05/02/2025
* Description: all things related to thrown attack
*-----------------------------------------------------------

; define constants
THRW_W_INIT EQU         15          ; Throws initial Width
THRW_H_INIT EQU         15          ; Throws initial Height
; hitbox
THROW_HEIGHT        EQU     20
THROW_WIDTH         EQU     35 

THRW_DFLT_V EQU         00          ; Default throw Velocity
THRW_JUMP_V EQU         -16          ; throw arc Velocity
THRW_DFLT_G EQU         01          ; throw Default Gravity

; initialise throw data
initThrow:
    ; Initialise throw Velocity
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.B  #THRW_DFLT_V,D1              ; Init throw Velocity
    MOVE.L  D1,         THROW_VELOCITY

    ; Initialise Throw Gravity
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  #THRW_DFLT_G,D1                 ; Init Throw Gravity
    MOVE.L  D1,         THROW_GRAVITY

    ; set x and y off screen
    MOVE.L  #-100,      THROW_X
    MOVE.L  #-100,      THROW_Y

    ; clr if the acorn is being thrown
    MOVE.B  #00,        CURRENTLYTHROWING

    rts


* Move the acorn each frame
MOVE_THROW:
    ; if not currently throwing then skip
    tst.b CURRENTLYTHROWING
    if <EQ> then 
        rts
    endi
    ; Update the Throws Positon based on Velocity and Gravity
    EOR.L   D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  THROW_VELOCITY, D1       ; Fetch Throw Velocity
    MOVE.L  THROW_GRAVITY, D2        ; Fetch Throw Gravity
    ADD.L   D2,         D1          ; Add Gravity to Velocity
    MOVE.L  D1,         THROW_VELOCITY ; Update Throw Velocity
    ADD.L   THROW_Y,   D1          ; Add Velocity to Throw
    MOVE.L  D1,         THROW_Y    ; Update Throws Y Position

    ; move acorn forward
    ADDI.L   #4,        THROW_X
    BSR     CHECK_THROW_DONE
    
    RTS

; check if the acorn has fallen far enough to reset
CHECK_THROW_DONE:
    CMP.L    #350, THROW_Y
    BGT      RESET_THROW        ; go to reset
    RTS

; resets the acorn 
RESET_THROW:
    ; set currently throwing to false
    MOVE.B   #00, CURRENTLYTHROWING
    ; reset acorn pos
    MOVE.L   #-100, THROW_X
    MOVE.L   #-100, THROW_Y

    ; reset achievement value
    move.b #0, achAcornDoubleCount
    RTS

; perform the throwing of the acorn
PERFORM_THROW:
    ; skip if paused
    TST.B  isPaused
    IF <NE> THEN
        RTS
    ENDI
    ; if acorn is still thrown then skip
    TST.B    CURRENTLYTHROWING
    BNE      CONTINUE
    
    ; set thrown to true
    MOVE.B   #01,CURRENTLYTHROWING
    ; set the beginning x and y to the players current x and y
    MOVE.L   PLAYER_X,THROW_X
    ADDI.L   #PLYR_W_INIT,THROW_X
    MOVE.L   PLAYER_Y,THROW_Y
    SUBI.L   #PLYR_H_INIT,THROW_Y

    ; perform the jump of the acorn
    BSR     PERFORM_THROW_ARC
    RTS

*-----------------------------------------------------------
* Subroutine    : Throw
* Description   : Perform a Throw
*-----------------------------------------------------------
THROW_ARC:
    CMP.L   #GND_TRUE,PLYR_ON_GND   ; Throw is on the Ground ?
    BEQ     PERFORM_THROW_ARC       ; Do throw
    BRA     ARC_DONE                ;
PERFORM_THROW_ARC:
    MOVE.L  #THRW_JUMP_V,THROW_VELOCITY ; Set the Throws velocity to true
    RTS                             ; Return to subroutine
ARC_DONE:
    RTS                             ; Return to subroutine


*-----------------------------------------------------------
* Subroutine    : draw Throw
* Description   : draw the Throw acorn
*-----------------------------------------------------------
DRAW_THROW:

    ; Set Pixel Colors
    MOVE.L  #ACORN,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    ; Reset Pixel Colors
    MOVE.L  #ACORN,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

* ---- draw main acorn shell ----*
    MOVE.L  THROW_X,   D1          ; X
    MOVE.L  THROW_Y,   D2
    MOVE.L  d1,   D3
    ADD.L   #THRW_W_INIT,   D3      ; Width
    MOVE.L  d2,   D4 
    SUB.L   #THRW_H_INIT,   D4      ; Height          ; Y
    
    ; Draw Acorn
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)

* ---- draw main acorn hat ----* 
    ; Set Pixel Colors
    MOVE.L  #ACORNHAT,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    ; Reset Pixel Colors
    MOVE.L  #ACORNHAT,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  THROW_X,D1
    SUB.L   #2,D1
    ADD.l   #2,D3
    ADD.L   #1,D4
    MOVE.L  D4,D2
    SUB.L   #6,D2

    ; Draw Acorn
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  THROW_X,D1
    ADD.L   #6,D1
    MOVE.L  D2,D4
    SUB.l   #5,D2
    MOVE.L  D1,D3
    ADD.L   #4,D3

    ; Draw Acorn
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)

    RTS                             ; Return to subroutine

*--- throw variables
CURRENTLYTHROWING   DC.B    00
THROW_COOLDOWN      DC.W    00
THROW_TIME          DC.W    00
THROW_X             DC.L    00
THROW_Y             DC.L    00
THROW_VELOCITY      DS.L    01  
THROW_GRAVITY       DS.L    01  