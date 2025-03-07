;ENEMY 1
enemy1x dc.l 0
enemy1y dc.l 20
;ENEMY 2
enemy2x dc.l 0
enemy2y dc.l 75
;ENEMY 3
enemy3x dc.l 0
enemy3y dc.l 130
;ENEMY 4
enemy4x dc.l 0
enemy4y dc.l 10

enemyIndex dc.b 1

; current enemy spawn
currentSpawnX ds.l 01
currentSpawnY ds.l 01

; ENEMY PATH FLAGS:
;   yflag0 hard-coded
;   NEXT FLAGS DUPED
;   first 2 x flags auto determined by hill y, one with offset
;   y flag determined by y post + offset
;   x flag same as first

;   LAYOUT:
;       yflagTop: manual
;       xFlag1: auto
;       xFlag2: xflag1 with offset
;       yFlagBottom: auto
yFlagTop dc.l 150
yFlagbottom dc.l 0

xFlagLeft dc.l 0
xFlagFarLeft dc.l 0
xFlagRight dc.l 0
xFlagFarRight dc.l 0

xFlagOffset equ 70
yFlagOffset equ 60

initStarts: ; start pos and flags
    ;FLAGS TO EDIT:
    ;   xflag1
    ;   xflag2
    ;   yflagbottom

    ; set enemy spawn to top middle
    move.l centerX, enemyStartX
    move.l #0, enemyStartY

    ; yFlagBottom
    move.l cellBrY, d3
    sub.l zoneHrad, d3
    sub.l #yFlagOffset, d3 ; Y middle of zone 2 in d3
    move.l d3, yFlagBottom ; set yFlagBottom

    ; left x flags
    move.l cellTlX, d2
    add.l zoneWrad, d2  ; X middle of zone 1 in d2
    move.l d2, xFlagLeft ; set xFlag1
    sub.L #xFlagOffset, d2
    move.l d2, xFlagFarLeft ; set xFlag2

    ; right x flags
    move.l cellBrX, d2
    sub.l zoneWrad, d2  ; X middle of zone 1 in d2
    move.l d2, xFlagRight ; set xFlag1
    add.L #xFlagOffset, d2
    move.l d2, xFlagFarRight ; set xFlag2
    
    rts


initAllEnemies:
    move.w lvlIndex, enemyDir

    clr.l enemy1x
    clr.l enemy1y

    clr.l enemy2x
    clr.l enemy2y

    clr.l enemy3x
    clr.l enemy3y

    clr.l enemy4x
    clr.l enemy4y

    clr.l d2 ; put screenw here
    clr.l d3 ; put screenh here
    move.w screenW, d2
    move.w screenH, d3

    move.l enemyStartX, enemy1x
    move.l enemyStartY, enemy1Y

    move.l enemyStartX, enemy2x
    move.l enemyStartY, enemy2Y

    move.l enemyStartX, enemy3x
    move.l enemyStartY, enemy3Y

    move.l enemyStartX, enemy4x
    move.l enemyStartY, enemy4Y

    ; add values
    sub.l #enemy1offset, enemy1y

    sub.l #enemy2offset, enemy2y

    sub.l #enemy3offset, enemy3y

    sub.l #enemy4offset, enemy4y
    rts

initAlltl: ; top left enemies
    move.l enemyStartX, enemy1x
    move.l enemyStartY, enemy1Y

    move.l enemyStartX, enemy2x
    move.l enemyStartY, enemy2Y

    move.l enemyStartX, enemy3x
    move.l enemyStartY, enemy3Y

    move.l enemyStartX, enemy4x
    move.l enemyStartY, enemy4Y

    ; add values
    sub.l #enemy1offset, enemy1y

    sub.l #enemy2offset, enemy2y

    sub.l #enemy3offset, enemy3y

    sub.l #enemy4offset, enemy4y

    rts
initAlltr:
    move.l d2, enemy1x
    ;clr.l enemy1y

    move.l d2, enemy2x
    ;clr.l enemy2y

    move.l d2, enemy3x
    ;clr.l enemy3y

    move.l d2, enemy4x
    ;clr.l enemy4y

    ; add values
    sub.l #enemy1offset, enemy1x
    add.l #enemy1offset, enemy1y

    sub.l #enemy2offset, enemy2x
    add.l #enemy2offset, enemy2y

    sub.l #enemy3offset, enemy3x
    add.l #enemy3offset, enemy3y

    sub.l #enemy4offset, enemy4x
    add.l #enemy4offset, enemy4y
    rts
