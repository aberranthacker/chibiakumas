                                                            #
                                                            # ;*******************************************************************************
                                                            # ;*                            Object Event Array                               *
                                                            # ;*******************************************************************************
                                                            #
                                                            # Event_LevelTime equ Event_LevelTime_Plus1 - 1
                                                            # Event_LevelSpeed equ Event_LevelSpeed_Plus1-1
                                                            # Event_NextEventPointer equ Event_NextEventPointer_Plus2-2
                                                            # Event_NextEventTime equ Event_NextEventTime_Plus1-1
                                                            #
                                                            # LdAFromHLIncHL:
                                                            #     ld a,(hl)
                                                            #     inc hl
                                                            # ret
                                                            #
# DoMovesBackground_ScrollUp:                                 # DoMovesBackground_ScrollUp:
                                                            #     ; Move Up
                                                            #     ld bc,&790D ; DEC C  (OD)      LD a,C (79)
                                                            #     ld de,&F7FE ; CP (FE) F7 (199+24+24=247)
                                                            #     push de
                                                            #     ld de,&7A57
                                                            #     ld ixl,&57
                                                            #     ld hl,&DF0E
                                                            #
                                                            #     cp 3
                                                            #     jr nz, DoMovesBackground_SetScroll2
                                                            # DoMovesBackground_ScrollDown:
                                                            #     ld c,&0C
                                                            #     jr DoMovesBackground_SetScroll2_V2
DoMovesBackground_SetScroll:                                # DoMovesBackground_SetScroll: ;A=Direction 0-Left 1-Right 2-Up 3-Down
       .global DoMovesBackground_SetScroll
        # A=Direction 0-Left 1-Right 2-Up 3-Down
        PUSH R3                                             #     push hl
        PUSH R4                                             #     push ix
        # CMP  R0,$2                                          #         cp 2
        # BHIS DoMovesBackground_ScrollUp                     #         jr nc,DoMovesBackground_ScrollUp
        # # Move left                                         #         ; Move Left
        # MOV  $0x7805,R1                                     #         ld bc,&7805 ; INC B  (05)      LD a,B (78)
        # MOV  $0xD0FE,R2                                     #         ld de,&D0FE ; CP (FE)  D0 (160+24+24=208)
        # PUSH R2                                             #         push de
        #                                                     #
        # MOV  $0x794F,R2                                     #         ld de,&794F
        #                                                     #
        # MOV  0xB816,R3                                      #         ld hl,&B816
        # MOV  0x4F,R4                                        #         ld ixl,&4F
        #                                                     #
        # TST  R0                                             #         or a
        # BEQ  DoMovesBackground_SetScroll2                   #         jr z,DoMovesBackground_SetScroll2
        # # Move right                                        #         ;Move Right
                                                            #         ld c,&04
                                                            # DoMovesBackground_SetScroll2_V2:
                                                            #         ld h,&12    ;Start far left
                                                            #
# DoMovesBackground_SetScroll2:                               # DoMovesBackground_SetScroll2:
                                                            #         ld a,d
                                                            #         ld (OBjectStripReprogram_Plus1 - 1),a
                                                            #         ld a,e
                                                            #         ld (OBjectStripReprogram_Plus1 + 1),a
                                                            #         ld (DoMovesBGShift_Plus1 - 1),bc
                                                            #         pop de
                                                            #         ld (DoMovesBGShift_Plus1 + 1),de
                                                            #         ld a,ixl
                                                            #         ld (OneObjectQuick_Program),a
                                                            #         ld (OneObjectQuick_Program + 1),hl
                                                            #
        POP  R4                                             #     pop ix
        POP  R3                                             #     pop hl
                                                            #
RETURN                                                      # ret
SetLevelTime: # This is used for jumping around the event stream # SetLevelTime:
        # Make sure level time is LOWER than the first event, otherwise run Event_GetEventsNow
        MOV  R0,@$srcEvent_LevelTime                        #     ld (Event_LevelTime),a
        MOVB (R3)+,@$srcEvent_NextEventTime                 #     ld a,(hl)
                                                            #     ld (Event_NextEventTime_Plus1 - 1),a
                                                            #     inc hl
        MOV  R3,@$srcEvent_NextEventPointer                 #     ld (Event_NextEventPointer_Plus2 - 2),hl
