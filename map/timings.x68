; this file contains timing stuff

playerTime dc.w 5
enemyTime dc.w 5
healTime dc.w 40
enemySpawnTimer dc.w 2000

; /100 of second delay
scoreLineDelay dc.l 100

increment: ; D6 permanently used up
    
    move.b #8, d0
    trap #15
    
    ; d1 now contains time in 1/100 of second
    ;probably the same as previousTime

    cmp.l previousTime, d1
    if <eq> then
        add.l #1, d6
    endi

    bra endIncrement
endIncrement:
    move.l d1, previousTime
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

delay100:
    move.l #1, d1
    move #23, d0
    trap #15
    rts

previousTime dc.l 0