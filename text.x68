; intro
introMsg1 dc.b 'The ant kingdom is under siege by a rival colony!',0
                'We must defend ourselves against the invaders!',0

antsMsg1 dc.b 'You have ', 0
antsMsg2 dc.b ' ants remaining.', 0

; all ant lives depleted
noLivesMsg1 dc.b 'Your army is depleted.',0
                'With nobody to oppose them, the invaders overrun ',0
                'your kingdom and claim it for themselves.',0

; play message depending on how many hills you had at the end
fourHillsMsg dc.b   'Through your might and valour, you easily slew your opponents.',0
threeHillsMsg dc.b  'You fought well, and managed to thwart the invasion.',0
twoHillsMsg dc.b    'After a hard-fought battle, the invaders are defeated.',0
oneHillMsg dc.b     'With your kingdom nearing ruin, you finally defeated the invaders.',0

endWinMsg dc.b 'YOU WIN!',0
endLoseMsg dc.b 'YOU LOSE!',0