RETURN                                                      #     ret
                                                            # GetLevelTime: ; Return the current level time
                                                            #     ld a,(Event_NextEventTime)
                                                            #     ld b,a
                                                            #     ld a,(Event_LevelTime)
                                                            #     ld hl,(Event_NextEventPointer)
                                                            #     dec hl
                                                            #     ret
                                                            #
                                                            # ; Restart the event stream for a new level
# ../SrcALL/Akuyou_Multiplatform_EventStream.asm:86
Event_StreamInit:                                           # Event_StreamInit:
       .global Event_StreamInit
        # Store the address of our 2nd setting buffer (1st is contained in core)
        MOV  R2,@$srcEvent_SavedSettings # uknc/event_stream.s:614
        CLR  R0
        MOV  R0,@$srcEvent_MultipleEventCount # uknc/event_stream.s:485
        CALL SetLevelTime # uknc/event_stream.s:68 # does MOVB (R3)+,@$srcEvent_NextEventTime
        # process the first batch of events
        BR   Event_GetEventsNow # uknc/event_stream.s:127
                                                            #
Event_MoreEventsDec: #multiple events at the same timepoint # Event_MoreEventsDec: ; multiple events at the same timepoint
                                                            #     dec a
                                                            #     ld (Event_MultipleEventCount_Plus1-1),a
                                                            #     ld (Event_NextEventPointer),hl
                                                            #     jr Event_GetEventsNow
                                                            #
                                                            # ;     Process the event stream - the eventstream is basically the level map,
                                                            # ; rather than a bitmap which would waste memory, it is a bytestream based around
                                                            # ; a Time,Event structure.
                                                            # ;    Multiple events can be at the same time, and the length of each event
                                                            # ; varies depending upon the event, for this reason, it is only intended that the
                                                            # ; stream is read forwards not backwards.
                                                            # Event_Stream:
                                                            #     ld a,(Timer_TicksOccured)
                                                            #     and %00000100:Event_LevelSpeed_Plus1    ; how often ticks occur
                                                            #     ret z       ; no ticks occured
                                                            # Event_Stream_ForceNow:
        INC  $0x00; Event_LevelTime_Plus2:                  #     ld a,&0 :Event_LevelTime_Plus1
       .equiv srcEvent_LevelTime, Event_LevelTime_Plus2 - 2
        MOV  $srcEvent_LevelTime,R0                         #     inc a
                                                            #     ld (Event_LevelTime),a
                                                            #     ld b,a
                                                            #
Event_MoreEvents:                                           # Event_MoreEvents:
        CMPB $01,R0; Event_NextEventTime_Plus2:             #     ld a,1 :Event_NextEventTime_Plus1 ;The time the event should occur
       .equiv srcEvent_NextEventTime, Event_NextEventTime_Plus2 - 2
        BEQ  Event_GetEventsNow                             #     cp b
        RETURN                                              #     ret nz  ; event does not happen yet

Event_GetEventsNow:                                         # Event_GetEventsNow:
        #MOV  $LdAFromHLIncHL,R5                            #     ld iy,LdAFromHLIncHL ; Set RST 6 to do our bidding
                                                            #     ld hl,Event_LoadNextEvt
        MOV  $Event_LoadNextEvt,-(SP)                       #     push hl ; We do a dirty trick to save space, all these actions end in a RET
                                                            #
        MOV  $0x0000,R3; Event_NextEventPointer_Plus2:      #     ld hl,6969 :Event_NextEventPointer_Plus2 ; mem pointer of next byte
       .equiv srcEvent_NextEventPointer, Event_NextEventPointer_Plus2 - 2
        MOVB (R3)+,R0                                       #     ld a,(hl)
                                                            #     inc hl
        MOV  R0,R1                                          #     ld d,a
        BIC  $0xFFF0,R1                                     #     and %00001111
                                                            #     ld b,a
                                                            #     ld a,d
        BIC  $0xFF0F,R0                                     #     and %11110000
        ASH  $-4,R0                                         #     rrca
                                                            #     rrca
                                                            #     rrca
                                                            #     rrca
        PUSH R3                                             #     push hl
        MOV  $Event_VectorArray,R3                          #     ld hl,Event_VectorArray
        JMP  VectorJump_PushHlFirst # uknc/stararray_add.s:149 #     jp VectorJump_PushHlFirst
                                                            #
Event_StarBust:                                             # Event_StarBust:
                                                            #     ld d,(hl)   ;X
                                                            #     inc hl
                                                            #     ld c,(hl)   ;Y
                                                            #     inc hl
                                                            #     push hl
                                                            #     push iy
                                                            #         call Stars_AddObjectBatchDefault
                                                            #     pop iy
                                                            #     pop hl
