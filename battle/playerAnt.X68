
*--------------------- Player Inits ------------------*
PLYR_W_INIT EQU         27          ; Players initial Width
PLYR_H_INIT EQU         13          ; Players initial Height

PLYR_DFLT_V EQU         00          ; Default Player Velocity
PLYR_JUMP_V EQU         -19          ; Player Jump Velocity
PLYR_DFLT_G EQU         01          ; Player Default Gravity

INIT_PLAYER:

    ; Place the Player at the center of the screen
    EOR.L    D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on X Axis
    MOVE.L  D1,         PLAYER_X    ; Players X Position

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         PLAYER_Y    ; Players Y Position

        ; Set the player starting width and height
    MOVE.B  #PLYR_W_INIT,        PLAYER_WIDTH ; Players Width
    MOVE.B  #PLYR_H_INIT,        PLAYER_HEIGHT ; Players Width

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         PLAYER_Y    ; Players Y Position

    ; Initialise Player Velocity
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.B  #PLYR_DFLT_V,D1         ; Init Player Velocity
    MOVE.L  D1,         PLYR_VELOCITY

    ; Initialise Player Gravity
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  #PLYR_DFLT_G,D1         ; Init Player Gravity
    MOVE.L  D1,         PLYR_GRAVITY

        ; Initialize Player on Ground
    MOVE.L  #GND_TRUE,  PLYR_ON_GND ; Init Player on Ground
    

UPDATE_PLAYER:
    ; Update the Players Positon based on Velocity and Gravity
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  PLYR_VELOCITY, D1       ; Fetch Player Velocity
    MOVE.L  PLYR_GRAVITY, D2        ; Fetch Player Gravity
    ADD.L   D2,         D1          ; Add Gravity to Velocity
    MOVE.L  D1,         PLYR_VELOCITY ; Update Player Velocity
    ADD.L   PLAYER_Y,   D1          ; Add Velocity to Player
    MOVE.L  D1,         PLAYER_Y    ; Update Players Y Position
    MOVE.L  D1,         ATTACK_Y 

    RTS

; Move Player to the left
MOVE_PLAYER_LEFT:
    TST.B  isPaused
    IF <NE> THEN
        RTS
    ENDI

    MOVE.B  #LOOKLEFT,        PLAYER_DIR
    MOVE.L  PLAYER_X,   D1          ; Fetch Player X Position
    SUB.L   #02,        D1          ; Move Player Left
    MOVE.L  D1,         PLAYER_X    ; Update Players X Position
    SUB.L   #02,        ATTACK_X
    RTS                             ; Return to subroutine    

; Move Player to the right
MOVE_PLAYER_RIGHT:
    TST.B  isPaused
    IF <NE> THEN
        RTS
    ENDI
    MOVE.B  #LOOKRIGHT,        PLAYER_DIR
    MOVE.L  PLAYER_X,   D1          ; Fetch Player X Position
    ADD.L   #02,        D1          ; Move Player Right
    MOVE.L  D1,         PLAYER_X    ; Update Players X Position
    ADD.L   #02,        ATTACK_X
    RTS                             ; Return to subroutine

