
*--------------------- Player Inits ------------------*
PLYR_W_INIT EQU         27          ; Players initial Width
PLYR_H_INIT EQU         13          ; Players initial Height

PLYR_DFLT_V EQU         00          ; Default Player Velocity
PLYR_JUMP_V EQU         -18          ; Player Jump Velocity
PLYR_DFLT_G EQU         01          ; Player Default Gravity

GND_TRUE    EQU         01          ; Player on Ground True
GND_FALSE   EQU         00          ; Player on Ground False

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
    MOVE.L  PLAYER_X,   D1          ; Fetch Player X Position
    SUB.L   #03,        D1          ; Move Player Left
    MOVE.L  D1,         PLAYER_X    ; Update Players X Position
    SUB.L   #03,        ATTACK_X
    RTS                             ; Return to subroutine    

; Move Player to the right
MOVE_PLAYER_RIGHT:
    TST.B  isPaused
    IF <NE> THEN
        RTS
    ENDI
    MOVE.L  PLAYER_X,   D1          ; Fetch Player X Position
    ADD.L   #03,        D1          ; Move Player Right
    MOVE.L  D1,         PLAYER_X    ; Update Players X Position
    ADD.L   #03,        ATTACK_X
    RTS                             ; Return to subroutine

*-----------------------------------------------------------
* Subroutine    : Jump
* Description   : Perform a Jump
*-----------------------------------------------------------
JUMP:
    TST.B  isPaused
    IF <NE> THEN
        RTS
    ENDI
    CMP.L   #GND_TRUE,PLYR_ON_GND   ; Player is on the Ground ?
    BEQ     PERFORM_JUMP            ; Do Jump
    BRA     JUMP_DONE               ;
PERFORM_JUMP:
    BSR     PLAY_JUMP               ; Play jump sound
    MOVE.L  #PLYR_JUMP_V,PLYR_VELOCITY ; Set the players velocity to true
    RTS                             ; Return to subroutine
JUMP_DONE:
    RTS                             ; Return to subroutine

*-----------------------------------------------------------
* Subroutine    : Player is on Ground
* Description   : Check if the Player is on or off Ground
*-----------------------------------------------------------
IS_PLAYER_ON_GND:
    ; Check if Player is on Ground
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    CLR.L   D2                      ; Clear contents of D2 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1  
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  PLAYER_Y,   D2          ; Player Y Position
    CMP     D1,         D2          ; Compare middle of Screen with Players Y Position 
    BGE     SET_ON_GROUND           ; The Player is on the Ground Plane
    BLT     SET_OFF_GROUND          ; The Player is off the Ground
    RTS                             ; Return to subroutine


*-----------------------------------------------------------
* Subroutine    : On Ground
* Description   : Set the Player On Ground
*-----------------------------------------------------------
SET_ON_GROUND:
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         PLAYER_Y    ; Reset the Player Y Position
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  #00,        D1          ; Player Velocity
    MOVE.L  D1,         PLYR_VELOCITY ; Set Player Velocity
    MOVE.L  #GND_TRUE,  PLYR_ON_GND ; Player is on Ground
    RTS

*-----------------------------------------------------------
* Subroutine    : Off Ground
* Description   : Set the Player Off Ground
*-----------------------------------------------------------
SET_OFF_GROUND:
    MOVE.L  #GND_FALSE, PLYR_ON_GND ; Player if off Ground
    RTS                             ; Return to subroutine

; draw all player relevant data
DRAW_PLAYER:
    ; load x and y into a1 and a2 for quick access
    LEA     PLAYER_X,   A1
    LEA     PLAYER_Y,   A2
        
    ; check to show melee msg
    tst.b   tutorialMeleeTimer
    IF <NE> THEN
        ; sub 1 from the timer
        subi.b #1, tutorialMeleeTimer
        
        ; Set Pixel Colors
        MOVE.L  #WHITE,     D1          ; Set Background color
        MOVE.B  #81,        D0          ; Task for Background Color
        TRAP    #15                     ; Trap (Perform action)

        ; print the message above the player
        MOVE.L  (a1),   D1          ; X
        MOVE.L  (a2),   D2 
        sub.l #85, d1
        sub.l #60, d2
        lea     tutorialMeleeMSG,a1
        move.b  #95, d0
        trap    #15
    ENDI  

    ; check to show melee msg
    tst.b  showThrowMSG
    IF <NE> THEN
        tst.b  tutorialThrowTimer
        IF <NE> THEN
            ; sub 1 from the timer
            subi.b #1, tutorialThrowTimer
            
            ; Set Pixel Colors
            MOVE.L  #WHITE,     D1          ; Set Background color
            MOVE.B  #81,        D0          ; Task for Background Color
            TRAP    #15                     ; Trap (Perform action)

            ; print the message above the player
            MOVE.L  (a1),   D1          ; X
            MOVE.L  (a2),   D2 
            sub.l #125, d1
            sub.l #60, d2
            lea     tutorialThrowMSG,a1
            move.b  #95, d0
            trap    #15
        ENDI
    ENDI  

    ; Set Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    ; Reset Pixel Colors
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
  
*-------------- draw body -----------------*
    LEA     PLAYER_X,   A1
    MOVE.L  (a1),   D1          ; X
    MOVE.L  (a2),   D2
    MOVE.L  D1,   D3
    MOVE.L  D2,   D4
    
    SUBQ.L  #4,     D2
    ADD.l   #PLYR_W_INIT,   d3
    SUB.B   #PLYR_H_INIT,   D4      ; Height          ; Y
    
     ; Draw Player
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw abdomen -----------------*
    MOVE.L  (a1),   D1          ; X
    MOVE.L  (a2),   D2
    SUBQ.L  #4,D2
    MOVE.L  (a1),   D3
    ADD.L   #PLYR_W_INIT, D3
    SUBI.L   #12,D3
    MOVE.L  (a2),   D4
    SUB.L   #PLYR_H_INIT,   D4      ; Height
    SUB.L   #3,D4
    
    ; Draw Player
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)

    ; change thickness
    MOVE.l  #3,D1
    MOVE.B  #93,D0
    TRAP    #15
