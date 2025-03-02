    
checkPlayerEnemy:    
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
    LEA     PLAYER_X,   A1
    LEA     PLAYER_Y,   A2
    LEA     ENEMY_X,    A3
    LEA     ENEMY_Y,    A4
playerEnemyCol1:
    MOVE.L  (A1),   D1          ; Move Player X to D1
    ADD.L   #PLYR_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  (a3),    D2          ; Move Enemy X to D2
    CMP.L   D1,         D2          ; Do the Overlap ?
    BLE     playerEnemyCol2  ; Less than or Equal ?
    BRA      checkPlayerFlyingEnemy

playerEnemyCol2:     ; Check player is not  
    MOVE.L  (A1),   D1          ; Move Player X to D1
    ADD.L   #ENMY_W_INIT,D2          ; Set Enemy width X + Width
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     playerEnemyCol3  ; Less than or Equal
    BRA      checkPlayerFlyingEnemy  

playerEnemyCol3:     
    MOVE.L  (A2),   D1          ; Move Player Y to D1
    MOVE.L  (a4),    D2          ; Move Enemy Y to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BLE     playerEnemyCol4  ; Less than or Equal
    BRA      checkPlayerFlyingEnemy

playerEnemyCol4:     ; Less than or Equal ?
    ;ADD.B   PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     enemyCollision               ; Collision !
    BRA      checkPlayerFlyingEnemy

*--------------------Checking for flying enemy collision---------------------
checkPlayerFlyingEnemy:
    LEA     FLYINGENEMY_X,    A3
    LEA     FLYINGENEMY_Y,    A4
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
playerFlyEnemyCol1:
    MOVE.L  (a1),   D1
    ADD.L   #PLYR_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  (a3),    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     playerFlyEnemyCol2      ; Less than or Equal ?
    BRA     checkPlayerBruteCol

playerFlyEnemyCol2:           ; Check player is not  
    MOVE.L  (a1),   D1
    ADD.L   #FLY_ENMY_W_INIT,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     playerFlyEnemyCol3  ; Less than or Equal
    BRA     checkPlayerBruteCol

playerFlyEnemyCol3:     
    MOVE.L  (a2),   D1          ; Move Player Y to D1
    MOVE.L  (a4),    D2          ; Move Enemy Y to D2
    ADD.L   #FLY_ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     playerFlyEnemyCol4  ; Less than or Equal
    BRA     checkPlayerBruteCol

playerFlyEnemyCol4:     ; Less than or Equal ?
    ADD.B   #PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  (a4),    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     enemyCollision               ; Collision !
    BRA     checkPlayerBruteCol
*--------------------Checking for brute enemy collision---------------------
checkPlayerBruteCol:
    CMP.W   #0,     lvlIndex
    BEQ     checkPlayerHealthCol
    LEA     BRUTE_X,    A3
    LEA     BRUTE_Y,    A4
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
playerBruteCol1:
    MOVE.L  (a1),   D1
    ADD.L   #PLYR_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  (a3),    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     playerBruteCol2      ; Less than or Equal ?
    BRA     checkPlayerHealthCol

playerBruteCol2:           ; Check player is not  
    MOVE.L  (a1),   D1
    ADD.L   #BRUTE_W_INIT,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     playerBruteCol3  ; Less than or Equal
    BRA     checkPlayerHealthCol

playerBruteCol3:     
    MOVE.L  (a2),   D1          ; Move Player Y to D1
    MOVE.L  (a4),    D2          ; Move Enemy Y to D2
    ADD.L   #BRUTE_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     playerBruteCol4  ; Less than or Equal
    BRA     checkPlayerHealthCol

playerBruteCol4:     ; Less than or Equal ?
    ADD.B   #PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  (a4),    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     enemyCollision               ; Collision !
    BRA     checkPlayerHealthCol

*--------------------Checking for Health collision---------------------
checkPlayerHealthCol:
    CMP.B   #0,     DRAW_HEALTHPACKS
    BEQ     checkAttackEnemyCol
    
    LEA     HEALTH_X,    A3
    LEA     HEALTH_Y,    A4
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
playerHealthCol1:
    MOVE.L  (a1),   D1
    ADD.B   #PLYR_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  (a3),    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     playerHealthCol2      ; Less than or Equal ?
    BRA     checkAttackEnemyCol

playerHealthCol2:           ; Check player is not  
    MOVE.L  (a1),   D1
    ADD.L   #HEALTH_PACK_W,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     playerHealthCol3  ; Less than or Equal
    BRA     checkAttackEnemyCol
