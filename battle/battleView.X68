*-----------------------------------------------------------
* Title      : Game Starter Kit
* Written by : Oliwier Jakubiec
* Date       : 05/02/2025
* Description: Project Starter Kit
*-----------------------------------------------------------

*-----------------------------------------------------------
* Section       : Charater Setup
* Description   : Size of Player and Enemy and properties
* of these characters e.g Starting Positions and Sizes
*-----------------------------------------------------------

THRW_W_INIT EQU         15          ; Players initial Width
THRW_H_INIT EQU         15          ; Players initial Height

THRW_DFLT_V EQU         00          ; Default Player Velocity
THRW_JUMP_V EQU         -16          ; Player Jump Velocity
THRW_DFLT_G EQU         01          ; Player Default Gravity

GND_TRUE    EQU         01          ; Player on Ground True
GND_FALSE   EQU         00          ; Player on Ground False

GAMEOVER_INDEX   EQU             00          ; Player Run Sound Index  
JMP_INDEX   EQU             01          ; Player Jump Sound Index  
HITHURT_INDEX  EQU          02          ; Player Opps Sound Index
POWERUP_INDEX  EQU          03          ; Player Opps Sound Index
LEVELCHANGE_INDEX  EQU      04          ; Player Opps Sound Index
HIT_INDEX  EQU              05  
ROAR_INDEX  EQU              07  
HILLHURT_INDEX  EQU              08  

SONG_INDEX equ          06

ENMY_W_INIT EQU         27          ; Enemy initial Width
ENMY_H_INIT EQU         13          ; Enemy initial Height

FLY_ENMY_W_INIT  EQU         30          ; Enemy initial Width
FLY_ENMY_H_INIT  EQU         13          ; Enemy initial Height

BRUTE_W_INIT EQU         50          ; BRute Enemy initial Width
BRUTE_H_INIT EQU         25          ; Brute Enemy initial Height

HEALTH_PACK_W    EQU         12          ; Enemy initial Width
HEALTH_PACK_H    EQU         12          ; Enemy initial Height

LOOKRIGHT   EQU         02          ; Look Right
LOOKLEFT    EQU         01          ; Look Left

*-----------------------------------------------------------
* Section       : Keyboard Keys
* Description   : Spacebar and Escape or two functioning keys
* Spacebar to JUMP and Escape to Exit Game
*-----------------------------------------------------------
SPACEBAR    EQU         $20         ; Spacebar ASCII Keycode
ESCAPE      EQU         $1B         ; Escape ASCII Keycode
Rkey           EQU         $52         ; R ASCII Keycode
Akey           EQU         $41         ; A ASCII Keycode
Skey           EQU         $53         ; S ASCII Keycode
Dkey           EQU         $44         ; D ASCII Keycode
Lkey           EQU         $4C         ; L ASCII Keycode
Kkey           EQU         $4B         ; K ASCII Keycode

*-----------------------------------------------------------
* Subroutine    : Initialise
* Description   : Initialise game data into memory such as 
* sounds and screen size
*-----------------------------------------------------------
INITRUN:
    move.w #2, lvlType
    
    BSR     stop_song
    BSR     BATTLE_SONG_LOAD

    bsr PLAY_SONG

    ; Screen Size
    MOVE.B  #TC_SCREEN, D0          ; access screen information
    MOVE.L  #TC_S_SIZE, D1          ; placing 0 in D1 triggers loading screen size information
    TRAP    #15                     ; interpret D0 and D1 for screen size
    MOVE.W  D1,         SCREEN_H    ; place screen height in memory location
    SWAP    D1                      ; Swap top and bottom word to retrive screen size
    MOVE.W  D1,         SCREEN_W    ; place screen width in memory location

    BSR     INIT_PLAYER
    
    ; Initialise Player Velocity
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.B  #THRW_DFLT_V,D1         ; Init Player Velocity
    MOVE.L  D1,         THROW_VELOCITY

    ; Initialise Player Gravity
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  #THRW_DFLT_G,D1         ; Init Player Gravity
    MOVE.L  D1,         THROW_GRAVITY

    ; Initial Position for Enemy
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #100,D1
    MOVE.L  D1,         ENEMY_X     ; Enemy X Position

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         ENEMY_Y     ; Enemy Y Position

    ; Initial Position for Flying Enemy
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #100,D1
    MOVE.L  D1,         FLYINGENEMY_X     ; Enemy X Position

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    SUB.W   #60,        D1
    MOVE.L  D1,         FLYINGENEMY_Y     ; Enemy Y Position
    
    ; Initial Position for Health pack
    MOVE.L  #380,         HEALTH_X     ; Enemy X Position
    MOVE.L  #90,         HEALTH_Y     ; Enemy Y Position

    MOVE.B  maxAntHp,        antHealth

    MOVE.B  #02,        POINTS
    MOVE.B  #00,        DRAW_HEALTHPACKS
    MOVE.B  #00,        SPAWN_HEALTHPACKS

    MOVE.L  #0,         ATTACK_X
    MOVE.L  #0,         ATTACK_Y
    MOVE.L  #-100,      THROW_X
    MOVE.L  #-100,      THROW_Y
    
    MOVE.B  #00,        CURRENTLYATTACKING
    MOVE.B  #00,        CURRENTLYTHROWING
    
    MOVE.B  #00,        ENEMY_HIT
    MOVE.B  #00,        FLYENEMY_HIT

    ADD.B   #5,        enemiesToDefeat
    MOVE.B  #0,         ENEMIES_DEFEATED
    MOVE.B  #0,         enemiesPassed
    MOVE.B  #4,         backToMapCount
    CLR.L   D1
    
    MOVE.B  (a6),   hillHP
    
    MOVE.B     #100,    hillHP
    ; Init brute
    ; Initial Position for BRUTE
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #100,D1
    MOVE.L  D1,         BRUTE_X     

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         BRUTE_Y     

    MOVE.B      #0,     BRUTE_DEAD          
    MOVE.B      #0,     BRUTE_HIT           
    MOVE.B      #3,     BRUTE_HP            

    ; Enable the screen back buffer(see easy 68k help)
    MOVE.B  #TC_DBL_BUF,D0          ; 92 Enables Double Buffer
    MOVE.B  #17,        D1          ; Combine Tasks
    TRAP	#15                     ; Trap (Perform action)
        
    ; Clear the screen (see easy 68k help)
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)

    bra gameloop

*-----------------------------------------------------------
* Subroutine    : Game
* Description   : Game including main GameLoop. GameLoop is like
* a while loop in that it runs forever until interupted
* (Input, Update, Draw). The Enemies Run at Player Jump to Avoid
*-----------------------------------------------------------
GAME:

    
GAMELOOP:

    MOVEQ		#8,d0				* get time in 1/100 ths seconds
	TRAP		#15

	MOVE.l	d1,-(sp)			* push time on the stack
    MOVE.l	(sp)+,d7			* restore time in 1/100 ths from stack
    jsr wait_100ms
    bra continueLoop

wait_100ms:
	MOVEQ		#8,d0				* get time in 1/100 ths seconds
	TRAP		#15

	SUB.l		d7,d1				* subtract previous time from current time
	CMP.b		#$02,d1			* compare with 9/100ths
	BMI.s		wait_100ms			* loop if time not up yet
    rts

