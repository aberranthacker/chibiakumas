
/*******************************************************************************
 *                            Object Event Array                               *
 *******************************************************************************/

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
        # PUSH R3                                             #     push hl
        # PUSH R4                                             #     push ix
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
        # POP  R4                                             #     pop ix
        # POP  R3                                             #     pop hl
                                                            #
RETURN                                                      # ret

SetLevelTime: # This is used for jumping around the event stream # SetLevelTime:
        # Make sure level time is LOWER than the first event, otherwise run Event_GetEventsNow
        MOV  R0,@$srcEvent_LevelTime                        #     ld (Event_LevelTime),a
        MOV  (R5)+,@$srcEvent_NextEventTime                 #     ld a,(hl)
                                                            #     ld (Event_NextEventTime_Plus1 - 1),a
                                                            #     inc hl
        MOV  R5,@$srcEvent_NextEventPointer                 #     ld (Event_NextEventPointer_Plus2 - 2),hl
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
       #MOV  R3,@$srcEvent_SavedSettings # uknc/event_stream.s:621
        CLR  R0
        MOV  R0,@$srcEvent_MultipleEventCount # uknc/event_stream.s:493
        CALL SetLevelTime # uknc/event_stream.s:70 # does MOV (R3)+,@$srcEvent_NextEventTime
        # process the first batch of events
        BR   Event_GetEventsNow # uknc/event_stream.s:130

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

EventStream_Process:                                        # Event_Stream:
        BIT  (PC)+,@(PC)+                                   #     ld a,(Timer_TicksOccured)
             srcEvent_LevelSpeed:                           #     and %00000100:Event_LevelSpeed_Plus1    ; how often ticks occur
       .word 0x04
       .word srcTimer_TicksOccured

        BNZ  Event_Stream_ForceNow                          #     ret z       ; no ticks occured
RETURN

Event_Stream_ForceNow:                                      # Event_Stream_ForceNow:
        INC  (PC)+; srcEvent_LevelTime: .word 0x00          #     ld a,&0 :Event_LevelTime_Plus1
                                                            #     inc a
        #MOV  @$srcEvent_LevelTime,R0                       #     ld (Event_LevelTime),a
                                                            #     ld b,a

Event_MoreEvents:                                           # Event_MoreEvents:
        # compare NextEventTime with LevelTime              #     ld a,1 :Event_NextEventTime_Plus1 ;The time the event should occur
        CMP  (PC)+, @(PC)+
             srcEvent_NextEventTime:
       .word 0x01
       .word srcEvent_LevelTime

        BEQ  Event_GetEventsNow
RETURN                                                      #     ret nz  ; event does not happen yet

Event_GetEventsNow: # ../SrcALL/Akuyou_Multiplatform_EventStream.asm:121
        MOV  $Event_LoadNextEvt,-(SP) # We do a dirty trick to save space, all these actions end in a RET

        MOV  (PC)+,R5; srcEvent_NextEventPointer: .word 0x0000 # mem pointer of next byte

        CLR  R1
        BISB (R5)+,R1
        MOVB (R5)+,R0 # there are less than 48 events, sign extension clears MSB

        JMP  @Event_VectorArray(R0)

# Read in the next object
Event_LoadNextEvt:                                          # Event_LoadNextEvt:
        TST  (PC)+; srcEvent_MultipleEventCount: .word 0x00 #     ld a,0 :Event_MultipleEventCount_Plus1
                                                            #     or a
        BZE  events_processed$                              #     jp nz,Event_MoreEventsDec ; there are multiple events at this point
        # multiple events at the same timepoint             # Event_MoreEventsDec: ; multiple events at the same timepoint
                                                            #     dec a
        DEC  @$srcEvent_MultipleEventCount                  #     ld (Event_MultipleEventCount_Plus1-1),a
        MOV  R5,@$srcEvent_NextEventPointer                 #     ld (Event_NextEventPointer),hl
        JMP  @$Event_GetEventsNow                           #     jr Event_GetEventsNow
    events_processed$:
        MOV  (R5)+,@$srcEvent_NextEventTime                 #     rst 6
                                                            #     ld (Event_NextEventTime),a
        MOV  R5,@$srcEvent_NextEventPointer                 #     ld (Event_NextEventPointer),hl
        #MOV  @$srcEvent_LevelTime,R0                       #     ld a,(Event_LevelTime)
                                                            #     ld b,a
        JMP  @$Event_MoreEvents                             #     jp Event_MoreEvents


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
RETURN # JMP  Event_LoadNextEvt                             #     ret
                                                            #
