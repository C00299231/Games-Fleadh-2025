    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
PLAYER_X_LTE_TO_ENEMY_X_PLUS_W:
    MOVE.L  PLAYER_X,   D1          ; Move Player X to D1
    ADD.B   PLAYER_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X,    D2          ; Move Enemy X to D2
    CMP.L   D1,         D2          ; Do the Overlap ?
    BLE     PLAYER_X_PLUS_W_LTE_TO_ENEMY_X  ; Less than or Equal ?
    BRA     CHECK_FLYENEMY_COLLISIONS

PLAYER_X_PLUS_W_LTE_TO_ENEMY_X:     ; Check player is not  
    MOVE.L  PLAYER_X,   D1          ; Move Player X to D1
    MOVE.L  ENEMY_X,    D2          ; Move Enemy X to D2
    ADD.W   ENEMY_WIDTH,D2          ; Set Enemy width X + Width
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     PLAYER_Y_LTE_TO_ENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_FLYENEMY_COLLISIONS  

PLAYER_Y_LTE_TO_ENEMY_Y_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y,    D2          ; Move Enemy Y to D2
    ;ADD.W   ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BLE     PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y  ; Less than or Equal
    BRA     CHECK_FLYENEMY_COLLISIONS

PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y:     ; Less than or Equal ?
    ADD.B   PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     ENEMYCOLLISION               ; Collision !
    BRA     CHECK_FLYENEMY_COLLISIONS

*--------------------Checking for flying enemy collision---------------------
CHECK_FLYENEMY_COLLISIONS:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
PLX_LTE_TO_FLYENEMY_X_PLUS_W:
    MOVE.L  PLAYER_X,   D1
    ADD.B   PLAYER_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  FLYINGENEMY_X,    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     PLX_PLUS_W_LTE_TO_FLYENEMY_X      ; Less than or Equal ?
    BRA     CHECK_HEALTH_COLLISIONS

PLX_PLUS_W_LTE_TO_FLYENEMY_X:           ; Check player is not  
    MOVE.L  PLAYER_X,   D1
    MOVE.L  FLYINGENEMY_X,    D2            ; Move Enemy X to D2
    ADD.W   FLYENEMY_WIDTH,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     PLY_LTE_TO_FLYENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_HEALTH_COLLISIONS

PLY_LTE_TO_FLYENEMY_Y_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  FLYINGENEMY_Y,    D2          ; Move Enemy Y to D2
    ADD.W   FLYENEMY_HEIGHT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     PLY_PLUS_H_LTE_TO_FLYENEMY_Y  ; Less than or Equal
    BRA     CHECK_HEALTH_COLLISIONS

PLY_PLUS_H_LTE_TO_FLYENEMY_Y:     ; Less than or Equal ?
    ADD.B   PLAYER_HEIGHT,D1          ; Add Player Height to D1
    MOVE.L  FLYINGENEMY_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ENEMYCOLLISION               ; Collision !
    BRA     CHECK_HEALTH_COLLISIONS

*--------------------Checking for Health collision---------------------
CHECK_HEALTH_COLLISIONS:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
PLX_LTE_TO_HEALTH_X_PLUS_W:
    MOVE.L  PLAYER_X,   D1
    ADD.B   PLAYER_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  HEALTH_X,    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     PLX_PLUS_W_LTE_TO_HEALTH_X      ; Less than or Equal ?
    BRA     CHECK_ATTACK_COLLISIONS

PLX_PLUS_W_LTE_TO_HEALTH_X:           ; Check player is not  
    MOVE.L  PLAYER_X,   D1
    MOVE.L  HEALTH_X,    D2            ; Move Enemy X to D2
    ADD.L   #HEALTH_PACK_W,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     PLY_LTE_TO_HEALTH_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_ATTACK_COLLISIONS
PLY_LTE_TO_HEALTH_Y_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  HEALTH_Y,    D2          ; Move Enemy Y to D2
    ADD.L   #HEALTH_PACK_H,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     PLY_PLUS_H_LTE_TO_HEALTH_Y  ; Less than or Equal
    BRA     CHECK_ATTACK_COLLISIONS