continueLoop:   ; after wait is done
    BSR     BATTLEINPUT                   ; Check Keyboard Input
    BSR     checkPaused
    BSR     UPDATE                  ; Update positions and points
    BSR     IS_PLAYER_ON_GND        ; Check if player is on ground
    BSR     CHECK_COLLISIONS        ; Check for Collisions
    BSR     DRAWBATTLE                  ; Draw the Scene
                ; Loop back to GameLoop
    BRA     GAMELOOP    
    
*-----------------------------------------------------------
* Subroutine    : Input
* Description   : Process Keyboard Input
*-----------------------------------------------------------
BATTLEINPUT:
    move.l CURRENT_KEY, D0
    move.l D0,lastkey 

    MOVE.B  #TC_KEYCODE, D0          ; Check for pressed keys
    ;MOVE.L  #$41444C20, D1          
    MOVE.L  #runActionKeys, D1          ; Check for A, D, L, and Spacebar
    TRAP    #15                         ; Trap (Perform action)
    MOVE.L  D1,         CURRENT_KEY     ; Put Current Key in Memory

    BTST.L  #24,D1
    IF <NE> THEN
        BSR    MOVE_PLAYER_LEFT
    ENDI

    MOVE.L  CURRENT_KEY, D1
    BTST.L  #16,D1
    IF <NE> THEN
        BSR    MOVE_PLAYER_RIGHT
    ENDI

    MOVE.L  CURRENT_KEY, D1
    BTST.L  #8,D1
    IF <NE> THEN
        BSR    PERFORM_ATTACK
    ENDI

    MOVE.L  CURRENT_KEY, D1
    BTST.L  #0,D1
    IF <NE> THEN
        BSR    JUMP
    ENDI

    MOVE.B  #TC_KEYCODE, D0          ; Check for pressed keys
    MOVE.L  #$1B4B, D1                 ; check K and escape
    TRAP    #15                     ; Trap (Perform action)
    MOVE.L  D1,         CURRENT_KEY     ; Put Current Key in Memory

    MOVE.L  CURRENT_KEY, D1
    BTST.L  #0,D1
    IF <NE> THEN
        BSR    PERFORM_THROW
    ENDI



    ; Process Input
    CLR.L   D1                      ; Clear Data Register
    CLR.L   D2
    MOVE.B  #TC_KEYCODE,D0          ; Listen for Keys
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  D1,         D2          ; Move last key D1 to D2
    CMP.B   #00,        D2          ; Key is pressed
    BEQ     PROCESS_INPUT           ; Process Key
    TRAP    #15                     ; Trap for Last Key
    ; Check if key still pressed
    CMP.B   #$FF,       D1          ; Is it still pressed
    BEQ     PROCESS_INPUT           ; Process Last Key
    RTS                             ; Return to subroutine
*-----------------------------------------------------------
* Subroutine    : Process Input
* Description   : Branch based on keys pressed
*-----------------------------------------------------------
PROCESS_INPUT:
    MOVE.L  D2,         CURRENT_KEY ; Put Current Key in Memory

; pause
    move.l  d2,         currentKey
    CMP.l   #escapekey,    currentKey ; Is Current Key Escape
    BEQ     escapePressed

    cmpi.l #key0, currentKey ; fullscreen
    beq key0pressed

    tst.b   isPaused
    bne     pausedInput

    RTS                             ; Return to subroutine

*----------
checkPaused:
    TST.B  isPaused
    BNE    stillPaused
    RTS

stillPaused:
    BSR    DRAWBATTLE
    BRA    GAMELOOP
*-----------------------------------------------------------
* Subroutine    : Update
* Description   : Main update loop update Player and Enemies
*-----------------------------------------------------------
UPDATE:
    ; update player position
    BSR     UPDATE_PLAYER
    BSR     MOVE_THROW

    ; Move the Enemy
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  ENEMY_X,    D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_ENEMY_POSITION    ; Reset Enemy if off Screen
    BSR     MOVE_ENEMY              ; Move the Enemy

    ; Move flying enemy
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  FLYINGENEMY_X,    D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_FLYENEMY_POSITION    ; Reset Enemy if off Screen
    
    ; Move Brute enemy
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  BRUTE_X,    D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_BRUTE_POSITION    ; Reset Enemy if off Screen
    CMP.L   #660,D1
    IF <EQ> THEN
        BSR     PLAY_ROAR
    ENDI


    ; move health
    BSR     MOVE_HEALTHPACK
    MOVE.B  #1, healthCooldownOver
    CMP.W   #0,healthCooldown
    IF <GT> THEN
        SUBI.W  #1, healthCooldown
        MOVE.B  #0, healthCooldownOver
    ENDI

    BSR     CHECK_ATTACK_COOLDOWN

    TST.W   ATTACK_TIME
    BNE     ATTACK_TIME_SUB
    MOVE.B  #00,        CURRENTLYATTACKING
    MOVE.L  #480,        ATTACK_Y

    TST.B   hillHurtTimer
    IF <NE> THEN
        SUB.B   #1,hillHurtTimer
    ENDI

    RTS                             ; Return to subroutine  

MOVE_THROW:
       ; Update the Players Positon based on Velocity and Gravity
    EOR.L   D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  THROW_VELOCITY, D1       ; Fetch Player Velocity
    MOVE.L  THROW_GRAVITY, D2        ; Fetch Player Gravity
    ADD.L   D2,         D1          ; Add Gravity to Velocity
    MOVE.L  D1,         THROW_VELOCITY ; Update Player Velocity
    ADD.L   THROW_Y,   D1          ; Add Velocity to Player
    MOVE.L  D1,         THROW_Y    ; Update Players Y Position

    ADDI.L   #4,        THROW_X
    BSR     CHECK_THROW_DONE
    
    RTS

CHECK_THROW_DONE:
    CMP.L    #350, THROW_Y
    BGT      RESET_THROW
    RTS

RESET_THROW:
    MOVE.B   #00, CURRENTLYTHROWING
    MOVE.L   #-100, THROW_X
    MOVE.L   #-100, THROW_Y
    RTS

CHECK_ATTACK_COOLDOWN:
    CMP.W   #0, ATTACK_COOLDOWN
    BGT     ATTACK_COOLDOWN_SUB
    RTS

ATTACK_TIME_SUB:
    SUB.W   #02,        ATTACK_TIME
    RTS   
ATTACK_COOLDOWN_SUB:
    SUB.W   #02,        ATTACK_COOLDOWN
    RTS                            

MOVE_HEALTHPACK:
    ; check if health is meant to spawn
    TST.B   SPAWN_HEALTHPACKS
    BEQ     CONTINUE
    
    ; check if health is on the
    CMP.L   #240,       HEALTH_Y
    BGE     CONTINUE

    ; else
    ADD.L   #01,        HEALTH_Y
    RTS

*-----------------------------------------------------------
* Subroutine    : Move Enemy
* Description   : Move Enemy Right to Left
*-----------------------------------------------------------
MOVE_ENEMY:
    CMP.W   #3,lvlIndex
    BEQ     MOVE_ENEMY_L4
    CMP.W   #2,lvlIndex
    BEQ     MOVE_ENEMY_L3
    CMP.W   #1,lvlIndex
    BEQ     MOVE_ENEMY_L2

    CMP.L   #180,FLYINGENEMY_X
    IF <LE> THEN
        ADD.L   #1,FLYINGENEMY_Y
    ENDI

    SUB.L   #03,        FLYINGENEMY_X
    SUB.L   #02,        ENEMY_X     ; Move enemy by X Value
    CMP.b   #5,         DIFFICULTY
    IF <EQ> THEN
        SUB.L  #HARD_INCREASE, FLYINGENEMY_X
        SUB.L  #HARD_INCREASE, ENEMY_X
    ENDI
    RTS

