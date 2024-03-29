#Untitled, AKG format, v1.0.

#Generated by Arkos Tracker 2.

Ep1BossMusic_Start:
Ep1BossMusic_StartDisarkGenerateExternalLabel:

Ep1BossMusic_DisarkByteRegionStart0:
	.ascii "AT20"
Ep1BossMusic_DisarkPointerRegionStart1:
	.word Ep1BossMusic_ArpeggioTable	#The address of the Arpeggio table.
	.word Ep1BossMusic_PitchTable	#The address of the Pitch table.
	.word Ep1BossMusic_InstrumentTable	#The address of the Instrument table.
	.word Ep1BossMusic_EffectBlockTable	#The address of the Effect Block table.
Ep1BossMusic_DisarkPointerRegionEnd1:


#The addresses of each Subsong:
Ep1BossMusic_DisarkPointerRegionStart2:
	.word Ep1BossMusic_Subsong0_Start
Ep1BossMusic_DisarkPointerRegionEnd2:

#Declares all the Arpeggios.
Ep1BossMusic_ArpeggioTable:
Ep1BossMusic_DisarkPointerRegionStart3:
Ep1BossMusic_DisarkPointerRegionEnd3:

#Declares all the Pitches.
Ep1BossMusic_PitchTable:
Ep1BossMusic_DisarkPointerRegionStart4:
Ep1BossMusic_DisarkPointerRegionEnd4:

#Declares all the Instruments.
Ep1BossMusic_InstrumentTable:
Ep1BossMusic_DisarkPointerRegionStart5:
	.word Ep1BossMusic_EmptyInstrument
	.word Ep1BossMusic_Instrument1
	.word Ep1BossMusic_Instrument2
	.word Ep1BossMusic_Instrument3
	.word Ep1BossMusic_Instrument4
	.word Ep1BossMusic_Instrument5
Ep1BossMusic_DisarkPointerRegionEnd5:

Ep1BossMusic_EmptyInstrument:
	.byte 0	#The speed (>0, 0 for 256).
Ep1BossMusic_EmptyInstrument_Loop:	.byte 0	#No Soft no Hard. Volume: 0. Noise? false.

	.byte 6	#Loop to silence.

Ep1BossMusic_Instrument1:
	.byte 1	#The speed (>0, 0 for 256).
	.byte 121	#Soft only. Volume: 15.
	.byte 105	#Additional data. Noise: 9. Pitch? true. Arp? true. Period? false.
	.byte 126	#Arpeggio.
	.word -5	#Pitch.

	.byte 121	#Soft only. Volume: 15.
	.byte 71	#Additional data. Noise: 7. Pitch? false. Arp? true. Period? false.
	.byte 82	#Arpeggio.

	.byte 121	#Soft only. Volume: 15.
	.byte 70	#Additional data. Noise: 6. Pitch? false. Arp? true. Period? false.
	.byte 124	#Arpeggio.

	.byte 121	#Soft only. Volume: 15.
	.byte 69	#Additional data. Noise: 5. Pitch? false. Arp? true. Period? false.
	.byte 85	#Arpeggio.

	.byte 113	#Soft only. Volume: 14.
	.byte 4	#Additional data. Noise: 4. Pitch? false. Arp? false. Period? false.

	.byte 97	#Soft only. Volume: 12.
	.byte 3	#Additional data. Noise: 3. Pitch? false. Arp? false. Period? false.

	.byte 81	#Soft only. Volume: 10.
	.byte 2	#Additional data. Noise: 2. Pitch? false. Arp? false. Period? false.

	.byte 65	#Soft only. Volume: 8.
	.byte 1	#Additional data. Noise: 1. Pitch? false. Arp? false. Period? false.

	.byte 177	#Soft only. Volume: 6. Volume only.

	.byte 177	#Soft only. Volume: 6. Volume only.

	.byte 6	#Loop to silence.

Ep1BossMusic_Instrument2:
	.byte 1	#The speed (>0, 0 for 256).
	.byte 224	#No Soft no Hard. Volume: 12. Noise? true.
	.byte 1	#Noise: 1.

	.byte 6	#Loop to silence.

