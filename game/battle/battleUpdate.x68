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
    ; first test if 3 ground enemies were defeated first
    tst.b  firstWaveTutAmt
    IF <EQ> THEN
        SUB.L   #02,        FLYINGENEMY_X
    ENDI

    SUB.L   #03,        ENEMY_X     ; Move enemy by X Value
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
        ADD.L  #EASY_DECREASE, BRUTE_X
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