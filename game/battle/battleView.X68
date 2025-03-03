*-----------------------------------------------------------
* Title      : battle view 
* Written by : Oliwier Jakubiec
* Date       : 05/02/2025
* Description: battle main file
*-----------------------------------------------------------

*-----------------------------------------------------------
* Subroutine    : Initialise battle
* Description   : Initialise game data into memory such as 
* sounds and screen size
*-----------------------------------------------------------
INITRUN:
    move.w #2, lvlType
    
    BSR     stop_song
    BSR     BATTLE_SONG_LOAD

    bsr PLAY_SONG

    ; Set up Screen Size
    MOVE.B  #TC_SCREEN, D0          ; access screen information
    MOVE.L  #TC_S_SIZE, D1          ; placing 0 in D1 triggers loading screen size information
    TRAP    #15                     ; interpret D0 and D1 for screen size
    MOVE.W  D1,         SCREEN_H    ; place screen height in memory location
    SWAP    D1                      ; Swap top and bottom word to retrive screen size
    MOVE.W  D1,         SCREEN_W    ; place screen width in memory location

    ; init player
    BSR     INIT_PLAYER
    BSR     initThrow
    
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
    MOVE.L  D1,         FLYINGENEMY_X     ; flying Enemy X Position

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    SUB.W   #60,        D1          ; sub to move y pos up
    MOVE.L  D1,         FLYINGENEMY_Y     ; flying Enemy Y Position
    
    ; Initial Position for Health pack
    MOVE.L  #380,         HEALTH_X     ; health X Position
    MOVE.L  #90,         HEALTH_Y     ; health Y Position

    ; Initial health x y
    MOVE.B  maxAntHp,        antHealth

    ; reset draw and spawn health to 0
    MOVE.B  #00,        DRAW_HEALTHPACKS
    MOVE.B  #00,        SPAWN_HEALTHPACKS

    ; move attack x and y to 0,0
    MOVE.L  #0,         ATTACK_X
    MOVE.L  #0,         ATTACK_Y
    
    ; set booleans to false
    MOVE.B  #00,        CURRENTLYATTACKING
    MOVE.B  #00,        ENEMY_HIT
    MOVE.B  #00,        FLYENEMY_HIT

    ; set up the wave enemies count
    ADD.B   #enemyPerWave,         enemiesToDefeat
    MOVE.B  #0,         ENEMIES_DEFEATED
    MOVE.B  #0,         enemiesPassed
    MOVE.B  #4,         backToMapCount
    
    ; move the current hill no. hp into this hill hp
    MOVE.B  (a6),   hillHP
    
    MOVE.B     #100,    hillHP
    
    ; Init brute
    ; Initial Position for BRUTE
    EOR.L     D1,D1                      ; Clear contents of D1 
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #100,D1
    MOVE.L  D1,         BRUTE_X     

    EOR.L     D1,D1                      ; Clear contents of D1 
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         BRUTE_Y     

    ; reset brute bools
    MOVE.B      #0,     BRUTE_DEAD          
    MOVE.B      #0,     BRUTE_HIT           
    MOVE.B      #3,     BRUTE_HP            

    ; Enable the screen back buffer
    MOVE.B  #TC_DBL_BUF,D0          ; 92 Enables Double Buffer
    MOVE.B  #17,        D1          ; Combine Tasks
    TRAP	#15                     ; Trap (Perform action)
        
    ; Clear the screen 
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)

    bra gameloop

*-----------------------------------------------------------
* Subroutine    : Game
* Description   : Game including main GameLoop. GameLoop is like
* a while loop in that it runs forever until interupted
* (Input, Update, Draw). 
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
	CMP.b		#$02,d1			    * compare with 2/100ths
	BMI.s		wait_100ms			* loop if time not up yet
    rts

continueLoop:   ; after wait is done
    BSR     BATTLEINPUT                   ; Check Keyboard Input
    BSR     checkPaused             ; check if the game is paused
    BSR     UPDATE                  ; Update positions 
    BSR     IS_PLAYER_ON_GND        ; Check if player is on ground
    BSR     CHECK_COLLISIONS        ; Check for Collisions
    BSR     DRAWBATTLE                  ; Draw the Scene
                
    BRA     GAMELOOP    ; Loop back to GameLoop
    