Ep1BossMusic_Instrument3:
	.byte 1	#The speed (>0, 0 for 256).
	.byte 232	#No Soft no Hard. Volume: 13. Noise? true.
	.byte 5	#Noise: 5.

	.byte 121	#Soft only. Volume: 15.
	.byte 64	#Additional data. Noise: 0. Pitch? false. Arp? true. Period? false.
	.byte 1	#Arpeggio.

	.byte 209	#Soft only. Volume: 10. Volume only.

	.byte 233	#Soft only. Volume: 13. Volume only.

	.byte 225	#Soft only. Volume: 12. Volume only.

	.byte 209	#Soft only. Volume: 10. Volume only.

	.byte 193	#Soft only. Volume: 8. Volume only.

	.byte 177	#Soft only. Volume: 6. Volume only.

	.byte 161	#Soft only. Volume: 4. Volume only.

	.byte 0	#No Soft no Hard. Volume: 0. Noise? false.

	.byte 137	#Soft only. Volume: 1. Volume only.

	.byte 137	#Soft only. Volume: 1. Volume only.

	.byte 6	#Loop to silence.

Ep1BossMusic_Instrument4:
	.byte 1	#The speed (>0, 0 for 256).
	.byte 34	#Soft to Hard. Envelope: 10. Retrig ? false. Noise ? false.
	.byte 131	#Simple case. Ratio: 4

	.byte 34	#Soft to Hard. Envelope: 10. Retrig ? false. Noise ? false.
	.byte 131	#Simple case. Ratio: 4

	.byte 34	#Soft to Hard. Envelope: 10. Retrig ? false. Noise ? false.
	.byte 131	#Simple case. Ratio: 4

	.byte 34	#Soft to Hard. Envelope: 10. Retrig ? false. Noise ? false.
	.byte 131	#Simple case. Ratio: 4

	.byte 34	#Soft to Hard. Envelope: 10. Retrig ? false. Noise ? false.
	.byte 131	#Simple case. Ratio: 4

	.byte 34	#Soft to Hard. Envelope: 10. Retrig ? false. Noise ? false.
	.byte 131	#Simple case. Ratio: 4

	.byte 34	#Soft to Hard. Envelope: 10. Retrig ? false. Noise ? false.
	.byte 131	#Simple case. Ratio: 4

	.byte 34	#Soft to Hard. Envelope: 10. Retrig ? false. Noise ? false.
	.byte 131	#Simple case. Ratio: 4

	.byte 34	#Soft to Hard. Envelope: 10. Retrig ? false. Noise ? false.
	.byte 131	#Simple case. Ratio: 4

	.byte 6	#Loop to silence.

Ep1BossMusic_Instrument5:
	.byte 1	#The speed (>0, 0 for 256).
Ep1BossMusic_Instrument5_Loop:	.byte 249	#Soft only. Volume: 15. Volume only.

	.byte 7	#Loop.
Ep1BossMusic_DisarkWordForceReference6:
	.word Ep1BossMusic_Instrument5_Loop	#Loop here.


#The indexes of the effect blocks used by this song.
Ep1BossMusic_EffectBlockTable:
Ep1BossMusic_DisarkPointerRegionStart7:
	.word Ep1BossMusic_EffectBlock_P5P15P20P128P0	#Index 0
	.word Ep1BossMusic_EffectBlock_P5P15P20P160P0	#Index 1
	.word Ep1BossMusic_EffectBlock_P5P15P20P192P0	#Index 2
	.word Ep1BossMusic_EffectBlock_P5P15P20P224P0	#Index 3
	.word Ep1BossMusic_EffectBlock_P5P0P20P128P0	#Index 4
	.word Ep1BossMusic_EffectBlock_P5P0P20P160P0	#Index 5
	.word Ep1BossMusic_EffectBlock_P5P0P20P192P0	#Index 6
	.word Ep1BossMusic_EffectBlock_P5P0P20P224P0	#Index 7
	.word Ep1BossMusic_EffectBlock_P5P15P20P32P0	#Index 8
	.word Ep1BossMusic_EffectBlock_P5P15P20P64P0	#Index 9
	.word Ep1BossMusic_EffectBlock_P5P15P20P96P0	#Index 10
	.word Ep1BossMusic_EffectBlock_P5P0P20P32P0	#Index 11
	.word Ep1BossMusic_EffectBlock_P5P0P20P64P0	#Index 12
	.word Ep1BossMusic_EffectBlock_P5P0P20P96P0	#Index 13
	.word Ep1BossMusic_EffectBlock_P4P0	#Index 14
	.word Ep1BossMusic_EffectBlock_P4P15	#Index 15