playerHealthCol3:     
    MOVE.L  (a2),   D1          ; Move Player Y to D1
    MOVE.L  (a4),    D2          ; Move Enemy Y to D2
    ADD.L   #HEALTH_PACK_H,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     playerHealthCol4  ; Less than or Equal
    BRA     checkAttackEnemyCol

playerHealthCol4:     ; Less than or Equal ?
    ADD.B   #PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  (a4),    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     HEALTH_COLLISION               ; Collision !
    BRA     checkAttackEnemyCol

*--------------------Checking for ATTACK collision---------------------
checkAttackEnemyCol:
    LEA     ATTACK_X, a1
    LEA     ATTACK_Y, a2
    LEA     ENEMY_X, a3
    LEA     ENEMY_Y, a4
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
ATTACK_X_LTE_TO_ENEMY_X_PLUS_W:
    MOVE.L  (a1),   D1
    ADD.L   #ATTACK_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  (a3),    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     ATTACK_PLUS_W_LTE_TO_ENMY_X      ; Less than or Equal ?
    BRA     CHECK_ATTACK_FLY_COLLISIONS

ATTACK_PLUS_W_LTE_TO_ENMY_X:           ; Check player is not  
    MOVE.L  (a1),   D1
    ADD.W   #ENMY_W_INIT,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     ATK_LTE_TO_ENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_ATTACK_FLY_COLLISIONS

ATK_LTE_TO_ENEMY_Y_PLUS_H:     
    MOVE.L  (a2),   D1          ; Move Player Y to D1
    MOVE.L  (a4),    D2          ; Move Enemy Y to D2
    ADD.W   #ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     ATK_PLUS_H_LTE_TO_ATTACK_Y  ; Less than or Equal
    BRA     CHECK_ATTACK_FLY_COLLISIONS

ATK_PLUS_H_LTE_TO_ATTACK_Y:     ; Less than or Equal ?
    ADD.L   #ATTACK_HEIGHT,D1          ; Add Player Height to D1
    MOVE.L  (a4),    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_COLLISION               ; Collision !
    BRA     CHECK_ATTACK_FLY_COLLISIONS

*--------------------Checking for ATTACK FLYING collision---------------------
CHECK_ATTACK_FLY_COLLISIONS:
    LEA     FLYINGENEMY_X,    A3
    LEA     FLYINGENEMY_Y,    A4
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
ATK_X_LTE_TO_FLYENEMY_X_PLUS_W:
    MOVE.L  (a1),   D1
    ADD.L   #ATTACK_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  (a3),    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     ATTACK_PLUS_W_LTE_TO_FLYENMY_X     ; Less than or Equal ?
    BRA     CHECK_ATTACK_BRUTE_COLLISIONS

ATTACK_PLUS_W_LTE_TO_FLYENMY_X:           ; Check player is not  
    MOVE.L  (A1),   D1
    ADD.W   #FLY_ENMY_W_INIT,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     ATK_LTE_TO_FLYENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_ATTACK_BRUTE_COLLISIONS

ATK_LTE_TO_FLYENEMY_Y_PLUS_H:     
    MOVE.L  (a2),   D1          ; Move Player Y to D1
    MOVE.L  (a4),    D2          ; Move Enemy Y to D2
    ADD.W   #FLY_ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     ATK_PLUS_H_LTE_TO_FLYENEMY_Y  ; Less than or Equal
    BRA     CHECK_ATTACK_BRUTE_COLLISIONS

ATK_PLUS_H_LTE_TO_FLYENEMY_Y:     ; Less than or Equal ?
    ADD.L   #ATTACK_HEIGHT,D1          ; Add Player Height to D1
    MOVE.L  (a4),    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_FLY_COLLISION               ; Collision !
    BRA     CHECK_ATTACK_BRUTE_COLLISIONS

*--------------------Checking for ATTACK BRUTE collision---------------------
CHECK_ATTACK_BRUTE_COLLISIONS:

    CMP.W   #0,     lvlIndex
    BEQ     CHECK_THROW_COLLISION
    LEA     BRUTE_X,    A3
    LEA     BRUTE_Y,    A4

    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
ATK_X_LTE_TO_BRUTE_X_PLUS_W:
    MOVE.L  (a1),   D1
    ADD.L   #ATTACK_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  (a3),    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     ATTACK_PLUS_W_LTE_TO_BRUTE_X     ; Less than or Equal ?
    BRA     CHECK_THROW_COLLISION

ATTACK_PLUS_W_LTE_TO_BRUTE_X:           ; Check player is not  
    MOVE.L  (a1),   D1
    ADD.L   #BRUTE_W_INIT,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     ATK_LTE_TO_BRUTE_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_THROW_COLLISION