# Event_SpriteSwitch: # Set the next sprite                   # Event_SpriteSwitch_0101:          ;Set the next sprite
#         MOV  (R5)+,@$srcEventObjectSpriteToAdd              #     ld de,EventObjectSpriteToAdd_Plus1-1
# RETURN                                                      #     jr Event_CoreReprogram_ByteCopy
                                                            #
Event_SetProgram: # Set the next program                    # Event_ProgramSwitch_0001:
        MOV  (R5)+,@$srcEventObjectProgramToAdd             #     ld de,EventObjectProgramToAdd_Plus1 - 1
RETURN                                                      #     jr Event_CoreReprogram_ByteCopy
                                                            #
Event_SetAnimator:                                          # Event_AnimatorSwitch_1110:
        MOV  R1,@$srcEventObjectAnimatorToAdd               #     ld de,EventObjectAnimatorToAdd_Plus1-1
RETURN                                                      #     jr Event_CoreReprogram_ByteCopy
                                                            #
Event_SetSpriteSize:                                        # Event_SpriteSizeSwitch_1101:
        MOV  R1,@$srcEventObjectSpriteSizeToAdd             #     ld de,EventObjectSpriteSizeToAdd_Plus1-1
RETURN                                                      #     jr Event_CoreReprogram_ByteCopy
                                                            #
# Event_MoveSwitch: # Set the next move                       # Event_MoveSwitch_0011:
#         MOV  (R5)+,@$srcEventObjectMoveToAdd                #     ld de,EventObjectMoveToAdd_Plus1-1
# RETURN                                                      #     jr Event_CoreReprogram_ByteCopy
                                                            #
Event_SetProgMoveLife: # Set Prog,MoveLife                  # Event_ProgramMoveLifeSwitch_0100:
        MOV  (R5)+,@$srcEventObjectProgramToAdd             #     rst 6
                                                            #     ld (EventObjectProgramToAdd_Plus1 - 1),a
Event_SetMoveLife:                                          # Event_MoveLifeSwitch_0000:
        MOV  (R5)+,@$srcEventObjectMoveToAdd                #     rst 6
                                                            #     ld (EventObjectMoveToAdd_Plus1 - 1),a
Event_SetLife:                                              # Event_LifeSwitch_0010:
        MOV  (R5)+,@$srcEventObjectLifeToAdd                #     ld de,EventObjectLifeToAdd_Plus1 - 1
RETURN                                                      #
                                                            # Event_CoreReprogram_ByteCopy:
                                                            #     rst 6
                                                            #     ld (de),a   ; put it at DE
                                                            #     ret
                                                            #
                                                            # Reconfigure the core for custom actions this level
# Event_CoreReprogram: # not used, legacy                   # Event_CoreReprogram:    ;1111????
#         JMP  @Event_ReprogramVector(R1)                    #     ld a,b
                                                            #     push hl
                                                            #     ld hl,Event_ReprogramVector
        #JMP  VectorJump_PushHlFirst # uknc/stararray_add.s:149 #     jp VectorJump_PushHlFirst

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
RETURN # JMP @$Event_LoadNextEvt                            #     jr SetCustMove
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
        MOV  (R5)+,(R2)                                     #     ld c,(hl)
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

                                                            # ;Event_CoreReprogram_PlusPalette            ; Set background (41 byte max)
                                                            # ;   ld de,PlusRasterPalette
                                                            # ;di
                                                            # ;halt ;this is deprecated
                                                            # ;   jr Event_CoreReprogram_DataCopy

Event_CoreReprogram_Palette:
        MOV  (R5)+,@$PPUCommandArg
       .ppudo_ensure $PPU_SetPalette