Ep1BossMusic_DisarkPointerRegionEnd7:

Ep1BossMusic_EffectBlock_P4P0:
	.byte 4, 0
Ep1BossMusic_EffectBlock_P4P15:
	.byte 4, 15
Ep1BossMusic_EffectBlock_P5P15P20P128P0:
	.byte 5, 15, 20, 128, 0
Ep1BossMusic_EffectBlock_P5P15P20P160P0:
	.byte 5, 15, 20, 160, 0
Ep1BossMusic_EffectBlock_P5P15P20P192P0:
	.byte 5, 15, 20, 192, 0
Ep1BossMusic_EffectBlock_P5P15P20P224P0:
	.byte 5, 15, 20, 224, 0
Ep1BossMusic_EffectBlock_P5P0P20P128P0:
	.byte 5, 0, 20, 128, 0
Ep1BossMusic_EffectBlock_P5P0P20P160P0:
	.byte 5, 0, 20, 160, 0
Ep1BossMusic_EffectBlock_P5P0P20P192P0:
	.byte 5, 0, 20, 192, 0
Ep1BossMusic_EffectBlock_P5P0P20P224P0:
	.byte 5, 0, 20, 224, 0
Ep1BossMusic_EffectBlock_P5P15P20P32P0:
	.byte 5, 15, 20, 32, 0
Ep1BossMusic_EffectBlock_P5P15P20P64P0:
	.byte 5, 15, 20, 64, 0
Ep1BossMusic_EffectBlock_P5P15P20P96P0:
	.byte 5, 15, 20, 96, 0
Ep1BossMusic_EffectBlock_P5P0P20P32P0:
	.byte 5, 0, 20, 32, 0
Ep1BossMusic_EffectBlock_P5P0P20P64P0:
	.byte 5, 0, 20, 64, 0
Ep1BossMusic_EffectBlock_P5P0P20P96P0:
	.byte 5, 0, 20, 96, 0

Ep1BossMusic_DisarkByteRegionEnd0:

#Subsong 0
#----------------------
Ep1BossMusic_Subsong0_DisarkByteRegionStart0:
Ep1BossMusic_Subsong0_Start:
	.byte 2	#ReplayFrequency (0=12.5hz, 1=25, 2=50, 3=100, 4=150, 5=300).
	.byte 0	#Digichannel (0-2).
	.byte 1	#PSG count (>0).
	.byte 1	#Loop start index (>=0).
	.byte 12	#End index (>=0).
	.byte 6	#Initial speed (>=0).
	.byte 19	#Base note index (>=0).

Ep1BossMusic_Subsong0_Linker:
Ep1BossMusic_Subsong0_DisarkPointerRegionStart1:
#Position 0
	.word Ep1BossMusic_Subsong0_Track0
	.word Ep1BossMusic_Subsong0_Track1
	.word Ep1BossMusic_Subsong0_Track0
	.word Ep1BossMusic_Subsong0_LinkerBlock0

#Position 1
Ep1BossMusic_Subsong0_Linker_Loop:
	.word Ep1BossMusic_Subsong0_Track0
	.word Ep1BossMusic_Subsong0_Track5
	.word Ep1BossMusic_Subsong0_Track3
	.word Ep1BossMusic_Subsong0_LinkerBlock1

#Position 2
	.word Ep1BossMusic_Subsong0_Track0
	.word Ep1BossMusic_Subsong0_Track5
	.word Ep1BossMusic_Subsong0_Track3
	.word Ep1BossMusic_Subsong0_LinkerBlock1

#Position 3
	.word Ep1BossMusic_Subsong0_Track2
	.word Ep1BossMusic_Subsong0_Track5
	.word Ep1BossMusic_Subsong0_Track3
	.word Ep1BossMusic_Subsong0_LinkerBlock1