*-----------------------------------------------------------
* Subroutine    : Input
* Description   : Process Keyboard Input
*-----------------------------------------------------------
BATTLEINPUT:
    move.l CURRENT_KEY, D0
    move.l D0,lastkey 

    MOVE.B  #TC_KEYCODE, D0             ; Check for pressed keys      
    MOVE.L  #runActionKeys, D1          ; Check for A, D, K, and Spacebar
    TRAP    #15                         ; Trap (Perform action)
    ; returns the FF in the position of the pressed keys in d1
    MOVE.L  D1,         CURRENT_KEY     ; Put Current Keys in Memory

    ; check if A is pressed
    BTST.L  #24,D1      ; bit test the 24th bit
    IF <NE> THEN        ; if its not 0 the move left
        BSR    MOVE_PLAYER_LEFT
    ENDI
    ; check if D is pressed
    MOVE.L  CURRENT_KEY, D1
    BTST.L  #16,D1
    IF <NE> THEN
        BSR    MOVE_PLAYER_RIGHT
    ENDI

    ; check if K is pressed
    MOVE.L  CURRENT_KEY, D1
    BTST.L  #8,D1
    IF <NE> THEN
        BSR    PERFORM_ATTACK
    ENDI

    ; check if space is pressed
    MOVE.L  CURRENT_KEY, D1
    BTST.L  #0,D1
    IF <NE> THEN
        BSR    JUMP
    ENDI

    ; seperate check for keys for other inputs that dont need to be check at the same time
    MOVE.B  #TC_KEYCODE, D0          ; Check for pressed keys
    MOVE.L  #$1B4a, D1                 ; check J
    TRAP    #15                     ; Trap (Perform action)
    MOVE.L  D1,         CURRENT_KEY     ; Put Current Key in Memory

    ; if j is pressed do thrown attack
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
; check if still paused
checkPaused:
    TST.B  isPaused
    BNE    stillPaused
    RTS

; go back to game loop after drawing
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
    CLR.L   D1                      ; Clear the contents of D1
    MOVE.L  ENEMY_X,    D1          ; Move the Enemy X Position to D1
    CMP.L   #00,        D1
    BLE     RESET_ENEMY_POSITION    ; Reset Enemy if off Screen

    ; Move flying enemy
    CLR.L   D1                            ; Clear the contents of D1
    MOVE.L  FLYINGENEMY_X,    D1          ; Move the flying Enemy X Position to D1
    CMP.L   #00,        D1
    BLE     RESET_FLYENEMY_POSITION       ; Reset flying Enemy if off Screen
    
    ; Move Brute enemy
    CLR.L   D1                      ; Clear the contents of D1
    MOVE.L  BRUTE_X,    D1          ; Move the brute X Position to D1
    CMP.L   #00,        D1
    BLE     RESET_BRUTE_POSITION    ; Reset Enemy if off Screen
    CMP.L   #660,D1
    IF <EQ> THEN
        BSR     PLAY_ROAR
    ENDI

    BSR     MOVE_ENEMIES             ; Move the Enemies

    ; move health
    BSR     MOVE_HEALTHPACK
    ; set cooldown over to true
    MOVE.B  #1, healthCooldownOver
    ; if the cooldown is not over then set it back to false
    CMP.W   #0,healthCooldown
    IF <GT> THEN
        SUBI.W  #1, healthCooldown
        MOVE.B  #0, healthCooldownOver
    ENDI

    ; check the attack cooldown
    BSR     CHECK_ATTACK_COOLDOWN

    ; check to see if the attack time is over
    TST.W   ATTACK_TIME
    BNE     ATTACK_TIME_SUB
    MOVE.B  #00,        CURRENTLYATTACKING
    MOVE.L  #480,        ATTACK_Y

    ; test if hill hurt timer is 0
    TST.B   hillHurtTimer
    IF <NE> THEN
        SUB.B   #1,hillHurtTimer
    ENDI

    RTS                             ; Return to subroutine  