HALT #RETURN                                                #     ret
                                                            #
# By default each time can only have ONE event, but we can use this commend to declare
# XX events will occur at this time to save memory!
Event_CoreMultipleEventsAtOneTime:                          # Event_CoreMultipleEventsAtOneTime:
        # uknc/event_stream.s:485                           #     ld a,b
        MOV  R1,@$srcEvent_MultipleEventCount               #     ld (Event_MultipleEventCount_Plus1 - 1),a
RETURN                                                      #     ret
                                                            #
                                                            # Event_SpriteSwitch_0101:          ;Set the next sprite
                                                            #     ld de,EventObjectSpriteToAdd_Plus1-1
                                                            #     jr Event_CoreReprogram_ByteCopy
                                                            #
                                                            # Event_ProgramSwitch_0001:         ;Set the next program
                                                            #     ld de,EventObjectProgramToAdd_Plus1-1
                                                            #     jr Event_CoreReprogram_ByteCopy
                                                            #
                                                            # Event_AnimatorSwitch_1110:
                                                            #     ld de,EventObjectAnimatorToAdd_Plus1-1
                                                            #     jr Event_CoreReprogram_ByteCopy
                                                            # Event_SpriteSizeSwitch_1101:
                                                            #     ld de,EventObjectSpriteSizeToAdd_Plus1-1
                                                            #     jr Event_CoreReprogram_ByteCopy
                                                            #
                                                            # Event_MoveSwitch_0011:            ;Set the next move
                                                            #     ld de,EventObjectMoveToAdd_Plus1-1
                                                            #     jr Event_CoreReprogram_ByteCopy
                                                            #
                                                            #
                                                            # Event_ProgramMoveLifeSwitch_0100: ;Set Prog,MoveLife
                                                            #     rst 6
                                                            #     ;ld a,(hl)  ;Program Type
                                                            #     ld (EventObjectProgramToAdd_Plus1-1),a
                                                            #     ;inc hl                       ;Fall into Move Life code
                                                            # Event_MoveLifeSwitch_0000:
                                                            #     rst 6
                                                            #     ;ld a,(hl)  ;Move Type
                                                            #     ld (EventObjectMoveToAdd_Plus1-1),a
                                                            #     ;inc hl                       ;Fall into Life code
                                                            #
                                                            # Event_LifeSwitch_0010:
                                                            #     ld de,EventObjectLifeToAdd_Plus1-1
                                                            #
                                                            # Event_CoreReprogram_ByteCopy:
                                                            #     rst 6
                                                            #     ;ld a,(hl)  ; read in a byte
                                                            #     ld (de),a   ; put it at DE
                                                            #     ret
                                                            #
        # Reconfigure the core for custom actions this level
Event_CoreReprogram: # 0b1111???? 240 0xF0                  # Event_CoreReprogram:    ;1111????
        MOV  R1,R0                                          #     ld a,b
        PUSH R3                                             #     push hl
        MOV  $Event_ReprogramVector,R3                      #     ld hl,Event_ReprogramVector
        JMP  VectorJump_PushHlFirst # uknc/stararray_add.s:149 #     jp VectorJump_PushHlFirst
                                                            #
                                                            # ;Powerup objects are defined by their sprite, which changes each level
                                                            # ; OK so I didn't think this through very well!
                                                            # Event_CoreReprogram_PowerupSprites:
                                                            #     rst 6
                                                            #     ld (DroneSprite_Plus1-1),a
                                                            #     rst 6
                                                            #     ld (ShootSpeedSprite_Plus1-1),a
                                                            #     rst 6
                                                            #     ld (ShootPowerSprite_Plus1-1),a
                                                            #     rst 6
                                                            #     ld (PointsSprite_Plus1-1),a
                                                            #     ld (PointsSpriteB_Plus1-1),a
                                                            #     ld (PointsSpriteC_Plus1-1),a
                                                            #     ret
                                                            #
                                                            # Event_ReprogramObjectBurstPosition:
                                                            #     ld de,BurstPosition_Plus2-2
                                                            #     jr SetCustMove
