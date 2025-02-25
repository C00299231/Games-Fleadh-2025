increaseDifficulty:
    add.l #10, enemyMaxHp
    add.l #10, enemyDamage
    sub.l #10, enemyTime
    sub.w #800, enemySpawnTimer
    add.b 10, maxSpawns
    rts

initWave1:
    rts
    
initWave2:
    jsr increaseDifficulty
    rts

initWave3:
    jsr increaseDifficulty
    rts

processEnemies:

    ; for next time, increment enemy
    jsr incrementEnemyIndex
    rts

manage:
    rts

; go to next enemyIndex. if index is same as count, wrap to 0
incrementEnemyIndex:
    move.b enemyIndex, d2
    add.b #1, d2
    cmp.b enemyCount, d2
    beq wrapIndex
    move.b d2, enemyIndex
    rts
wrapIndex:
    move.b #0, d2
    move.b d2, enemyIndex
    rts

; ALL ENEMIES
enemiesX ds.l 10
enemiesY ds.l 10
enemiesHp ds.l 10
enemiesDir ds.b 10
enemiesActive ds.b 10

enemyCount dc.b 10
enemyIndex dc.b 0

; how many have been spawned this wave
enemiesSpawned dc.b 0
maxSpawns dc.b 15