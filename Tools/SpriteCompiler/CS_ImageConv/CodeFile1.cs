namespace CsImageConv
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Windows.Forms;

    class globals{
        
        public static int[,] PixelMap = new int[340, 200];
        public static System.Drawing.Bitmap LastFrame=null;
        public static string RegBC = "";
        public static string RegDE = "";
        public static string RegHL = "";
        public static int DEUsed = 0;
        public static int PicNumber = 0;
        public static string LastDE = "";
        public static string LastHL = "";
        public static string ChunkDeBak = "";
        public static string BitmapData = "";
        public static string[] ChunkCache_Name = new string[20480];
        public static string[] ChunkCache_Data = new string[20480];
        public static string[] ChunkCache_DE = new string[20480];
        public static int[] ChunkCache_Reused = new int[20480];
        public static int ChunkCache = 0;


        public static string[] PairCache_Data = new string[20480];
        public static int PairCache_Count = 0;

        public static bool SkipNextline = false;
        public static int GlobalsDone = 0;
        public static string initdata = VbX.Chr(13) + VbX.Chr(10) + "nolist" + VbX.Chr(13) + VbX.Chr(10) +
            "LD hl,&D5E1" + VbX.Chr(13) + VbX.Chr(10) + "ld (&0030),hl" + VbX.Chr(13) + VbX.Chr(10) + "LD hl,&D5D5" + VbX.Chr(13) + VbX.Chr(10) + "ld (&0032),hl" + VbX.Chr(13) + VbX.Chr(10) + "LD hl,&D5E9" + VbX.Chr(13) + VbX.Chr(10) + "ld (&0034),hl" + VbX.Chr(13) + VbX.Chr(10);
        public static System.Text.StringBuilder imagedata = new System.Text.StringBuilder();
        public static System.Text.StringBuilder globaldata = new System.Text.StringBuilder();
        public static int localnextline = 0;
        public static int localnextlinenum = -1;
        public static int MaxDePush = 5;
        public static bool DoRawBmp = false;
        public static bool[] DePushUsed = new bool[41];
        public static bool[] BitmapPushLastUsed = new bool[41];
        public static bool[] BitmapDataLastUsed = new bool[41];
        public static bool[] MultiPushDeLast = new bool[41];
        public static bool[] BitmapDataUsed = new bool[81];
        public static int[,] LastPixelMap = new int[340, 200];




        public static string IntToBin(int i)
        {
            return VbX.Right("00000000" + Convert.ToString(i, 2), 8);
        }
        public static string HexToBin(string i) {
            try
            {
                int hint = Convert.ToInt32(i, 16);
                return IntToBin(hint);
            }
            catch (Exception e) {
                return "00000000";
            }
            
        //.ToString("X");
        }
        public static string BinToHex(string i)
        {
            int hint = Convert.ToInt32(i, 2);
            return hint.ToString("X");
            //.ToString("X");
        }
        public static int BinToInt(string B)
        {
            return Convert.ToInt32(B, 2);
        }

        public static string BinOr(string B1, string B2) {
            string NewBin = "";
            for (int i = 0; i < 8; i++) {
                if (B2.Substring(i, 1) == "1" || B1.Substring(i, 1) == "1")
                {
                    NewBin += "1";
                }
                else {
                    NewBin += "0";
                }
            }
            return NewBin;
        }
        public static string BinAnd(string B1, string B2)
        {
            string NewBin = "";
            for (int i = 0; i < 8; i++)
            {
                if (B2.Substring(i, 1) == "1" && B1.Substring(i, 1) == "1")
                {
                    NewBin += "1";
                }
                else
                {
                    NewBin += "0";
                }
            }
            return NewBin;
        }



        public static string AkuyouInit =
            "read \"..\\CoreDefs.asm\" ;read \"BootStrap.asm\"" + VbX.Chr(13) + VbX.Chr(10);
            
            // akuyou V2 - this hooks our existing background code
            
            //"ld hl,(BackgroundSolidFillNextLine_Minus1+1)"+ VbX.Chr(13) + VbX.Chr(10) +

        public static string AkuyouNextFile =
            "ld (Background_CompiledSprite_Minus1+1),de"+ VbX.Chr(13) + VbX.Chr(10) +
            "call Akuyou_ScreenBuffer_GetActiveScreen" + VbX.Chr(13) + VbX.Chr(10) +
            "ld h,a" + VbX.Chr(13) + VbX.Chr(10) +
            "ld l,&50" + VbX.Chr(13) + VbX.Chr(10) +
            "ld (StackRestore_Plus2-2),sp" + VbX.Chr(13) + VbX.Chr(10) +
            "di" + VbX.Chr(13) + VbX.Chr(10) +
            "ld sp,hl" + VbX.Chr(13) + VbX.Chr(10);





        public static string AkuyouNextLine =

           "NextLine: " + VbX.Chr(13) + VbX.Chr(10) +

    "ld hl,&0850" + VbX.Chr(13) + VbX.Chr(10) +
    "add hl,sp" + VbX.Chr(13) + VbX.Chr(10) +

    "ei" + VbX.Chr(13) + VbX.Chr(10) +
    "ld sp,&0000:StackRestore_Plus2" + VbX.Chr(13) + VbX.Chr(10) +
    "di" + VbX.Chr(13) + VbX.Chr(10) +

    "ld sp,hl" + VbX.Chr(13) + VbX.Chr(10) +
    //"jp CompiledSprite_GetNxtLin :CompiledSprite_NextLineJump_Plus2" + VbX.Chr(13) + VbX.Chr(10) +
    //"CompiledSprite_GetNxtLin:" + VbX.Chr(13) + VbX.Chr(10) +
    //"jp nc,JumpToNextLine" + VbX.Chr(13) + VbX.Chr(10) +

    //"ld hl,&c050" + VbX.Chr(13) + VbX.Chr(10) +
    //"add hl,sp" + VbX.Chr(13) + VbX.Chr(10) +
    //"ld sp,hl" + VbX.Chr(13) + VbX.Chr(10) +
    //"jp JumpToNextLine" + VbX.Chr(13) + VbX.Chr(10) +
    //"CompiledSprite_GetNxtLinAlt:" + VbX.Chr(13) + VbX.Chr(10) +
    "Background_CompiledSprite_Minus1:" + VbX.Chr(13) + VbX.Chr(10) +
    "bit 7,h" + VbX.Chr(13) + VbX.Chr(10) +
    "jp z,JumpToNextLine" + VbX.Chr(13) + VbX.Chr(10) +
    "ld hl,&c050" + VbX.Chr(13) + VbX.Chr(10) +
    "add hl,sp" + VbX.Chr(13) + VbX.Chr(10) +
    "ld sp,hl" + VbX.Chr(13) + VbX.Chr(10) +
    ";push hl" + VbX.Chr(13) + VbX.Chr(10) +
    "jp JumpToNextLine" + VbX.Chr(13) + VbX.Chr(10) +

    "JumpToNextLine: " + VbX.Chr(13) + VbX.Chr(10) +
    "LD L,(IX)" + VbX.Chr(13) + VbX.Chr(10) +
    "INC IX" + VbX.Chr(13) + VbX.Chr(10) +
    "LD H,(IX)" + VbX.Chr(13) + VbX.Chr(10) +
    "INC IX" + VbX.Chr(13) + VbX.Chr(10) +
    "JP (HL)" + VbX.Chr(13) + VbX.Chr(10)
;

        public static string AkuyouNextLineBCdisable = "CompiledSprite_GetNxtLinbc: defw &0000 :CompiledSprite_NextLineJumpBC_Plus2" + VbX.Chr(13) + VbX.Chr(10);
        public static string AkuyouNextLineBC =

       "NextLineBC: " + VbX.Chr(13) + VbX.Chr(10) +

"ld hl,&0850" + VbX.Chr(13) + VbX.Chr(10) +
"add hl,sp" + VbX.Chr(13) + VbX.Chr(10) +

"ld sp,(StackRestore_Plus2-2)" + VbX.Chr(13) + VbX.Chr(10) +
"ei" + VbX.Chr(13) + VbX.Chr(10) +
"di" + VbX.Chr(13) + VbX.Chr(10) +

"ld sp,hl" + VbX.Chr(13) + VbX.Chr(10) +
"jp CompiledSprite_GetNxtLinBC :CompiledSprite_NextLineJumpBC_Plus2" + VbX.Chr(13) + VbX.Chr(10) +
"CompiledSprite_GetNxtLinBC:" + VbX.Chr(13) + VbX.Chr(10) +
"jp nc,JumpToNextLineBC" + VbX.Chr(13) + VbX.Chr(10) +

"ld hl,&c050" + VbX.Chr(13) + VbX.Chr(10) +
"add hl,sp" + VbX.Chr(13) + VbX.Chr(10) +
"ld sp,hl" + VbX.Chr(13) + VbX.Chr(10) +
"jp JumpToNextLineBC" + VbX.Chr(13) + VbX.Chr(10) +
"CompiledSprite_GetNxtLinAltBC:" + VbX.Chr(13) + VbX.Chr(10) +
"bit 7,h" + VbX.Chr(13) + VbX.Chr(10) +
"jp z,JumpToNextLineBC" + VbX.Chr(13) + VbX.Chr(10) +
"ld hl,&c050" + VbX.Chr(13) + VbX.Chr(10) +
"add hl,sp" + VbX.Chr(13) + VbX.Chr(10) +
"ld sp,hl" + VbX.Chr(13) + VbX.Chr(10) +
";push hl" + VbX.Chr(13) + VbX.Chr(10) +
"jp JumpToNextLineBC" + VbX.Chr(13) + VbX.Chr(10) +

"JumpToNextLineBC: " + VbX.Chr(13) + VbX.Chr(10) +
"LD L,C" + VbX.Chr(13) + VbX.Chr(10) +
"LD H,B" + VbX.Chr(13) + VbX.Chr(10) +
"JP (HL)" + VbX.Chr(13) + VbX.Chr(10)
;

public static bool UseLooper=false;
public static string LooperDef =
        "LooperContinueAddress:defw LooperContinue" + VbX.Chr(13) + VbX.Chr(10) +
"Looper:" + VbX.Chr(13) + VbX.Chr(10) +

"ld b,ixh" + VbX.Chr(13) + VbX.Chr(10) +
"ld c,ixl" + VbX.Chr(13) + VbX.Chr(10) +

"LD a,(bc)" + VbX.Chr(13) + VbX.Chr(10) +
"INC bc" + VbX.Chr(13) + VbX.Chr(10) +
"ld (Looper_CountB_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +
"LD a,(bc)" + VbX.Chr(13) + VbX.Chr(10) +
"INC bc" + VbX.Chr(13) + VbX.Chr(10) +
"ld (Looper_CountSize_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +
"ld (RestoreLooperAddress_Plus2-2),bc" + VbX.Chr(13) + VbX.Chr(10) +

"LooperNextStage:" + VbX.Chr(13) + VbX.Chr(10) +
"	ld hl,&0000 :RestoreLooperAddress_Plus2" + VbX.Chr(13) + VbX.Chr(10) +
"	ld (Looper_Address_Plus2-2),hl" + VbX.Chr(13) + VbX.Chr(10) +

"	ld a,0:Looper_CountB_Plus1" + VbX.Chr(13) + VbX.Chr(10) +
"	ld (Looper_Count_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +


"	LooperRepeat:" + VbX.Chr(13) + VbX.Chr(10) +
"		ld hl,&0000 :Looper_Address_Plus2" + VbX.Chr(13) + VbX.Chr(10) +

"		LD c,(hl)" + VbX.Chr(13) + VbX.Chr(10) +
"		INC hl" + VbX.Chr(13) + VbX.Chr(10) +
"		LD b,(hl)" + VbX.Chr(13) + VbX.Chr(10) +
"		INC hl" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (Looper_Address_Plus2-2),hl" + VbX.Chr(13) + VbX.Chr(10) +
"		ld h,b" + VbX.Chr(13) + VbX.Chr(10) +
"		ld l,c" + VbX.Chr(13) + VbX.Chr(10) +
"		ld ix,LooperContinueAddress" + VbX.Chr(13) + VbX.Chr(10) +
"		jp (hl)" + VbX.Chr(13) + VbX.Chr(10) +
"   LooperContinue:" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,0:Looper_Count_Plus1" + VbX.Chr(13) + VbX.Chr(10) +
"		dec a" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (Looper_Count_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +
"	jp nz,LooperRepeat" + VbX.Chr(13) + VbX.Chr(10) +


"	ld a,0:Looper_CountSize_Plus1" + VbX.Chr(13) + VbX.Chr(10) +
"	dec a" + VbX.Chr(13) + VbX.Chr(10) +
"	ld (Looper_CountSize_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +
"jp nz,LooperNextStage" + VbX.Chr(13) + VbX.Chr(10) +

"ld ix,(Looper_Address_Plus2-2)" + VbX.Chr(13) + VbX.Chr(10) +
"LD L,(IX)" + VbX.Chr(13) + VbX.Chr(10) +
"INC IX" + VbX.Chr(13) + VbX.Chr(10) +
"LD H,(IX)" + VbX.Chr(13) + VbX.Chr(10) +
"INC IX" + VbX.Chr(13) + VbX.Chr(10) +
"JP (HL)" + VbX.Chr(13) + VbX.Chr(10);

public static Boolean useRLE = false;
public static string RleDecoder =
      "RLE_ImageWidth equ 38" + VbX.Chr(13) + VbX.Chr(10) +

    "RLE_Draw:" + VbX.Chr(13) + VbX.Chr(10) +
"  		ld a,ixh" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (ImageWidthA_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (ImageWidthB_Plus2-2),a" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (ImageWidthC_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (ImageWidthD_Plus2-2),a" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (ImageWidthE_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +
"		cpl" + VbX.Chr(13) + VbX.Chr(10) +
"		inc a" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (NegativeImageWidth_Plus2-2),a" + VbX.Chr(13) + VbX.Chr(10) +



"		ld a,d" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (RLE_LastByteH_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,e" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (RLE_LastByteL_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +



"	push hl" + VbX.Chr(13) + VbX.Chr(10) +

//"		ld hl,&C000-1+20+RLE_ImageWidth" + VbX.Chr(13) + VbX.Chr(10) +
    //"		ld (RLE_ScrPos_Plus2-2),hl" + VbX.Chr(13) + VbX.Chr(10) +

"		ld a,IXL" + VbX.Chr(13) + VbX.Chr(10) +
"		ld h,&C0" + VbX.Chr(13) + VbX.Chr(10) +
"		LD L,a" + VbX.Chr(13) + VbX.Chr(10) +

"		ld a,b" + VbX.Chr(13) + VbX.Chr(10) +
    //"		ld hl,&C000-1+20+RLE_ImageWidth" + VbX.Chr(13) + VbX.Chr(10) +
"				ld de,&FFFF :NegativeImageWidth_Plus2" + VbX.Chr(13) + VbX.Chr(10) +
"		or a" + VbX.Chr(13) + VbX.Chr(10) +

"RLE_DrawGetNextLine:" + VbX.Chr(13) + VbX.Chr(10) +
"		jr z,RLE_DrawGotLine" + VbX.Chr(13) + VbX.Chr(10) +
"		call RLE_NextScreenLineHL" + VbX.Chr(13) + VbX.Chr(10) +
"		add hl,de" + VbX.Chr(13) + VbX.Chr(10) +
"		dec a" + VbX.Chr(13) + VbX.Chr(10) +
"		jr RLE_DrawGetNextLine" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_DrawGotLine:" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (RLE_ScrPos_Plus2-2),hl" + VbX.Chr(13) + VbX.Chr(10) +





"	;	xor a" + VbX.Chr(13) + VbX.Chr(10) +
"				ld iyl,RLE_ImageWidth :ImageWidthA_Plus1" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,255" + VbX.Chr(13) + VbX.Chr(10) +
"		ld e,a" + VbX.Chr(13) + VbX.Chr(10) +
"		;ld (Nibble_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +
"	pop hl" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_MoreBytesLoop:" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	inc hl" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,(hl)" + VbX.Chr(13) + VbX.Chr(10) +
"	ld b,a" + VbX.Chr(13) + VbX.Chr(10) +
"	or a" + VbX.Chr(13) + VbX.Chr(10) +
"	jp z,RLE_OneByteData" + VbX.Chr(13) + VbX.Chr(10) +
"	and %00001111" + VbX.Chr(13) + VbX.Chr(10) +
"	jp z,RLE_PlainBitmapData" + VbX.Chr(13) + VbX.Chr(10) +
"	ld ixh,0" + VbX.Chr(13) + VbX.Chr(10) +
"	ld ixl,a" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	;we're doing Nibble data, Expand the data into two pixels of Mode 1 and duplicate" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,b" + VbX.Chr(13) + VbX.Chr(10) +
"	and %00110000" + VbX.Chr(13) + VbX.Chr(10) +
"	rrca" + VbX.Chr(13) + VbX.Chr(10) +
"	rrca" + VbX.Chr(13) + VbX.Chr(10) +
"	ld c,a" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,b" + VbX.Chr(13) + VbX.Chr(10) +
"	and %11000000" + VbX.Chr(13) + VbX.Chr(10) +
"	or c" + VbX.Chr(13) + VbX.Chr(10) +
"	ld c,a" + VbX.Chr(13) + VbX.Chr(10) +
"	rrca	;Remove these for Left->right" + VbX.Chr(13) + VbX.Chr(10) +
"	rrca" + VbX.Chr(13) + VbX.Chr(10) +
"	or c" + VbX.Chr(13) + VbX.Chr(10) +
"	ld c,a" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,ixl" + VbX.Chr(13) + VbX.Chr(10) +
"	cp 15" + VbX.Chr(13) + VbX.Chr(10) +
"	jp nz,RLE_NoMoreNibbleBytes" + VbX.Chr(13) + VbX.Chr(10) +
"	push de" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_MoreNibbleBytes:" + VbX.Chr(13) + VbX.Chr(10) +
"		inc hl" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,(hl)" + VbX.Chr(13) + VbX.Chr(10) +
"		ld d,0" + VbX.Chr(13) + VbX.Chr(10) +
"		ld e,a" + VbX.Chr(13) + VbX.Chr(10) +
"		add ix,de" + VbX.Chr(13) + VbX.Chr(10) +
"		cp 255" + VbX.Chr(13) + VbX.Chr(10) +
"		jp z,RLE_MoreNibbleBytes" + VbX.Chr(13) + VbX.Chr(10) +
"	pop de" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_NoMoreNibbleBytes:" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,e" + VbX.Chr(13) + VbX.Chr(10) +
"	or a" + VbX.Chr(13) + VbX.Chr(10) +
"	jp z,RLE_MoreBytesPart2Flip" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,ixl" + VbX.Chr(13) + VbX.Chr(10) +
"	cp 4" + VbX.Chr(13) + VbX.Chr(10) +
"	call nc,RLE_ByteNibbles" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	xor a" + VbX.Chr(13) + VbX.Chr(10) +
"	ld d,a ;byte for screen" + VbX.Chr(13) + VbX.Chr(10) +
"	push hl" + VbX.Chr(13) + VbX.Chr(10) +
"	ld hl,&C050 :RLE_ScrPos_Plus2" + VbX.Chr(13) + VbX.Chr(10) +
"	ld b,iyl" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_MoreBytes:" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,c" + VbX.Chr(13) + VbX.Chr(10) +
"	and %00110011" + VbX.Chr(13) + VbX.Chr(10) +
"	or d" + VbX.Chr(13) + VbX.Chr(10) +
"	ld d,a" + VbX.Chr(13) + VbX.Chr(10) +
"	dec ix" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,ixl" + VbX.Chr(13) + VbX.Chr(10) +
"	or ixh" + VbX.Chr(13) + VbX.Chr(10) +
"	jr z,RLE_LastByteFlip" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_MoreBytesPart2:" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,c" + VbX.Chr(13) + VbX.Chr(10) +
"	and %11001100" + VbX.Chr(13) + VbX.Chr(10) +
"	or d" + VbX.Chr(13) + VbX.Chr(10) +
"	ld d,a" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	dec ix" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (hl),d" + VbX.Chr(13) + VbX.Chr(10) +
"		dec hl" + VbX.Chr(13) + VbX.Chr(10) +
"		dec b" + VbX.Chr(13) + VbX.Chr(10) +
"		call z,RLE_NextScreenLineHL" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	xor a" + VbX.Chr(13) + VbX.Chr(10) +
"	ld d,a ;byte for screen" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,ixl" + VbX.Chr(13) + VbX.Chr(10) +
"	or ixh" + VbX.Chr(13) + VbX.Chr(10) +
"	jr nz,RLE_MoreBytes" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_LastByte:" + VbX.Chr(13) + VbX.Chr(10) +
"	ld iyl,b" + VbX.Chr(13) + VbX.Chr(10) +
"	ld (RLE_ScrPos_Plus2-2),hl" + VbX.Chr(13) + VbX.Chr(10) +
"	pop hl" + VbX.Chr(13) + VbX.Chr(10) +
";	ld iyl,b" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,&00:RLE_LastByteH_Plus1" + VbX.Chr(13) + VbX.Chr(10) +
"	cp h" + VbX.Chr(13) + VbX.Chr(10) +
"	jp nz,RLE_MoreBytesLoop" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,&00:RLE_LastByteL_Plus1" + VbX.Chr(13) + VbX.Chr(10) +
"	cp l" + VbX.Chr(13) + VbX.Chr(10) +
"	jp nz,RLE_MoreBytesLoop" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10);


public static string RLE_NextScreenLineHL =
        "RLE_NextScreenLineHL:" + VbX.Chr(13) + VbX.Chr(10) +
"	push de" + VbX.Chr(13) + VbX.Chr(10) +
"				ld b,RLE_ImageWidth :ImageWidthE_Plus1" + VbX.Chr(13) + VbX.Chr(10) +
"		ld de,&800+RLE_ImageWidth :ImageWidthD_Plus2" + VbX.Chr(13) + VbX.Chr(10) +
"		add hl,de" + VbX.Chr(13) + VbX.Chr(10) +
"	pop de" + VbX.Chr(13) + VbX.Chr(10) +
"	ret nc" + VbX.Chr(13) + VbX.Chr(10) +
"	push de" + VbX.Chr(13) + VbX.Chr(10) +
"		ld de,&c050" + VbX.Chr(13) + VbX.Chr(10) +
"		add hl,de" + VbX.Chr(13) + VbX.Chr(10) +
"	pop de" + VbX.Chr(13) + VbX.Chr(10) +
"	ret" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10);


public static string RleDecoder2=
"	exx 			;keep the firmware working!" + VbX.Chr(13) + VbX.Chr(10) +
"	pop bc" + VbX.Chr(13) + VbX.Chr(10) +
"	exx" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	ret" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_LastByteFlip:" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,e" + VbX.Chr(13) + VbX.Chr(10) +
"	cpl" + VbX.Chr(13) + VbX.Chr(10) +
"	ld e,a" + VbX.Chr(13) + VbX.Chr(10) +
"	jp RLE_LastByte" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_MoreBytesPart2Flip:" + VbX.Chr(13) + VbX.Chr(10) +
"	push hl" + VbX.Chr(13) + VbX.Chr(10) +
"	ld b,iyl" + VbX.Chr(13) + VbX.Chr(10) +
"	ld hl,(RLE_ScrPos_Plus2-2)" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,e" + VbX.Chr(13) + VbX.Chr(10) +
"	cpl" + VbX.Chr(13) + VbX.Chr(10) +
"	ld e,a" + VbX.Chr(13) + VbX.Chr(10) +
"	jp RLE_MoreBytesPart2" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_NextScreenLineHL:" + VbX.Chr(13) + VbX.Chr(10) +
"	push de" + VbX.Chr(13) + VbX.Chr(10) +
"				ld b,RLE_ImageWidth :ImageWidthE_Plus1" + VbX.Chr(13) + VbX.Chr(10) +
"		ld de,&800+RLE_ImageWidth :ImageWidthD_Plus2" + VbX.Chr(13) + VbX.Chr(10) +
"		add hl,de" + VbX.Chr(13) + VbX.Chr(10) +
"	pop de" + VbX.Chr(13) + VbX.Chr(10) +
"	ret nc" + VbX.Chr(13) + VbX.Chr(10) +
"	push de" + VbX.Chr(13) + VbX.Chr(10) +
"		ld de,&c050" + VbX.Chr(13) + VbX.Chr(10) +
"		add hl,de" + VbX.Chr(13) + VbX.Chr(10) +
"	pop de" + VbX.Chr(13) + VbX.Chr(10) +
"	ret" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_NextScreenLine:" + VbX.Chr(13) + VbX.Chr(10) +
"	push hl" + VbX.Chr(13) + VbX.Chr(10) +
"		ld iyl,RLE_ImageWidth :ImageWidthC_Plus1" + VbX.Chr(13) + VbX.Chr(10) +
"		ld hl,&800+RLE_ImageWidth :ImageWidthB_Plus2" + VbX.Chr(13) + VbX.Chr(10) +
"		add hl,de" + VbX.Chr(13) + VbX.Chr(10) +
"		ex hl,de" + VbX.Chr(13) + VbX.Chr(10) +
"	pop hl" + VbX.Chr(13) + VbX.Chr(10) +
"	ret nc" + VbX.Chr(13) + VbX.Chr(10) +
"	push hl" + VbX.Chr(13) + VbX.Chr(10) +
"		ld hl,&c050" + VbX.Chr(13) + VbX.Chr(10) +
"		add hl,de" + VbX.Chr(13) + VbX.Chr(10) +
"		ex hl,de" + VbX.Chr(13) + VbX.Chr(10) +
"	pop hl" + VbX.Chr(13) + VbX.Chr(10) +
"	ret" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_PlainBitmapData:" + VbX.Chr(13) + VbX.Chr(10) +
"	push de" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,(hl)" + VbX.Chr(13) + VbX.Chr(10) +
"		rrca" + VbX.Chr(13) + VbX.Chr(10) +
"		rrca" + VbX.Chr(13) + VbX.Chr(10) +
"		rrca" + VbX.Chr(13) + VbX.Chr(10) +
"		rrca" + VbX.Chr(13) + VbX.Chr(10) +
"		ld b,0" + VbX.Chr(13) + VbX.Chr(10) +
"		ld c,a" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		cp 15" + VbX.Chr(13) + VbX.Chr(10) +
"		jp nz,RLE_PlainBitmapDataNoExtras" + VbX.Chr(13) + VbX.Chr(10) +
"	;More than 14 bytes, load an extra byte into the count" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_PlainBitmapDataHasExtras:" + VbX.Chr(13) + VbX.Chr(10) +
"		inc hl" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,(hl)" + VbX.Chr(13) + VbX.Chr(10) +
"		or a" + VbX.Chr(13) + VbX.Chr(10) +
"		jr z,RLE_PlainBitmapDataNoExtras	; no more bytes" + VbX.Chr(13) + VbX.Chr(10) +
"		push hl" + VbX.Chr(13) + VbX.Chr(10) +
"			ld h,0" + VbX.Chr(13) + VbX.Chr(10) +
"			ld l,a" + VbX.Chr(13) + VbX.Chr(10) +
"			add hl,bc" + VbX.Chr(13) + VbX.Chr(10) +
"			ld b,h" + VbX.Chr(13) + VbX.Chr(10) +
"			ld c,l" + VbX.Chr(13) + VbX.Chr(10) +
"		pop hl" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		cp 255" + VbX.Chr(13) + VbX.Chr(10) +
"		jr z,RLE_PlainBitmapDataHasExtras" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_PlainBitmapDataNoExtras:" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	" + VbX.Chr(13) + VbX.Chr(10) +
"		ld de,(RLE_ScrPos_Plus2-2)" + VbX.Chr(13) + VbX.Chr(10) +
"		RLE_PlainBitmapData_More:" + VbX.Chr(13) + VbX.Chr(10) +
"		inc hl" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,(hl)" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (de),a" + VbX.Chr(13) + VbX.Chr(10) +
"		dec de" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		dec iyl" + VbX.Chr(13) + VbX.Chr(10) +
"		call z,RLE_NextScreenLine" + VbX.Chr(13) + VbX.Chr(10) +
"		dec bc" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,b" + VbX.Chr(13) + VbX.Chr(10) +
"		or c" + VbX.Chr(13) + VbX.Chr(10) +
"		jp nz,RLE_PlainBitmapData_More" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (RLE_ScrPos_Plus2-2),de" + VbX.Chr(13) + VbX.Chr(10) +
";ret" + VbX.Chr(13) + VbX.Chr(10) +
"	pop de" + VbX.Chr(13) + VbX.Chr(10) +
"	jp RLE_MoreBytesLoop" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_OneByteData:" + VbX.Chr(13) + VbX.Chr(10) +
"	push de" + VbX.Chr(13) + VbX.Chr(10) +
"		xor a " + VbX.Chr(13) + VbX.Chr(10) +
"		ld b,a" + VbX.Chr(13) + VbX.Chr(10) +
"		ld c,a" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_OneByteDataExtras:" + VbX.Chr(13) + VbX.Chr(10) +
"		inc hl" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,(hl)" + VbX.Chr(13) + VbX.Chr(10) +
"		push hl" + VbX.Chr(13) + VbX.Chr(10) +
"			ld h,0" + VbX.Chr(13) + VbX.Chr(10) +
"			ld l,a" + VbX.Chr(13) + VbX.Chr(10) +
"			add hl,bc" + VbX.Chr(13) + VbX.Chr(10) +
"			ld b,h" + VbX.Chr(13) + VbX.Chr(10) +
"			ld c,l" + VbX.Chr(13) + VbX.Chr(10) +
"		pop hl" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		cp 255" + VbX.Chr(13) + VbX.Chr(10) +
"		jp z,RLE_OneByteDataExtras" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		inc hl" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,(hl)" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (RLE_ThisOneByte_Plus1-1),a" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		ld de,(RLE_ScrPos_Plus2-2)" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_OneByteData_More:" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,00:RLE_ThisOneByte_Plus1" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (de),a" + VbX.Chr(13) + VbX.Chr(10) +
"		dec de" + VbX.Chr(13) + VbX.Chr(10) +
"		dec iyl" + VbX.Chr(13) + VbX.Chr(10) +
"		call z,RLE_NextScreenLine" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		dec bc" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,b" + VbX.Chr(13) + VbX.Chr(10) +
"		or c" + VbX.Chr(13) + VbX.Chr(10) +
"		jp nz,RLE_OneByteData_More" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (RLE_ScrPos_Plus2-2),de" + VbX.Chr(13) + VbX.Chr(10) +
"		;ret" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	pop de" + VbX.Chr(13) + VbX.Chr(10) +
"	jp RLE_MoreBytesLoop" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_ByteNibbles:" + VbX.Chr(13) + VbX.Chr(10) +
"	di" + VbX.Chr(13) + VbX.Chr(10) +
"	ld a,c" + VbX.Chr(13) + VbX.Chr(10) +
"	exx" + VbX.Chr(13) + VbX.Chr(10) +
"	ld b,iyl" + VbX.Chr(13) + VbX.Chr(10) +
"	ld c,a" + VbX.Chr(13) + VbX.Chr(10) +
"	ld d,ixh" + VbX.Chr(13) + VbX.Chr(10) +
"	ld e,ixl" + VbX.Chr(13) + VbX.Chr(10) +
"		ld hl,(RLE_ScrPos_Plus2-2)" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_ByteNibblesMore3:" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,3" + VbX.Chr(13) + VbX.Chr(10) +
"RLE_ByteNibblesMore:" + VbX.Chr(13) + VbX.Chr(10) +
"		ld (hl),c" + VbX.Chr(13) + VbX.Chr(10) +
"		dec hl " + VbX.Chr(13) + VbX.Chr(10) +
"		dec b;iyl" + VbX.Chr(13) + VbX.Chr(10) +
"		call z,RLE_NextScreenLineHL" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		dec de" + VbX.Chr(13) + VbX.Chr(10) +
"		dec de" + VbX.Chr(13) + VbX.Chr(10) +
"		cp e" + VbX.Chr(13) + VbX.Chr(10) +
"		jp c,RLE_ByteNibblesMore" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"		ld a,d" + VbX.Chr(13) + VbX.Chr(10) +
"		or a" + VbX.Chr(13) + VbX.Chr(10) +
"		jp nz,RLE_ByteNibblesMore3" + VbX.Chr(13) + VbX.Chr(10) +
"" + VbX.Chr(13) + VbX.Chr(10) +
"	ld (RLE_ScrPos_Plus2-2),hl" + VbX.Chr(13) + VbX.Chr(10) +
"	ld iyl,b" + VbX.Chr(13) + VbX.Chr(10) +
"	ld ixh,d" + VbX.Chr(13) + VbX.Chr(10) +
"	ld ixl,e" + VbX.Chr(13) + VbX.Chr(10) +
"	exx" + VbX.Chr(13) + VbX.Chr(10) +
"";


    }



}