; draw all player relevant data
DRAW_PLAYER:
    ; Set Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    ; Reset Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw body -----------------*
    MOVE.L  PLAYER_X,   D1          ; X
    MOVE.L  PLAYER_Y,   D2
    SUBQ.L  #4,D2

    MOVE.L  PLAYER_X,   D3
    EOR.L   D4,D4
    MOVE.B   PLAYER_WIDTH,   D4      ; Width
    ADD.L   D4,D3
    MOVE.L  PLAYER_Y,   D4
    SUB.B   PLAYER_HEIGHT,   D4      ; Height          ; Y
    
     ; Draw Player
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw abdomen -----------------*
    MOVE.L  PLAYER_X,   D1          ; X
    MOVE.L  PLAYER_Y,   D2
    SUBQ.L  #4,D2
    MOVE.L  PLAYER_X,   D3
    EOR.L   D4,D4
    MOVE.B   PLAYER_WIDTH,   D4      ; Width
    SUBI.B   #12,D4
    ADD.L   D4,D3
    MOVE.L  PLAYER_Y,   D4
    SUB.B   PLAYER_HEIGHT,   D4      ; Height
    SUB.B   #3,D4
    
    ; Draw Player
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw antena -----------------*    
    ; change thickness
    MOVE.l  #3,D1
    MOVE.B  #93,D0
    TRAP    #15

    MOVE.L  PLAYER_X,D1
    ADD.L   #22,D1
    MOVE.L  PLAYER_Y,D2
    SUB.L   #PLYR_H_INIT,D2
    MOVE.L  D1,D3
    ADD.L   #10,D3
    MOVE.L  D2,D4
    SUBI.L  #7,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw leg 1 -----------------*
    MOVE.L  PLAYER_X,D1
    MOVE.L  PLAYER_Y,D2
    MOVE.L  D1,D3
    ADD.L   #4,D3
    MOVE.L  D2,D4
    SUBI.L  #4,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw leg 2 -----------------*
    MOVE.L  PLAYER_X,D1
    ADD.L   #13,D1
    MOVE.L  PLAYER_Y,D2
    MOVE.L  D1,D3
    MOVE.L  D2,D4
    SUBI.L  #4,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw leg 3 -----------------*
    MOVE.L  PLAYER_X,D1
    ADD.L   #22,D1
    MOVE.L  PLAYER_Y,D4
    MOVE.L  D1,D3
    ADD.L   #3,D3
    MOVE.L  D4,D2
    SUBI.L  #4,D2

    MOVE.B  #84,D0
    TRAP    #15

    ; Set Pixel Colors
    MOVE.L  #WHITE,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw eye -----------------*
    MOVE.L  PLAYER_X,D1
    ADD.L   #22,D1
    MOVE.L  PLAYER_Y,D2
    SUB.L   #10,D2
    MOVE.L  D1,D3
    MOVE.L  D2,D4

    MOVE.B  #84,D0
    TRAP    #15

    MOVE.l  #1,D1
    MOVE.B  #93,D0
    TRAP    #15
    
    BSR     IS_ATTACKING
    BSR     IS_THROWING

    RTS                             ; Return to subroutine

IS_ATTACKING:
    TST.B   CURRENTLYATTACKING
    BNE     DRAW_ATTACK
    RTS
DRAW_ATTACK:

    ; Set Pixel Colors
    MOVE.L  #WHITE,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    ; Reset Pixel Colors
    MOVE.L  #WHITE,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  ATTACK_X,   D1          ; X
    MOVE.L  ATTACK_Y,   D2
    
    MOVE.L  ATTACK_X,   D3
    ADD.L   #ATTACK_WIDTH,   D3      ; Width
    MOVE.L  ATTACK_Y,   D4 
    SUB.L   #ATTACK_HEIGHT,   D4      ; Height          ; Y
    
    ; Draw Player
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

IS_THROWING:
    TST.B   CURRENTLYTHROWING
    BNE     DRAW_THROW
    RTS
DRAW_THROW:

    ; Set Pixel Colors
    MOVE.L  #ACORN,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    ; Reset Pixel Colors
    MOVE.L  #ACORN,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  THROW_X,   D1          ; X
    MOVE.L  THROW_Y,   D2
    
    MOVE.L  THROW_X,   D3
    ADD.L   #THRW_W_INIT,   D3      ; Width
    MOVE.L  THROW_Y,   D4 
    SUB.L   #THRW_H_INIT,   D4      ; Height          ; Y
    
    ; Draw Acorn
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)
    
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

*-----------------DRAW respawn -----------------------------*
DRAW_RESPAWN:
    MOVEQ.L     #0,  D5
    MOVE.W      respawnTime,D5

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         PLAYER_Y    ; Players Y Position

MOVE_RESPAWNED:
    MOVE.L  D5, PLAYER_X

    ; Enable back buffer
    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15

    ; Clear the screen
    MOVE.B	#TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W	#$FF00,     D1          ; Clear contents
    TRAP    #15                     ; Trap (Perform action)

    MOVE.B  #1,D1
    MOVE.B  #93,D0
    TRAP    #15

    BSR     DRAW_BACKGROUND        
    BSR     DRAW_HILL 
    BSR     DRAW_PLYR_DATA          ; Draw Draw Score, HUD, Player X and Y
    BSR     DRAW_PLAYER             ; Draw Player
    BSR     DRAW_ENEMY              ; Draw Enemy
    BSR     DRAW_FLYENEMY
    BSR     DRAW_HEALTHPACK
    BSR     DRAW_FLOOR              ; Draw Floor
    BSR     drawPause        


    ADDQ.W      #1,respawnTime
    MOVE.W      respawnTime,D5
    CMP.W       #200,respawnTime
    BNE         MOVE_RESPAWNED
    MOVE.W     #0,respawnTime
    ;else
    RTS