; attack cooldown check
CHECK_ATTACK_COOLDOWN:
    CMP.W   #0, ATTACK_COOLDOWN
    BGT     ATTACK_COOLDOWN_SUB
    RTS

; subtract 2 from the timer
ATTACK_TIME_SUB:
    SUB.W   #02,        ATTACK_TIME
    RTS   
; subtract 2 from the cooldown
ATTACK_COOLDOWN_SUB:
    SUB.W   #02,        ATTACK_COOLDOWN
    RTS                            

; move the health
MOVE_HEALTHPACK:
    ; check if health is meant to spawn
    TST.B   SPAWN_HEALTHPACKS
    BEQ     CONTINUE
    
    ; check if health is on the ground
    CMP.L   #240,       HEALTH_Y
    BGE     CONTINUE

    ; else
    ADD.L   #01,        HEALTH_Y
    RTS

*-----------------------------------------------------------
* Subroutine    : Move Enemy
* Description   : Move Enemy Right to Left
*-----------------------------------------------------------
MOVE_ENEMIES:
    ; check to see which wave it is and update enemy positions accordingly
    CMP.W   #3,lvlIndex
    BEQ     MOVE_ENEMY_L4
    CMP.W   #2,lvlIndex
    BEQ     MOVE_ENEMY_L3
    CMP.W   #1,lvlIndex
    BEQ     MOVE_ENEMY_L2
    ; else, do wave 1 updates

    ; check if enemy is close to ant hill to start moving down
    CMP.L   #180,FLYINGENEMY_X
    IF <LE> THEN
        ADD.L   #1,FLYINGENEMY_Y
    ENDI

    ; move the enemies left
    SUB.L   #03,        FLYINGENEMY_X
    SUB.L   #02,        ENEMY_X     ; Move enemy by X Value
    ; if hardcore is active then increase the speed
    CMP.b   #5,         DIFFICULTY
    IF <EQ> THEN
        SUB.L  #HARD_INCREASE, FLYINGENEMY_X
        SUB.L  #HARD_INCREASE, ENEMY_X
    ENDI
    RTS

; move enemies a little faster and move brute this wave 
MOVE_ENEMY_L2:
    ; check for easy mode
    cmp.b   #easyDiff, DIFFICULTY
    IF <EQ> THEN 
        ; add 1 to the x to push them back
        ADD.L  #EASY_DECREASE, FLYINGENEMY_X
        ADD.L  #EASY_DECREASE, ENEMY_X
    ENDI
    ; move enemies left
    SUB.L   #4,         ENEMY_X
    SUB.L   #2,         FLYINGENEMY_X
    SUB.L   #1,         BRUTE_X

    ; move flying enemy faster if its dead
    CMP.L   #380,       FLYINGENEMY_Y
    IF <GE> THEN
        SUB.l   #02,    FLYINGENEMY_X
    ENDI

    ; move flying enemy lower if its near the hill
    CMP.L   #130,      FLYINGENEMY_X
    IF <LE> THEN
        ADD.L   #1,FLYINGENEMY_Y
    ENDI
 
    RTS

MOVE_ENEMY_L3:
    ; move flying enemy lower if its near the hill
    CMP.L   #130,      FLYINGENEMY_X
    IF <LE> THEN
        ADD.L   #3,FLYINGENEMY_Y
    ENDI

    ; check for easy mode
    cmp.b   #easyDiff, DIFFICULTY
    IF <EQ> THEN 
        ; add 1 to the x to push them back
        ADD.L  #EASY_DECREASE, FLYINGENEMY_X
        ADD.L  #EASY_DECREASE, ENEMY_X
    ENDI
    ; move enemies left
    SUB.L   #4,         ENEMY_X
    SUB.L   #5,         FLYINGENEMY_X
    SUB.L   #2,         BRUTE_X

    RTS

MOVE_ENEMY_L4:
    ; move flying enemy lower if its near the hill
    CMP.L   #130,      FLYINGENEMY_X
    IF <LE> THEN
        ADD.L   #4,FLYINGENEMY_Y
    ENDI


    ; check for easy mode
    cmp.b   #easyDiff, DIFFICULTY
    IF <EQ> THEN 
        ; add 1 to the x to push them back
        ADD.L  #EASY_DECREASE, FLYINGENEMY_X
        ADD.L  #EASY_DECREASE, ENEMY_X
    ENDI
    ; move enemies left
    SUB.L   #7,         FLYINGENEMY_X
    SUB.L   #5,         ENEMY_X
    SUB.L   #2,         BRUTE_X

    RTS