Event_CoreReprogram_CustomMove1:                            # Event_CoreReprogram_CustomMove1:
        MOV  (R3)+,@$dstLevelSpecificMove                   #     ld de,LevelSpecificMove_Plus2-2
        RETURN # JMP @$Event_LoadNextEvt                    #     jr SetCustMove
                                                            # Event_CoreReprogram_CustomMove2:
                                                            #     ld de,LevelSpecificMoveB_Plus2-2
                                                            #     jr SetCustMove
                                                            # Event_SmartBombSpecial:
                                                            #     ld de,SmartBombSpecial_Plus2-2 ; Custom smartbomb handler - needed to wipe Omega array during final boss
                                                            #     jr SetCustMove
                                                            # Event_ObjectFullCustomMoves:       ; Override whole move handler
                                                            #     ld de,ObjectDoMovesOverride_Plus2-2
                                                            #     jr SetCustMove
                                                            # Event_CoreReprogram_CustomMove3:
                                                            #     ld de,LevelSpecificMoveC_Plus2-2
                                                            #     jr SetCustMove
                                                            # Event_CoreReprogram_CustomMove4:
                                                            #     ld de,LevelSpecificMoveD_Plus2-2
                                                            #     jr SetCustMove
                                                            # Event_CoreReprogram_AnimatorPointer:
                                                            #     ld de,AnimatorPointers_Plus2-2
                                                            #     jr SetCustMove
                                                            # Event_CustomProgram1:
                                                            #     ld de,CustomProgram1_Plus2-2
                                                            #     jr SetCustMove
                                                            # Event_CustomProgram2:
                                                            #     ld de,CustomProgram2_Plus2-2
                                                            #     jr SetCustMove
                                                            # Event_CustomPlayerHitter:
                                                            #     ld de,customPlayerHitter_Plus2-2
                                                            #     jr SetCustMove
                                                            # Event_CustomSmartBomb:
                                                            #     ld de,CustomSmartBombEnemy_Plus2-2
                                                            #     jr SetCustMove
SetCustMove:                                                # SetCustMove:
        MOV  (R3)+,(R2)                                     #     ld c,(hl)
                                                            #     inc hl
                                                            #     ld b,(hl)
                                                            #     inc hl
                                                            #     ld a,c
                                                            #     ld (de),a
                                                            #     inc de
                                                            #     ld a,b
                                                            #     ld (de),a
RETURN # JMP @$Event_LoadNextEvt                            #     ret;    jp Event_LoadNextEvt
                                                            # Event_CoreReprogram_ShotToDeath:
                                                            #     ld de,CustomShotToDeathCall_Plus2-2
                                                            #     jr SetCustMove
                                                            # Event_CoreReprogram_ObjectHitHandler:
                                                            #     ld de,ObjectShotOverride_Plus2-2
                                                            #     jr SetCustMove
                                                            #
                                                            # ;Event_CoreReprogram_PlusPalette            ; Set background (41 byte max)
                                                            # ;   ld de,PlusRasterPalette
                                                            # ;di
                                                            # ;halt ;this is deprecated
                                                            # ;   jr Event_CoreReprogram_DataCopy
                                                            #
# ; Program raster palette - careful - this can cause all nasty crashes if you
# ; do it wrong, as you have to specify bytes, offsets and loop counters,
# ; it's best to copy existing ones from levels and modify them
                                                            #
Event_CoreReprogram_Palette:                                # Event_CoreReprogram_Palette:
        MOV  (R3)+,$PPUCommandArg                           #     ld de,RasterColors_ColorArray1 :RasterColors_ColorArray1PointerB_Plus2
RETURN                                                      #
                                                            # Event_CoreReprogram_DataCopy:
                                                            #     ;reads in Offset then Bytecount from (HL) and dumps to destination DE
                                                            #     xor a
                                                            #     push hl
                                                            #         ld b,a
                                                            #         ld c,(hl)   ;Byte offset
                                                            #         ld h,d
                                                            #         ld l,e
                                                            #         add hl,bc
                                                            #         ld d,h
                                                            #         ld e,l
                                                            #     pop hl
                                                            #     inc hl
                                                            #
                                                            #     ld b,a
                                                            #     ld c,(hl)   ;bytecount
                                                            #     inc hl
                                                            #
                                                            #     ldir