MOVE_ENEMY_L2:
    MOVE.L  FLYINGENEMY_X, D1
    SUB.L   #02,        d1
    ADD.L   EASY_SLOW,  d1
    MOVE.L  d1, FLYINGENEMY_X
    CMP.L   #380,       FLYINGENEMY_Y
    IF <GE> THEN
        SUB.l   #02,    FLYINGENEMY_X
    ENDI

    CMP.L   #130,      FLYINGENEMY_X
    IF <LE> THEN
        ADD.L   #1,FLYINGENEMY_Y
    ENDI
    MOVE.L  ENEMY_X, D1
    SUB.L   #04,        d1
    ADD.L   EASY_SLOW,  d1
    MOVE.L  d1, ENEMY_X
    SUB.L   #1,         BRUTE_X
    RTS

MOVE_ENEMY_L3:
    CMP.L   #130,      FLYINGENEMY_X
    IF <LE> THEN
        ADD.L   #3,FLYINGENEMY_Y
    ENDI
    MOVE.L  FLYINGENEMY_X, D1
    SUB.L   #05,        d1
    ADD.L   EASY_SLOW,  d1
    MOVE.L  d1, FLYINGENEMY_X
    MOVE.L  ENEMY_X, D1
    SUB.L   #04,        d1
    ADD.L   EASY_SLOW,  d1
    MOVE.L  d1, ENEMY_X
    MOVE.L  BRUTE_X, D1
    SUB.L   #02,        d1
    ADD.L   EASY_SLOW,  d1
    MOVE.L  d1, BRUTE_X
    RTS

MOVE_ENEMY_L4:
    CMP.L   #130,      FLYINGENEMY_X
    IF <LE> THEN
        ADD.L   #4,FLYINGENEMY_Y
    ENDI
    MOVE.L  FLYINGENEMY_X, D1
    SUB.L   #07,        d1
    ADD.L   EASY_SLOW,  d1
    MOVE.L  d1, FLYINGENEMY_X
    MOVE.L  ENEMY_X, D1
    SUB.L   #05,        d1
    ADD.L   EASY_SLOW,  d1
    MOVE.L  d1, ENEMY_X
    MOVE.L  BRUTE_X, D1
    SUB.L   #02,        d1
    ADD.L   EASY_SLOW,  d1
    MOVE.L  d1, BRUTE_X
    RTS
*-----------------------------------------------------------
* Subroutine    : Reset Enemy
* Description   : Reset Enemy if to passes 0 to Right of Screen
*-----------------------------------------------------------
RESET_ENEMY_POSITION:
    CLR.L   D1       
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         ENEMY_Y     ; Enemy Y Position

    CLR.L   d1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #ENMY_W_INIT,D1
    MOVE.L  D1,         ENEMY_X     ; Enemy X Position

    TST.B     ENEMY_HIT
    IF <EQ> THEN        ; enemy has not been hit
        BSR   damage_hill
    ENDI
    MOVE.B  #0,         ENEMY_HIT
    BSR     CHECK_WAVE_CLEARED

    RTS

RESET_FLYENEMY_POSITION:
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    SUB.W   #60,        D1
    MOVE.L  D1,         FLYINGENEMY_Y     ; Enemy Y Position

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #FLY_ENMY_W_INIT,D1
    MOVE.L  D1,         FLYINGENEMY_X     ; FLY Enemy X Position

    TST.B     FLYENEMY_HIT
    IF <EQ> THEN        ; enemy has not been hit
        BSR   damage_hill
    ENDI
    MOVE.B  #0,         FLYENEMY_HIT
    BSR     CHECK_WAVE_CLEARED

    RTS

RESET_BRUTE_POSITION:
    CLR.L   D1       
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         BRUTE_Y     ; brute Enemy Y Position

    EOR.L  D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #100,D1
    MOVE.L  D1,         BRUTE_X     ; Enemy X Position

    TST.B     BRUTE_DEAD
    IF <EQ> THEN        ; big enemy has not been killed
        BSR   damage_hill
        BSR   damage_hill        
    ENDI
    MOVE.B  #3,         BRUTE_HP
    MOVE.B  #0,         BRUTE_HIT
    MOVE.B  #0,         BRUTE_DEAD

    BSR     CHECK_WAVE_CLEARED

    RTS

RESET_HEALTH_POSITION:
    MOVE.B  #01,        DRAW_HEALTHPACKS
    MOVE.L  #90,        HEALTH_Y
    RTS

CHECK_WAVE_CLEARED:
    ADDI.B  #1,         enemiesPassed
    MOVE.B  enemiesPassed,D1
    CMP.B   enemiesToDefeat,D1
    BEQ     WAVE_DEFEATED
    RTS

damage_hill:
    sub.b  #10,hillHP
    CMP.b   #0,hillHP
    BLE     HILL_LOST
    BSR     PLAY_HILLHURT
    sub.l   #15,currentHealth
    move.b  #10,hillHurtTimer
    RTS

CONTINUE:
    RTS

PERFORM_ATTACK:
    TST.B  isPaused
    IF <NE> THEN
        RTS
    ENDI
    TST.W    ATTACK_COOLDOWN
    BNE      CONTINUE
    
    MOVE.B   #01, CURRENTLYATTACKING
    MOVE.W   #50, ATTACK_TIME
    MOVE.W   #76, ATTACK_COOLDOWN

    MOVE.L   PLAYER_X,ATTACK_X
    ADDI.L   #PLYR_W_INIT,ATTACK_X
    MOVE.L   PLAYER_Y,ATTACK_Y
    RTS

PERFORM_THROW:
    TST.B  isPaused
    IF <NE> THEN
        RTS
    ENDI
    TST.B    CURRENTLYTHROWING
    BNE      CONTINUE
    
    MOVE.B   #01,CURRENTLYTHROWING
    MOVE.L   PLAYER_X,THROW_X
    ADDI.L   #PLYR_W_INIT,THROW_X
    MOVE.L   PLAYER_Y,THROW_Y
    SUBI.L   #PLYR_H_INIT,THROW_Y

    BSR     PERFORM_THROW_ARC
    RTS

*-----------------------------------------------------------
* Subroutine    : Draw
* Description   : Draw Screen
*-----------------------------------------------------------
DRAWBATTLE: 
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
    BSR     DRAW_TREES
    BSR     DRAW_ENTRANCE_HOLE
    BSR     DRAW_ENEMY              ; Draw Enemy
    BSR     DRAW_FLYENEMY
    BSR     DRAW_BRUTEENEMY
    BSR     DRAW_HEALTHPACK
    BSR     DRAW_ENTRANCE
    BSR     DRAW_PLAYER             ; Draw Player
    BSR     DRAW_FLOOR              ; Draw Floor
    BSR     DRAW_PLYR_DATA          ; Draw Draw Score, HUD, Player X and Y
    BSR     drawHillHealth         ; draw hill hp
    BSR     drawAntHealth
    BSR     drawAntsRemaining
    BSR     drawPause
    RTS                             ; Return to subroutine