ATK_LTE_TO_BRUTE_Y_PLUS_H:     
    MOVE.L  (a2),   D1          ; Move Player Y to D1
    MOVE.L  (a4),    D2          ; Move Enemy Y to D2
    ADD.L   #BRUTE_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     ATK_PLUS_H_LTE_TO_BRUTE_Y  ; Less than or Equal
    BRA     CHECK_THROW_COLLISION

ATK_PLUS_H_LTE_TO_BRUTE_Y:     ; Less than or Equal ?
    ADD.L   #ATTACK_HEIGHT,D1          ; Add Player Height to D1
    MOVE.L  (a4),    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_BRUTE_COLLISION               ; Collision !
    BRA     CHECK_THROW_COLLISION

*--------------------Checking for THROW collision---------------------
CHECK_THROW_COLLISION:
    LEA     THROW_X, a1
    LEA     THROW_Y, a2
    LEA     ENEMY_X, a3
    LEA     ENEMY_Y, a4
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
THROW_X_LTE_TO_ENEMY_X_PLUS_W:
    MOVE.L  (a1),   D1
    ADD.L   #THROW_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  (a3),    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     THROW_PLUS_W_LTE_TO_ENMY_X      ; Less than or Equal ?
    BRA     CHECK_THROW_FLY_COLLISIONS

THROW_PLUS_W_LTE_TO_ENMY_X:           ; Check player is not  
    MOVE.L  (a1),   D1
    ADD.W   #ENMY_W_INIT,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     TRW_LTE_TO_ENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_THROW_FLY_COLLISIONS

TRW_LTE_TO_ENEMY_Y_PLUS_H:     
    MOVE.L  (a2),   D1          ; Move Player Y to D1
    MOVE.L  (a4),    D2          ; Move Enemy Y to D2
    ADD.W   #ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     TRW_PLUS_H_LTE_TO_THROW_Y  ; Less than or Equal
    BRA     CHECK_THROW_FLY_COLLISIONS

TRW_PLUS_H_LTE_TO_THROW_Y:     ; Less than or Equal ?
    ADD.L   #THRW_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  (a4),    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_COLLISION               ; Collision !
    BRA     CHECK_THROW_FLY_COLLISIONS

*--------------------Checking for THROW FLYING collision---------------------
CHECK_THROW_FLY_COLLISIONS:
    LEA     FLYINGENEMY_X,    A3
    LEA     FLYINGENEMY_Y,    A4

    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
THROW_X_LTE_TO_FLYENEMY_X_PLUS_W:
    MOVE.L  (a1),   D1
    ADD.L   #THRW_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  (a3),    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     THROW_PLUS_W_LTE_TO_FLYENMY_X     ; Less than or Equal ?
    BRA     CHECK_THROW_BRUTE_COLLISIONS

THROW_PLUS_W_LTE_TO_FLYENMY_X:           ; Check player is not  
    MOVE.L  (a1),   D1
    ADD.W   #FLY_ENMY_W_INIT,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     TRW_LTE_TO_FLYENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_THROW_BRUTE_COLLISIONS

TRW_LTE_TO_FLYENEMY_Y_PLUS_H:     
    MOVE.L  (a2),   D1          ; Move Player Y to D1
    MOVE.L  (a4),    D2          ; Move Enemy Y to D2
    ADD.W   #FLY_ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     TRW_PLUS_H_LTE_TO_FLYENEMY_Y  ; Less than or Equal
    BRA     CHECK_THROW_BRUTE_COLLISIONS

TRW_PLUS_H_LTE_TO_FLYENEMY_Y:     ; Less than or Equal ?
    ADD.L   #THRW_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  (a4),    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_FLY_COLLISION               ; Collision !
    BRA     CHECK_THROW_BRUTE_COLLISIONS

*--------------------Checking for THROW BRUTE collision---------------------
CHECK_THROW_BRUTE_COLLISIONS:
    LEA     BRUTE_X,    A3
    LEA     BRUTE_Y,    A4
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
THROW_X_LTE_TO_BRUTE_X_PLUS_W:
    MOVE.L  (a1),   D1
    ADD.L   #THROW_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  (a3),    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     THROW_PLUS_W_LTE_TO_BRUTE_X     ; Less than or Equal ?
    BRA     COLLISION_CHECK_DONE

THROW_PLUS_W_LTE_TO_BRUTE_X:           ; Check player is not  
    MOVE.L  (a1),   D1
    ADD.L   #BRUTE_W_INIT,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     TRW_LTE_TO_BRUTE_Y_PLUS_H  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE

TRW_LTE_TO_BRUTE_Y_PLUS_H:     
    MOVE.L  (a2),   D1          ; Move Player Y to D1
    MOVE.L  (a4),    D2          ; Move Enemy Y to D2
    ADD.L   #BRUTE_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     TRW_PLUS_H_LTE_TO_BRUTE_Y  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE

TRW_PLUS_H_LTE_TO_BRUTE_Y:     ; Less than or Equal ?
    ADD.L   #THROW_HEIGHT,D1          ; Add Player Height to D1
    MOVE.L  (a4),    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_BRUTE_COLLISION               ; Collision !
    BRA     COLLISION_CHECK_DONE


*-------------------------------------------------------------*
*           Collision Done 
*
*--------------------------------------------------------------*

ATTACK_COLLISION:
    TST.B   ENEMY_HIT
    BNE     STILL_COLLIDED
    BSR     PLAY_HIT
    MOVE.L  #400, ENEMY_Y
    MOVE.B  #01,  ENEMY_HIT
    BSR     CHECK_ENEMIES_CLEARED
    RTS

ATTACK_FLY_COLLISION:
    TST.B   FLYENEMY_HIT
    BNE     STILL_COLLIDED
    BSR     PLAY_HIT
    MOVE.L  #400, FLYINGENEMY_Y
    MOVE.B  #01,  FLYENEMY_HIT
    BSR     CHECK_ENEMIES_CLEARED
    RTS

ATTACK_BRUTE_COLLISION:
    TST.B   BRUTE_HIT
    BNE     STILL_COLLIDED
    BSR     PLAY_HIT

    SUBQ.B  #1,BRUTE_HP
    TST.B   BRUTE_HP
    IF <EQ> THEN
        MOVE.L  #400, BRUTE_Y
        MOVE.B  #1,BRUTE_DEAD
        BSR     CHECK_ENEMIES_CLEARED
    ENDI

    MOVE.B  #01,  BRUTE_HIT
    RTS

CHECK_ENEMIES_CLEARED:
    ADDI.B  #1,         ENEMIES_DEFEATED
    MOVE.B  ENEMIES_DEFEATED,D1
    CMP.B   enemiesToDefeat,D1
    BEQ     WAVE_DEFEATED
    RTS

COLLISION_CHECK_DONE:               ; No Collision Update points
    CLR.B   IN_ENEMY
    CLR.B   BRUTE_HIT
    CLR.B   IN_HPACK
    CLR.L   D1
    MOVE.B  POINTS,    D1          ; Move points upgrade to D1
    ADD.L   PLAYER_SCORE,D1         ; Add to current player score
    MOVE.L  D1, PLAYER_SCORE        ; Update player score in memory
    RTS                             ; Return to subroutine


enemyCollision:
    CMP.B     #$01, IN_ENEMY
    BEQ     STILL_COLLIDED
    SUB.B   #1, antHealth
    MOVE.B  #$01, IN_ENEMY
    TST.B   antHealth
    BEQ     antKilled
    BSR     PLAY_HITHURT               ; Play Opps Wav
    CMP.B   #01, DRAW_HEALTHPACKS
    IF <NE> THEN    
        BSR RESET_HEALTH_POSITION
    ENDI

    MOVE.B  #01, DRAW_HEALTHPACKS 
    MOVE.B  #01, SPAWN_HEALTHPACKS 
    RTS                             ; Return to subroutine

antKilled:
    MOVE.B    #3, antHealth
    SUBQ.b    #1, antsRemaining
    TST.b     antsRemaining
    BEQ       GAME_OVER
    BSR     PLAY_HITHURT               ; Play Opps Wav
    BSR     DRAW_RESPAWN
    RTS

HEALTH_COLLISION:
    ; skip if still collided
    CMP.B     #$01, IN_HPACK
    BEQ     STILL_COLLIDED
    MOVE.b  maxAntHp,d1
    CMP.B     antHealth, d1
    BEQ     STILL_COLLIDED

    CMP.W   #0, healthCooldown
    IF <EQ> THEN
        MOVE.W  #500, healthCooldown
    ENDI

    BSR     PLAY_POWERUP               ; Play Opps Wav

    ADD.B   #1, antHealth
    CMP.B   #03, antHealth
    BGE     STOP_HPACK_SPAWN
    
    MOVE.B  #$01, IN_HPACK
    MOVE.L  #90, HEALTH_Y
    
    RTS

STOP_HPACK_SPAWN:
    MOVE.B  #00, DRAW_HEALTHPACKS
    MOVE.B  #00, SPAWN_HEALTHPACKS

    RTS

STILL_COLLIDED:
    RTS
    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
