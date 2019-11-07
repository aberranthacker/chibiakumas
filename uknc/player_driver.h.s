        .equiv  srcSpendTimeout, SpendTimeout_Plus2 - 2

        .equiv  srcShowContinueCounter, ShowContinueCounter_Plus2 - 2
        .global srcShowContinueCounter

        .global ShowContinuesSelfMod
        .global SpendCreditSelfMod
        .global Player_GetPlayerVars

        .equiv  srcContinuesScreenPos, ContinuesScreenPos_Plus2 - 2
        .global srcContinuesScreenPos

        .equiv  dstFireUpHandler, FireUpHandler_Plus2 - 2
        .global dstFireUpHandler

        .equiv  dstFireDownHandler, FireDownHandler_Plus2 - 2
        .global dstFireDownHandler

        .equiv  dstFireLeftHandler, FireLeftHandler_Plus2 - 2
        .global dstFireLeftHandler

        .equiv  dstFireRightHandler, FireRightHandler_Plus2 - 2
        .global dstFireRightHandler

        .global SetFireDir_UP
        .global SetFireDir_DOWN
        .global SetFireDir_LEFTsave
        .global SetFireDir_LEFT
        .global SetFireDir_RIGHTsave
        .global SetFireDir_RIGHT
        .global SetFireDir_Fire
        .global SetFireDir_FireAndSaveRestore

        .equiv  dstFire2Handler, Fire2Handler_Plus2 - 2
        .global dstFire2Handler

        .equiv  dstFire1Handler, Fire1Handler_Plus2 - 2
        .global dstFire1Handler

        .equiv  srcPlayerSaveShot, PlayerSaveShot_Plus2 - 2
        #.global srcPlayerSaveShot

        .equiv  dstDroneFlipFireCurrent, DroneFlipFireCurrent_Plus2 - 2
        .global dstDroneFlipFireCurrent

        .equiv  srcPlayerThisSprite, PlayerThisSprite_Plus4 - 4
        .equiv  srcPlayerThisShot,   PlayerThisShot_Plus4 - 4

        .equiv  dstPlayerDoFire, PlayerDoFire_Plus2 - 2