RETURN # JMP @$Event_LoadNextEvt
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
# Event_MoveSwitch: # not used, legacy                      # Event_MoveSwitch:
#         JMP  @Event_MoveVector(R1)                        #     jp VectorJump_PushHlFirst
                                                            #
# Used to remember boss objects and apply custom animation etc by hacking the object array.
Event_LoadLastAddedObjectToAddress:
        MOV  (PC)+,@(R5)+
        srcObjects_LastAdded: .word 0
RETURN
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

                                                            # ; alter stream time
Event_ChangeStreamTime:                                     # Event_ChangeStreamTime_1000:
        MOV  (R5)+,R1                                       #     ld c,(hl)
                                                            #     inc hl
                                                            #     ld b,(hl)
                                                            #     inc hl
        MOV  (R5),R0                                        #     ld a,(hl)
                                                            #
        MOV  R1,R5                                          #     ld h,b
                                                            #     ld l,c
                                                            #
        CALL SetLevelTime                                   #     call SetLevelTime
                                                            #     pop hl ; we didn't use up the Event_LoadNextEvt on the stack
        TST  (SP)+ # we didn't use up the Event_LoadNextEvt on the stack
        JMP  Event_MoreEvents # uknc/event_stream.s:124     #     jp Event_MoreEvents

# Add to the foreground (top of the object array)
Event_AddToForeground:                                      # Event_AddFront_0110:
        MOV  $1,@$srcObjectAddToForeBack                    #     ld a,1
RETURN                                                      #     jr Event_AddXX
                                                            #
# Add to the background (bottom of the object array)
Event_AddToBackground:                                      # Event_AddBack_0111:
        CLR  @$srcObjectAddToForeBack                       #     xor a
RETURN                                                      #
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

Event_OneObj: # Type 0 - one Obj                            # Event_OneObj:       ; Type 0 - one Obj
        CMP  R1,$1                                          #     ld a,b
                                                            #     cp 1
        BEQ  Event_OneObjYOnly$                             #     jr z,Event_OneObjYOnly
        CMP  R1,$14                                         #     cp 14
        BHIS Event_OneObjectBurst$                          #     jr NC,Event_OneObjectBurst  ;>=14
        TST  R1                                             #     or a
        BNZ  Event_OneObjQuick$                             #     jr nz,Event_OneObjQuick
        BR   EventOneObject$                                #     jr EventoneObject
Event_OneObjectBurst$:                                      # Event_OneObjectBurst:
                                                            # ;Burst Object
                                                            #     ld bc,&0000 :BurstPosition_Plus2
                                                            #     ld d,b
                                                            #     jr EventoneObjectStrip
                                                            #
Event_OneObjYOnly$:                                         # Event_OneObjYOnly: ; Type 1 - Read in Y and dump the same sprite to far right
                                                            #     ld c,(hl) ; Y
                                                            #     inc hl
                                                            #     jr Event_OneObjQuick_GO
                                                            #
Event_OneObjQuick$:                                         # Event_OneObjQuick: ; one sprite, same as last time Y * 16 (Y 2-13)
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
EventOneObject$:                                            # EventoneObject:
                                                            #     rst 6
        MOV  (R5)+,@$srcEventObjectSpriteToAdd              #     ld (EventObjectSpriteToAdd_Plus1 - 1),a
        MOV  (R5)+,R2 # Y=LSB, X=MSB                        #     ld d,(hl)   ;X
                                                            #     inc hl
                                                            #     EventoneObjectColumn:
                                                            #     ld c,(hl)   ;Y
                                                            #     inc hl
                                                            #     EventoneObjectStrip:
                                                            #     ;look for a space in the object array

        # PUSH R3 all registers are versatile on PDP-11 :-) #     push hl
        CALL Event_AddObject                                #     call Event_AddObject
        # POP  R3                                           #     pop hl
RETURN                                                      #     ret