drawHillHealth:
    move.l  #10,        D1
    move.l  #425,       D2
    move.l  #440,       D4
    clr.l   d5
    clr.l   d6
    move.b     maxHillHp,  d5
    move.b     hillHP, D6
    mulu.w  #2,d5
    mulu.w  #2,d6
    BSR     drawModularHbar
        
    MOVE.L  #color5,D1
    MOVE.B  #tcFont,D0
    MOVE.L  #00090000,D2
    TRAP    #15

    MOVE.L  #deepgreen,D1
    MOVE.B  #tcPenFil,D0
    TRAP    #15

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$021B,     D1           02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     hillHP_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    RTS
drawAntHealth:
    move.l  #10,        D1
    move.l  #335,       D2
    move.l  #350,       D4
    clr.l   d5
    clr.l   d6
    move.b     maxAntHp,  d5
    move.b     antHealth, D6
    mulu.w  #50,d5
    mulu.w  #50,d6
    BSR     drawModularHbar
        
    MOVE.L  #color5,D1
    MOVE.B  #tcFont,D0
    MOVE.L  #00090000,D2
    TRAP    #15

    MOVE.L  #deepgreen,D1
    MOVE.B  #tcPenFil,D0
    TRAP    #15

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0215,     D1           02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     antHealth_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    RTS
drawAntsRemaining:
    move.l  #10,        D1
    move.l  #380,       D2
    move.l  #395,       D4
    clr.l   d5
    clr.l   d6
    move.b     maxRemainingAnts,  d5
    move.b     antsRemaining, D6
    mulu.w  #40,d5
    mulu.w  #40,d6
    BSR     drawModularHbar
        
    MOVE.L  #color5,D1
    MOVE.B  #tcFont,D0
    MOVE.L  #00090000,D2
    TRAP    #15

    MOVE.L  #deepgreen,D1
    MOVE.B  #tcPenFil,D0
    TRAP    #15

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0218,     D1           02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     antsRem_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    RTS

DRAW_HILL:


    ; Set Pixel Colors
    MOVE.L  #DIRT,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #DIRT,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    CMP.B   #0, hillHurtTimer
    IF <NE> THEN
     
        MOVE.L  #MIDBROWN,     D1          ; Set Background color
        MOVE.B  #80,        D0          ; Task for Background Color
        TRAP    #15                     ; Trap (Perform action)

        MOVE.L  #MIDBROWN,     D1
        MOVE.B  #81,        D0
        TRAP    #15
    ENDI

     
    ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #30,   D3           
    MOVE.L  #120,   D4     
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)
    
     ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #60,   D3           
    MOVE.L  #135,   D4 
    
    
    MOVE.B  #87,        D0          ; Draw
    TRAP    #15                     ; Trap (Perform action)

     ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #80,   D3           
    MOVE.L  #150,   D4 
    
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)

     ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #100,   D3           
    MOVE.L  #200,   D4 
    
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #BLACK,     D1
    MOVE.B  #81,        D0
    TRAP    #15
    MOVE.L  #BLACK,     D1
    MOVE.B  #80,        D0
    TRAP    #15

    ; Set X, Y, X2, and Y2
    MOVE.L  #5,   D1          ; X
    MOVE.L  #130,  D2          ; Y
    MOVE.L  #25,   D3           
    MOVE.L  #120,   D4     

    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)

    RTS

DRAW_ENTRANCE:
    ; Set Pixel Colors
    MOVE.L  #DIRT,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #DIRT,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    
    CMP.B   #0, hillHurtTimer
    IF <NE> THEN
            ; Set Pixel Colors
        MOVE.L  #MIDBROWN,     D1          ; Set Background color
        MOVE.B  #80,        D0          ; Task for Background Color
        TRAP    #15                     ; Trap (Perform action)

        MOVE.L  #MIDBROWN,     D1
        MOVE.B  #81,        D0
        TRAP    #15
    ENDI

    ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #5,   D3           
    MOVE.L  #181,   D4     
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)

    RTS

DRAW_ENTRANCE_HOLE:
    ; Set Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #BLACK,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    ; Set X, Y, X2, and Y2
    MOVE.L  #5,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #20,   D3           
    MOVE.L  #211,   D4     
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)
    RTS

DRAW_BACKGROUND:
    CLR.L       D1
    MOVE.L      #SKY,D1
    MOVE.B      #81,D0
    TRAP        #15

    MOVE.L      #00, D1
    MOVE.L      #00, D2
    MOVE.L      #89, D0
    TRAP        #15
    
    MOVE.L     #brown,D1
    MOVE.L     #$01110000,D2
    MOVE.B     #21,D0
    TRAP       #15

    RTS

DRAW_TREES:
    
    MOVE.L  #4,D1
    MOVE.L  #93,D0
    TRAP    #15
    
    ; Set Pixel Colors
    MOVE.L  #TRUNKO,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #TRUNKO,     D1
    MOVE.B  #81,        D0
    TRAP    #15
    
    ; left trunk
    MOVE.L  #330,D1
    MOVE.L  #241,D2
    MOVE.L  #340,D3
    MOVE.L  #137,D4
    
    MOVE.B  #84,D0
    TRAP    #15
    
    ;top trunk
    MOVE.L  #368,D1
    MOVE.L  D4,D2
    MOVE.B  #85,D0
    TRAP    #15
    
    ; right trunk
    MOVE.L  #375,D1
    MOVE.L  #241,D2
    MOVE.B  #85,D0
    TRAP    #15
    
    ; bottom of trunk
    MOVE.L  #330,D1
    MOVE.L  #241,D2
    MOVE.B  #85,D0
    TRAP    #15
    
    ; fill in trunk of tree
    MOVE.L  #TRUNKI,     D1
    MOVE.B  #81,        D0
    TRAP    #15
    
    MOVE.L  #340,D1
    MOVE.L  #160,D2
    MOVE.B  #89,D0
    TRAP    #15
   
   ; reset pen size
    MOVE.L  #1,D1
    MOVE.L  #93,D0
    TRAP    #15

   ; Set Pixel Colors
    MOVE.L  #GREEN1,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #GREEN1,     D1
    MOVE.B  #81,        D0
    TRAP    #15

; 88 for elipse
    MOVE.L  #303,D1
    MOVE.L  #33,D2
    MOVE.L  #391,D3
    MOVE.L  #118,D4
    MOVE.B  #87,D0
    TRAP    #15
   
      ; Set Pixel Colors
    MOVE.L  #GREEN2,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #GREEN2,     D1
    MOVE.B  #81,        D0
    TRAP    #15

; 88 for elipse
    MOVE.L  #338,D1
    MOVE.L  #42,D2
    MOVE.L  #427,D3
    MOVE.L  #133,D4
    MOVE.B  #87,D0
    TRAP    #15
    
          ; Set Pixel Colors
    MOVE.L  #GREEN3,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #GREEN3,     D1
    MOVE.B  #81,        D0
    TRAP    #15

; 88 for elipse
    MOVE.L  #284,D1
    MOVE.L  #65,D2
    MOVE.L  #368,D3
    MOVE.L  #150,D4
    MOVE.B  #87,D0
    TRAP    #15
    
          ; Set Pixel Colors
    MOVE.L  #GREEN4,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #GREEN4,     D1
    MOVE.B  #81,        D0
    TRAP    #15

; 88 for elipse
    MOVE.L  #340,D1
    MOVE.L  #76,D2
    MOVE.L  #423,D3
    MOVE.L  #158,D4
    MOVE.B  #87,D0
    TRAP    #15
    

    

    RTS
