
/*******************************************************************************
 *                            Object Event Array                               *
 *******************************************************************************/

DoMovesBackground_ScrollUp:
                                            # ; Move Up
                                            # ld bc,&790D ; DEC C (OD) ; LD a,C (79)
                                            # ld de,&F7FE ; CP    (FE) ; F7 (199+24+24=247)
                                            # push de
                                            # ld de,&7A57
                                            # ld ixl,&57
                                            # ld hl,&DF0E
                                            #
                                            # cp 3
                                            # jr nz, DoMovesBackground_SetScroll2
DoMovesBackground_ScrollDown:
                                            # ld c,&0C
                                            # jr DoMovesBackground_SetScroll2_V2

DoMovesBackground_SetScroll:
        # A=Direction 0-Left 1-Right 2-Up 3-Down
        # PUSH R3                           # push hl
        # PUSH R4                           # push ix
        # CMP  R0,$2                        #     cp 2
        # BHIS DoMovesBackground_ScrollUp   #     jr nc,DoMovesBackground_ScrollUp

        # Move left                         #     ; Move Left
        # MOV  $0x7805,R1                   #     ld bc,&7805 ; INC B (05); LD a,B (78)
        # MOV  $0xD0FE,R2                   #     ld de,&D0FE ; CP    (FE); D0 (160+24+24=208)
        # PUSH R2                           #     push de

        # MOV  $0x794F,R2                   #     ld de,&794F

        # MOV  0xB816,R3                    #     ld hl,&B816 ; LD  D,n (16) ; B8
        # MOV  0x4F,R4                      #     ld ixl,&4F  ; LD  C,A (4F)

        # TST  R0                           #     or a
        # BEQ  DoMovesBackground_SetScroll2 #     jr z,DoMovesBackground_SetScroll2
        # Move right
                                            #     ld c,&04
DoMovesBackground_SetScroll2_V2:
                                            #     ld h,&12    ;Start far left
                                            #
DoMovesBackground_SetScroll2:
                                            #     ld a,d
                                            #     ld (OBjectStripReprogram_Plus1 - 1),a
                                            #     ld a,e
                                            #     ld (OBjectStripReprogram_Plus1 + 1),a
                                            #     ld (DoMovesBGShift_Plus1 - 1),bc
                                            #     pop de
                                            #     ld (DoMovesBGShift_Plus1 + 1),de
                                            #     ld a,ixl
                                            #     ld (OneObjectQuick_Program),a
                                            #     ld (OneObjectQuick_Program + 1),hl
        # POP  R4                           # pop ix
        # POP  R3                           # pop hl
                                            #
        RETURN                              # ret

SetLevelTime: # This is used for jumping around the event stream # SetLevelTime:
        # Make sure level time is LOWER than the first event, otherwise run Event_GetEventsNow
        MOV  R0,@$Event_LevelTime        # ld (Event_LevelTime),a
        MOV  (R5)+,@$Event_NextEventTime # ld a,(hl)
                                         # ld (Event_NextEventTime_Plus1 - 1),a
                                         # inc hl
        MOV  R5,@$Event_NextEventPointer # ld (Event_NextEventPointer_Plus2 - 2),hl
        RETURN                           # ret

                                         # GetLevelTime: ; Return the current level time
                                         #     ld a,(Event_NextEventTime)
                                         #     ld b,a
                                         #     ld a,(Event_LevelTime)
                                         #     ld hl,(Event_NextEventPointer)
                                         #     dec hl
                                         #     ret

      # Restart the event stream for a new level
# ../SrcALL/Akuyou_Multiplatform_EventStream.asm:86

EventStream_Init:
      # Store the address of our 2nd setting buffer (1st is contained in core)
       #MOV  R3,@$Event_SavedSettings # core/event_stream.s:621
        CLR  R0
        MOV  R0,@$Event_MultipleEventCount # uknc/event_stream.s:493
        CALL @$SetLevelTime # uknc/event_stream.s:70 # does MOV (R3)+,@$Event_NextEventTime
      # process the first batch of events
        BR   Event_GetEventsNow # uknc/event_stream.s:130

