; this file contains enemy data

; variable data for current enemy
enemyX ds.l 01
enemyY ds.l 01
enemyHp ds.l 01

enemyDir ds.b 01
enemyActive ds.b 01

enemyMaxHp ds.l 01
enemyDamage ds.l 01

enemySetUp:
    move.l #20, enemyMaxHp
    move.l #20, enemyDamage
    rts

; enemy initialization: set position, health
; 3 longs require 3 mem locations
; call srts, then take values outside them

; GENERAL INIT/PROCESS
; before these srts are called, enemyDir is given a value
; 0: top
; 1: left
; 2: right
; 3: bottom

initEnemy:
    ; init based on which direction
    tst.b enemyDir
    beq initEnemyTop
    cmpi.b #1, enemyDir
    beq initEnemyLeft
    cmpi.b #2, enemyDir
    beq initEnemyRight
    cmpi.b #3, enemyDir
    beq initEnemyBottom

    ; no valid direction placed. just put enemy at the top
    bra initEnemyTop

processEnemy:
    tst.b enemyActive
    beq endProcess
    ; process based on direction
    tst.b enemyDir
    beq processEnemyTop
    cmpi.b #1, enemyDir
    beq processEnemyLeft
    cmpi.b #2, enemyDir
    beq processEnemyRight
    cmpi.b #3, enemyDir
    beq processEnemyBottom

    ; no valid direction placed. just put enemy at the top
    bra processEnemyTop

enemyColCheck:
    tst.b enemyActive
    beq endCollide

    ; colCheck based on direction
    tst.b enemyDir
    beq enemyTopColCheck
    cmpi.b #1, enemyDir
    beq enemyLeftColCheck
    cmpi.b #2, enemyDir
    beq enemyRightColCheck
    cmpi.b #3, enemyDir
    beq enemyBottomColCheck

    ; no valid direction. nothing we can do atp
    rts

;-------------------------------ENEMY TOP
initEnemyTop:
    move.l #0, enemyY
    move.l centerX, enemyX
    move.l enemyMaxHp, enemyHp
    jsr endInitEnemy
    rts
processEnemyTop:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcess

    add.l #1, enemyY

    bra endProcess

enemyTopColCheck:
    move.l celltlY, d2
    sub.l #enemyH, d2
    cmp.l enemyY, d2
    beq enemyCollide
    rts

;-------------------------------ENEMY LEFT
initEnemyLeft:
    move.l #0, enemyX
    move.l centerY, enemyY
    move.l enemyMaxHp, enemyHp
    jsr endInitEnemy
    rts
processEnemyLeft:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcess

    add.l #1, enemyX

    bra endProcess

enemyLeftColCheck:
    move.l celltlX, d2
    sub.l #enemyW, d2
    cmp.l enemyX, d2
    beq enemyCollide
    rts

;-------------------------------ENEMY RIGHT
initEnemyRight:
    clr.l d2
    move.w screenW, d2
    move.l d2, enemyX

    move.l centerY, enemyY
    move.l enemyMaxHp, enemyHp

    jsr endInitEnemy
    rts
processEnemyRight:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcess

    sub.l #1, enemyX

    bra endProcess

enemyRightColCheck:
    move.l celltlx, d2
    sub.l #enemyw, d2
    cmp.l enemyX, d2
    beq enemyCollide
    rts

;-------------------------------ENEMY BOTTOM
initEnemyBottom:
    clr.l d2
    move.w screenH, d2
    move.l d2, enemyY

    move.l centerX, enemyX
    move.l enemyMaxHp, enemyHp

    jsr endInitEnemy
    rts
processEnemyBottom:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcess

    sub.l #1, enemyY

    bra endProcess

enemyBottomColCheck:
    move.l celltlY, d2
    sub.l #enemyH, d2
    cmp.l enemyY, d2
    beq enemyCollide
    rts

;---------------OTHER STUFF
enemyCollide: ; enemy successfully reached the base
    jsr takeDmg
    move.b #0, enemyActive
    rts
enemyHit: ; enemy hit by a projectile
    rts

endProcess:
    rts
endCollide:
    rts
endInitEnemy:
    sub.l #enemyHalfH, enemyY
    sub.l #enemyHalfW, enemyX
    rts