*-----------------------------------------------------------
* Subroutine    : Draw game info
* Description   : Draw info about the current battle e.g. your hp, hill hp, ant remaining, etc.
*-----------------------------------------------------------
DRAW_PLYR_DATA:
    EOR.L   D1,D1                      ; Clear contents of D1 (XOR is faster)
    EOR.L    D2,D2

    MOVE.L  #deepgreen,D1
    MOVE.B  #tcFont,D0
    MOVE.L  #$00120000,D2
    TRAP    #15

    MOVE.L  #SKY,D1
    MOVE.B  #tcPenFil,D0
    TRAP    #15

      ; Show antHealth msg
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0100,     D1           02, Row 06
    TRAP    #15                     ; Trap (Perform action)
    LEA     wave_MSG,   A1          ; Draw
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)  
    
    ; Show antHealth msg
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0A00,     D1           30, Row 1
    TRAP    #15                     ; Trap (Perform action)   
    EOR.L   D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  lvlIndex,      D1          ; Move Key Pressed to D1
    ADD.B   #1,D1
    MOVE.B  #03,        D0          ; Display the contents of D1
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #deepgreen,D1
    MOVE.B  #tcFont,D0
    MOVE.L  #$00090000,D2
    TRAP    #15

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0203,     D1           
    TRAP    #15                     ; Trap (Perform action)
    LEA     ENEMIESDEAD_MSG,    A1          ; On Ground Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1703,     D1           06, Row 04
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.B  ENEMIES_DEFEATED,     D1          ; Move Play on Ground ? to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
    ; number of enemies in wave msg
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0202,     D1           
    TRAP    #15                     ; Trap (Perform action)
    LEA     ENEMYCOUNT_MSG,    A1          ; On Ground Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; number of enemies in wave 
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1702,     D1           06, Row 04
    TRAP    #15                     ; Trap (Perform action)
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.B  enemiesToDefeat,     D1          ; Move Play on Ground ? to D1.L
    MOVE.B  #03,        D0          ; Display number at D1.L
    TRAP    #15                     ; Trap (Perform action)


    RTS
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

*-----------------------------------------------------------
* Subroutine    : Throw
* Description   : Perform a Throw
*-----------------------------------------------------------
THROW_ARC:
    CMP.L   #GND_TRUE,PLYR_ON_GND   ; Player is on the Ground ?
    BEQ     PERFORM_THROW_ARC    ; Do Jump
    BRA     ARC_DONE               ;
PERFORM_THROW_ARC:
    ;BSR     PLAY_JUMP               ; Play jump sound
    MOVE.L  #THRW_JUMP_V,THROW_VELOCITY ; Set the players velocity to true
    RTS                             ; Return to subroutine
ARC_DONE:
    RTS                             ; Return to subroutine

*-----------------------------------------------------------
* Subroutine    : Idle
* Description   : Perform a Idle
*----------------------------------------------------------- 
IDLE:
    RTS                             ; Return to subroutine

*-----------------------------------------------------------
* Subroutines   : Sound Load and Play
* Description   : Initialise game sounds into memory 
* Current Sounds are RUN, JUMP and Opps for Collision
*-----------------------------------------------------------
GAMEOVER_LOAD:
    LEA     GAMEOVER_WAV,    A1          ; Load Wav File into A1
    MOVE    #GAMEOVER_INDEX, D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_GAMEOVER:
    bsr STOP_SONG
    MOVE    #GAMEOVER_INDEX, D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

JUMP_LOAD:
    LEA     JUMP_WAV,   A1          ; Load Wav File into A1
    MOVE    #JMP_INDEX, D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_JUMP:
    MOVE    #JMP_INDEX, D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

HITHURT_LOAD:
    LEA     HITHURT_WAV,   A1          ; Load Wav File into A1
    MOVE    #HITHURT_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_HITHURT:
    MOVE    #HITHURT_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

POWERUP_LOAD:
    LEA     POWERUP_WAV,   A1          ; Load Wav File into A1
    MOVE    #POWERUP_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_POWERUP:
    MOVE    #POWERUP_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

LVLCHANGE_LOAD:
    LEA     LEVELCHANGE_WAV,   A1          ; Load Wav File into A1
    MOVE    #LEVELCHANGE_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_LVLCHANGE:
    MOVE    #LEVELCHANGE_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

HIT_LOAD:
    LEA     HIT_WAV,   A1          ; Load Wav File into A1
    MOVE    #HIT_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_HIT:
    MOVE    #HIT_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

ROAR_LOAD:
    LEA     ROAR_WAV,   A1          ; Load Wav File into A1
    MOVE    #ROAR_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_ROAR:
    MOVE    #ROAR_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

HILLHURT_LOAD:
    LEA     HILLHURT_WAV,   A1          ; Load Wav File into A1
    MOVE    #HILLHURT_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_HILLHURT:
    MOVE    #HILLHURT_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

MAP_SONG_LOAD:
    LEA     MAP_SONG_WAV,   A1          ; Load Wav File into A1
    MOVE    #SONG_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

BATTLE_SONG_LOAD:
    LEA     BATTLE_SONG_WAV,   A1          ; Load Wav File into A1
    MOVE    #SONG_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

MENU_SONG_LOAD:
    LEA     MENU_SONG_WAV,   A1          ; Load Wav File into A1
    MOVE    #SONG_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

; special function to play song in song index
PLAY_SONG:
    MOVE    #SONG_INDEX,D1          ; Load Sound INDEX
    move.l #1, d2
    MOVE    #77,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

; stop song playing
STOP_SONG:
    move #SONG_INDEX,d1
    move.l #2, d2
    move #77, d0
    trap #15
    rts

*-----------------------------------------------------------
* Subroutine    : Draw Player
* Description   : Draw Player Ant
*-----------------------------------------------------------
    include "battle/playerAnt.X68"
*-----------------------------------------------------------
* Subroutine    : Draw Enemy
* Description   : Draw Enemy Ant
*-----------------------------------------------------------
    include "battle/battleEnemy.X68"

    