RETURN                                                      #     ret
                                                            #
                                                            # Event_MoveSwitch:
                                                            #     ld a,b
                                                            #
                                                            #     push hl
                                                            #     ld hl,Event_MoveVector
                                                            #     jp VectorJump_PushHlFirst
                                                            #
                                                            # Event_LoadLastAddedObjectToAddress_1010:
                                                            # ; Used to remember boss objects and apply custom animation etc by hacking the
                                                            # ; object array.
                                                            #     ld c,(hl)
                                                            #     inc hl
                                                            #     ld b,(hl)
                                                            #     inc hl
                                                            #     push hl
                                                            #         ld h,b
                                                            #         ld l,c
                                                            #
                                                            #         ld bc, &6969:Objects_LastAdded_Plus2
                                                            #
                                                            #         ld (hl),c
                                                            #         inc hl
                                                            #         ld (hl),b
                                                            #     pop hl
                                                            #     ret
                                                            #
                                                            # ; call a function - be very careful what you do, as registers must be pretty
                                                            # ; much untouched otherwise a crash will occur on return. it's best to set a flag
                                                            # ; and do some action in your level loop, as that won't corrupt any registers.
                                                            # Event_Call_1001:
                                                            #     ld c,(hl)
                                                            #     inc hl
                                                            #     ld b,(hl)
                                                            #     inc hl
                                                            #     call CallBC
                                                            #     ret
                                                            #
                                                            # Event_ClearPowerups:        ; used at the start of each level to take the users powerups
                                                            #     call ResetPowerup
                                                            #     ret
                                                            # CallBC:
                                                            #     push bc
                                                            #     ret
                                                            #
                                                            # ; alter stream time
                                                            # Event_ChangeStreamTime_1000:
                                                            #     ld c,(hl)
                                                            #     inc hl
                                                            #     ld b,(hl)
                                                            #     inc hl
                                                            #     ld a,(hl)
                                                            #
                                                            #     ld h,b
                                                            #     ld l,c
                                                            #
                                                            #     call SetLevelTime
                                                            #
                                                            #     pop hl ; we didn't use up the Event_LoadNextEvt on the stack
                                                            #     jp Event_MoreEvents
                                                            #
                                                            # ; Add to the foreground (top of the object array)
                                                            # Event_AddFront_0110:
                                                            #     ld a,1
                                                            #     jr Event_AddXX
                                                            #
                                                            # ; Add to the background (bottom of the object array)
                                                            # Event_AddBack_0111:
                                                            #     xor a
                                                            #
                                                            # Event_AddXX:
                                                            #     ld (ObjectAddToForeBack_Plus1-1),a
                                                            #     ret
                                                            #
                                                            # ; Change time between events, used on water level when waterlevel changes - it was
                                                            # ; too slow by default
                                                            # Event_ChangeStreamSpeed_1100:
                                                            #     rst 6
                                                            #     ld (Event_LevelSpeed_Plus1-1),a
                                                            #     ret
                                                            #
                                                            # ; we don't have a tile array - this does spikes in stage 7 and 8 - this can work
                                                            # ; horiz or vert depending on scroll
                                                            # Event_ObjStrip:
                                                            #     ld d,(hl)   ;X
                                                            #     inc hl
                                                            #     ld C,(hl)   ;Y
                                                            #     inc hl
                                                            #     ld E,(hl)   ;S space
                                                            #     inc hl
                                                            #     ;fall into next event
                                                            # Event_ObjStrip_Next:
                                                            #     rst 6
                                                            #     ld (EventObjectSpriteToAdd_Plus1-1),a
                                                            #
                                                            #     push bc
                                                            #     push de
                                                            #         call EventoneObjectStrip
                                                            #     pop de
                                                            #     pop bc
                                                            #
                                                            #     ld a,c ; 79 == LD A,C
                                                            # OBjectStripReprogram_Plus1:
                                                            #     add e
                                                            #     ld c,a ; 4F == LD C,A
                                                            #
                                                            #     djnz Event_ObjStrip_Next
                                                            #     ret
                                                            #
                                                            # Event_ObjColumn:
                                                            #     ld d,(hl)   ;X
                                                            #     ld e,b
                                                            #     inc hl
                                                            #     Event_ObjColumn_Next:
                                                            #     rst 6
                                                            #     ld (EventObjectSpriteToAdd_Plus1-1),a
                                                            #
                                                            #     push de
                                                            #     call EventoneObjectColumn
                                                            #     pop de
                                                            #     dec e
                                                            #     jr nz,Event_ObjColumn_Next
                                                            #     ret
                                                            #
                                                            # Event_MultiObj:     ; Type 16 - multiple objects
                                                            #     push bc
                                                            #     call EventoneObject
                                                            #     pop bc
                                                            #     djnz Event_MultiObj
                                                            #     ret
                                                            #
                                                            # Event_OneObj:       ; Type 0 - one Obj
                                                            #     ld a,b
                                                            #
                                                            #     cp 1
                                                            #     jr z,Event_OneObjYOnly
                                                            #     cp 14
                                                            #     jr NC,Event_OneObjectBurst  ;>=14
                                                            #     or a
                                                            #     jr nz,Event_OneObjQuick
                                                            #     jr EventoneObject
                                                            # Event_OneObjectBurst:
                                                            # ;Burst Object
                                                            #     ld bc,&0000 :BurstPosition_Plus2
                                                            #     ld d,b
                                                            #     jr EventoneObjectStrip
                                                            #
                                                            # Event_OneObjYOnly: ; Type 1 - Read in Y and dump the same sprite to far right
                                                            #     ld c,(hl) ; Y
                                                            #     inc hl
                                                            #     jr Event_OneObjQuick_GO
                                                            #
                                                            # Event_OneObjQuick: ; one sprite, same as last time Y * 16 (Y 2-13)
                                                            #     rla
                                                            #     rla
                                                            #     rla
                                                            #     rla
                                                            #     sub 8
                                                            #
                                                            # OneObjectQuick_Program:
                                                            #     ld C,a
                                                            #
                                                            # Event_OneObjQuick_GO:
                                                            #     ld D,160+24
                                                            #     jr EventoneObjectStrip
                                                            #
                                                            # ; Read in the next object