*-----------------------------------------------------------
* Subroutine    : Reset Enemies 
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
    IF <EQ> THEN                    ; enemy has not been hit
        BSR   damage_hill
    ENDI
    MOVE.B  #0,         ENEMY_HIT
    BSR     CHECK_WAVE_CLEARED      ; check if the wave is cleared

    RTS

RESET_FLYENEMY_POSITION:
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    SUB.W   #60,        D1
    MOVE.L  D1,         FLYINGENEMY_Y     ; fly Enemy Y Position

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #FLY_ENMY_W_INIT,D1
    MOVE.L  D1,         FLYINGENEMY_X     ; FLY Enemy X Position

    TST.B     FLYENEMY_HIT
    IF <EQ> THEN                        ; enemy has not been hit
        BSR   damage_hill
    ENDI
    MOVE.B  #0,         FLYENEMY_HIT
    BSR     CHECK_WAVE_CLEARED      ; check if the wave is cleared

    RTS

RESET_BRUTE_POSITION:
    CLR.L   D1       
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         BRUTE_Y     ; brute Enemy Y Position

    EOR.L  D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #100,D1
    MOVE.L  D1,         BRUTE_X     ; brute  X Position

    TST.B     BRUTE_DEAD
    IF <EQ> THEN                    ; big enemy has not been killed
        BSR   damage_hill
        BSR   damage_hill        
    ENDI
    MOVE.B  #3,         BRUTE_HP        ; reset brute hp
    MOVE.B  #0,         BRUTE_HIT       ; make brute not hit
    MOVE.B  #0,         BRUTE_DEAD      ; make brute alive

    BSR     CHECK_WAVE_CLEARED      ;  check if the wave is cleared

    RTS

; reset health position
RESET_HEALTH_POSITION:
    MOVE.B  #01,        DRAW_HEALTHPACKS
    MOVE.L  #90,        HEALTH_Y
    RTS

; check if the wave is cleared
CHECK_WAVE_CLEARED:
    ; add 1 to enemies passed
    ADDI.B  #1,         enemiesPassed
    ; compare enemies passed with the wave reqs
    MOVE.B  enemiesPassed,D1
    CMP.B   enemiesToDefeat,D1
    ; branch if its equal
    BEQ     WAVE_DEFEATED
    RTS

; damage the hill
damage_hill:
    sub.b  #10,hillHP
    CMP.b   #0,hillHP       ; if 0 then hill is dead
    BLE     HILL_LOST
    BSR     PLAY_HILLHURT
    move.b  #10,hillHurtTimer      ; set timer for damage color
    RTS

CONTINUE:
    RTS

; perform attack
PERFORM_ATTACK:
    ; if paused then skip
    TST.B  isPaused
    IF <NE> THEN
        RTS
    ENDI
    ; skip if still attacking
    TST.W    ATTACK_COOLDOWN
    BNE      CONTINUE
    
    ; set attack data
    MOVE.B   #01, CURRENTLYATTACKING
    MOVE.W   #50, ATTACK_TIME
    MOVE.W   #76, ATTACK_COOLDOWN

    ; move attack x and y to match player
    MOVE.L   PLAYER_X,ATTACK_X
    ADDI.L   #PLYR_W_INIT,ATTACK_X
    MOVE.L   PLAYER_Y,ATTACK_Y
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
    RTS                             ; Return to subroutine