DRAW_FLYENEMY:
    ; Set Pixel Colors
    MOVE.L  #blue,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #blue,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

        *-------------- draw FLYINGENEMY body -----------------*
    MOVE.L  FLYINGENEMY_X,   D1          ; X
    MOVE.L  FLYINGENEMY_Y,   D2
    SUBQ.L  #4,D2

    MOVE.L  FLYINGENEMY_X,   D3
    ADD.L   #FLY_ENMY_W_INIT, D3  
    MOVE.L  FLYINGENEMY_Y,   D4
    SUB.L   #FLY_ENMY_H_INIT,   D4      ; Height          ; Y
    
     ; Draw 
    MOVE.B  #87,        D0          ; Draw enemy
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw FLYINGENEMY abdomen -----------------*
    MOVE.L  FLYINGENEMY_X,   D1          ; X
    MOVE.L  D1,   D3
    ADD.L   #FLY_ENMY_W_INIT,D1
    MOVE.L  FLYINGENEMY_Y,   D2
    SUBQ.L  #4,D2
    MOVE.L  FLYINGENEMY_X,   D3
    ADDI.L   #12,D3
    
    MOVE.L  FLYINGENEMY_Y,   D4
    SUB.L   #FLY_ENMY_H_INIT,   D4      ; Height          ; Y
    SUB.B   #3,D4
    
    ; Draw 
    MOVE.B  #87,        D0          ; Draw enemy
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw FLYINGENEMY antena -----------------*    
    ; change thickness
    MOVE.l  #3,D1
    MOVE.B  #93,D0
    TRAP    #15

    MOVE.L  FLYINGENEMY_X,D1
    ADD.L   #3,D1
    MOVE.L  FLYINGENEMY_Y,D2
    SUB.L   #FLY_ENMY_H_INIT,D2
    MOVE.L  D1,D3
    SUB.L   #10,D3
    MOVE.L  D2,D4
    SUBI.L  #7,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw FLYINGENEMY leg 1 -----------------*
    MOVE.L  FLYINGENEMY_X,D1
    MOVE.L  FLYINGENEMY_Y,D2
    MOVE.L  D1,D3
    ADD.L   #4,D3
    MOVE.L  D2,D4
    SUBI.L  #4,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw FLYINGENEMY leg 2 -----------------*
    MOVE.L  FLYINGENEMY_X,D1
    ADD.L   #13,D1
    MOVE.L  FLYINGENEMY_Y,D2
    MOVE.L  D1,D3
    MOVE.L  D2,D4
    SUBI.L  #4,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw FLYINGENEMY leg 3 -----------------*
    MOVE.L  FLYINGENEMY_X,D1
    ADD.L   #22,D1
    MOVE.L  FLYINGENEMY_Y,D4
    MOVE.L  D1,D3
    ADD.L   #3,D3
    MOVE.L  D4,D2
    SUBI.L  #4,D2

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw FLYINGENEMY Wing 1 -----------------*
    ; Set Pixel Colors
    MOVE.L  #WING,     D1          ; Set Pen color
    MOVE.B  #80,        D0          ; Task for Pen Color
    TRAP    #15                     ; Trap (Perform action)
    
    ; change thickness
    MOVE.l  #5,D1
    MOVE.B  #93,D0
    TRAP    #15

    MOVE.L  FLYINGENEMY_X,D1
    ADD.L   #15,D1
    MOVE.L  FLYINGENEMY_Y,d2
    SUB.L   #FLY_ENMY_H_INIT,D2
    MOVE.L  D1,D3
    SUB.L   #9,D3
    MOVE.L  D2,D4
    SUB.L   #10,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw FLYINGENEMY Wing 2 -----------------*
    MOVE.L  FLYINGENEMY_X,D1
    ADD.L   #15,D1
    MOVE.L  FLYINGENEMY_Y,d2
    SUB.L   #FLY_ENMY_H_INIT,D2
    MOVE.L  D1,D3
    ADD.L   #9,D3
    MOVE.L  D2,D4
    SUB.L   #10,D4

    MOVE.B  #84,D0
    TRAP    #15


*-------------- draw FLYINGENEMY eye -----------------*
    ; Set Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Pen color
    MOVE.B  #80,        D0          ; Task for Pen Color
    TRAP    #15                     ; Trap (Perform action)
    
    ; change thickness
    MOVE.l  #3,D1
    MOVE.B  #93,D0
    TRAP    #15

    MOVE.L  FLYINGENEMY_X,D1
    ADD.L   #3,D1
    MOVE.L  FLYINGENEMY_Y,D2
    SUB.L   #10,D2
    MOVE.L  D1,D3
    ADDQ.L  #1,D3
    MOVE.L  D2,D4

    MOVE.B  #84,D0
    TRAP    #15

    ; reset pen
    MOVE.l  #1,D1
    MOVE.B  #93,D0
    TRAP    #15

    RTS  

DRAW_HEALTHPACK:

    TST.B   healthCooldownOver
    BEQ     DRAW_HEALTHPACK_DONE
    CMP.B   #00,     SPAWN_HEALTHPACKS
    BEQ     DRAW_HEALTHPACK_DONE
    CMP.B   #00,     DRAW_HEALTHPACKS
    BEQ     DRAW_HEALTHPACK_DONE
    
    ; Set Pixel Colors
    MOVE.L  #RED,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #RED,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  HEALTH_X,    D1          ; X
    MOVE.L  HEALTH_Y,    D2          ; Y
    MOVE.L  D1,    D3
    ADD.L   #HEALTH_PACK_W,   D3      ; Width
    MOVE.L  D2,    D4 
    SUB.L   #HEALTH_PACK_H,   D4      ; Height

    ; Draw  
    MOVE.B  #87,        D0          ; Draw
    TRAP    #15                     ; Trap (Perform action)

    ; Set Pixel Colors
    MOVE.L  #GREEN1,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #GREEN1,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    
    ; change thickness
    MOVE.l  #2,D1
    MOVE.B  #93,D0
    TRAP    #15
        ; Set X, Y, Width and Height
    MOVE.L  HEALTH_X,    D1          ; X
    MOVE.L  HEALTH_Y,    D2          ; Y
    SUB.L   #HEALTH_PACK_H,   D2      ; Height
    MOVE.L  D1,    D3
    ADD.L   #3,D1
    ADD.L   #HEALTH_PACK_W,   D3      ; Width
    SUB.L   #5,D3
    MOVE.L  D2,    D4
    SUB.L   #5,     D4 

    ; Draw  
    MOVE.B  #87,        D0          ; Draw
    TRAP    #15                     ; Trap (Perform action)
    
    ; Set Pixel Colors
    MOVE.L  #BROWN,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #BROWN,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    

        ; Set X, Y, Width and Height
    MOVE.L  HEALTH_X,    D1          ; X
    MOVE.L  HEALTH_Y,    D2          ; Y
    ADD.L   #6,D1
    MOVE.L  D1,    D3
    ADD.L   #3,D3
    SUB.L   #HEALTH_PACK_H,   D2      ; Height
    MOVE.L  D2,    D4
    SUB.L   #5, D4 

    ; Draw  
    MOVE.B  #84,        D0          ; Draw
    TRAP    #15                     ; Trap (Perform action)
    ; reset thickness
    MOVE.l  #1,D1
    MOVE.B  #93,D0
    TRAP    #15


    RTS                             ; Return to subroutine

DRAW_HEALTHPACK_DONE:
    MOVE.L  #-1, HEALTH_Y
    MOVE.W  healthCooldown,D2
    CMP.W   #0,  D2
    IF <EQ> THEN
        BSR     RESET_HEALTH_POSITION
    ENDI
    RTS

DRAW_FLOOR:
    ; Set Pixel Colors
    MOVE.L  #GREEN,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #GREEN,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    
    ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #640,   D3           
    MOVE.L  #480,   D4 
    
    ; Draw grass
    MOVE.B  #87,        D0          ; Draw Line
    TRAP    #15                     ; Trap (Perform action)

    ; Set Pixel Colors
    MOVE.L  #deepgreen,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #deepgreen,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    BRA     DRAWDIRT
    
DRAWDIRT:
    ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #640,   D3  
    MOVE.L  #277,   D2         
    MOVE.L  #480,   D4 
    
    ; Draw Dirt
    MOVE.B  #87,        D0          ; Draw Line
    TRAP    #15                     ; Trap (Perform action)


    ; Reset Pixel Colors
    MOVE.L  #$00000000,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #$00000000,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    RTS                             ; Return to subroutine
    
*-----------------------------------------------------------
* Subroutine    : Collision Check
* Description   : Axis-Aligned Bounding Box Collision Detection
* Algorithm checks for overlap on the 4 sides of the Player and 
* Enemy rectangles
* PLAYER_X <= ENEMY_X + ENEMY_W &&
* PLAYER_X + PLAYER_W >= ENEMY_X &&
* PLAYER_Y <= ENEMY_Y + ENEMY_H &&
* PLAYER_H + PLAYER_Y >= ENEMY_Y
*-----------------------------------------------------------
CHECK_COLLISIONS:
    include     "battle/battlecollisions.x68"     

*-----------------------------------------------------------
* Subroutine    : End of round
* Description   : checks how the wave concluded
*-----------------------------------------------------------

