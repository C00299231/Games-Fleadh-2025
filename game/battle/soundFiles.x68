*-----------------------------------------------------------
* Section       : Sounds
* Description   : Sound files, which are then loaded and given
* an address in memory, they take a longtime to process and play
* so keep the files small.
*-----------------------------------------------------------
GAMEOVER_INDEX   EQU             00          ; gameover sound
JMP_INDEX   EQU                  01          ; jump sound
HITHURT_INDEX  EQU               02          ; player hurt sound
POWERUP_INDEX  EQU               03          ; health up sound
HIT_INDEX  EQU                   05          ; enemy hit sound   
ROAR_INDEX  EQU                  06          ; brute enemy spawn sound
HILLHURT_INDEX  EQU              07          ; hill dmg sound
    
SONG_INDEX      equ              08          ; index for the current song
STING_INDEX     EQU              09          ; sound for end of round

JUMP_WAV        DC.B    'jump.wav',0        
GAMEOVER_WAV    DC.B    'gameOver.wav',0    
HITHURT_WAV     DC.B    'hitHurt.wav',0     
HIT_WAV         DC.B    'hit.wav',0         
POWERUP_WAV     DC.B    'powerUP.wav',0     
ROAR_WAV        DC.B    'roar-8-bit.wav',0 
HILLHURT_WAV        DC.B    'hillHurt.wav',0 

; songs
BATTLE_SONG_WAV DC.B    'antopia-battle.wav',0
MAP_SONG_WAV    DC.B    'antopia-map.wav',0
MENU_SONG_WAV   dc.B    'antopia-menu.wav',0

; STINGS
LOSS_STING_WAV  DC.b    'antopia-loss-sting.wav',0
WIN_STING_WAV   DC.B    'antopia-win-sting.wav',0
wordOrder dc.b 0

loadAllSounds:
    ; Initialise Sounds
    BSR     JUMP_LOAD
    BSR     GAMEOVER_LOAD
    BSR     HITHURT_LOAD
    BSR     POWERUP_LOAD
    BSR     HIT_LOAD
    BSR     ROAR_LOAD
    BSR     HILLHURT_LOAD
    rts