DRAW_HILL:
    ; Set Pixel Colors
    MOVE.L  #brown,     D1
    jsr SetPenColour

    MOVE.L  #DIRT,     D1          ; Set Background color
    jsr setFillColour

    ; darken the hill if its hurt
    CMP.B   #0, hillHurtTimer
    IF <NE> THEN
     
        MOVE.L  #MIDBROWN,     D1          ; Set Background color
        jsr setFillColour
    ENDI

    ; leftmost chunk
    ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #30,   D3           
    MOVE.L  #120,   D4     
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)
    
    ; second chunk
     ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #60,   D3           
    MOVE.L  #135,   D4 
    
    
    MOVE.B  #87,        D0          ; Draw
    TRAP    #15                     ; Trap (Perform action)

    ; third chunk
     ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #80,   D3           
    MOVE.L  #150,   D4 
    
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)

    ; last chunk
     ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #100,   D3           
    MOVE.L  #200,   D4 
    
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)

    ; change color for top entrance
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

; draw hill entrance
DRAW_ENTRANCE:
    ; Set Pixel Colors
    MOVE.L  #DIRT,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #DIRT,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    ; if the hill is hurt then change the color
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
    MOVE.L  #1,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #5,   D3           
    MOVE.L  #210,   D4     
    
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


; draw the background
DRAW_BACKGROUND:
    ; fill the sky 
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

; draw the tree
DRAW_TREES:
    
    ; set pen width
    MOVE.L  #1,D1
    MOVE.L  #93,D0
    TRAP    #15
    
    ; Set Pixel Colors
    MOVE.L  #trunko,     D1          ; Set Background color
    jsr setPenColour

    MOVE.L  #TRUNKO,     D1
    jsr setFillColour
    
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
    jsr setFillColour
    
    MOVE.L  #340,D1
    MOVE.L  #160,D2
    MOVE.B  #89,D0
    TRAP    #15
   
   ; reset pen size
    MOVE.L  #1,D1
    MOVE.L  #93,D0
    TRAP    #15

   ; Set Pixel Colors
    MOVE.L  #green1,     D1          ; Set Background color
    jsr setPenColour

    MOVE.L  #GREEN1,     D1
    jsr setFillColour

    ; draw leaves 1
    MOVE.L  #303,D1
    MOVE.L  #33,D2
    MOVE.L  #391,D3
    MOVE.L  #118,D4
    MOVE.B  #87,D0
    TRAP    #15

    ; draw leaves 2
    MOVE.L  #GREEN2,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    MOVE.L  #338,D1
    MOVE.L  #42,D2
    MOVE.L  #427,D3
    MOVE.L  #133,D4
    MOVE.B  #87,D0
    TRAP    #15

    ; draw leaves 3
    MOVE.L  #GREEN3,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    MOVE.L  #284,D1
    MOVE.L  #65,D2
    MOVE.L  #368,D3
    MOVE.L  #150,D4
    MOVE.B  #87,D0
    TRAP    #15

    ; draw leaves 4
    MOVE.L  #GREEN4,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    MOVE.L  #340,D1
    MOVE.L  #76,D2
    MOVE.L  #423,D3
    MOVE.L  #158,D4
    MOVE.B  #87,D0
    TRAP    #15

    RTS

*-----------------------------------------------------------
* Subroutines   : Sound Load and Play
* Description   : Initialise game sounds into memory 
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

; songs
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

; stings
LOSS_STING_LOAD:
    LEA     LOSS_STING_WAV,   A1          ; Load Wav File into A1
    MOVE    #STING_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

WIN_STING_LOAD:
    LEA     WIN_STING_WAV,   A1          ; Load Wav File into A1
    MOVE    #STING_INDEX,D1          ; Assign it INDEX
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

PLAY_Sting:
    MOVE    #Sting_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

; stop song playing
STOP_sting:
    move #stinG_INDEX,d1
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

; draw the health 
DRAW_HEALTHPACK:

    TST.B   healthCooldownOver         ; check if the cooldown is over
    BEQ     DRAW_HEALTHPACK_DONE
    CMP.B   #00,     SPAWN_HEALTHPACKS  ; check if health pack is spawning
    BEQ     DRAW_HEALTHPACK_DONE
    CMP.B   #00,     DRAW_HEALTHPACKS   ; check if to draw the health
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

; subroutine if the healthpack is not meant to be drawn
DRAW_HEALTHPACK_DONE:
    MOVE.L  #-1, HEALTH_Y       ; move off screen
    MOVE.W  healthCooldown,D2   ; if the healthcooldown is over then move back on screen 
    CMP.W   #0,  D2
    IF <EQ> THEN
        BSR     RESET_HEALTH_POSITION
    ENDI
    RTS