HILL_LOST:


    clr.l   d3
    move.b  ENEMIES_DEFEATED, d3
    add.l   d3,totalKills

    tst.b   totalHillsDefended
    IF <EQ> THEN
        cmp.w   #3,lvlIndex
        IF <EQ> THEN
            beq     GAME_OVER
        ENDI
    ENDI

    CMP.W   #3,lvlIndex
    BEQ     WIN_SCREEN

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)
    BSR     PLAY_GAMEOVER

*------------Set Colours--------------*
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$01130005, D2
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #deepgreen,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    ;MOVE.W      #0,D1
    ;MOVE.W      #0,d2
    ;MOVE.B      #89,D0
    ;TRAP        #15
    jsr drawBg

*------------ Print hill lost message--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0803,     D1           
    TRAP    #15                     ; Trap (Perform action)
    LEA     HILLLOST_MSG,A1        ; Game Over Message
    BSR     print

*------------print amount of enemies defeated--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0606,     D1           02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     ENEMIESDEAD_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B06,     D1           09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVEQ.L #0,D1
    MOVE.B  ENEMIES_DEFEATED,D1         ; Move Score to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
*------------print hill health --------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0607,     D1           02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     hillHP_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B07,     D1           09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    MOVEQ.L #0,D1
    MOVE.B  hillHP,D1         ; Move Score to D1.L
    MOVE.B  #03,        D0          ; Display number at D1.L
    TRAP    #15                     ; Trap (Perform action)
    
*------------ print back to map--------------*

    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$03140000, D2
    TRAP    #15                     ; Trap (Perform action)

    ; Restart
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$070C,     D1           09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     BACK_TO_MAP_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feedF=
    TRAP    #15                     ; Trap (Perform action)

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1F0C,     D1           09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    MOVEQ.L #0,D1
    MOVE.B  backToMapCount,D1         ; Move Score to D1.L
    MOVE.B  #03,        D0          ; Display number at D1.L
    TRAP    #15                     ; Trap (Perform action)

    
    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15
   
    ; delay by 1sec
    MOVE.b  #23,D0
    MOVE.L  #100,D1
    TRAP    #15

    SUB.B   #01,backToMapCount
    TST.B   backToMapCount
    BEQ     mapNotFirstInit

    MOVE.l  #200,currentHealth
    bsr     initDraw
    ; back to top
    BRA     HILL_LOST

INPUTLOOP:
    BSR     BATTLEINPUT
    BRA     INPUTLOOP

GAME_OVER:
    
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)
    BSR     PLAY_GAMEOVER
    
*------------Set Colours--------------*
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$01130000, D2
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #color1,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    ;MOVE.W      #0,D1
    ;MOVE.W      #0,d2
    ;MOVE.B      #89,D0
    ;TRAP        #15
    jsr drawBg

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0F05,     D1           
    TRAP    #15                     ; Trap (Perform action)
    LEA     GAMEOVER_MSG,A1        ; Game Over Message
    BSR     print
   
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0607,     D1           
    TRAP    #15                     ; Trap (Perform action)
    LEA     FALLENKINGDOM_MSG,A1        ; Game Over Message
    BSR     print


    MOVE.B  #TC_REDRAW,D0          ; Set Cursor Position
    TRAP	#15                     ; Trap (Perform action)

     ; delay by 1sec
    MOVE.b  #23,D0
    MOVE.L  #150,D1
    TRAP    #15
    MOVE.b  #TC_CURSR_P,d0
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    trap    #15

    MOVE.L  #color1,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    ;MOVE.W      #0,D1
    ;MOVE.W      #0,d2
    ;MOVE.B      #89,D0
    ;TRAP        #15

    jsr drawBg

    BRA     tallyScore

WAVE_DEFEATED:

    addi.b #1, totalHillsDefended

    clr.l   d3
    move.b  ENEMIES_DEFEATED, d3
    add.l   d3,totalKills

    move.b  hillHP,d3
    move.b  maxHillHp,d4
    cmp.b   d4,d3
    IF <EQ> THEN
        addi.l  #1,perfectDefenceAmount
    ENDI
    CMP.W   #3,lvlIndex
    BEQ     WIN_SCREEN
    
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)
    BSR     PLAY_GAMEOVER

*------------Set Colours--------------*
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$01130005, D2
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #deepgreen,     D1
    MOVE.B  #tcPenFil,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    ;MOVE.W      #0,D1
    ;MOVE.W      #0,d2
    ;MOVE.B      #89,D0
    ;TRAP        #15
    jsr drawBg

*------------ Print wave defeated message--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0E03,     D1           
    TRAP    #15                     ; Trap (Perform action)
    LEA     HILLDEFENDED_MSG,A1        ; Game Over Message
    BSR     print

*------------print amount of enemies defeated--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0606,     D1           02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     ENEMIESDEAD_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B06,     D1           09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVEQ.L #0,D1
    MOVE.B  ENEMIES_DEFEATED,D1         ; Move Score to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
*------------print hill health --------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0607,     D1           02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     hillHP_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B07,     D1           09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    MOVEQ.L #0,D1
    MOVE.B  hillHP,D1         ; Move Score to D1.L
    MOVE.B  #03,        D0          ; Display number at D1.L
    TRAP    #15                     ; Trap (Perform action)
    
*------------ print back to map--------------*
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$03140000, D2
    TRAP    #15                     ; Trap (Perform action)


    ; Restart
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$070C,     D1           09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     BACK_TO_MAP_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feedF=
    TRAP    #15                     ; Trap (Perform action)

MAPCOUNTDOWN:
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1F0C,     D1           09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    MOVEQ.L #0,D1
    MOVE.B  backToMapCount,D1         ; Move Score to D1.L
    MOVE.B  #03,        D0          ; Display number at D1.L
    TRAP    #15                     ; Trap (Perform action)
    
    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15
   
    ; delay by 1sec
    MOVE.b  #23,D0
    MOVE.L  #100,D1
    TRAP    #15

    SUB.B   #01,backToMapCount
    TST.B   backToMapCount
    BEQ     mapNotFirstInit

    bsr     initDraw
    MOVE.l  #200,currentHealth
    ; back to top
    BRA     MAPCOUNTDOWN


WIN_SCREEN:
    move.b #1, isWin
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)
    BSR     PLAY_GAMEOVER
    
*------------Set Colours--------------*
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$01130000, D2
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #color1,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    ;MOVE.W      #0,D1
    ;MOVE.W      #0,d2
    ;MOVE.B      #89,D0
    ;TRAP        #15
    jsr drawBg
    
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0406,     D1           
    TRAP    #15                     ; Trap (Perform action)
    LEA     WIN_MSG,A1        ; Game Over Message
    BSR     print


    MOVE.B  #TC_REDRAW,D0          ; Set Cursor Position
    TRAP	#15                     ; Trap (Perform action)

     ; delay by 1sec
    MOVE.b  #23,D0
    MOVE.L  #150,D1
    TRAP    #15
    MOVE.b  #TC_CURSR_P,d0
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    trap    #15

    MOVE.L  #color1,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    ;MOVE.W      #0,D1
    ;MOVE.W      #0,d2
    ;MOVE.B      #89,D0
    ;TRAP        #15

    jsr drawBg

    BRA     tallyScore


EXIT:
    
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)

    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15

    MOVE.B  #TC_EXIT,   D0          ; Exit Code
    TRAP    #15                     ; Trap (Perform action)
    SIMHALT

