; this file contains camera information

cameraOffsetX dc.l 160
cameraOffsetY dc.l 120
cameraX dc.l 0
cameraY dc.l 0
cameraZoom dc.w 02

isFollow dc.w 0

; get the position of the camera
followCam:
    tst isFollow
    beq endFollow

    move.l playerX, d2
    move.l playerY, d3
    sub.l cameraOffsetX, d2
    sub.l cameraOffsetY, d3

    move.l d2, cameraX
    move.l d3, cameraY
    RTS
endFollow:
    rts

; turn on or off follow
toggleFollow:
    move.w isFollow, d2
    tst.w d2
    beq turnOnFollow
    move.w #0, isFollow
    rts

turnOnFollow:
    move.w #1, isFollow
    rts