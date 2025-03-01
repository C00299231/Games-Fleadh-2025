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
    add.l cellYoffset, d1
    sub.l cellYradius, d1
    move.l d1, celltlY

    ; BR
    move.l centerX, d1
    add.l cellXradius, d1
    add.l playerH, d1
    move.l d1, cellbrX

    move.l centerY, d1
    add.l cellYoffset, d1
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

    ;--------get zone 4 bounds
    ; TL
    move.l celltlX, d1
    move.l d1, zone4tlX

    move.l cellbrY, d1
    sub.l zoneHeight, d1
    move.l d1, zone4tlY

    ; BR
    move.l celltlX, d1
    add.l zoneWidth, d1
    move.l d1, zone4brX

    move.l cellbrY, d1
    move.l d1, zone4brY

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

    ; need to go to enemy thing
    bra initRun

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
    bra initRun

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
    bra initRun
    
    rts

zone4collision:
    move.l playerX, d2
    move.l playerY, d3

    ; check x
    cmp.l zone4brX, d2
    bgt endCollision
    ; check y
    cmp.l zone4tlY, d3
    blt endCollision

    ; at this point, player is confirmed in zone 4
    bra initRun

    rts

endCollision:
    rts

;-cell top-left bounds
celltlX ds.l 01
celltlY ds.l 01
; cell bottom-right bounds
cellbrX ds.l 01
cellbrY ds.l 01

;----------------------zone 1 top-left bounds
zone1tlX ds.l 01
zone1tlY ds.l 01
; zone 1 bottom-right bounds
zone1brX ds.l 01
zone1brY ds.l 01

;----------------------zone 2 top-left bounds
zone2tlX ds.l 01
zone2tlY ds.l 01
; zone 2 bottom-right bounds
zone2brX ds.l 01
zone2brY ds.l 01

;----------------------zone 3 top-left bounds
zone3tlX ds.l 01
zone3tlY ds.l 01
; zone 3 bottom-right bounds
zone3brX ds.l 01
zone3brY ds.l 01

;----------------------zone 4 top-left bounds
zone4tlX ds.l 01
zone4tlY ds.l 01
; zone 4 bottom-right bounds
zone4brX ds.l 01
zone4brY ds.l 01

; horizontal and vertical radius of main cell (half width)
cellXradius dc.l 100
cellYradius dc.l 80

; how lower from center it is
cellYoffset dc.l 60

; width of zone
zoneWidth dc.l 54
zoneHeight dc.l 44

zoneWrad dc.l 27
zoneHrad dc.l 22

zoneMsg dc.b 'IN ZONE',0

; colours
zone1pen ds.l 01
zone2pen ds.l 01
zone3pen ds.l 01
zone4pen ds.l 01
zone1shake dc.l 0
zone2shake dc.l 0
zone3shake dc.l 0
zone4shake dc.l 0

resetZonePens:
    tst affectHillTimer
    if <NE> then
        sub #1, affectHillTimer
        rts
    endi

    jsr processShakes

    move.l #brown, zone1pen
    move.l #brown, zone2pen
    move.l #brown, zone3pen
    move.l #brown, zone4pen
    rts

enterHill:
    rts



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