Event_AddObject: # called by object_driver as well          # Event_AddObject:
                                                            #     ld hl,Event_AddObject_MoveDirection_Plus1 - 1
        TST  (PC)+; srcObjectAddToForeBack: .word 0         #     ld a,0  :ObjectAddToForeBack_Plus1
                                                            #     or a
        BEQ  Event_AddObjectBack$                           #     jr z,Event_AddObjectBack
                                                            #
        #     0062703 == ADD (PC)+,R3                       #     ;add object to the front
        MOV  $0062703,@$opcAddObject_MoveDirection$         #     ld a,&23 ; 23 == INC HL

                                                            #     ld (hl),a
        CLR  R0                                             #     xor a   :BackgroundNoSpritesTurbo_Plus1
        BR   Event_AddObjectStart$                          #     jr Event_AddObjectStart
                                                            #
    Event_AddObjectBack$:                                   # Event_AddObjectBack:
        #     0162703 == SUB (PC)+,R3
        MOV  $0162703,@$opcAddObject_MoveDirection$         #     ld a,&2B ; 2B == DEC HL
                                                            #
                                                            #     ld (hl),a
        MOV  $(ObjectArraySize - 1) << 3,R0                 #     ld a,ObjectArraySize ;(ObjectArray_Size)
                                                            #     dec a
                                                            #
    Event_AddObjectStart$:                                  # Event_AddObjectStart:
        # R2=XY  Y=LSB, X=MSB                               #     ; D=X C=Y
                                                            #
        MOV  $ObjectArrayPointer,R3                         #     ld b,ObjectArraySize;a
        ADD  R0,R3                                          #     ld hl,ObjectArrayPointer;(ObjectArrayAddress)
                                                            #     add l       ; add l to a (start of loop)
        MOV  $ObjectArraySize,R4                            #     ld l,a

    Event_Objectloop$:                                      # Event_Objectloop:
                                                            #     ld a,(hl)   ; Y check
        TSTB (R3)                                           #     or a
        BNE  Event_ObjectLoopNext$                          #     jp NZ,Event_ObjectLoopNext

                                                            #     ;found a free slot!
        MOV  R3,@$srcObjects_LastAdded                      #     ld (Objects_LastAdded_Plus2 - 2),hl

                                                            #     ld a,c
        BIC  $0b111,R2                                      #     and %11111000
                                                            #     ld (hl),a
                                                            #     inc h;
        MOV  R2,(R3)+ # Y=LSB, X=MSB                        #     ld (hl),d ;X

                                                            #     inc h
        MOVB (PC)+,(R3)+; srcEventObjectMoveToAdd: .word 0  #     ld (hl),&0 :EventObjectMoveToAdd_Plus1   ; Move
                                                            #     inc h
        MOVB (PC)+,(R3)+; srcEventObjectSpriteToAdd: .word 0#     ld (hl),&0 :EventObjectSpriteToAdd_Plus1 ; sprite
                                                            #     set 6,l
                                                            #
        MOV  (PC)+,R0; srcEventObjectLifeToAdd: .word 0     #     ld a,&0 :EventObjectLifeToAdd_Plus1 ; life
                                                            #     push af
        CMPB @$LivePlayers,$1                               #         ld a,(LivePlayers)
        BEQ  AddObjectOnePlayer$                            #         dec a
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
    AddObjectOnePlayer$:                                    # AddObjectOnePlayer:
                                                            #     pop af
                                                            # AddObjectTwoPlayer:
        MOVB R0,(R3)+ # LifeToAdd                           #     ld (hl),a
                                                            #     dec h
        MOVB (PC)+,(R3)+; srcEventObjectProgramToAdd: .word 0x00 #     ld (hl),&0 :EventObjectProgramToAdd_Plus1    ; Program code
       .global srcEventObjectProgramToAdd    # Program code
                                                            #     dec h
        MOVB (PC)+,(R3)+; srcEventObjectSpriteSizeToAdd: .word 0x00 #     ld (hl),&0 :EventObjectSpriteSizeToAdd_Plus1 ; Sprite size for collisions
       .global srcEventObjectSpriteSizeToAdd # Sprite size for collisions
                                                            #     dec h
        MOVB (PC)+,(R3)+; srcEventObjectAnimatorToAdd: .word 0x00 #     ld (hl),&0 :EventObjectAnimatorToAdd_Plus1   ; Animator
       .global srcEventObjectAnimatorToAdd   # Animator