#     Process the event stream - the eventstream is basically the level map,
# rather than a bitmap which would waste memory, it is a bytestream based around
# a Time/Event structure.
#    Multiple events can be at the same time, and the length of each event
# varies depending upon the event, for this reason, it is only intended that the
# stream is read forwards not backwards.

EventStream_Process:
       .equiv Event_LevelSpeed, .+2 # how often ticks occur
        BIT  $0x04,@$Timer_TicksOccured
        BZE  1237$ # no ticks occured

       .equiv Event_LevelTime, .+2
        INC  $0xFFFF

Event_MoreEvents:
      # compare NextEventTime with LevelTime
       .equiv Event_NextEventTime, .+2 # The time the event should occur
        CMP  $1, @$Event_LevelTime
        BNE  1237$ # event does not happen yet

Event_GetEventsNow: # ../SrcALL/Akuyou_Multiplatform_EventStream.asm:121
      # We do a dirty trick to save space, all these actions end in a RET
        MOV  $Event_LoadNextEvt,-(SP)
       .equiv Event_NextEventPointer, .+2 # mem pointer of next byte
        MOV  $0x0000,R5

        CLR  R1
        BISB (R5)+,R1
        MOVB (R5)+,R0 # there are less than 48 events, sign extension clears MSB

    .ifdef DebugMode
        CMP  R0,0x5E
        BHI  .
    .endif

        JMP  @Event_VectorArray(R0)

# Read in the next object
Event_LoadNextEvt:
       .equiv Event_MultipleEventCount, .+2
        TST  $0x00
        BZE  events_processed

      # multiple events at the same timepoint
        DEC  @$Event_MultipleEventCount
        MOV  R5,@$Event_NextEventPointer
        BR   Event_GetEventsNow

events_processed:
        MOV  (R5)+,@$Event_NextEventTime
        MOV  R5,@$Event_NextEventPointer
        BR   Event_MoreEvents

Event_StarBust:
        MOV  R1,R3    # pattern
        CLR  R1
        BISB (R5)+,R1 # Y
        CLR  R2
        BISB (R5)+,R2 # X
        PUSH R5
        CALL @$Stars_AddObjectBatchDefault
        POP  R5

1237$:  RETURN

# By default each time can only have ONE event, but we can use this commend to declare
# XX events will occur at this time to save memory!
Event_CoreMultipleEventsAtOneTime:
        # uknc/event_stream.s:485
        MOV  R1,@$Event_MultipleEventCount
        RETURN # JMP Event_LoadNextEvt

Event_SetSprite: # Set the next sprite
        MOV  R1,@$EventObjectSpriteToAdd
        RETURN

Event_SetProgram: # Set the next program
        MOV  (R5)+,@$EventObjectProgramToAdd
        RETURN

Event_SetAnimator:
        MOV  R1,@$EventObjectAnimatorToAdd
        RETURN

Event_SetSpriteSize:
        MOV  R1,@$EventObjectSpriteSizeToAdd
        RETURN

Event_SetMove: # Set the next move
        MOV  (R5)+,@$EventObjectMoveToAdd
        RETURN

Event_SetProgMoveLife:
        MOV  (R5)+,@$EventObjectProgramToAdd

Event_SetMoveLife:
        MOV  (R5)+,@$EventObjectMoveToAdd

Event_SetLife:
        MOV  (R5)+,@$EventObjectLifeToAdd
        RETURN
                                                            # Event_CoreReprogram_ByteCopy:
                                                            #     rst 6
                                                            #     ld (de),a   ; put it at DE
                                                            #     ret
                                                            #
                                                            # Reconfigure the core for custom actions this level
# Event_CoreReprogram: # not used, legacy                   # Event_CoreReprogram:    ;1111????
#         JMP  @Event_ReprogramVector(R1)                   #     ld a,b
                                                            #     push hl
                                                            #     ld hl,Event_ReprogramVector
        #JMP  VectorJump_PushHlFirst # uknc/stararray_add.s:149 #     jp VectorJump_PushHlFirst

# Powerup objects are defined by their sprite, which changes each level
# OK so I didn't think this through very well!
Event_CoreReprogram_PowerupSprites:
        MOVB (R5)+,@$DroneSprite
        MOVB (R5)+,@$ShootSpeedSprite
        MOV  (R5)+,R0
        MOVB R0,@$ShootPowerSprite
        SWAB R0
        MOVB R0,@$PointsSpriteA
        MOVB R0,@$PointsSpriteB
        MOVB R0,@$PointsSpriteC
        RETURN

