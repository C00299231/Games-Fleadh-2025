;ENEMY 1
enemy1x dc.l 00
enemy1y dc.l 00

;ENEMY 2
enemy2x dc.l 50
enemy2y dc.l 50

;ENEMY 3
enemy3x dc.l 100
enemy3y dc.l 100

;ENEMY 4
enemy4x dc.l 150
enemy4y dc.l 150

enemyIndex dc.b 1

; current enemy spawn
currentSpawnX ds.l 01
currentSpawnY ds.l 01

initAllEnemies:
    move.l #0, enemy1x
    move.l #0, enemy1y

    move.l #50, enemy2x
    move.l #50, enemy2y

    move.l #100, enemy3x
    move.l #100, enemy3y

    move.l #150, enemy4x
    move.l #150, enemy4y

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

; current enemy dir
enemyDir dc.w 0000