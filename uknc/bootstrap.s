.equiv DiskMap1, 1
.equiv DiskMap2, 2
.equiv DiskMap3, 3
.equiv DiskMap4, 4

                org Akuyou_BootStrapStart
START:

FileBeginBootStrap:
Bootstrap_Launch:                       #     ld bc,&7f8D ; Reset the firmware to OFF
                                        #     out (c),c
                                        #     ld hl,RasterColors_InitColors
                                        #     call SetColors
                                        # 
        CLR R3                          #     ld h,0
                                        #     ld l,0
                                        # 
Bootstrap_FromHL:                       #     ; HL is used as the bootstrap command
                                        #     ; H=1 means levels
                                        #     ; H=0 means system events (Menu etc)
        MOV  R3,R0                      #     ld a,h
        SWAB R0
        TSTB R0                         #     or a
        BEQ  Bootstrap_SystemEvent      #     jr z,Bootstrap_SystemEvent
        CMPB R3,$1                      #     cp 1
        BEQ  Bootstrap_Level            #     jr z,Bootstrap_Level
RETURN                                  # ret

Bootstrap_SystemEvent:
        MOV  R3,R0                      #     ld a,l
        TSTB R0                         #     cp 0
        BEQ  BootsStrap_StartGame       #     jp z,BootsStrap_StartGame
                                        #     cp 1
                                        #     jp z,BootsStrap_ContinueScreen
                                        #     cp 2
                                        #     jp z,BootsStrap_ConfigureControls
                                        #     cp 3
                                        #     jp z,BootStrap_SaveSettings
                                        #     cp 4
                                        #     jp z,GameOverWin
                                        #     cp 5
                                        #     jp z,NewGame_EP2_1UP
                                        #     cp 6
                                        #     jp z,NewGame_EP2_2UP
                                        #     cp 7
                                        #     jp z,NewGame_EP2_2P
                                        #     cp 8
                                        #     jp z,NewGame_CheatStart
                                        # ret
BootsStrap_StartGame:
        .include "./bootstrap/start_game.s" #   read "..\AkuCPC\BootsStrap_StartGame_CPC.asm"
        JMP Bootstrap_Level_0           #     jp Bootstrap_Level_0    ; Start the menu
#----------------------------------------------------------------------------}}}
Bootstrap_Level_0:                      # main menu -------------------------{{{
                                        #     call StartANewGame
                                        #     call LevelReset0000
                                        # 
                                        #     ld hl,DiskMap_MainMenu      ;T08-SC1.D01
                                        #     ld c,DiskMap_MainMenu_Disk
                                        # 
                                        #     call Bootstrap_LoadEP2Music_Z
                                        # 
                                        #     ld hl,DiskMap_MainMenu      ;T08-SC1.D01
                                        #     ld c,DiskMap_MainMenu_Disk
                                        # 
                                        #     ;need to use Specail MSX version - no extra tilemaps
                                        #     jp Bootstrap_LoadEP2Level_1PartOnly;Bootstrap_LoadEP2Level_1Part;Z;_Zpartial
                                        # ret
#----------------------------------------------------------------------------}}}

