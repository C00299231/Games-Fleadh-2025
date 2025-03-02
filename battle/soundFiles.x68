*-----------------------------------------------------------
* Section       : Sounds
* Description   : Sound files, which are then loaded and given
* an address in memory, they take a longtime to process and play
* so keep the files small.
*-----------------------------------------------------------
JUMP_WAV        DC.B    'jump.wav',0        ; Jump Sound
GAMEOVER_WAV    DC.B    'gameOver.wav',0    ; Run Sound
HITHURT_WAV     DC.B    'hitHurt.wav',0     ; Collision Opps
HIT_WAV         DC.B    'hit.wav',0         ; Collision Opps
POWERUP_WAV     DC.B    'powerUP.wav',0     ; Collision Opps
LEVELCHANGE_WAV DC.B    'levelChange.wav',0 ; Collision Opps
ROAR_WAV        DC.B    'roar-8-bit.wav',0 ; Collision Opps
HILLHURT_WAV        DC.B    'hillHurt.wav',0 ; Collision Opps

; songs
BATTLE_SONG_WAV DC.B    'antopia-battle.wav',0
MAP_SONG_WAV    DC.B    'antopia-map.wav',0
MENU_SONG_WAV   dc.B    'antopia-menu.wav',0

loadAllSounds:
    ; Initialise Sounds
    BSR     JUMP_LOAD
    BSR     GAMEOVER_LOAD
    BSR     HITHURT_LOAD
    BSR     POWERUP_LOAD
    BSR     LVLCHANGE_LOAD
    BSR     HIT_LOAD
    BSR     ROAR_LOAD
    BSR     HILLHURT_LOAD
    rts