*-----------------------------------------------------------
* Section       : Messages
* Description   : Messages to Print on Console, names should be
* self documenting
*-----------------------------------------------------------
SCORE_MSG       DC.B    'Score : ', 0       ; Score Message
KEYCODE_MSG     DC.B    'KeyCode : ', 0     ; Keycode Message
JUMP_MSG        DC.B    'Jump....', 0       ; Jump Message


ENEMIESDEAD_MSG         DC.B    'Enemies Defeated:', 0           
ENEMYCOUNT_MSG         DC.B    'Wave enemy count:', 0           

EXIT_MSG        DC.B    'Exiting....', 0    ; Exit Message
HILLLOST_MSG    DC.B    'ANT HILL HAS BEEN OVERRUN!', 0      ; Game Over Message
WIN_MSG    DC.B    'THE ENEMY ARMY HAS BEEN DEFEATED!', 0      ; Game Over Message
HILLDEFENDED_MSG    DC.B    'WAVE COMPLETE!', 0      ; Game Over Message
FALLENKINGDOM_MSG    DC.B    'YOUR ANT KINGDOM HAS FALLEN', 0      ; Game Over Message
GAMEOVER_MSG    DC.B    'GAME OVER!', 0      ; Game Over Message
BACK_TO_MAP_MSG    DC.B    'Returning to map in ...', 0      ; Game Over Message
RESTART_MSG    DC.B    'Press R to restart', 0      ; Game Over Message
TREET          DC.B     '##',0

PRESSSTART      DC.B    'Enter 1 to start',0
TITLEMSG        DC.B    'ANT DEFENDER',0
antHealth_MSG       DC.B    'Health : ',0        ; health message
antsRem_MSG       DC.B    'Ants Remaining : ',0        ; health message
hillHP_MSG       DC.B    'Hill Health: ',0        ; health message
wave_MSG       DC.B    'Wave: ',0        ; health message

hillHP          DC.B      100
IN_ENEMY        DC.B      00                  ; marker for if the player is in the enemy
IN_HPACK        DC.B      00                  ; marker for if the player is in the health pack
DRAW_HEALTHPACKS   DC.B     $00                  ; marker for if the healthpacks are showing
SPAWN_HEALTHPACKS   DC.B    $00                  ; marker for if the healthpacks are spawning
healthCooldownOver  DC.B    $00

*-----------------------------------------------------------
* Section       : Screen Size
* Description   : Screen Width and Height
*-----------------------------------------------------------
SCREEN_W        DS.W    01  ; Reserve Space for Screen Width
SCREEN_H        DS.W    01  ; Reserve Space for Screen Height

*-----------------------------------------------------------
* Section       : Keyboard Input
* Description   : Used for storing Keypresses
*-----------------------------------------------------------
CURRENT_KEY     DS.L    01  ; Reserve Space for Current Key Pressed
LAST_KEY        DS.W    01  ; Reserve Space for Current Key Pressed

*-----------------------------------------------------------
* Section       : Character Data
* Description   : Player and Enemy Position Memory Locations
*-----------------------------------------------------------
PLAYER_X        DS.L    01  ; Reserve Space for Player X Position
PLAYER_Y        DS.L    01  ; Reserve Space for Player Y Position
PLAYER_SCORE    DS.L    01  ; Reserve Space for Player Score

PLYR_VELOCITY   DS.L    01  ; Reserve Space for Player Velocity
PLYR_GRAVITY    DS.L    01  ; Reserve Space for Player Gravity
PLYR_ON_GND     DS.L    01  ; Reserve Space for Player on Ground

; 1, = left, 0 = right
PLAYER_DIR      DS.B    01  ; Reserve Space for Player Direction

ENEMY_X         DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y         DS.L    01  ; Reserve Space for Enemy Y Position

HEALTH_X         DS.L    01  ; Reserve Space for Health+ X Position
HEALTH_Y         DS.L    01  ; Reserve Space for Health Y Position

FLYINGENEMY_X         DS.L    01  ; Reserve Space for Flying Enemy X Position
FLYINGENEMY_Y         DS.L    01  ; Reserve Space for Flying Enemy Y Position

BRUTE_X         DS.L    01
BRUTE_Y         DS.L    01

ENEMYCOLOR        DC.L        $000000FF
FLYENEMYCOLOR     DC.L        $00FF0000

RANDOM            DS.L        01  ; Reserve Space for Random Number
antHealth         DC.B        03  ; reserves space for antHealth
antsRemaining     DC.B        00  ; reserves space for ants
maxHillHp         DC.B        100
maxAntHp         DC.B        3
maxRemainingAnts         DC.B        5
totalHillsDefended       DC.b        0

POINTS            DC.B        02          ; Points added

CURRENTLYATTACKING   DC.B    00
ATTACK_COOLDOWN      DC.W    00
ATTACK_TIME          DC.W    00
ATTACK_X             DC.L    00
ATTACK_Y             DC.L    00
ATTACK_HEIGHT        EQU     20
ATTACK_WIDTH         EQU     35 

CURRENTLYTHROWING   DC.B    00
THROW_COOLDOWN      DC.W    00
THROW_TIME          DC.W    00
THROW_X             DC.L    00
THROW_Y             DC.L    00
THROW_HEIGHT        EQU     20
THROW_WIDTH         EQU     35 
THROW_VELOCITY      DS.L    01  
THROW_GRAVITY       DS.L    01  

ENEMIES_DEFEATED    DC.B    00
enemiesPassed       DC.b    00
enemiesToDefeat     DC.B    00

ENEMY_HIT           DC.B    00
FLYENEMY_HIT        DC.B    00
BRUTE_DEAD          DC.B    00
BRUTE_HIT           DC.B    00
BRUTE_HP            DC.b    03

* Widths and heights of player, enemy and healthpack
; NOT NECESSARY AT THE MOMENT
*-----------------------------------------------------------
PLAYER_WIDTH      DC.B        12          ; Player Width
PLAYER_HEIGHT     DC.B        12          ; Player Height

ENEMY_WIDTH       DC.W        12          ; Enemy Width
ENEMY_HEIGHT      DC.W        12          ; Enemy Height

FLYENEMY_WIDTH    DC.W        20 
FLYENEMY_HEIGHT   DC.W        12 

        
*-----------------------------------------------------------
* Section       : Sounds
* Description   : Sound files, which are then loaded and given
* an address in memory, they take a longtime to process and play
* so keep the files small.
*-----------------------------------------------------------
JUMP_WAV        DC.B    'jump.wav',0        ; Jump Sound
GAMEOVER_WAV    DC.B    'gameOver.wav',0    ; Run Sound
HITHURT_WAV     DC.B    'hitHurt.wav',0     ; Collision Opps
HIT_WAV         DC.B    'hit.wav',0         ; Collision Opps
POWERUP_WAV     DC.B    'powerUP.wav',0     ; Collision Opps
LEVELCHANGE_WAV DC.B    'levelChange.wav',0 ; Collision Opps
ROAR_WAV        DC.B    'roar-8-bit.wav',0 ; Collision Opps
HILLHURT_WAV        DC.B    'hillHurt.wav',0 ; Collision Opps

BATTLE_SONG_WAV DC.B    'antopia-battle.wav',0
MAP_SONG_WAV    DC.B    'antopia-map.wav',0
MENU_SONG_WAV   dc.B    'antopia-menu.wav',0


respawnTime         dc.W        0
backToMapCount      dc.b        3
healthCooldown      DC.W        0
hillHurtTimer       dc.b        0
*---*
timer           DC.L    0

;    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
