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
    move.l enemyStartX, enemyX
    move.l enemyStartY, enemyY
    jsr endInitEnemy
    rts

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

;-------------------------------ENEMY TL
processEnemyTl:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcessNoCol
    
    move.l enemyX, d2
    move.l enemyY, d3

    ; first, check not reached flag0
    cmp.l yFlag0, d3
    if <lt> then
        ; go down
        add.l #enemyYspeed, enemyY
        bra endProcess
    endi
    
    ; then, check not reached xflag, but past yFlag
    cmp.l xFlag1, d2
    if <ge> then
        cmp.l yFlag0, d3
        if <le> then
            ; go left
            sub.l #enemyXspeed, enemyX
            bra endProcess
        endi
    endi

    ; finally, check not reached yflag1
    cmp.l yFlag1, d3
    if <lt> then
        ; go down
        add.l #enemyYspeed, enemyY
        bra endProcess
    endi

    ; past all flags, go right
    add.l #enemyXspeed, enemyX

    bra endProcess

;-------------------------------ENEMY TR
processEnemytr:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcessNoCol
    
    move.l enemyX, d2
    move.l enemyY, d3

    ; first, check not reached flag0
    cmp.l yFlag0, d3
    if <lt> then
        ; go down
        add.l #enemyYspeed, enemyY
        bra endProcess
    endi
    
    ; then, check not reached xflag, but past yFlag
    cmp.l xFlag2, d2
    if <le> then
        cmp.l yFlag0, d3
        if <le> then
            ; go right
            add.l #enemyXspeed, enemyX
            bra endProcess
        endi
    endi

    ; finally, check not reached yflag1
    cmp.l yFlag1, d3
    if <lt> then
        ; go down
        add.l #enemyYspeed, enemyY
        bra endProcess
    endi

    ; past all flags, go left
    sub.l #enemyXspeed, enemyX

    bra endProcess



;-------------------------------ENEMY BR
processEnemybr:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcessNoCol
    
    move.l enemyX, d2
    move.l enemyY, d3

    ; first, check not reached flag0
    cmp.l yFlag0, d3
    if <lt> then
        ; go down
        add.l #enemyYspeed, enemyY
        bra endProcess
    endi
    
    ; then, check not reached xflag, but past yFlag
    cmp.l xFlag2, d2
    if <le> then
        cmp.l yFlag0, d3
        if <le> then
            ; go right
            add.l #enemyXspeed, enemyX
            bra endProcess
        endi
    endi

    ; finally, check not reached yflag1
    cmp.l yFlag2, d3
    if <lt> then
        ; go down
        add.l #enemyYspeed, enemyY
        bra endProcess
    endi

    ; past all flags, go left
    sub.l #enemyXspeed, enemyX

    bra endProcess

;-------------------------------ENEMY BL
processEnemyBl:
    move.w enemyTime, d5
    jsr checkIncrement
    bne endProcessNoCol
    
    move.l enemyX, d2
    move.l enemyY, d3

    ; first, check not reached flag0
    cmp.l yFlag0, d3
    if <lt> then
        ; go down
        add.l #enemyYspeed, enemyY
        bra endProcess
    endi
    
    ; then, check not reached xflag, but past yFlag
    cmp.l xFlag1, d2
    if <ge> then
        cmp.l yFlag0, d3
        if <le> then
            ; go left
            sub.l #enemyXspeed, enemyX
            bra endProcess
        endi
    endi

    ; finally, check not reached yflag1
    cmp.l yFlag2, d3
    if <lt> then
        ; go down
        add.l #enemyYspeed, enemyY
        bra endProcess
    endi

    ; past all flags, go right
    add.l #enemyXspeed, enemyX

    bra endProcess

;-----------------------------------------------------COLLISION
enemyLeftColCheck:
    ; check y
    move.l cellTlY, d2
    cmp.l enemyY, d2
    bgt endColCheck

    ; check x
    move.l celltlX, d2
    cmp.l enemyX, d2
    bgt endColCheck

    jsr initEnemy
    rts

enemyRightColCheck:
    ; check y
    move.l cellTlY, d2
    cmp.l enemyY, d2
    bgt endColCheck


    ; check x
    move.l cellbrx, d2
    sub.l #enemyw, d2
    cmp.l enemyX, d2
    blt endColCheck

    jsr initEnemy
    rts
endColCheck:
    rts

;---------------OTHER STUFF
enemyCollide: ; enemy successfully reached the base
    jsr initEnemy
    rts

endProcess:
    jsr enemyColCheck
    rts
endProcessNoCol:
    rts
endCollide:
    rts
endInitEnemy:
    sub.l #enemyHalfH, enemyY
    sub.l #enemyHalfW, enemyX
    rts

enemyXspeed equ 3
enemyYspeed equ 2