RETURN                                                      #     ret
    Event_ObjectLoopNext$:                                  # Event_ObjectLoopNext:
        opcAddObject_MoveDirection$:
        ADD  $8,R3                                          #     inc hl      :Event_AddObject_MoveDirection_Plus1
        SOB  R4,Event_Objectloop$                           #     djnz,Event_Objectloop
RETURN                                                      #     ret
                                                            #
# Event_CoreSaveLoadSettings2:
# # 1001XXXX Save/Load object settings XXXX bank
# # (0-15 = load . 16 = Save (to bank marked by next byte))
#         MOV  (PC)+,@(PC)+
#              srcEvent_SavedSettings:
#        .word 0
#        .word srcEvent_SavedSettingsFinal
#
#         BR    Event_CoreSaveLoadSettingsStart$
#
# Event_CoreSaveLoadSettings:
# # 1001XXXX Save/Load object settings XXXX slot
# # (0x0 - 0xE = load / 0xF = Save (to slot marked by next word))
#         MOV  $Event_SavedSettings,@$srcEvent_SavedSettingsFinal
#
# Event_CoreSaveLoadSettingsStart$:
#         MOV  R1,R0
#         CMP  R1,$0x0F  # save?
#         BNE  Event_CoreSaveLoadSettings_Part2$
#         MOV  (R5)+,R0 # yes, get save slot number
#
# Event_CoreSaveLoadSettings_Part2$:
#         ASH  $3,R0
#         MOV  (PC)+,R3; srcEvent_SavedSettingsFinal: .word 0
#         ADD  R0,R3
#
#         CMP  R1,$0x0F
#         BEQ  Event_CoreSaveLoadSettings_Save$
#         # Load settings
#         MOVB (R3)+, @$srcEventObjectProgramToAdd
#         MOVB (R3)+, @$srcEventObjectMoveToAdd
#         MOVB (R3)+, @$srcEventObjectLifeToAdd
#         MOVB (R3)+, @$srcEventObjectSpriteToAdd
#         MOVB (R3)+, @$srcEventObjectSpriteSizeToAdd
#         MOVB (R3)+, @$srcEventObjectAnimatorToAdd
#         MOVB (R3)+, @$srcObjectAddToForeBack
# RETURN
#
# Event_CoreSaveLoadSettings_Save$:
#         MOVB @$srcEventObjectProgramToAdd,   (R3)+
#         MOVB @$srcEventObjectMoveToAdd,      (R3)+
#         MOVB @$srcEventObjectLifeToAdd,      (R3)+
#         MOVB @$srcEventObjectSpriteToAdd,    (R3)+
#         MOVB @$srcEventObjectSpriteSizeToAdd,(R3)+
#         MOVB @$srcEventObjectAnimatorToAdd,  (R3)+
#         MOVB @$srcObjectAddToForeBack,       (R3)
# RETURN

Event_SaveObjSettings:
        ASH  $3,R1
        ADD  $Event_SavedSettings,R1

        MOVB @$srcEventObjectProgramToAdd,   (R1)+
        MOVB @$srcEventObjectMoveToAdd,      (R1)+
        MOVB @$srcEventObjectLifeToAdd,      (R1)+
        MOVB @$srcEventObjectSpriteToAdd,    (R1)+
        MOVB @$srcEventObjectSpriteSizeToAdd,(R1)+
        MOVB @$srcEventObjectAnimatorToAdd,  (R1)+
        MOVB @$srcObjectAddToForeBack,       (R1)
RETURN

Event_LoadObjSettings:
        ASH  $3,R1
        ADD  $Event_SavedSettings,R1

        MOVB (R1)+, @$srcEventObjectProgramToAdd
        MOVB (R1)+, @$srcEventObjectMoveToAdd
        MOVB (R1)+, @$srcEventObjectLifeToAdd
        MOVB (R1)+, @$srcEventObjectSpriteToAdd
        MOVB (R1)+, @$srcEventObjectSpriteSizeToAdd
        MOVB (R1)+, @$srcEventObjectAnimatorToAdd
        MOVB (R1),  @$srcObjectAddToForeBack
RETURN



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
