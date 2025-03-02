titleArt0 dc.b 13,'                             _   _ _______          _       ',0
titleArt1 dc.b '                       /\   | \ | |__   __|        (_)      ',0
titleArt2 dc.b '                      /  \  |  \| |  | | ___  _ __  _  __ _ ',0
titleArt3 dc.b '                     / /\ \ | . ` |  | |/ _ \| "_ \| |/ _` |',0
titleArt4 dc.b '                    / ____ \| |\  |  | | (_) | |_) | | (_| |',0
titleArt5 dc.b '                   /_/    \_\_| \_|  |_|\___/| .__/|_|\__,_|',0
titleArt6 dc.b '                                             | |            ',0
titleArt7 dc.b '                                             |_|',0

printArt:
    lea titleArt0, a1
    jsr print
    lea titleArt1, a1
    jsr print
    lea titleArt2, a1
    jsr print
    lea titleArt3, a1
    jsr print

    lea titleArt4, a1
    jsr print
    lea titleArt5, a1
    jsr print
    lea titleArt6, a1
    jsr print
    lea titleArt7, a1
    jsr print
    rts

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~