PLY_PLUS_H_LTE_TO_HEALTH_Y:     ; Less than or Equal ?
    ADD.B   PLAYER_HEIGHT,D1          ; Add Player Height to D1
    MOVE.L  HEALTH_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     HEALTH_COLLISION               ; Collision !
    BRA     CHECK_ATTACK_COLLISIONS

*--------------------Checking for ATTACK collision---------------------
CHECK_ATTACK_COLLISIONS:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
ATTACK_X_LTE_TO_ENEMY_X_PLUS_W:
    MOVE.L  ATTACK_X,   D1
    ADD.L   #ATTACK_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X,    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     ATTACK_PLUS_W_LTE_TO_ENMY_X      ; Less than or Equal ?
    BRA     CHECK_ATTACK_FLY_COLLISIONS

ATTACK_PLUS_W_LTE_TO_ENMY_X:           ; Check player is not  
    MOVE.L  ATTACK_X,   D1
    MOVE.L  ENEMY_X,    D2            ; Move Enemy X to D2
    ADD.W   ENEMY_WIDTH,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     ATK_LTE_TO_ENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_ATTACK_FLY_COLLISIONS

ATK_LTE_TO_ENEMY_Y_PLUS_H:     
    MOVE.L  ATTACK_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y,    D2          ; Move Enemy Y to D2
    ADD.W   ENEMY_HEIGHT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     ATK_PLUS_H_LTE_TO_ATTACK_Y  ; Less than or Equal
    BRA     CHECK_ATTACK_FLY_COLLISIONS

ATK_PLUS_H_LTE_TO_ATTACK_Y:     ; Less than or Equal ?
    ADD.L   #ATTACK_HEIGHT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_COLLISION               ; Collision !
    BRA     CHECK_ATTACK_FLY_COLLISIONS

*--------------------Checking for ATTACK FLYING collision---------------------
CHECK_ATTACK_FLY_COLLISIONS:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
ATK_X_LTE_TO_FLYENEMY_X_PLUS_W:
    MOVE.L  ATTACK_X,   D1
    ADD.L   #ATTACK_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  FLYINGENEMY_X,    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     ATTACK_PLUS_W_LTE_TO_FLYENMY_X     ; Less than or Equal ?
    BRA     CHECK_THROW_COLLISION

ATTACK_PLUS_W_LTE_TO_FLYENMY_X:           ; Check player is not  
    MOVE.L  ATTACK_X,   D1
    MOVE.L  FLYINGENEMY_X,    D2            ; Move Enemy X to D2
    ADD.W   FLYENEMY_WIDTH,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     ATK_LTE_TO_FLYENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_THROW_COLLISION

ATK_LTE_TO_FLYENEMY_Y_PLUS_H:     
    MOVE.L  ATTACK_Y,   D1          ; Move Player Y to D1
    MOVE.L  FLYINGENEMY_Y,    D2          ; Move Enemy Y to D2
    ADD.W   FLYENEMY_HEIGHT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     ATK_PLUS_H_LTE_TO_FLYENEMY_Y  ; Less than or Equal
    BRA     CHECK_THROW_COLLISION

ATK_PLUS_H_LTE_TO_FLYENEMY_Y:     ; Less than or Equal ?
    ADD.L   #ATTACK_HEIGHT,D1          ; Add Player Height to D1
    MOVE.L  FLYINGENEMY_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_FLY_COLLISION               ; Collision !
    BRA     CHECK_THROW_COLLISION

*--------------------Checking for THROW collision---------------------
CHECK_THROW_COLLISION:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
THROW_X_LTE_TO_ENEMY_X_PLUS_W:
    MOVE.L  THROW_X,   D1
    ADD.L   #THROW_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X,    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     THROW_PLUS_W_LTE_TO_ENMY_X      ; Less than or Equal ?
    BRA     CHECK_THROW_FLY_COLLISIONS

THROW_PLUS_W_LTE_TO_ENMY_X:           ; Check player is not  
    MOVE.L  THROW_X,   D1
    MOVE.L  ENEMY_X,    D2            ; Move Enemy X to D2
    ADD.W   ENEMY_WIDTH,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     TRW_LTE_TO_ENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_THROW_FLY_COLLISIONS

TRW_LTE_TO_ENEMY_Y_PLUS_H:     
    MOVE.L  THROW_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y,    D2          ; Move Enemy Y to D2
    ADD.W   ENEMY_HEIGHT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     TRW_PLUS_H_LTE_TO_THROW_Y  ; Less than or Equal
    BRA     CHECK_THROW_FLY_COLLISIONS

TRW_PLUS_H_LTE_TO_THROW_Y:     ; Less than or Equal ?
    ADD.L   #THRW_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_COLLISION               ; Collision !
    BRA     CHECK_THROW_FLY_COLLISIONS

*--------------------Checking for THROW FLYING collision---------------------
CHECK_THROW_FLY_COLLISIONS:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
THROW_X_LTE_TO_FLYENEMY_X_PLUS_W:
    MOVE.L  THROW_X,   D1
    ADD.L   #THRW_W_INIT,D1          ; Move Player Width to D1
    MOVE.L  FLYINGENEMY_X,    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     THROW_PLUS_W_LTE_TO_FLYENMY_X     ; Less than or Equal ?
    BRA     COLLISION_CHECK_DONE

THROW_PLUS_W_LTE_TO_FLYENMY_X:           ; Check player is not  
    MOVE.L  THROW_X,   D1
    MOVE.L  FLYINGENEMY_X,    D2            ; Move Enemy X to D2
    ADD.W   FLYENEMY_WIDTH,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     TRW_LTE_TO_FLYENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE

TRW_LTE_TO_FLYENEMY_Y_PLUS_H:     
    MOVE.L  THROW_Y,   D1          ; Move Player Y to D1
    MOVE.L  FLYINGENEMY_Y,    D2          ; Move Enemy Y to D2
    ADD.W   FLYENEMY_HEIGHT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     TRW_PLUS_H_LTE_TO_FLYENEMY_Y  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE

TRW_PLUS_H_LTE_TO_FLYENEMY_Y:     ; Less than or Equal ?
    ADD.L   #THRW_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  FLYINGENEMY_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_FLY_COLLISION               ; Collision !
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

CHECK_ENEMIES_CLEARED:
    ADDI.B  #1,         ENEMIES_DEFEATED
    MOVE.B  ENEMIES_DEFEATED,D1
    CMP.B   enemiesToDefeat,D1
    BEQ     WAVE_DEFEATED
    RTS

COLLISION_CHECK_DONE:               ; No Collision Update points
    CLR.B   IN_ENEMY
    CLR.B   IN_HPACK
    CLR.L   D1
    MOVE.B  POINTS,    D1          ; Move points upgrade to D1
    ADD.L   PLAYER_SCORE,D1         ; Add to current player score
    MOVE.L  D1, PLAYER_SCORE        ; Update player score in memory
    RTS                             ; Return to subroutine


ENEMYCOLLISION:
    CMP.B     #$01, IN_ENEMY
    BEQ     STILL_COLLIDED
    CMP.B   #01, DRAW_HEALTHPACKS
    BNE     RESET_HEALTH_POSITION
    MOVE.B  #01, DRAW_HEALTHPACKS 
    MOVE.B  #01, SPAWN_HEALTHPACKS 
    SUB.B   #1, antHealth
    MOVE.B  #$01, IN_ENEMY
    TST.B   antHealth
    BEQ     antKilled
    BSR     PLAY_HITHURT               ; Play Opps Wav
    RTS                             ; Return to subroutine

antKilled:
    MOVE.B    #3, antHealth
    SUBQ.b    #1, antsRemaining
    TST.b     antsRemaining
    BEQ       GAME_OVER
    BSR     PLAY_HITHURT               ; Play Opps Wav
    RTS     DRAW_RESPAWN
    RTS

HEALTH_COLLISION:
    CMP.B     #$01, IN_HPACK
    BEQ     STILL_COLLIDED
    MOVE.B  #00, DRAW_HEALTHPACKS
    BSR     PLAY_POWERUP               ; Play Opps Wav
    ADD.B   #1, antHealth
    CMP.B   #03, antHealth
    BGE     STOP_HPACK_SPAWN
    MOVE.B  #$01, IN_HPACK
    RTS