#Position 4
	.word Ep1BossMusic_Subsong0_Track2
	.word Ep1BossMusic_Subsong0_Track5
	.word Ep1BossMusic_Subsong0_Track3
	.word Ep1BossMusic_Subsong0_LinkerBlock1

#Position 5
	.word Ep1BossMusic_Subsong0_Track4
	.word Ep1BossMusic_Subsong0_Track5
	.word Ep1BossMusic_Subsong0_Track3
	.word Ep1BossMusic_Subsong0_LinkerBlock1

#Position 6
	.word Ep1BossMusic_Subsong0_Track4
	.word Ep1BossMusic_Subsong0_Track5
	.word Ep1BossMusic_Subsong0_Track3
	.word Ep1BossMusic_Subsong0_LinkerBlock1

#Position 7
	.word Ep1BossMusic_Subsong0_Track6
	.word Ep1BossMusic_Subsong0_Track5
	.word Ep1BossMusic_Subsong0_Track3
	.word Ep1BossMusic_Subsong0_LinkerBlock1

#Position 8
	.word Ep1BossMusic_Subsong0_Track6
	.word Ep1BossMusic_Subsong0_Track5
	.word Ep1BossMusic_Subsong0_Track3
	.word Ep1BossMusic_Subsong0_LinkerBlock1

#Position 9
	.word Ep1BossMusic_Subsong0_Track4
	.word Ep1BossMusic_Subsong0_Track5
	.word Ep1BossMusic_Subsong0_Track3
	.word Ep1BossMusic_Subsong0_LinkerBlock1

#Position 10
	.word Ep1BossMusic_Subsong0_Track4
	.word Ep1BossMusic_Subsong0_Track5
	.word Ep1BossMusic_Subsong0_Track3
	.word Ep1BossMusic_Subsong0_LinkerBlock1

#Position 11
	.word Ep1BossMusic_Subsong0_Track6
	.word Ep1BossMusic_Subsong0_Track5
	.word Ep1BossMusic_Subsong0_Track3
	.word Ep1BossMusic_Subsong0_LinkerBlock1

#Position 12
	.word Ep1BossMusic_Subsong0_Track9
	.word Ep1BossMusic_Subsong0_Track7
	.word Ep1BossMusic_Subsong0_Track8
	.word Ep1BossMusic_Subsong0_LinkerBlock1

Ep1BossMusic_Subsong0_DisarkPointerRegionEnd1:
	.word 0	#Loop.
Ep1BossMusic_Subsong0_DisarkWordForceReference2:
	.word Ep1BossMusic_Subsong0_Linker_Loop

Ep1BossMusic_Subsong0_LinkerBlock0:
	.byte 24	#Height.
	.byte 0	#Transposition 0.
	.byte 0	#Transposition 1.
	.byte 0	#Transposition 2.
Ep1BossMusic_Subsong0_DisarkWordForceReference3:
	.word Ep1BossMusic_Subsong0_SpeedTrack0	#SpeedTrack address.
Ep1BossMusic_Subsong0_DisarkWordForceReference4:
	.word Ep1BossMusic_Subsong0_EventTrack0	#EventTrack address.
Ep1BossMusic_Subsong0_LinkerBlock1:
	.byte 32	#Height.
	.byte 0	#Transposition 0.
	.byte 0	#Transposition 1.
	.byte 0	#Transposition 2.
Ep1BossMusic_Subsong0_DisarkWordForceReference5:
	.word Ep1BossMusic_Subsong0_SpeedTrack0	#SpeedTrack address.
Ep1BossMusic_Subsong0_DisarkWordForceReference6:
	.word Ep1BossMusic_Subsong0_EventTrack0	#EventTrack address.

Ep1BossMusic_Subsong0_Track0:
	.byte 61, 127	#Waits for 128 lines.


Ep1BossMusic_Subsong0_Track1:
	.byte 191
	.byte 12	#Escape note (12).
	.byte 5	#New Instrument (5).
	.byte 61, 6	#Waits for 7 lines.

	.byte 63
	.byte 14	#Escape note (14).
	.byte 61, 6	#Waits for 7 lines.

	.byte 63
	.byte 16	#Escape note (16).
	.byte 61, 127	#Waits for 128 lines.