initAllbr: ; enemies on the bottom need different offsets
    move.l d2, enemy1x
    move.l d3, enemy1y

    move.l d2, enemy2x
    move.l d3, enemy2y

    move.l d2, enemy3x
    move.l d3, enemy3y

    move.l d2, enemy4x
    move.l d3, enemy4y

    ; move yOffsets into d2, and half it

    ; add values
    move.l #enemy1offset, d2
    divu #2, d2
    sub.l #enemy1offset, enemy1x
    sub.l d2, enemy1y

    move.l #enemy2offset, d2
    divu #2, d2
    sub.l #enemy2offset, enemy2x
    sub.l d2, enemy2y

    move.l #enemy3offset, d2
    divu #2, d2
    sub.l #enemy3offset, enemy3x
    sub.l d2, enemy3y

    move.l #enemy4offset, d2
    divu #2, d2
    sub.l #enemy4offset, enemy4x
    sub.l d2, enemy4y
    rts
initAllBl:
    ;clr.l enemy1x
    move.l d3, enemy1y

    ;clr.l enemy2x
    move.l d3, enemy2y

    ;clr.l enemy3x
    move.l d3, enemy3y

    ;clr.l enemy4x
    move.l d3, enemy4y

    ; add values
    move.l #enemy1offset, d2
    divu #2, d2
    add.l #enemy1offset, enemy1x
    sub.l d2, enemy1y

    move.l #enemy2offset, d2
    divu #2, d2
    add.l #enemy2offset, enemy2x
    sub.l d2, enemy2y

    move.l #enemy3offset, d2
    divu #2, d2
    add.l #enemy3offset, enemy3x
    sub.l d2, enemy3y

    move.l #enemy4offset, d2
    divu #2, d2
    add.l #enemy4offset, enemy4x
    sub.l d2, enemy4y
    rts

processEnemies:
    move.w #1, enemyIndex
    bra processEnemiesLoop
processEnemiesLoop:
    jsr getCurrentEnemy
    jsr processEnemy
    jsr saveCurrentEnemy
    add.w #1, enemyIndex

    move.w enemyIndex, d2
    cmpi.w #5, d2
    bne processEnemiesLoop
    rts


getCurrentEnemy:
    move.w enemyIndex, d2
    cmpi.w #1, d2
    beq getEnemy1

    move.w enemyIndex, d2
    cmpi.w #2, d2
    beq getEnemy2

    move.w enemyIndex, d2
    cmpi.w #3, d2
    beq getEnemy3

    move.w enemyIndex, d2
    cmpi.w #4, d2
    beq getEnemy4
    rts
getEnemy1:
    move.l enemy1x, enemyX
    move.l enemy1y, enemyY
    rts
getEnemy2:
    move.l enemy2x, enemyX
    move.l enemy2y, enemyY
    rts
getEnemy3:
    move.l enemy3x, enemyX
    move.l enemy3y, enemyY
    rts
getEnemy4:
    move.l enemy4x, enemyX
    move.l enemy4y, enemyY
    rts

saveCurrentEnemy:
    move.w enemyIndex, d2
    cmpi.w #1, d2
    beq saveEnemy1

    move.w enemyIndex, d2
    cmpi.w #2, d2
    beq saveEnemy2

    move.w enemyIndex, d2
    cmpi.w #3, d2
    beq saveEnemy3

    move.w enemyIndex, d2
    cmpi.w #4, d2
    beq saveEnemy4
    rts

saveEnemy1:
    move.l enemyx, enemy1X
    move.l enemyy, enemy1Y
    rts
saveEnemy2:
    move.l enemyx, enemy2X
    move.l enemyy, enemy2Y
    rts
saveEnemy3:
    move.l enemyx, enemy3X
    move.l enemyy, enemy3Y
    rts
saveEnemy4:
    move.l enemyx, enemy4X
    move.l enemyy, enemy4Y
    rts

; ENEMY START POINTS
enemy1offset equ 0
enemy2offset equ 100
enemy3offset equ 200
enemy4offset equ 300

enemyStartX ds.l 01
enemyStartY ds.l 01

enemyXmove equ 2
enemyYmove equ 1

enemyDir dc.w 0