Event_ReprogramObjectBurstPosition:
        MOV  (R5)+,@$BurstPosition # # Y: LSB, X: MSB
        RETURN # to Event_LoadNextEvt

Event_CoreReprogram_CustomMove1:
        MOV  (R5)+,@$jmpLevelSpecificMoveA
        RETURN # to Event_LoadNextEvt

Event_CoreReprogram_CustomMove2:
        MOV  (R5)+,@$jmpLevelSpecificMoveB
        RETURN # to Event_LoadNextEvt

Event_CoreReprogram_CustomMove3:
        MOV  (R5)+,@$jmpLevelSpecificMoveC
        RETURN # to Event_LoadNextEvt

Event_CoreReprogram_CustomMove4:
        MOV  (R5)+,@$jmpLevelSpecificMoveD
        RETURN # to Event_LoadNextEvt

Event_SmartBombSpecial:
      # Custom smartbomb handler - needed to wipe Omega array during final boss
       #MOV  (R5)+,@$SmartBombSpecial_Plus2 - 2
        RETURN # to Event_LoadNextEvt

Event_ObjectFullCustomMoves: # Override whole move handler
       #MOV  (R5)+,@$ObjectDoMovesOverride_Plus2 - 2
        RETURN # to Event_LoadNextEvt

Event_CoreReprogram_AnimatorPointer:
        MOV  (R5)+,@$ObjectAnimator_AnimatorPointers
        RETURN # to Event_LoadNextEvt

Event_CustomProgram1:
        MOV  (R5)+,@$ObjectProgram_Custom1
        RETURN # JMP @$Event_LoadNextEvt

Event_CustomProgram2:
        MOV  (R5)+,@$ObjectProgram_Custom2
        RETURN # to Event_LoadNextEvt

Event_CustomPlayerHitter:
       #MOV  (R5)+,@$customPlayerHitter_Plus2 - 2
        RETURN # to Event_LoadNextEvt

Event_CustomSmartBomb:
       #MOV  (R5)+,@$CustomSmartBombEnemy_Plus2 - 2
        RETURN # to Event_LoadNextEvt

Event_CoreReprogram_ShotToDeath:
       #MOV  (R5)+,@$CustomShotToDeathCall_Plus2 - 2
        RETURN # to Event_LoadNextEvt

Event_CoreReprogram_ObjectHitHandler:
        MOV  (R5)+,@$dstObjectShotOverride
        RETURN # to Event_LoadNextEvt

Event_CoreReprogram_Palette:
        MOV  (R5)+,@$PPUCommandArg
       .ppudo_ensure $PPU_SetPalette
        RETURN # to Event_LoadNextEvt

      # reads in Offset then Bytecount from (HL) and dumps to destination DE
                                                            # Event_CoreReprogram_DataCopy:
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
        RETURN                                              #     ret
                                                            #
# Event_MoveSwitch: # not used, legacy                      # Event_MoveSwitch:
#         JMP  @Event_MoveVector(R1)                        #     jp VectorJump_PushHlFirst
                                                            #
# Used to remember boss objects and apply custom animation etc by hacking the object array.
Event_LoadLastAddedObjectToAddress:
        MOV  @$Objects_LastAdded,@(R5)+
        RETURN
                                                            #
# call a function - be very careful what you do, as registers must be pretty
# much untouched otherwise a crash will occur on return. it's best to set a flag
# and do some action in your level loop, as that won't corrupt any registers.
Event_CallSubroutine: # Event_Call_1001:
        JMP @(R5)+ # Event_LoadNextEvt is on top of the stack

                                                            # Event_ClearPowerups: ; used at the start of each level to take the users powerups
                                                            #     call ResetPowerup
                                                            #     ret

      # alter stream time
Event_ChangeStreamTime: # Event_ChangeStreamTime_1000:
        MOV  (R5)+,R0
        MOV  (R5),R5
        CALL SetLevelTime

        TST  (SP)+ # we didn't use up the Event_LoadNextEvt on the stack
        JMP  Event_MoreEvents # uknc/event_stream.s:124

