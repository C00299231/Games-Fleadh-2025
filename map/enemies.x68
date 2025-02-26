; this file contains enemy data

; variable data for current enemy
enemyX ds.l 01
enemyY ds.l 01

; enemy initialization: set position, health
; 3 longs require 3 mem locations
; call srts, then take values outside them

; GENERAL INIT/PROCESS
; before these srts are called, enemyDir is given a value
; 0: tl
; 1: tr
; 2: br
; 3: bl

initEnemy:
    ; move screen w and h into regs
    clr.l d2 ; put screenw here
    clr.l d3 ; put screenh here
    move.w screenW, d2
    move.w screenH, d3

    ; init based on which direction
    tst enemyDir
    beq initEnemytl

    cmpi #1, enemyDir
    beq initEnemytr

    cmpi #2, enemyDir
    beq initEnemybr

    cmpi #3, enemyDir
    beq initEnemyBl

    ; no valid direction placed. just put enemy at the top
    bra initEnemyTl

processEnemy:

    ; process based on direction
    tst enemyDir
    beq processEnemyTl
    cmpi #1, enemyDir
    beq processEnemytr
    cmpi #2, enemyDir
    beq processEnemybr
    cmpi #3, enemyDir
    beq processEnemyBl

    ; no valid direction placed. just put enemy at the top
    bra processEnemyTl

enemyColCheck:
    move.w enemyDir, d2
    ; colCheck based on direction
    cmpi #0, enemyDir
    beq enemyLeftColCheck

    cmpi #1, enemyDir
    beq enemyRightColCheck

    cmpi #2, enemyDir
    beq enemyRightColCheck

    cmpi #3, enemyDir
    beq enemyLeftColCheck

    ; no valid direction. nothing we can do atp
    rts

;-------------------------------ENEMY TOP
initEnemytl:
    move.l #0, enemyY
    move.l #0, enemyX
    jsr endInitEnemy
    rts
processEnemyTl:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcess

    add.l #enemyYmove, enemyY
    add.l #1, enemyX

    jsr enemyColCheck

    bra endProcess

;-------------------------------ENEMY LEFT
initEnemytr:
    move.l d2, enemyX
    move.l #0, enemyY
    jsr endInitEnemy
    rts
processEnemytr:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcess

    add.l #enemyYmove, enemyY
    sub.l #1, enemyX

    jsr enemyColCheck

    bra endProcess



;-------------------------------ENEMY RIGHT
initEnemybr:
    move.l d2, enemyX

    move.l d3, enemyY

    jsr endInitEnemy
    rts
processEnemybr:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcess

    sub.l #enemyYmove, enemyY
    sub.l #enemyXmove, enemyX

    jsr enemyColCheck

    bra endProcess

;-------------------------------ENEMY BOTTOM
initEnemyBl:
    move.l d3, enemyY

    move.l #0, enemyX

    jsr endInitEnemy
    rts
processEnemyBl:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcess

    sub.l #enemyYmove, enemyY
    add.l #enemyXmove, enemyX

    jsr enemyColCheck

    bra endProcess

;----------COLLISION
enemyLeftColCheck:
    move.l celltlX, d2
    ;sub.l #enemyW, d2
    cmp.l enemyX, d2
    ble enemyCollide
    rts

enemyRightColCheck:
    move.l cellbrx, d2
    sub.l #enemyw, d2
    cmp.l enemyX, d2
    bge enemyCollide
    rts

;---------------OTHER STUFF
enemyCollide: ; enemy successfully reached the base
    jsr initEnemy
    rts

endProcess:
    rts
endCollide:
    rts
endInitEnemy:
    sub.l #enemyHalfH, enemyY
    sub.l #enemyHalfW, enemyX
    rts

