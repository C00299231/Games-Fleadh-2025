; this file contains timing stuff

playerTime dc.w 10
enemyTime dc.w 50
projTime dc.w 300
healTime dc.w 40

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