; draw the ground
DRAW_FLOOR:
    ; Set Pixel Colors
    MOVE.L  #brown,     D1          ; Set Background color
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
    
; draw the dirt
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

; runs if hill hp went to 0
HILL_LOST:
    ; add enemies killed to total 
    clr.l   d3
    move.b  ENEMIES_DEFEATED, d3
    add.l   d3,totalKills

    ; if 0 hills were defended and its the last wave then go to game_over
    tst.b   totalHillsDefended
    IF <EQ> THEN
        cmp.w   #3,lvlIndex
        IF <EQ> THEN
            beq     GAME_OVER
        ENDI
    ENDI

    ; if its the last wave then go to win screen
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
    jsr drawBg

*------------ Print hill lost message--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0803,     D1          ; col 8, row 3 
    TRAP    #15                     ; Trap (Perform action)
    LEA     HILLLOST_MSG,A1        ; Game Over Message
    BSR     print

*------------print amount of enemies defeated--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0606,     D1          ; col 06, Row 06
    TRAP    #15                     ; Trap (Perform action)
    LEA     ENEMIESDEAD_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B06,     D1          ;col 27, Row 06
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVEQ.L #0,D1
    MOVE.B  ENEMIES_DEFEATED,D1         ; Move Score to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
*------------print hill health --------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0607,     D1          ;col 6, Row 07
    TRAP    #15                     ; Trap (Perform action)
    LEA     hillHP_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B07,     D1          ;col 27, Row 07
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
    MOVE.W  #$070C,     D1          ;col 7, Row 012
    TRAP    #15                     ; Trap (Perform action)
    LEA     BACK_TO_MAP_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feedF=
    TRAP    #15                     ; Trap (Perform action)

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1F0C,     D1          ;col 31, Row 012
    TRAP    #15                     ; Trap (Perform action)
    MOVEQ.L #0,D1
    MOVE.B  backToMapCount,D1         ; Move Score to D1.L
    MOVE.B  #03,        D0          ; Display number at D1.L
    TRAP    #15                     ; Trap (Perform action)

    
    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15
   
    ; delay time
    MOVE.b  #23,D0
    MOVE.L  #100,D1
    TRAP    #15

    ; sub from the counter
    SUB.B   #01,backToMapCount
    ; if the counter is 0 then go back to map
    TST.B   backToMapCount
    BEQ     mapNotFirstInit

    ; reset current health
    MOVE.l  #200,currentHealth
    bsr     initDraw
    ; back to top
    BRA     HILL_LOST

; game over screen
GAME_OVER:
    
    ; clear screen
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

    ; play loss sting
    jsr stop_sting
    jsr LOSS_STING_LOAD
    jsr play_sting


    MOVE.B  #TC_REDRAW,D0          ; Set Cursor Position
    TRAP	#15                     ; Trap (Perform action)

     ; delay time
    MOVE.b  #23,D0
    MOVE.L  #endGameDelay,D1
    TRAP    #15
    MOVE.b  #TC_CURSR_P,d0
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    trap    #15

    MOVE.L  #color1,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*

    jsr drawBg

    BRA     tallyScore

; wave cleared screen
WAVE_DEFEATED:

    ; add 1 to total hills defended
    addi.b #1, totalHillsDefended

    ; add kills to total
    clr.l   d3
    move.b  ENEMIES_DEFEATED, d3
    add.l   d3,totalKills

    ; if the hp of the hill is full add 1 to perfect defences
    move.b  hillHP,d3
    move.b  #maxHillHp,d4
    cmp.b   d4,d3
    IF <EQ> THEN
        addi.l  #1,perfectDefenceAmount
    ENDI

    ; if last wave go to win screen
    CMP.W   #3,lvlIndex
    BEQ     WIN_SCREEN
    
    ; clear screen
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
    jsr drawBg

*------------ Print wave defeated message--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0E03,     D1           ;col 14, Row 03
    TRAP    #15                     ; Trap (Perform action)
    LEA     HILLDEFENDED_MSG,A1        ; Game Over Message
    BSR     print