Ep1BossMusic_Subsong0_Track2:
	.byte 237
	.byte 3	#New Instrument (3).
	.byte 14	#Index to an effect block.
	.byte 60	#Waits for 1 line.

	.byte 45
	.byte 60	#Waits for 1 line.

	.byte 50
	.byte 60	#Waits for 1 line.

	.byte 45
	.byte 60	#Waits for 1 line.

	.byte 45
	.byte 60	#Waits for 1 line.

	.byte 45
	.byte 60	#Waits for 1 line.

	.byte 52
	.byte 60	#Waits for 1 line.

	.byte 50
	.byte 60	#Waits for 1 line.

	.byte 45
	.byte 60	#Waits for 1 line.

	.byte 45
	.byte 60	#Waits for 1 line.

	.byte 52
	.byte 60	#Waits for 1 line.

	.byte 45
	.byte 60	#Waits for 1 line.

	.byte 45
	.byte 55
	.byte 50
	.byte 46
	.byte 50
	.byte 48
	.byte 52
	.byte 50
	.byte 61, 127	#Waits for 128 lines.


Ep1BossMusic_Subsong0_Track3:
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 21
	.byte 21
	.byte 21
	.byte 21
	.byte 21
	.byte 21
	.byte 21
	.byte 61, 127	#Waits for 128 lines.


Ep1BossMusic_Subsong0_Track4:
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 178
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 180
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 178
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 180
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 147
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 55
	.byte 50
	.byte 46
	.byte 50
	.byte 48
	.byte 52
	.byte 50
	.byte 61, 127	#Waits for 128 lines.


Ep1BossMusic_Subsong0_Track5:
	.byte 164
	.byte 3	#New Instrument (3).
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 38
	.byte 38
	.byte 38
	.byte 38
	.byte 38
	.byte 38
	.byte 38
	.byte 38
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 40
	.byte 40
	.byte 40
	.byte 40
	.byte 40
	.byte 40
	.byte 40
	.byte 40
	.byte 61, 127	#Waits for 128 lines.


Ep1BossMusic_Subsong0_Track6:
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 178
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 180
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 178
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 180
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 55
	.byte 50
	.byte 46
	.byte 50
	.byte 48
	.byte 52
	.byte 50
	.byte 61, 127	#Waits for 128 lines.


Ep1BossMusic_Subsong0_Track7:
	.byte 164
	.byte 3	#New Instrument (3).
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 38
	.byte 38
	.byte 38
	.byte 38
	.byte 38
	.byte 38
	.byte 38
	.byte 38
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 36
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 21
	.byte 21
	.byte 21
	.byte 21
	.byte 21
	.byte 21
	.byte 168
	.byte 3	#New Instrument (3).
	.byte 61, 127	#Waits for 128 lines.


Ep1BossMusic_Subsong0_Track8:
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 149
	.byte 1	#New Instrument (1).
	.byte 157
	.byte 2	#New Instrument (2).
	.byte 232
	.byte 5	#New Instrument (5).
	.byte 15	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 11	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 9	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 13	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 0	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 5	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 2	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 7	#Index to an effect block.
	.byte 61, 127	#Waits for 128 lines.


Ep1BossMusic_Subsong0_Track9:
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 178
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 180
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 178
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 180
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 173
	.byte 3	#New Instrument (3).
	.byte 145
	.byte 4	#New Instrument (4).
	.byte 232
	.byte 5	#New Instrument (5).
	.byte 14	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 8	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 12	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 10	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 4	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 1	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 6	#Index to an effect block.
	.byte 124	#No note, but effects.
	.byte 3	#Index to an effect block.
	.byte 61, 127	#Waits for 128 lines.


#The speed tracks
Ep1BossMusic_Subsong0_SpeedTrack0:
	.byte 255	#Wait for 128 lines.

#The event tracks
Ep1BossMusic_Subsong0_EventTrack0:
	.byte 255	#Wait for 128 lines.

Ep1BossMusic_Subsong0_DisarkByteRegionEnd0:
