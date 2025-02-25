; this file contains cell data

; cell contains:
    ; big square boundary
    ; 2 square attack zones - top corners
    ; 1 square heal zone - bottom

initializeCell: ; initialize values for cell and zones

    ; this subroutine gathers top-left and bottom-right bounds for the cell,
    ; as well as each zone

    ; these bounds are used to draw and process

    ;--------RECTANGLE TRAP CODE:
    ; d1: top left X
    ; d2: top left Y

    ; d3: bottom right X
    ; d4: bottom right Y
    

    ;--------get cell bounds
    ; TL
    move.l centerX, d1      ; move centerX to d1
    sub.l cellXradius, d1     ; add/sub based on cell radius
    move.l d1, celltlX      ; save to relevant location

    move.l centerY, d1
    sub.l cellYradius, d1
    move.l d1, celltlY

    ; BR
    move.l centerX, d1
    add.l cellXradius, d1
    add.l playerH, d1
    move.l d1, cellbrX

    move.l centerY, d1
    add.l cellYradius, d1
    move.l d1, cellbrY


    ;--------get zone 1 bounds
    ; TL
    move.l celltlX, zone1tlX

    move.l celltlY, zone1tlY

    ; BR
    move.l zone1tlX, d1
    add.l zoneWidth, d1
    move.l d1, zone1brX

    move.l zone1tly, d1
    add.l zoneHeight, d1
    move.l d1, zone1brY


    ;--------get zone 2 bounds
    ; TL
    move.l cellbrX, d1
    sub.l zoneWidth, d1
    move.l d1, zone2tlX

    move.l celltlY, zone2tlY

    ; BR
    move.l cellbrx, zone2brX

    move.l celltlY, d1
    add.l zoneHeight, d1
    move.l d1, zone2brY


    ;--------get zone 3 bounds
    ;(ZONE 3 IS ON THE BOTTOM; FULL WIDTH OF CELL, REGULAR ZONE HEIGHT)
    ; TL
    move.l cellbrX, d1
    sub.l zoneWidth, d1
    move.l d1, zone3tlX

    move.l cellbrY, d1
    sub.l zoneHeight, d1
    move.l d1, zone3tlY

    ; BR
    move.l cellbrX, zone3brX

    move.l cellbrY, zone3brY

    rts

zone1collision:
    move.l playerX, d2
    move.l playerY, d3

    ; check x
    cmp.l zone1brX, d2
    bgt endCollision
    ; check y
    cmp.l zone1brY, d3
    bgt endCollision


    ; at this point, player is confirmed in zone 1
    lea zoneMsg, a1
    jsr print

    rts

zone2collision:
    move.l playerX, d2
    move.l playerY, d3

    ; check x
    cmp.l zone2tlX, d2
    blt endCollision
    ; check y
    cmp.l zone1brY, d3
    bgt endCollision

    lea zoneMsg, a1
    jsr print

    ; at this point, player is confirmed in zone 2

    rts

zone3collision:
    move.l playerX, d2
    move.l playerY, d3

    ; check x
    cmp.l zone3tlX, d2
    blt endCollision
    ; check y
    cmp.l zone3tlY, d3
    blt endCollision

    ; at this point, player is confirmed in zone 3

    move.w healTime, d5
    jsr checkIncrement
    bne endCollision
    jsr heal
    
    rts

endCollision:
    rts

;---------------cell top-left bounds
celltlX ds.l 01
celltlY ds.l 01
; cell bottom-right bounds
cellbrX ds.l 01
cellbrY ds.l 01

;---------------zone 1 top-left bounds
zone1tlX ds.l 01
zone1tlY ds.l 01
; zone 1 bottom-right bounds
zone1brX ds.l 01
zone1brY ds.l 01

;---------------zone 2 top-left bounds
zone2tlX ds.l 01
zone2tlY ds.l 01
; zone 2 bottom-right bounds
zone2brX ds.l 01
zone2brY ds.l 01

;---------------zone 3 top-left bounds
zone3tlX ds.l 01
zone3tlY ds.l 01
; zone 3 bottom-right bounds
zone3brX ds.l 01
zone3brY ds.l 01

; horizontal and vertical radius of main cell (half width)
cellXradius dc.l 80
cellYradius dc.l 70

; width of zone
zoneWidth dc.l 50
zoneHeight dc.l 35

zoneMsg dc.b 'IN ZONE',0


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