*------------print amount of enemies defeated--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0606,     D1          ;col 6, Row 06
    TRAP    #15                     ; Trap (Perform action)
    LEA     ENEMIESDEAD_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B06,     D1          ;col 27, Row 06
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVEQ.L #0,D1
    MOVE.B  ENEMIES_DEFEATED,D1         ; Move enemies killed to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
*------------print hill health --------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0607,     D1          ;col 6, Row 07
    TRAP    #15                     ; Trap (Perform action)
    LEA     hillHP_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B07,     D1          ;col 27, Row 07
    TRAP    #15                     ; Trap (Perform action)
    MOVEQ.L #0,D1
    MOVE.B  hillHP,D1               ; Move hill hp to D1.L
    MOVE.B  #03,        D0          ; Display number at D1.L
    TRAP    #15                     ; Trap (Perform action)
    
*------------ print back to map--------------*
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$03140000, D2
    TRAP    #15                     ; Trap (Perform action)


    ; Restart
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$070C,     D1          ;col 7, Row 012
    TRAP    #15                     ; Trap (Perform action)
    LEA     BACK_TO_MAP_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feedFeed
    TRAP    #15                     ; Trap (Perform action)

MAPCOUNTDOWN:
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1F0C,     D1           09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    MOVEQ.L #0,D1
    MOVE.B  backToMapCount,D1         ; Move counter to D1.L
    MOVE.B  #03,        D0          ; Display counter at D1.L
    TRAP    #15                     ; Trap (Perform action)
    
    ; redraw
    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15
   
    ; delay time
    MOVE.b  #23,D0
    MOVE.L  #100,D1
    TRAP    #15

    ; sub 1 from the counter
    SUB.B   #01,backToMapCount
    ; check if counter is done and branch to map
    TST.B   backToMapCount
    BEQ     mapNotFirstInit
    
    bsr     initDraw    
    MOVE.l  #200,currentHealth  ; reset current health
    ; back to top
    BRA     MAPCOUNTDOWN

; win screen after 4 rounds
WIN_SCREEN:
    ; set isWin to true
    move.b #1, isWin
    ; clear screen
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
    jsr drawBg
    
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0406,     D1           
    TRAP    #15                     ; Trap (Perform action)
    LEA     WIN_MSG,A1        ; Game Over Message
    BSR     print

    ; play loss sting
    jsr stop_sting
    jsr win_STING_LOAD
    jsr play_sting

    ; redraw
    MOVE.B  #TC_REDRAW,D0          ; Set Cursor Position
    TRAP	#15                     ; Trap (Perform action)

     ; delay time
    MOVE.b  #23,D0
    MOVE.L  #endGameDelay,D1
    TRAP    #15
    MOVE.b  #TC_CURSR_P,d0
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    trap    #15

    ; change text colour
    MOVE.L  #color1,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    jsr drawBg

    ; go to tally score
    BRA     tallyScore

*-----------------------------------------------------------
* Section       : Messages
* Description   : Messages to Print on Console, names should be
* self documenting
*-----------------------------------------------------------

ENEMIESDEAD_MSG         DC.B    'Enemies Defeated:', 0                  ; enemies defeated message
ENEMYCOUNT_MSG          DC.B    'Wave enemy count:', 0                  ; wave enemies message

HILLLOST_MSG            DC.B    'ANT HILL HAS BEEN OVERRUN!', 0         ; ant hill lost message
WIN_MSG                 DC.B    'THE ENEMY ARMY HAS BEEN DEFEATED!', 0  ; win message  
HILLDEFENDED_MSG        DC.B    'WAVE COMPLETE!', 0                     ; hill defended message
FALLENKINGDOM_MSG       DC.B    'YOUR ANT KINGDOM HAS FALLEN', 0        ; game over message
GAMEOVER_MSG            DC.B    'GAME OVER!', 0                         ; game over  
BACK_TO_MAP_MSG         DC.B    'Returning to map in ...', 0            ; return to map counter message

antHealth_MSG           DC.B    'Health : ',0                           ; health message
antsRem_MSG             DC.B    'Ants Remaining : ',0                   ; ants remaining message
hillHP_MSG              DC.B    'Hill Health: ',0                       ; hill health message
wave_MSG                DC.B    'Wave: ',0                              ; wave message