# Add to the foreground (top of the object array)
Event_AddToForeground: # Event_AddFront_0110:
        MOV  $1,@$ObjectAddToForeBack
        RETURN

# Add to the background (bottom of the object array)
Event_AddToBackground: # Event_AddBack_0111:
        CLR  @$ObjectAddToForeBack
        RETURN

# Change time between events, used on water level when waterlevel changes -
# it was too slow by default
                                                            # Event_ChangeStreamSpeed_1100:
                                                            #     rst 6
                                                            #     ld (Event_LevelSpeed_Plus1-1),a
                                                            #     ret

# we don't have a tile array - this does spikes in stage 7 and 8 - this can work
# horiz or vert depending on scroll
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

Event_SingleSprite: # Type 0 - one Obj
        CMP  R1,$1
        BEQ  Event_OneObjYOnly

        CMP  R1,$14
        BHIS Event_OneObjectBurst

        TST  R1
        BNZ  Event_OneObjQuick
        BR   Event_OneObject

Event_OneObjectBurst: # Burst Object
       .equiv BurstPosition, .+2  # Y: LSB, X: MSB
        MOV  $0x0000,R2           # ld bc,&0000 :BurstPosition_Plus2 # D: X, C: Y
                                  # ld d,b
        BR   Event_OneObjectStrip # jr Event_OneObjectStrip

      # Type 1 - Read in Y and dump the same sprite to far right
Event_OneObjYOnly:
        MOV  $24+160,R2
        SWAB R2
        CLRB R2
        BISB (R5)+,R2              # ld c,(hl) ; Y
        INC  R5                    # inc hl
        BR   Event_OneObjectStrip  # jr Event_OneObjQuick_GO

      # one sprite, same as last time Y * 16 (Y 2-13)
Event_OneObjQuick:
        ASL  R1                   #     rla
        ASL  R1                   #     rla
        ASL  R1                   #     rla
        ASL  R1                   #     rla
        SUB  $8,R1                #     sub 8
                                  #
        CLR  R2                   # OneObjectQuick_Program:
        BISB $24+160, R2          #     ld C,a
        SWAB R2                   #
                                  # Event_OneObjQuick_GO:
        BISB R1,R2                #     ld D,160+24
        BR   Event_OneObjectStrip #     jr Event_OneObjectStrip

Event_OneObject:
                                            # rst 6
        MOV  (R5)+,@$EventObjectSpriteToAdd # ld (EventObjectSpriteToAdd_Plus1 - 1),a
        MOV  (R5)+,R2 # Y=LSB, X=MSB        # ld d,(hl)   ;X
                                            # inc hl
                                            # Event_OneObjectColumn:
                                            # ld c,(hl)   ;Y
                                            # inc hl
Event_OneObjectStrip: # look for a space in the object array
                                            # push hl
        CALL Event_AddObject                # call Event_AddObject
                                            # pop hl
        RETURN                              # ret

