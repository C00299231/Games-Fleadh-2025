; this file contains timing stuff

playerTime dc.w 10
enemyTime dc.w 5
healTime dc.w 40
enemySpawnTimer dc.w 2000

; /100 of second delay
scoreLineDelay dc.l 100

increment: ; D6 permanently used up
    add.w #1, d6
    rts

checkIncrement: ; d5 has been given check value
    move.w d6, d4 ; dont wanna mess up d6
    divu d5, d4
    move.w #0, d4
    swap d4
    ; d4 low word contains modulo
    ; compare w/ 0
    tst d4
    ; thingy contains whether they were equal
    rts

newDelay: ; milliseconds in d1.l
    move.l #100, d1
    move #23, d0
    trap #15
    rts