hillHP                  DC.B     100     
enemyPerWave            EQU      20            
IN_ENEMY                DC.B     00                  ; marker for if the player is in the enemy
IN_HPACK                DC.B     00                  ; marker for if the player is in the health pack
DRAW_HEALTHPACKS        DC.B     00                  ; marker for if the healthpacks are showing
SPAWN_HEALTHPACKS       DC.B     00                  ; marker for if the healthpacks are spawning


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

ENEMY_X         DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y         DS.L    01  ; Reserve Space for Enemy Y Position

HEALTH_X         DS.L    01  ; Reserve Space for Health+ X Position
HEALTH_Y         DS.L    01  ; Reserve Space for Health Y Position

FLYINGENEMY_X         DS.L    01  ; Reserve Space for Flying Enemy X Position
FLYINGENEMY_Y         DS.L    01  ; Reserve Space for Flying Enemy Y Position

BRUTE_X          DS.L        01
BRUTE_Y          DS.L        01

ENMY_W_INIT      EQU         27          ; Enemy initial Width
ENMY_H_INIT      EQU         13          ; Enemy initial Height

FLY_ENMY_W_INIT  EQU         30          ; flying Enemy initial Width
FLY_ENMY_H_INIT  EQU         13          ; Enemy flying initial Height

BRUTE_W_INIT     EQU         50          ; BRute Enemy initial Width
BRUTE_H_INIT     EQU         25          ; Brute Enemy initial Height

HEALTH_PACK_W    EQU         12          ; Enemy initial Width
HEALTH_PACK_H    EQU         12          ; Enemy initial Height

ENEMY_HIT           DC.B    00
FLYENEMY_HIT        DC.B    00
BRUTE_DEAD          DC.B    00
BRUTE_HIT           DC.B    00
BRUTE_HP            DC.b    03

JUMP_WAV        DC.B    'jump.wav',0        
GAMEOVER_WAV    DC.B    'gameOver.wav',0    
HITHURT_WAV     DC.B    'hitHurt.wav',0     
HIT_WAV         DC.B    'hit.wav',0         
POWERUP_WAV     DC.B    'powerUP.wav',0     
ROAR_WAV        DC.B    'roar-8-bit.wav',0 
HILLHURT_WAV        DC.B    'hillHurt.wav',0 

; songs
BATTLE_SONG_WAV DC.B    'antopia-battle.wav',0
MAP_SONG_WAV    DC.B    'antopia-map.wav',0
MENU_SONG_WAV   dc.B    'antopia-menu.wav',0

; STINGS
LOSS_STING_WAV  DC.b    'antopia-loss-sting.wav',0
WIN_STING_WAV   DC.B    'antopia-win-sting.wav',0
wordOrder dc.b 0

*-----------------------------------------------------------
* Section       : health data
* Description   : health related data
*-----------------------------------------------------------
antHealth         DC.B        03  ; reserves space for antHealth
antsRemaining     DC.B        00  ; reserves space for ants
maxHillHp         EQU        100  ; set max hill hp
maxAntHp          DC.B        3   ; reserve space for max ant health
maxRemainingAnts         DC.B        5  ; reserve space for max ants remaining
totalHillsDefended       DC.b        0  ; space for hills defended

*-----------------------------------------------------------
* Section       : melee attack 
* Description   : data for melee attack 
*-----------------------------------------------------------
CURRENTLYATTACKING   DC.B    00     
ATTACK_COOLDOWN      DC.W    00
ATTACK_TIME          DC.W    00
ATTACK_X             DC.L    00
ATTACK_Y             DC.L    00
ATTACK_HEIGHT        EQU     20
ATTACK_WIDTH         EQU     35 

ENEMIES_DEFEATED    DC.B    00
enemiesPassed       DC.b    00
enemiesToDefeat     DC.B    00

; all timers and cooldowns
respawnTime             dc.W        0
backToMapCount          dc.b        3
healthCooldown          DC.W        0
hillHurtTimer           dc.b        0
timer                   DC.L        0
healthCooldownOver      DC.B        0

*---------- END---------------*



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