Event_AddObject: # called by object_driver as well
       .equiv ObjectAddToForeBack, .+2             # ld a,0  :ObjectAddToForeBack_Plus1
        TST  $0x00                                 # or a
        BNZ  Event_AddObjectBack                   # jr z,Event_AddObjectBack
        #     0062703 == ADD (PC)+,R3              # ;add object to the front
        MOV  $0062703,@$opcAddObject_MoveDirection # ld a,&23 ; 23 == INC HL
                                                   # ld (hl),a
        CLR  R0                                    # xor a   :BackgroundNoSpritesTurbo_Plus1
        BR   Event_AddObjectStart                  # jr Event_AddObjectStart
                                                   #
    Event_AddObjectBack:
        #     0162703 == SUB (PC)+,R3
        MOV  $0162703,@$opcAddObject_MoveDirection # ld a,&2B ; 2B == DEC HL
                                                   # ld (hl),a
        MOV  $(ObjectArraySize - 1) * 8,R0         # ld a,ObjectArraySize ;(ObjectArray_Size)
                                                   # dec a

    Event_AddObjectStart:
      # R2=XY  Y=LSB, X=MSB                        # ; D=X C=Y
        MOV  $ObjectArrayPointer,R3                # ld b,ObjectArraySize;a
        ADD  R0,R3                                 # ld hl,ObjectArrayPointer;(ObjectArrayAddress)
                                                   # add l       ; add l to a (start of loop)
        MOV  $ObjectArraySize,R4                   # ld l,a

    Event_Objectloop:
                                          # ld a,(hl)   ; Y check
        TSTB (R3)                         # or a
        BNZ  Event_ObjectLoopNext         # jp NZ,Event_ObjectLoopNext
                                          # ;found a free slot!
       .equiv Objects_LastAdded, .+2
        MOV  R3,$0x0000                   # ld (Objects_LastAdded_Plus2 - 2),hl
                                          # ld a,c
        BIC  $0b111,R2                    # and %11111000
                                          # ld (hl),a
                                          # inc h;
        MOV  R2,(R3)+ # Y=LSB, X=MSB      # ld (hl),d ;X
       .equiv EventObjectMoveToAdd, .+2   # inc h
        MOVB $0x00,(R3)+                  # ld (hl),&0 :EventObjectMoveToAdd_Plus1   ; Move
       .equiv EventObjectSpriteToAdd, .+2 # inc h
        MOVB $0x00,(R3)+                  # ld (hl),&0 :EventObjectSpriteToAdd_Plus1 ; sprite
                                          # set 6,l
       .equiv EventObjectLifeToAdd, .+2   #
        MOV  $0x00,R0                     # ld a,&0 :EventObjectLifeToAdd_Plus1 ; life
                                          # push af
        CMPB @$LivePlayers,$1             #     ld a,(LivePlayers)
        BEQ  AddObjectOnePlayer           #     dec a
                                          #     jr z,AddObjectOnePlayer
                                          # pop af
                                          # cp %11000000
                                          # jr c,AddObjectTwoPlayer
                                          # cp 255  ;lifCustom
                                          # jr z,AddObjectTwoPlayer
                                          # push bc
                                          #     ld b,a
                                          #     sla a
                                          #
                                          #     or %11000000
                                          #     cp b
                                          # pop bc
                                          # jr NC,AddObjectTwoPlayer
                                          # ld a,%11111110
                                          # jr AddObjectTwoPlayer

    AddObjectOnePlayer:                               # AddObjectOnePlayer:
                                                      #     pop af
                                                      # AddObjectTwoPlayer:
        MOVB R0,(R3)+    # LifeToAdd                  #     ld (hl),a
       .equiv EventObjectProgramToAdd, .+2
        MOVB $0x00,(R3)+ # Program code
       .equiv EventObjectSpriteSizeToAdd, .+2
        MOVB $0x00,(R3)+ # Sprite size for collisions
       .equiv EventObjectAnimatorToAdd, .+2
        MOVB $0x00,(R3)+ # Animator

        RETURN

    Event_ObjectLoopNext:
        opcAddObject_MoveDirection:
        ADD  $8,R3
        SOB  R4,Event_Objectloop
        RETURN

Event_SaveObjSettings:
        ASL  R1
        ASL  R1
        ASL  R1
        ADD  $Event_SavedSettings,R1
        MOV  $ObjectSettingsVectors,R0

        MOVB @(R0)+,(R1)+
        MOVB @(R0)+,(R1)+
        MOVB @(R0)+,(R1)+
        MOVB @(R0)+,(R1)+
        MOVB @(R0)+,(R1)+
        MOVB @(R0)+,(R1)+
        MOVB @(R0)+,(R1)

        RETURN

Event_LoadObjSettings:
        ASL  R1
        ASL  R1
        ASL  R1
        ADD  $Event_SavedSettings,R1
        MOV  $ObjectSettingsVectors,R0

        MOVB (R1)+,@(R0)+
        MOVB (R1)+,@(R0)+
        MOVB (R1)+,@(R0)+
        MOVB (R1)+,@(R0)+
        MOVB (R1)+,@(R0)+
        MOVB (R1)+,@(R0)+
        MOVB (R1), @(R0)+

        RETURN

ObjectSettingsVectors:
       .word EventObjectProgramToAdd
       .word EventObjectMoveToAdd
       .word EventObjectLifeToAdd
       .word EventObjectSpriteToAdd
       .word EventObjectSpriteSizeToAdd
       .word EventObjectAnimatorToAdd
       .word ObjectAddToForeBack

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