Event_LoadNextEvt:                                          # Event_LoadNextEvt:
        TST  $0x00; Event_MultipleEventCount_Plus2: # 4     #     ld a,0 :Event_MultipleEventCount_Plus1
       .equiv srcEvent_MultipleEventCount, Event_MultipleEventCount_Plus2 - 2
                                                            #     or a
        BEQ  EventsProcessed                                #     jp nz,Event_MoreEventsDec ; there are multiple events at this point
        # multiple events at the same timepoint             # Event_MoreEventsDec: ; multiple events at the same timepoint
                                                            #     dec a
        DEC  @$srcEvent_MultipleEventCount                  #     ld (Event_MultipleEventCount_Plus1-1),a
        MOV  R3,@$srcEvent_NextEventPointer                 #     ld (Event_NextEventPointer),hl
        JMP  @$Event_GetEventsNow                           #     jr Event_GetEventsNow
    EventsProcessed:
        MOVB (R3)+,@$srcEvent_NextEventTime                 #     rst 6
                                                            #     ld (Event_NextEventTime),a
        MOV  R3,@$srcEvent_NextEventPointer                 #     ld (Event_NextEventPointer),hl
        MOV  $srcEvent_LevelTime,R0                         #     ld a,(Event_LevelTime)
                                                            #     ld b,a
        JMP  @$Event_MoreEvents # uknc/event_stream.s:121   #     jp Event_MoreEvents
                                                            # EventoneObject:
                                                            #     rst 6
                                                            #     ld (EventObjectSpriteToAdd_Plus1-1),a
                                                            #     ld d,(hl)   ;X
                                                            #     inc hl
                                                            #     EventoneObjectColumn:
                                                            #     ld c,(hl)   ;Y
                                                            #     inc hl
                                                            #     EventoneObjectStrip:
                                                            #     ;look for a space in the object array
                                                            #     push hl
                                                            #     call Event_AddObject
                                                            #     pop hl
                                                            #     ret
                                                            #
                                                            # Event_AddObject:
                                                            #     ld hl,Event_AddObject_MoveDirection_Plus1-1
                                                            #     ld a,0  :ObjectAddToForeBack_Plus1
                                                            #     or a
                                                            #     jr z,Event_AddObjectBack
                                                            #
                                                            #     ;add object to the front
                                                            #     ld a,&23
                                                            #     ld (hl),a
                                                            #     xor a   :BackgroundNoSpritesTurbo_Plus1
                                                            #     jr Event_AddObjectStart
                                                            #
                                                            # Event_AddObjectBack:
                                                            #     ld a,&2B
                                                            #
                                                            #     ld (hl),a
                                                            #     ld a,ObjectArraySize ;(ObjectArray_Size)
                                                            #     dec a
                                                            #
                                                            # Event_AddObjectStart:
                                                            #     ; D=X C=Y
                                                            #
                                                            #     ld b,ObjectArraySize;a
                                                            #     ld hl,ObjectArrayPointer;(ObjectArrayAddress)
                                                            #     add l       ; add l to a (start of loop)
                                                            #     ld l,a
                                                            #
                                                            # Event_Objectloop:
                                                            #     ld a,(hl)   ; Y check
                                                            #     or a
                                                            #     jp NZ,Event_ObjectLoopNext
                                                            #
                                                            #     ;found a free slot!
                                                            #     ld (Objects_LastAdded_Plus2-2),hl
                                                            #
                                                            #     ld a,c
                                                            #     and %11111000
                                                            #     ld (hl),a
                                                            #     inc h;
                                                            #     ld (hl),d ;X
                                                            #
                                                            #
                                                            #     inc h
                                                            #     ld (hl),&0 :EventObjectMoveToAdd_Plus1   ; Move
                                                            #     inc h
                                                            #     ld (hl),&0 :EventObjectSpriteToAdd_Plus1 ; sprite
                                                            #
                                                            #     set 6,l
                                                            #
                                                            #     ld a,&0 :EventObjectLifeToAdd_Plus1 ; life
                                                            #     push af
                                                            #         ld a,(LivePlayers)
                                                            #         dec a
                                                            #         jr z,AddObjectOnePlayer
                                                            #     pop af
                                                            #     cp %11000000
                                                            #     jr c,AddObjectTwoPlayer
                                                            #     cp 255  ;lifCustom
                                                            #     jr z,AddObjectTwoPlayer
                                                            #     push bc
                                                            #         ld b,a
                                                            #         sla a
                                                            #
                                                            #         or %11000000
                                                            #         cp b
                                                            #     pop bc
                                                            #     jr NC,AddObjectTwoPlayer
                                                            #     ld a,%11111110
                                                            #     jr AddObjectTwoPlayer
                                                            #
                                                            # AddObjectOnePlayer:
                                                            #     pop af
                                                            # AddObjectTwoPlayer:
                                                            #     ld (hl),a
                                                            #     dec h
        MOV  $0x00,(R3); EventObjectProgramToAdd_Plus2:     #     ld (hl),&0 :EventObjectProgramToAdd_Plus1    ; Program code
       .equiv  srcEventObjectProgramToAdd, EventObjectProgramToAdd_Plus2 - 2
       .global srcEventObjectProgramToAdd
                                                            #     dec h
        MOV  $0x00,(R3); EventObjectSpriteSizeToAdd_Plus2:  #     ld (hl),&0 :EventObjectSpriteSizeToAdd_Plus1 ; Sprite size for collisions
       .equiv  srcEventObjectSpriteSizeToAdd, EventObjectSpriteSizeToAdd_Plus2 - 2
       .global srcEventObjectSpriteSizeToAdd
                                                            #     dec h
        MOV  $0x00,(R3); EventObjectAnimatorToAdd_Plus2:    #     ld (hl),&0 :EventObjectAnimatorToAdd_Plus1   ; Animator
       .equiv  srcEventObjectAnimatorToAdd, EventObjectAnimatorToAdd_Plus2 - 2
       .global srcEventObjectAnimatorToAdd
                                                            #     ret
                                                            # Event_ObjectLoopNext:
                                                            #     inc hl      :Event_AddObject_MoveDirection_Plus1
                                                            #
                                                            #     djnz,Event_Objectloop
                                                            #     ret
                                                            #
                                                            # Event_CoreSaveLoadSettings2:
                                                            #     ; 1001XXXX Save/Load object settings XXXX bank
                                                            #     ; (0-15 = load . 16 = Save (to bank marked by next byte))
                                                            #     push hl
        MOV   $Event_SavedSettings,R3; Event_SavedSettings_Plus2: #         ld hl,&6969 :Event_SavedSettings_Plus2
       .equiv srcEvent_SavedSettings, Event_SavedSettings_Plus2 - 2
                                                            #     jr Event_CoreSaveLoadSettingsStart
                                                            # Event_CoreSaveLoadSettings:
                                                            #     ; 1001XXXX Save/Load object settings XXXX bank
                                                            #     ; (0-15 = load . 16 = Save (to bank marked by next byte))
                                                            #     push hl
                                                            #         ld hl,Event_SavedSettings ;Event_SavedSettings_Plus2
                                                            #
                                                            # Event_CoreSaveLoadSettingsStart:
                                                            #     ; 1001XXXX Save/Load object settings XXXX bank
                                                            #     ; (0-15 = load . 16 = Save (to bank marked by next byte))
                                                            #         ld (Event_SavedSettingsFinal_Plus2-2),hl
                                                            #     pop hl
                                                            #     ld a,d
                                                            #     and %00001111   ; bank no
                                                            #     cp  %00001111
                                                            #     jr nz,Event_CoreSaveLoadSettings_Load1 ; 15 means save
                                                            #     rst 6
                                                            #     jr Event_CoreSaveLoadSettings_Part2
                                                            # Event_CoreSaveLoadSettings_Load1:
                                                            #     ld d,b
                                                            # Event_CoreSaveLoadSettings_Part2:
                                                            #     push hl
                                                            #         call SettingsGetLocation
                                                            #         bit 7,d     ; This will only be 1 if we are saving
                                                            #         jr nz,Event_CoreSaveLoadSettings_Save ;----1--- = save
                                                            # Event_CoreSaveLoadSettings_Load:
                                                            #         Call DoSettingsLoad
                                                            #         jr Event_CoreSaveLoadSettings_Done
                                                            # SettingsGetLocation:
                                                            #         add a
                                                            #         add a   ; 4 bytes per bank
                                                            #         add a   ; 8 bytes per bank
                                                            #         ld hl,6969 :Event_SavedSettingsFinal_Plus2
                                                            #         add l
                                                            #         ld l,a
                                                            # ret
                                                            #
                                                            # DoSettingsLoad:
                                                            #     rst 6
                                                            #         ld (EventObjectProgramToAdd_Plus1-1),a
                                                            #     rst 6
                                                            #         ld (EventObjectMoveToAdd_Plus1-1),a
                                                            #     rst 6
                                                            #         ld (EventObjectLifeToAdd_Plus1-1),a
                                                            #     rst 6
                                                            #         ld (EventObjectSpriteToAdd_Plus1-1),a
                                                            #     rst 6
                                                            #         ld (EventObjectSpriteSizeToAdd_Plus1-1),a
                                                            #     rst 6
                                                            #         ld (EventObjectAnimatorToAdd_Plus1-1),a
                                                            #     rst 6
                                                            #         ld (ObjectAddToForeBack_Plus1-1),a
                                                            # ret
                                                            #
                                                            # Event_CoreSaveLoadSettings_Save:
                                                            #         ld a,(EventObjectProgramToAdd_Plus1-1)
                                                            #         ld (hl),a
                                                            #         inc hl
                                                            #
                                                            #         ld a,(EventObjectMoveToAdd_Plus1-1)
                                                            #         ld (hl),a
                                                            #         inc hl
                                                            #
                                                            #         ld a,(EventObjectLifeToAdd_Plus1-1)
                                                            #         ld (hl),a
                                                            #         inc hl
                                                            #
                                                            #         ld a,(EventObjectSpriteToAdd_Plus1-1)
                                                            #         ld (hl),a
                                                            #         inc hl
                                                            #
                                                            #         ld a,(EventObjectSpriteSizeToAdd_Plus1-1)
                                                            #         ld (hl),a
                                                            #         inc hl
                                                            #
                                                            #         ld a,(EventObjectAnimatorToAdd_Plus1-1)
                                                            #         ld (hl),a
                                                            #         inc hl
                                                            #
                                                            #         ld a,(ObjectAddToForeBack_Plus1-1)
                                                            #         ld (hl),a
                                                            #
                                                            # Event_CoreSaveLoadSettings_Done:
                                                            #     pop hl  ;reload the stream pointer
                                                            #     ret
                                                            #
                                                            # ; --------------------------------------------------
                                                            # ;                 Reset Powerup
                                                            # ; --------------------------------------------------
                                                            # ResetPowerup: ; used by levelcode to take our bonuses
                                                            #     push iy
                                                            #         ld iy,Player_Array
                                                            #         call ResetPlayerPowerup
                                                            #         ld iy,Player_Array2
                                                            #         call ResetPlayerPowerup
                                                            #     pop iy
                                                            # ret
                                                            # ResetPlayerPowerup:
                                                            #         ld (iy+4),0
                                                            #         ld a,&06
                                                            #         ld (PlayerStarColor_Plus1-1),a
                                                            #         xor a
                                                            #         ld (iy+14),a ; (PlayerShootPower_Plus1
                                                            #         ld a,%00000100
                                                            #         ld (iy+11),a ; ld (PlayerShootSpeed_Plus1-1),a
                                                            # ret