*-------------- draw antena -----------------*    
    ; draw if not currently attacking melee
    tst.b   CURRENTLYATTACKING
    IF  <EQ>    THEN
        MOVE.L  (a1),D1
        ADD.L   #22,D1
        MOVE.L  (a2),D2
        SUB.L   #PLYR_H_INIT,D2
        MOVE.L  D1,D3
        ADD.L   #10,D3
        MOVE.L  D2,D4
        SUBI.L  #7,D4

        MOVE.B  #84,D0
        TRAP    #15
    ENDI
*-------------- draw leg 1 -----------------*
    MOVE.L  (a1),D1
    MOVE.L  (a2),D2
    MOVE.L  D1,D3
    ADD.L   #4,D3
    MOVE.L  D2,D4
    SUBI.L  #4,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw leg 2 -----------------*
    MOVE.L  (a1),D1
    ADD.L   #13,D1
    MOVE.L  (a2),D2
    MOVE.L  D1,D3
    MOVE.L  D2,D4
    SUBI.L  #4,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw leg 3 -----------------*
    MOVE.L  (a1),D1
    ADD.L   #22,D1
    MOVE.L  (a2),D4
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
    MOVE.L  (a1),D1
    ADD.L   #22,D1
    MOVE.L  (a2),D2
    SUB.L   #10,D2
    MOVE.L  D1,D3
    MOVE.L  D2,D4

    MOVE.B  #84,D0
    TRAP    #15

    MOVE.l  #1,D1
    MOVE.B  #93,D0
    TRAP    #15
    
    ; check to see if either attack is happening
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

    MOVE.l  #3,D1
    MOVE.B  #93,D0
    TRAP    #15

    MOVE.L  (a1),D1
    ADD.L   #22,D1
    MOVE.L  (a2),D2
    SUB.L   #7,D2
    MOVE.L  D1,D3
    MOVE.L  D2,D4

    MOVE.B  #84,D0
    TRAP    #15

    ; Set Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    ; Reset Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  (a1),D1
    ADD.L   #22,D1
    MOVE.L  (a2),D2
    SUB.L   #10,D2
    MOVE.L  D1,D3
    MOVE.L  D2,D4

    MOVE.B  #84,D0
    TRAP    #15

    MOVE.l  #1,D1
    MOVE.B  #93,D0
    TRAP    #15
    MOVE.L  ATTACK_X,   D1          
    MOVE.L  ATTACK_Y,   D2
    SUB.L   #9,D2
    
    MOVE.L  ATTACK_X,   D3
    ADD.L   #ATTACK_WIDTH,   D3      
    SUB.L   #8,D3
    MOVE.L  D2,   D4 
    SUB.L   #3,   D4     
    
    ; Draw Player
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

IS_THROWING:
    TST.B   CURRENTLYTHROWING
    BNE     DRAW_THROW
    RTS
*-----------------DRAW respawn -----------------------------*
DRAW_RESPAWN:
    ; move current respawn timer to d5
    MOVEQ.L     #0,  D5
    MOVE.W      respawnTime,D5

    ; reset player y
    CLR.L     D1                         ; Clear contents of D1
    MOVE.W  SCREEN_H,   D1               ; Place Screen width in D1
    DIVU    #02,        D1               ; divide by 2 for center on Y Axis
    MOVE.L  D1,         PLAYER_Y         ; Players Y Position

    ; reset player velocity and attack
    MOVE.B  #0,     CURRENTLYATTACKING
    CLR.W   ATTACK_COOLDOWN
    CLR.W   ATTACK_TIME
    MOVE.L  #0,PLYR_VELOCITY

    ; push enemies back for fairness
    ADD.L   #50, ENEMY_X
    ADD.L   #50, FLYINGENEMY_X
    ADD.L   #50, BRUTE_X

; move the player from the ant hill out
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

    ; draw everything
    BSR     DRAW_BACKGROUND         ; background
    BSR     DRAW_HILL               ; ant hill
    BSR     DRAW_TREES              ; tree
    BSR     DRAW_ENTRANCE_HOLE      ; entrance to ant hill
    BSR     DRAW_ENEMY              ; Draw Enemy
    BSR     DRAW_FLYENEMY           ; flying enemy
    BSR     DRAW_BRUTEENEMY         ; brute
    BSR     DRAW_HEALTHPACK         ; health apple
    BSR     DRAW_ENTRANCE           ; entrance the overlaps entrance hole
    BSR     DRAW_PLAYER             ; Draw Player
    BSR     DRAW_FLOOR              ; Draw Floor
    BSR     DRAW_HUD                ; Draw hud
    BSR     drawPause               ; draw if paused

    ; update the respawn timer
    ADDQ.W      #1,respawnTime
    MOVE.W      respawnTime,D5
    CMP.W       #200,respawnTime
    BNE         MOVE_RESPAWNED
    MOVE.W     #0,respawnTime

    RTS

* --- player data and variables
PLAYER_X        DS.L    01  ; Reserve Space for Player X Position
PLAYER_Y        DS.L    01  ; Reserve Space for Player Y Position
PLAYER_SCORE    DS.L    01  ; Reserve Space for Player Score

PLYR_VELOCITY   DS.L    01  ; Reserve Space for Player Velocity
PLYR_GRAVITY    DS.L    01  ; Reserve Space for Player Gravity
PLYR_ON_GND     DS.L    01  ; Reserve Space for Player on Ground


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
