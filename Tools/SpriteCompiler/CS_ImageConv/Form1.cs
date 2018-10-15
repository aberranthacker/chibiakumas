using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace CsImageConv
{
   
    public partial class Form1 : Form
    {
        int RandomReg = 0;
        string nl = VbX.Chr(13) + VbX.Chr(10);
        public Form1()
        {
            InitializeComponent();
        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {

          

        }

        private void Color0_Click(object sender, EventArgs e)
        {
            if (colorDialog1.ShowDialog() == DialogResult.OK) ((Control)sender).BackColor = colorDialog1.Color;      
        }

        private void Color1_Click(object sender, EventArgs e)
        {
            if (colorDialog1.ShowDialog() == DialogResult.OK) ((Control)sender).BackColor = colorDialog1.Color;
        }

        private void Color2_Click(object sender, EventArgs e)
        {
            if (colorDialog1.ShowDialog() == DialogResult.OK) ((Control)sender).BackColor = colorDialog1.Color;
        }

        private void Color3_Click(object sender, EventArgs e)
        {
            if (colorDialog1.ShowDialog() == DialogResult.OK) ((Control)sender).BackColor = colorDialog1.Color;
        }

        private void ColorA_Click(object sender, EventArgs e)
        {
            if (colorDialog1.ShowDialog() == DialogResult.OK) ((Control)sender).BackColor = colorDialog1.Color;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            OpenFileDialog fd = new OpenFileDialog();
            fd.Filter = "All files (*.*)|*.*";
            DialogResult dr = fd.ShowDialog();
            if (dr == DialogResult.OK) txtFilename.Text = fd.FileName;
            pictureBox1.Image = lnx.LoadImg(txtFilename.Text);
        }

        

        private void button3_Click(object sender, EventArgs e)
        {
                  OpenFileDialog fd = new OpenFileDialog();
            fd.Filter = "All files (*.*)|*.*";
            DialogResult dr = fd.ShowDialog();
            if (dr == DialogResult.OK) txtFilenameOld.Text = fd.FileName;
            
        }
        Color getcolor(int i) {
            switch (i)
            {
                case 0:
                    return Color0.BackColor;

                case 1:
                    return Color1.BackColor;
                case 2:
                    return Color2.BackColor;
                case 3:
                    return Color3.BackColor;
            }
                    return ColorA.BackColor;
            
        
        }

        private void btnLastFrame_Click(object sender, EventArgs e)
        {
            for (int y = 0; y < globals.LastFrame.Height; y++)
            {
                for (int x = 0; x < globals.LastFrame.Width; x++)
                {
                    globals.LastFrame.SetPixel(x, y, getcolor(globals.LastPixelMap[x, y]));
                }
            }
            pictureBox1.Image = globals.LastFrame;
        }
        private string DoFilename(string lin) {
          string response= "Pic" + ss.GetItem(lin, "\\", ss.CountItems(lin, "\\")).Replace(".", "");
          response=response.Replace(" ", "");
          response = response.Replace("[", "");
          response = response.Replace("]", "");
          response = response.Replace("-", "");
          response = response.Replace("'", "");
          response = response.Replace("(", "");
          response = response.Replace(")", "");
          response = response.Replace("!", "");
          return response;
        }
        private void button1_Click(object sender, EventArgs e)
        {
            addheader();
            globals.PicNumber += 3;
            // globals.BitmapData = "";
            //; globals.ChunkCache = 0;

            StringBuilder Chunk = new StringBuilder();
            
            pictureBox1.Image = lnx.LoadImg(txtFilename.Text);
            if (!lnx.exists(txtFilename.Text)) return;

            string Filename = DoFilename(txtFilename.Text);// "Pic" + ss.GetItem(txtFilename.Text, "\\", ss.CountItems(txtFilename.Text, "\\")).Replace(".", "");
            
            string DrawOrder = "";
            string Bitblock = "";
            string BitblockLinear = "";
            
             
            int CodeBytes = 0;


 //           StringBuilder st = new StringBuilder();
            System.Drawing.Bitmap b = (System.Drawing.Bitmap) pictureBox1.Image;
            
            System.Drawing.Bitmap b2 = new Bitmap(b.Width, b.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
            if (globals.LastFrame == null) {
                globals.LastFrame = new Bitmap(b.Width, b.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
            }
            ConvertImage(b, globals.PixelMap);
            
            //globals.PixelMap[x, y] = bestcolor;
            if (txtFilenameOld.Text.Length > 0)
            {
                System.Drawing.Bitmap bold = (System.Drawing.Bitmap)lnx.LoadImg(txtFilenameOld.Text);
                globals.LastFrame = new Bitmap(b.Width, b.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
                ConvertImage(bold,  globals.LastPixelMap);
      
            }
            for (int y = 0; y < b.Height; y++)
            {
                for (int x = 0; x < b.Width; x += 8)
                {
                    int pixelcount = 0;
                    for (int p = 0; p < 8; p++)
                    {

                        if (globals.PixelMap[x + p, y] != globals.LastPixelMap[x + p, y])
                        {
                            pixelcount++;
                        }

                    }
                    if (pixelcount < VbX.CInt(txtFrameDiff.Text))
                    {
                        for (int p = 0; p < 8; p++)
                        {
                            globals.PixelMap[x + p, y] = 4;
                        }
                    }

                }
            }
            if (chkInterlace.Checked) {
                int ifield = 0;
                if (chkInterlaceField.Checked ) ifield = 1;
                for (int y = 0; y < b.Height; y++)
                {
                    if (y % 2 == ifield)
                    {
                        for (int x = 0; x < b.Width; x += 1)
                        {

                            globals.PixelMap[x, y] = 4;

                        }
                    }
                }
                chkInterlaceField.Checked = !chkInterlaceField.Checked;
            }

            
           if (cboPreprocessor.Text == "PixelPairHalveX") {
                for (int y = 0; y < b.Height; y+=1)
                {
                        for (int x = 0; x < b.Width; x += 4)
                        {
                            int c1 = globals.PixelMap[x + 1, y];
                            int c2 = globals.PixelMap[x + 2, y];
                            globals.PixelMap[x + 0, y] = c1;
                            globals.PixelMap[x + 1, y] = c2;
                            globals.PixelMap[x + 2, y] = c1;
                            globals.PixelMap[x + 3, y] = c2;
                        }
                }
            }
           if (cboPreprocessor.Text == "PixelPairQuarterX")
           {
               for (int y = 0; y < b.Height; y += 1)
               {
                   for (int x = 0; x < b.Width; x += 8)
                   {
                       int c1 = globals.PixelMap[x + 3, y];
                       int c2 = globals.PixelMap[x + 4, y];
                       globals.PixelMap[x + 0, y] = c1;
                       globals.PixelMap[x + 1, y] = c2;
                       globals.PixelMap[x + 2, y] = c1;
                       globals.PixelMap[x + 3, y] = c2;
                       globals.PixelMap[x + 4, y] = c1;
                       globals.PixelMap[x + 5, y] = c2;
                       globals.PixelMap[x + 6, y] = c1;
                       globals.PixelMap[x + 7, y] = c2;
                   }
               }
           }
            if (cboPreprocessor.Text == "InterlaceX2") {
                for (int y = 0; y < b.Height; y+=2)
                {
                        for (int x = 0; x < b.Width; x += 1)
                        {
                            globals.PixelMap[x, y] = 0;
                        }
                }
            }

            for (int y = 0; y < b.Height; y++)
            {
                for (int x = 0; x < b.Width; x++)
                {
                    b2.SetPixel(x, y, getcolor(globals.PixelMap[x, y]));
                    if (globals.PixelMap[x, y] < 4)
                        globals.LastPixelMap[x, y] = globals.PixelMap[x, y];
                }
            }
           
            pictureBox1.Image = b2;
            pictureBox1.Image.Save(txtFilename.Text+"_Processed.png");

            Application.DoEvents();
            int validwidth = b.Width / 8;
            validwidth = validwidth * 8;
            globals.initdata += "jp " + Filename + nl;


            globals.imagedata.Append(Filename + ":" + nl) ;

            

            if (cboEngine.Text.ToLower() != "akuyou")
            {
                string myvar = "sp";
                if (VbX.CInt(txtXpos.Text) > 0)
                {
                    myvar = "hl";
                }
                // int xpos = ((80 - (b2.Width / 4)) / 2);
                //int xpos = (79 - VbX.CInt(txtXpos.Text)) - (b2.Width/4);
                // int xpos = VbX.CInt(txtXpos.Text);
                int xpos = (80 -  ( VbX.CInt(txtXpos.Text)-b2.Width) / 4) ;
                globals.imagedata.Append("ld (StackRestore_Plus2-2),sp" + nl + "di" + nl + "ld "+myvar+",&C000+"+ VbX.CStr((VbX.CInt(txtXpos.Text)/1))+"+"+(b2.Width/4).ToString() + nl + nl);

                if (VbX.CInt(txtXpos.Text) > 0)
                
                
                {
                    globals.imagedata.Append("xor a" + nl);
                    globals.imagedata.Append("ld (ImageWidthD_Plus2-2),a" + nl);
                    globals.imagedata.Append("ld a," + txtYpos.Text + nl);
                    globals.imagedata.Append("or a"+ nl);
                    globals.imagedata.Append(Filename + "_DrawGetNextLine:" + nl);
                    globals.imagedata.Append("jr z," + Filename + "_DrawGotLine" + nl);
		            globals.imagedata.Append("call RLE_NextScreenLineHL"+ nl);
		            //globals.imagedata.Append("add hl,de"+ nl);
		            globals.imagedata.Append("dec a"+ nl);
                    globals.imagedata.Append("		jr " + Filename + "_DrawGetNextLine" + nl);
                    globals.imagedata.Append(Filename + "_DrawGotLine:" + nl);
                    globals.imagedata.Append("ld sp,hl"+ nl);
                }

            }
            else {
                globals.imagedata.Append(globals.AkuyouNextFile);
            
            }
            globals.imagedata.Append("LD IX," + Filename + "_DrawOrder"+ nl);
            globals.imagedata.Append("JP JumpToNextLine" + nl);
            globals.imagedata.Append(nl + nl);

            for (int y = 0; y < b.Height; y++)
            {
                string ChunkName = Filename + "_Line_" + y.ToString();
                globals.ChunkDeBak = globals.RegDE;
                globals.RegBC = "";
                // globals.RegDE = "";
                globals.RegHL = "";

                
                int DePushes = 0;
                RandomReg = 0;
                int HlPushes = 0;
                globals.DEUsed = 0;
                RandomReg = 0;
                //Chunk.Append(ChunkName + ":" + VbX.Chr(13) + VbX.Chr(10));
                for (int x = (validwidth)-8; x >= 0; x -= 8)
                {
                    string thispair = GetPair(y,x);
                    string nextpair = GetPair(y, x-8);
                    string thiscommand = "";
                    if (globals.RegDE == thispair || globals.RegHL == thispair)
                    {
                        // bitblocks will nuke DE
                        AddBitBlock(Bitblock, BitblockLinear, Chunk,x); Bitblock = ""; BitblockLinear = "";
                    }
                    if (globals.RegDE == thispair )
                    {
                        // AddPushes("HL", Chunk, HlPushes, globals.LastHL); HlPushes = 0;
                    }
                    if (globals.RegDE == thispair)
                    {
                        
                        CodeBytes++; DePushes++;
                    }
                    //else if (globals.RegHL== thispair)
//                    {
                        //AddPushes("DE", Chunk, DePushes,globals.LastDE); DePushes = 0;
                        //CodeBytes++; HlPushes++;
//                    }
                    else if (nextpair != thispair)
                    {
                        AddPushes("DE", Chunk, DePushes, globals.LastDE,x); DePushes = 0;
                       // AddPushes("HL", Chunk, HlPushes, globals.LastHL); HlPushes = 0;


                        if (thispair == "ZZZZ")
                        {
                            AddBitBlock(Bitblock, BitblockLinear, Chunk,x); Bitblock = ""; BitblockLinear = "";
                            Chunk.Append("dec sp" + nl);
                            Chunk.Append("dec sp" + nl);
                        }
                        else
                        {
                            if (Bitblock.Length >= VbX.CInt(txtBitBlockLength.Text)*3)
                            {
                                AddBitBlock(Bitblock, BitblockLinear, Chunk,x); Bitblock = ""; BitblockLinear = "";
                            }


                            Bitblock = thispair.Substring(2, 2) + "," + thispair.Substring(0, 2) + "," + Bitblock;
                            BitblockLinear = BitblockLinear + thispair.Substring(0, 2) + "," + thispair.Substring(2, 2) + ",";
                        }
                        /*
                        CodeBytes += 4;
                        AddPushes("DE", Chunk, DePushes);
                        DePushes = 0;

                        
                         if (RegBC == thispair)
                        {
                            CodeBytes += 1;
                            thiscommand = "  Push BC" + nl;
                        } if (RegHL == thispair)
                        {
                            CodeBytes += 1;
                            thiscommand = "  Push HL" + nl;
                        }
                        else
                        {
                            if (RandomReg == 2) RandomReg = 0;
                            
                            switch (RandomReg){
                                case 0:
                                    thiscommand = " LD BC,&" + thispair + nl + "  Push BC" + nl;
                                    RegBC = thispair;
                                    break;
                                case 1:
                                    thiscommand = " LD HL,&" + thispair + nl + "  Push HL" + nl;
                                    RegHL = thispair;
                                    break;

                            }
                        RandomReg++;
                        }
                        */
                    }

                    else if (globals.RegDE != thispair )
                    {

                        if (globals.DEUsed == 0) {
                            globals.ChunkDeBak = "";
                        }
                        AddBitBlock(Bitblock, BitblockLinear, Chunk,x); Bitblock = ""; BitblockLinear = "";
                        AddPushes("DE", Chunk, DePushes,globals.LastDE,x);DePushes = 0;
                       // AddPushes("HL", Chunk, HlPushes,globals.LastHL); HlPushes = 0;

                        //if (RandomReg == 1) RandomReg = 0;

                        //switch (RandomReg)
                        //{
                          //  case 0:
                                globals.LastDE = globals.RegDE;
                                //thiscommand = MakeConverter("DE", globals.RegDE, thispair) + nl;//thiscommand = " LD DE,&" + thispair + nl;
                                globals.RegDE = thispair;
                                CodeBytes += 3; DePushes++;
                            //    break;
                            //case 1:
                            //    globals.LastHL = globals.RegHL;
                                //thiscommand = MakeConverter("HL", globals.RegHL, thispair) + nl;//thiscommand = " LD DE,&" + thispair + nl;
                          //      globals.RegHL = thispair;
                                //CodeBytes += 3; HlPushes++;
                                //break;

                        //}
                        //RandomReg++;

                      //  thiscommand = MakeConverter("DE", globals.RegDE, thispair) + nl;//thiscommand = " LD DE,&" + thispair + nl;
                       // globals.RegDE = thispair;
                       // CodeBytes += 3; DePushes++;
                    }
                    // thiscommand += "    PUSH DE" + nl;


                    
                    Chunk.Append(thiscommand);
                }
                AddBitBlock(Bitblock, BitblockLinear, Chunk,319); Bitblock = ""; BitblockLinear = "";
                AddPushes("DE", Chunk, DePushes, globals.LastDE,319); DePushes = 0;
                // AddPushes("HL", Chunk, HlPushes, globals.LastHL); HlPushes = 0;
                // if (DrawOrder.Length > 0) DrawOrder += ",";
                
                CodeBytes += 2;


                String Nextline = "";
                // Nextline = nl + ";NewLine" + nl + "ld hl,&0850" + nl + "add hl,sp" + nl + "ld sp,hl" + nl + nl;
                //  if (y%8==7) Nextline = nl + ";NewLine" + nl + "ld hl,&C8A0" + nl + "add hl,sp" + nl + "ld sp,hl" + nl + nl;

                if (y % VbX.CInt(cboLineGroups.Text) !=  VbX.CInt(cboLineGroups.Text)-1 &&  VbX.CInt(cboLineGroups.Text)>1)
                {
                    string mylabel = "Label" + VbX.CStr(VbX.CInt(VbX.Rnd() * 32768000));
                    Nextline = "ld bc," + mylabel + nl + "jp NextLineBC" + nl + mylabel + ":"+nl;
                    globals.RegBC = "";
                }
                else
                {
                    if (cboNextLine.Text.ToLower() == "fast")
                    {
                        Nextline = "jp NextLineFirst" + nl;
                        if (y % 8 == 7) Nextline = "jp NextLineSecond" + nl;
                    }
                    else
                    {
                        if (globals.SkipNextline)
                        {
                            globals.SkipNextline = false;
                        } else {
                            Nextline = "jp NextLine" + nl;

                            /*
                             if (globals.localnextlinenum == 0)
                            {

                                Nextline = "LocalNextLine" + globals.localnextline.ToString() + ":jp NextLine" + nl;
                            }
                            else
                            {
                                Nextline = "jr LocalNextLine" + globals.localnextline.ToString() + nl;



                            }
                            globals.localnextlinenum++;

                            if (globals.localnextlinenum >= 2)
                            {
                                globals.localnextlinenum = -1;
                                globals.localnextline++;
                            }
                             * 
                             */
                        }
                    }
                }
                Chunk.Append(Nextline+nl+nl);

                globals.RegHL = "";



                if (!(y % VbX.CInt(cboLineGroups.Text) != VbX.CInt(cboLineGroups.Text)-1) || VbX.CInt(cboLineGroups.Text) == 1 || y == b.Height - 1)
                {
                    string Founchunk = "";
                    int FounchunkI = 0;
                    for (int i = 0; i < globals.ChunkCache; i++)
                    {
                        if (globals.ChunkCache_Data[i] == Chunk.ToString() && (globals.ChunkCache_DE[i] == globals.ChunkDeBak || globals.ChunkDeBak == "ZZZZ"))
                        {
                            Founchunk = globals.ChunkCache_Name[i];
                            FounchunkI = i;
                        }
                    }
                    if (Founchunk == "")
                    {
                        globals.imagedata.Append(ChunkName + ":" + nl);
                        globals.imagedata.Append(Chunk);
                        DrawOrder += "  DEFW " + ChunkName + VbX.Chr(13);
                        globals.ChunkCache_Name[globals.ChunkCache] = ChunkName;
                        if (globals.ChunkDeBak == "ZZZZ") globals.ChunkDeBak = "";
                        globals.ChunkCache_DE[globals.ChunkCache] = globals.ChunkDeBak;
                        globals.ChunkCache_Data[globals.ChunkCache] = Chunk.ToString();
                        globals.ChunkCache++;


                        

                    }
                    else
                    {
                        if (globals.ChunkCache_DE[FounchunkI].Length > 0)
                        {
                            if (globals.ChunkCache_Reused[FounchunkI] != 1)
                            {
                                globals.ChunkCache_Reused[FounchunkI] = 1;
                                globals.imagedata.Append(Founchunk + "_Reuse:" + nl);
                                globals.imagedata.Append("LD DE,&" + globals.ChunkCache_DE[FounchunkI] + nl);
                                globals.imagedata.Append("JP " + Founchunk + nl);

                            }
                            globals.RegDE = globals.ChunkCache_DE[FounchunkI];
                            DrawOrder += "  DEFW " + Founchunk + "_Reuse" + VbX.Chr(13);
                        }
                        else
                        {
                            DrawOrder += "  DEFW " + Founchunk + VbX.Chr(13);
                        }


                    }

                    Chunk = new StringBuilder();
                }
                else {
             
                
                }

            }


            DrawOrder += "  DEFW EndCode" + VbX.Chr(13); 

            globals.imagedata.Append(nl + Filename + "_DrawOrder: " +nl);
            string Last1 = "";
            string Last2="";
            int repeat1=1;
            for (int i=0;i<=ss.CountItems(DrawOrder,VbX.Chr(13));i++){
                string this1=ss.GetItem(DrawOrder,VbX.Chr(13),i).Replace(VbX.Chr(10), "").Replace(VbX.Chr(13), "");
                if (this1==Last1){
                    repeat1++;
                } else {
                    if ((repeat1 >= 1 && repeat1 <= 6 )||!chkLooper.Checked)
                    {
                        for (int a = 1; a <= repeat1; a++)
                        {
                            globals.imagedata.Append(Last1 + nl);
                        }
                    }
                    else if (repeat1 > 6){
                        globals.imagedata.Append("defw looper"+nl);
                        globals.imagedata.Append("  DEFB 1," + repeat1 + nl);
                        globals.imagedata.Append(Last1 + nl);
                        globals.UseLooper = true;
                    }
                    repeat1 = 1;
                    Last1=this1;
                    // globals.imagedata.Append(this1 + nl);
                
                }

                
            }

            DoGlobalData(b2);
           this.Text="Total Code:" + textBox1.Text.ToString().Length;
            //int value = Convert.ToInt32("1101", 2)
            // string binary = Convert.ToString(value, 2);
        }










        private void DoGlobalData(System.Drawing.Bitmap b2) {
            globals.globaldata = new StringBuilder();


            globals.globaldata.Append(nl + nl + nl + nl + nl + nl + ";Global Code");

            if (globals.useRLE == true) addrledecoder();
            else
            {
                globals.globaldata.Append(nl + "RLE_ImageWidth equ 0" + nl);
                globals.globaldata.Append(globals.RLE_NextScreenLineHL);
            }

            string EndCode = nl + "EndCode:" + nl;

            //EndCode += "LD BC,&7F00 ;Gate array port" + nl;
            //EndCode+="ld a,%10000001 ;Switch to ram config A (A < 7!)" + nl ;
            //EndCode+="OUT (C),A ;Send it" + nl ;
            //EndCode+="ld      hl,&0040" + nl ;
            //EndCode+="JumpFix:" + nl ;
            //EndCode+="dec     l" + nl ;
            //EndCode+="ld      a,(hl)			; get byte from rom" + nl ;
            //EndCode+="ld      (hl),a			; write byte to ram" + nl ;
            //EndCode+="jr      nz,JumpFix" + nl ;
            //EndCode+="ld a,%10001101 ;Switch to ram config A (A < 7!)" + nl ;
            //EndCode += "OUT (C),A ;Send it" + nl;
            if (cboEngine.Text.ToLower() == "akuyou")
            {
                EndCode += "ld sp,(StackRestore_Plus2-2)";
            }
            else
            {
                EndCode += "ld sp,&0000:StackRestore_Plus2";
            }
            EndCode += nl + "ei" + nl + "ret" + nl;

            globals.globaldata.Append(EndCode);

            for (int i = 40; i > 0; i--)
            {
                if (globals.DePushUsed[i])
                {
                    if (globals.MultiPushDeLast[i])
                    {
                        globals.globaldata.Append(nl + "MultiPushDeLast" + VbX.CStr(i) + ": ld HL,NextLine");
                        if (i >= 30)
                        {
                            globals.globaldata.Append(nl + "jp MultiPushDe" + VbX.CStr(i) + "B ");
                        }
                        else
                        {
                            globals.globaldata.Append(nl + "jr MultiPushDe" + VbX.CStr(i) + "B ");
                        }
                    }
                       
                    globals.globaldata.Append(nl + "MultiPushDe" + VbX.CStr(i) + ": pop HL");
                    if (i>=30) {
                        globals.globaldata.Append(nl + "jp MultiPushDe" + VbX.CStr(i) + "B ");
                    }else{
                        globals.globaldata.Append(nl + "jr MultiPushDe" + VbX.CStr(i) + "B ");
                    }


                    
                }
            }
            for (int i = 40; i > 0; i--)
            {
                if (i <= globals.MaxDePush)
                {
                    globals.globaldata.Append(nl + "MultiPushDe" + VbX.CStr(i) + "B: Push DE");
                }
            }
            globals.globaldata.Append(nl + "jp (hl)" + nl);
            for (int i = 40; i > 20; i--)
            {
                if (globals.BitmapDataUsed[i * 2])
                {
                    globals.globaldata.Append(nl + "BitmapPush" + VbX.CStr(i * 2) + ": " + "ld b,&" + VbX.Right("00" + (i * 2).ToString("X"), 2));
                    globals.globaldata.Append(nl + "jr BitmapPush" + nl);
                }
            }
            globals.globaldata.Append(nl + "BitmapPush:" + nl);
            globals.globaldata.Append("ld (BitmapPushDeRestore_Plus2-2),de" + nl);
            globals.globaldata.Append("pop iy" + nl);
            globals.globaldata.Append("ld l,(iy)" + nl);
            globals.globaldata.Append("inc iy" + nl);
            globals.globaldata.Append("ld h,(iy)" + nl);
            globals.globaldata.Append("inc iy" + nl);


            globals.globaldata.Append("BitmapPushRepeat:" + nl);
            globals.globaldata.Append("ld d,(hl)" + nl);
            globals.globaldata.Append("dec hl" + nl);
            globals.globaldata.Append("ld e,(hl)" + nl);
            globals.globaldata.Append("dec hl" + nl);
            globals.globaldata.Append("push de" + nl);
            globals.globaldata.Append("djnz BitmapPushRepeat" + nl);
            globals.globaldata.Append(nl + "ld de,&0000 :BitmapPushDeRestore_Plus2" + nl);
            globals.globaldata.Append(nl + "jp (iy)" + nl);


            for (int i = 20; i > 0; i--)
            {
                if (globals.BitmapDataUsed[i * 2])
                {
                    globals.globaldata.Append(nl + "BitmapPush" + VbX.CStr(i * 2) + ": " + "ld b,&" + VbX.Right("00" + (i).ToString("X"), 2));
                    globals.globaldata.Append(nl + "jr BitmapPush");
                }
            }
            globals.globaldata.Append(nl);


            for (int i = 40; i > 0; i--)
            {
                if (globals.BitmapDataLastUsed[i])
                {
                    globals.globaldata.Append(nl + "finalBitmapPush" + VbX.CStr(i) + ": " + "ld b,&" + VbX.Right("00" + (i / 2).ToString("X"), 2));
                    globals.globaldata.Append(nl + "jr finalBitmapPush" + nl);
                }
            }


            globals.globaldata.Append("finalBitmapPush:" + nl);
            globals.globaldata.Append("ld (BitmapPushDeRestore_Plus2-2),de" + nl);
            globals.globaldata.Append("pop iy" + nl);
            globals.globaldata.Append("ld l,(iy)" + nl);
            globals.globaldata.Append("inc iy" + nl);
            globals.globaldata.Append("ld h,(iy)" + nl);
            globals.globaldata.Append("inc iy" + nl);

            globals.globaldata.Append("ld iy,nextline" + nl);
            globals.globaldata.Append("jp BitmapPushRepeat" + nl);




            for (int i = 4; i >= 1; i--)
            {
                globals.globaldata.Append("NextLinePushDe" + VbX.CStr(i) + ": push de" + nl);
            }

            if (cboEngine.Text.ToLower() == "akuyou")
            {
                globals.globaldata.Append(nl);
                if (VbX.CInt(cboLineGroups.Text) > 1)
                {

                    globals.globaldata.Append(globals.AkuyouNextLineBC + nl);
                }
                else
                {


                }
                globals.globaldata.Append(globals.AkuyouNextLine + nl);
            }
            else
            {

                if (VbX.CInt(cboLineGroups.Text) > 1)
                {

                    globals.globaldata.Append(nl + "NextLineBC: " + nl);
                    globals.globaldata.Append("ld hl,&0850" + nl + "add hl,sp" + nl + "ld sp,hl" + nl);
                    globals.globaldata.Append("jp nc,JumpToNextLineBC" + nl);
                    globals.globaldata.Append("ld hl,&c050" + nl + "add hl,sp" + nl + "ld sp,hl" + nl);
                    globals.globaldata.Append("JumpToNextLineBC:ld h,b" + nl + "ld l,c" + nl + "jp (hl)" + nl);
                }

                if (cboNextLine.Text.ToLower() == "fast")
                {
                    globals.globaldata.Append(nl + "NextLineFirst: " + nl);
                    globals.globaldata.Append("ld hl,&0850" + nl + "add hl,sp" + nl + "ld sp,hl" + nl);

                    globals.globaldata.Append("JP JumpToNextLine" + nl);

                    globals.globaldata.Append(nl + "NextLineSecond: " + nl);
                    globals.globaldata.Append("ld hl,&C8A0" + nl + "add hl,sp" + nl + "ld sp,hl" + nl);
                }
                else
                {
                    globals.globaldata.Append(nl + "NextLine: " + nl);
                    globals.globaldata.Append("ld hl,&0800+" + VbX.CStr(b2.Width / 4) + nl + "add hl,sp" + nl + "ld sp,hl" + nl);
                    globals.globaldata.Append("jp nc,JumpToNextLine" + nl);
                    globals.globaldata.Append("ld hl,&c050" + nl + "add hl,sp" + nl + "ld sp,hl" + nl);

                }
                globals.globaldata.Append(nl + "JumpToNextLine: " + nl);
                globals.globaldata.Append("LD L,(IX)" + nl);
                globals.globaldata.Append("INC IX" + nl);
                globals.globaldata.Append("LD H,(IX)" + nl);
                globals.globaldata.Append("INC IX" + nl);
                globals.globaldata.Append("JP (HL)" + nl);

            }

            globals.globaldata.Append("NextLinePushHl: Push HL" + nl);
            globals.globaldata.Append("jr NextLine" + nl);
            globals.globaldata.Append("NextLinePushBC: Push BC" + nl);
            globals.globaldata.Append("jr NextLine" + nl);

            globals.globaldata.Append("NextLineSPshift:add hl,sp" + nl);
            globals.globaldata.Append("ld sp,hl" + nl);
            globals.globaldata.Append("jr NextLine" + nl);
            globals.globaldata.Append("NextLineDecSP8:dec sp" + nl);
            globals.globaldata.Append("dec sp" + nl);
            globals.globaldata.Append("dec sp" + nl);
            globals.globaldata.Append("dec sp" + nl);
            globals.globaldata.Append("NextLineDecSP4:dec sp" + nl);
            globals.globaldata.Append("dec sp" + nl);
            globals.globaldata.Append("dec sp" + nl);
            globals.globaldata.Append("dec sp" + nl);
            globals.globaldata.Append("jr NextLine" + nl);

            if (VbX.CInt(cboLineGroups.Text) > 1)
            {


            }
            else
            {
                globals.globaldata.Append(globals.AkuyouNextLineBCdisable + nl);

            }

            if (globals.UseLooper)
            {
                globals.globaldata.Append(globals.LooperDef + nl);
            }


            globals.globaldata.Append(nl + "BitmapData: " + nl);

            for (int i = 0; i <= globals.BitmapData.Length / 30; i++)
            {

                for (int a = 0; a < 10; a++)
                {
                    if ((i * 30 + a * 3) < globals.BitmapData.Length)
                    {
                        if (a > 0) globals.globaldata.Append(","); else globals.globaldata.Append(nl + "defb "); ;
                        globals.globaldata.Append("&" + globals.BitmapData.Substring(i * 30 + a * 3, 3).Replace(",", ""));
                    }
                }
            }

            globals.globaldata.Append("" + nl);
            globals.globaldata.Append("DoubleByteDE:" + nl);

            globals.globaldata.Append("pop iy" + nl);
            globals.globaldata.Append("ld a,(iy)" + nl);
            globals.globaldata.Append("inc iy" + nl);
            globals.globaldata.Append("ld d,a" + nl);
            globals.globaldata.Append("ld e,a" + nl);
            globals.globaldata.Append("push de" + nl);
            globals.globaldata.Append("push de" + nl);
            globals.globaldata.Append("jp(iy)" + nl);
            globals.globaldata.Append("" + nl);
            globals.globaldata.Append("PushDE_0000x:" + nl);
            globals.globaldata.Append("Ld DE,&0000" + nl);
            globals.globaldata.Append("jr PushDE_Multi" + nl);

            globals.globaldata.Append("PushDE_F0F0x:" + nl);
            globals.globaldata.Append("Ld DE,&F0F0" + nl);
            globals.globaldata.Append("jr PushDE_Multi" + nl);

            globals.globaldata.Append("PushDE_0F0Fx:" + nl);
            globals.globaldata.Append("Ld DE,&0F0F" + nl);
            globals.globaldata.Append("jr PushDE_Multi" + nl);


            globals.globaldata.Append("PushDE_FFFFx:" + nl);
            globals.globaldata.Append("Ld DE,&FFFF" + nl);
            globals.globaldata.Append("PushDE_Multi" + nl);
            globals.globaldata.Append("pop hl" + nl);
            for (int i = 1; i <= VbX.CInt(txtDeCompression.Text); i++)
            {
                globals.globaldata.Append("push DE" + nl);
            }
            //st.Append("push DE" + nl);
            globals.globaldata.Append("jp (hl)" + nl);

            globals.globaldata.Append(nl);
            for (int i = 0; i < globals.PairCache_Count; i++)
            {

                globals.globaldata.Append(globals.PairCache_Data[i]);
            }


            if (globals.DoRawBmp) {
                globals.globaldata.Append("DrawRawBmp:" + nl);
                globals.globaldata.Append("RawBmpRepeatNextLine:" + nl);
                globals.globaldata.Append("ld c,b" + nl);
                globals.globaldata.Append("ld b,IXL" + nl);
                globals.globaldata.Append("RawBmpRepeat:" + nl);
                globals.globaldata.Append("pop de" + nl);
                globals.globaldata.Append("ld (hl),d" + nl);
                globals.globaldata.Append("dec hl" + nl);
                globals.globaldata.Append("ld (hl),e" + nl);
                globals.globaldata.Append("dec hl" + nl);

                globals.globaldata.Append("djnz RawBmpRepeat" + nl);

                globals.globaldata.Append("ld de,&0800+" + VbX.CStr(b2.Width / 4) + nl);
                globals.globaldata.Append("add hl,de" + nl);
                globals.globaldata.Append("jp nc,JumpToNextLineRawBmp" + nl);
                globals.globaldata.Append("ld de,&c050" + nl);
                globals.globaldata.Append("add hl,de" + nl);
                globals.globaldata.Append("JumpToNextLineRawBmp:" + nl);
                globals.globaldata.Append("ld b,c" + nl);

                globals.globaldata.Append("djnz RawBmpRepeatNextLine" + nl);

                globals.globaldata.Append("ld sp,&0000:StackRestore_PlusRawBmp2" + nl);
                globals.globaldata.Append("ei" + nl);
                globals.globaldata.Append("ret" + nl);
            
            }



            textBox1.Text = globals.initdata + nl + globals.imagedata.ToString() + nl + globals.globaldata.ToString();

        
        }





        private string GetPair(int y, int x) {
            int transpcount = 0;
            if (x<0) return "Bad!";
            string thispair = "";
            for (int pair = 0; pair < 2; pair++)
            {
                int thisbyte = 0;
                for (int bit = 0; bit < 4; bit++)
                {
                    
                    int tx = x + (3 - bit) + (pair * 4);

                    int dot = globals.PixelMap[tx, y];
                    if (dot >= 4) {
                        transpcount++;
                        dot=0;
                    }
                    string binary = VbX.Right("00" + Convert.ToString(dot, 2), 2);
                    string Binary2 = binary.Substring(1, 1) + "000" + binary.Substring(0, 1);

                    thisbyte = thisbyte + (Convert.ToInt32(Binary2, 2) << bit);
                    // if (dot == 3) VbX.MsgBox(Binary2 + "   " + bit.ToString() + "  " + thisbyte.ToString());
                }
                thispair = VbX.Right("00" + thisbyte.ToString("X"), 2) + thispair;
            }
            if (transpcount==8) {return "ZZZZ";}
            return thispair;
        
        }
        private void AddBitBlock(String BitBlock, String BitBlockLinear, StringBuilder st,int xpos)
        {
            


            if (BitBlock.Length <= (4*3))
            {
          
                for (int i = 1; i <= VbX.Len(BitBlockLinear); i += 6)
                {
                    bool last = false;
                    if (i+6>VbX.Len(BitBlockLinear)) last=true;

                    string thispair = VbX.Mid(BitBlockLinear, i, 6).Replace(",", "");
                  
                    if (globals.RegBC == thispair)
                    {
                        if (xpos == 319 && last)
                        {
                            globals.SkipNextline = true;
                            st.Append(" jp NextLinePushBC " + nl);
                        }
                        else
                        {
                            st.Append("  Push BC" + nl);
                        }
                    }
                    else if (globals.RegDE == thispair)
                    {
                        globals.DEUsed = 1;
                        if (xpos == 319 && last)
                        {
                            globals.SkipNextline=true;
                            st.Append(" jp NextLinePushDe1" );
                        }else {
                            st.Append("  Push DE" + nl);
                        }
                    }
                    else if (globals.RegHL == thispair)
                    {
                        if (xpos == 319 && last)
                        {
                            globals.SkipNextline = true;
                            st.Append(" jp NextLinePushHl " + nl);
                        }
                        else
                        {
                            st.Append("  Push HL " + nl);
                        }
                    }
                    else
                    {

                        RandomReg++;

                        // RandomReg = 0;
                         //if (uniuquechars(thispair) >= 3)
                       // {
                        //    RandomReg = 1;
                       // }
                        if (RandomReg == 2) RandomReg = 0;


                        if (RandomReg == 0)
                        {
                            string thiscommand2 = MakeConverter("BC", globals.RegBC, thispair) + nl;// " LD BC,&" + thispair + nl;

                                

                            globals.RegBC = thispair;
                            if (xpos == 319 && last)
                            {
                                globals.SkipNextline = true;
                                thiscommand2 += " jp NextLinePushBC " + nl;
                            }
                            else
                            {
                                
                                if (thiscommand2.Contains("LD BC,") && chkcomressDEs.Checked)
                                {
                                    bool found = false;

                                     thiscommand2= "PairCache" + thispair + ":pop hl" + nl + "ld bc,&" + thispair + nl + "push bc" + nl + "jp (hl)" + nl;

                                    for (int iis = 0; iis < globals.PairCache_Count; iis++)
                                    {
                                        if (globals.PairCache_Data[iis] == thiscommand2)
                                        {
                                            found = true;
                                        }
                                    }
                                    if (!found) {
                                        globals.PairCache_Data[globals.PairCache_Count] = thiscommand2;
                                        globals.PairCache_Count++;
                                    }
                                    thiscommand2 = "call PairCache" + thispair + nl;
                                    globals.RegHL = "";
                                }
                                else
                                {

                                    thiscommand2 += "  Push BC" + nl;

                                }
                            }
                            st.Append(thiscommand2);
                        }
                        if (RandomReg == 1)
                        {
                            string thiscommand2 = MakeConverter("HL", globals.RegHL, thispair) + nl;// " LD BC,&" + thispair + nl;
                            globals.RegHL = thispair;
                            if (xpos == 319 && last)
                            {
                                globals.SkipNextline = true;
                                thiscommand2 += "  jp NextLinePushHl " + nl;
                            }
                            else
                            {

                                thiscommand2 += "  Push HL" + nl;
                             
                            }
                            st.Append(thiscommand2);
                        }
                    }
                }
                BitBlock = "";
                BitBlockLinear = "";
                return;
            }

            if (BitBlock == "") return;
            int bytecount = BitBlock.Length / 3;
            int alreadyexists = VbX.InStr(globals.BitmapData, BitBlock);
            // if (globals.BitmapData.Length < bytecount) alreadyexists = -1;
            string thiscommand = "";
            string mylabel = "      Label" + VbX.CStr(VbX.CInt(VbX.Rnd() * 32768000));
            if (alreadyexists > 0) {
                alreadyexists=(alreadyexists-1)/3;
                // BitmapPushReturn_Plus2
                // thiscommand = "ld hl,&FFFF" + nl + "add hl,sp" + nl + "ex de,hl" + nl + "ld hl,BitmapData+" + VbX.CStr(alreadyexists + bytecount - 1) + "" + nl + "ld bc,&" + VbX.Right("0000" + (bytecount).ToString("X"), 4) + nl;
                //thiscommand += "lddr" + nl + "ex de,hl" + nl + "ld sp,hl" + nl + "inc sp" + nl;
                
                //thiscommand += "ld hl," + mylabel + nl + "jp BitmapPush"+bytecount.ToString()+  nl;
                // if (xpos == 319)
                //{
                 //   globals.BitmapPushLastUsed[bytecount] = true;
                  //  globals.SkipNextline = true;
                //    thiscommand += "jp BitmapPushLast" + bytecount.ToString() + nl;
               // }
               // else
                //{
                if (xpos==319)
                {
                    globals.BitmapDataLastUsed[bytecount] = true;
                    thiscommand += "call FinalBitmapPush" + bytecount.ToString() + nl;
                    globals.SkipNextline = true;
                }
                else
                {
                    thiscommand += "call BitmapPush" + bytecount.ToString() + nl;
                    globals.BitmapDataUsed[bytecount] = true;
                }
                //}
                thiscommand += "defw BitmapData+" + VbX.CStr(alreadyexists + bytecount - 1) + "" + nl; //+ "ld c,&" + VbX.Right("00" + (bytecount).ToString("X"), 2) + nl;
                

                // thiscommand += mylabel + ":" + nl;
                BitBlock = "";
                st.Append(thiscommand);
                globals.RegBC = "";
                // globals.RegDE = "";
                globals.RegHL = "";
                
                return;
            }



            /*
      
            }
             */
            
             //thiscommand = "ld hl,&FFFF" + nl + "add hl,sp" + nl + "ex de,hl" + nl + "ld hl,BitmapData+" + VbX.CStr((BitmapData.Length / 2)+bytecount-1) + "" + nl + "ld bc,&" + VbX.Right("0000" + (bytecount).ToString("X"), 4) + nl;
            //thiscommand += "lddr" + nl + "ex de,hl" + nl + "ld sp,hl" + nl + "inc sp" + nl;
            
            //thiscommand += "ld hl," + mylabel + nl + "jp BitmapPush" +bytecount.ToString()+ nl;
            if (xpos == 319)
            {
                globals.BitmapDataLastUsed[bytecount] = true;
                thiscommand += "call FinalBitmapPush" + bytecount.ToString() + nl;
                globals.SkipNextline = true;
            }
            else
            {
                thiscommand += "call BitmapPush" + bytecount.ToString() + nl;
                globals.BitmapDataUsed[bytecount] = true;
            }
            thiscommand += "defw BitmapData+" + VbX.CStr((globals.BitmapData.Length / 3) + bytecount - 1) + "" + nl;//+ "ld c,&" + VbX.Right("00" + (bytecount).ToString("X"), 2) + nl;
            // thiscommand += mylabel + ":" + nl;
            globals.BitmapData = globals.BitmapData + BitBlock;
            
            BitBlock = "";
            st.Append(thiscommand);
            globals.RegBC = "";
            // globals.RegDE = "";
            globals.RegHL = "";

        }
        private string MakeConverter(string RegKey, string RegSrc, string RegDest) {
            if (RegSrc == RegDest) return "";

            switch (RegKey)
            {
                case "DE":
                    globals.RegDE = RegSrc; break;

                case "BC":
                    globals.RegBC = RegSrc; break;

                case "HL":
                    globals.RegHL = RegSrc; break;
            }

            string response = "";
            string part1 = "";
            string part2 = "";
            
            if (RegSrc == "0000" && RegDest == "FFFF")
            {
                response= "DEC " + RegKey + nl;
            }

            if (RegSrc == "FFFF" && RegDest == "0000")
            {
                response= "INC " + RegKey + nl;
            
            }
            
            if (response == "")
            {
               

                if (RegKey != "BC")
                {
                    if (VbX.Mid(RegDest, 3, 2) == VbX.Mid(globals.RegBC, 1, 2))
                    {
                        part2 = "Ld " + VbX.Mid(RegKey, 2, 1) + ",B";
                    }
                    if (VbX.Mid(RegDest, 3, 2) == VbX.Mid(globals.RegBC, 3, 2))
                    {
                        part2 = "Ld " + VbX.Mid(RegKey, 2, 1) + ",C";
                    }
                }

                if (RegKey != "HL")
                {
                    if (VbX.Mid(RegDest, 3, 2) == VbX.Mid(globals.RegHL, 1, 2))
                    {
                        part2 = "Ld " + VbX.Mid(RegKey, 2, 1) + ",H";
                    }
                    if (VbX.Mid(RegDest, 3, 2) == VbX.Mid(globals.RegHL, 3, 2))
                    {
                        part2 = "Ld " + VbX.Mid(RegKey, 2, 1) + ",L";
                    }

                }
                if (RegKey != "DE")
                {
                    if (VbX.Mid(RegDest, 3, 2) == VbX.Mid(globals.RegDE, 1, 2))
                    {
                        part2 = "Ld " + VbX.Mid(RegKey, 2, 1) + ",D";
                        globals.DEUsed = 1;
                    }
                    if (VbX.Mid(RegDest, 3, 2) == VbX.Mid(globals.RegDE, 3, 2))
                    {
                        part2 = "Ld " + VbX.Mid(RegKey, 2, 1) + ",E";
                        globals.DEUsed = 1;
                    }
                }
                if (RegKey != "BC")
                {
                    if (VbX.Mid(RegDest, 1, 2) == VbX.Mid(globals.RegBC, 1, 2))
                    {
                        part1 = "Ld " + VbX.Mid(RegKey, 1, 1) + ",B";
                    }
                    if (VbX.Mid(RegDest, 1, 2) == VbX.Mid(globals.RegBC, 3, 2))
                    {
                        part1 = "Ld " + VbX.Mid(RegKey, 1, 1) + ",C";
                    }
                }
                if (RegKey != "HL")
                {
                    if (VbX.Mid(RegDest, 1, 2) == VbX.Mid(globals.RegHL, 1, 2))
                    {
                        part1 = "Ld " + VbX.Mid(RegKey, 1, 1) + ",H";
                    }
                    if (VbX.Mid(RegDest, 1, 2) == VbX.Mid(globals.RegHL, 3, 2))
                    {
                        part1 = "Ld " + VbX.Mid(RegKey, 1, 1) + ",L";
                    }
                }
                if (RegKey != "DE")
                {
                    if (VbX.Mid(RegDest, 1, 2) == VbX.Mid(globals.RegDE, 1, 2))
                    {
                        part1 = "Ld " + VbX.Mid(RegKey, 1, 1) + ",D";
                        globals.DEUsed = 1;
                    }
                    if (VbX.Mid(RegDest, 1, 2) == VbX.Mid(globals.RegDE, 3, 2))
                    {
                        part1 = "Ld " + VbX.Mid(RegKey, 1, 1) + ",E";
                        globals.DEUsed = 1;
                    }
                }
                if (part1 != "" && part2 != "")
                {

                    if (VbX.Mid(RegDest, 3, 2) == VbX.Mid(RegSrc, 3, 2))
                    {
                        part2 = "";
                    }
                    if (VbX.Mid(RegDest, 1, 2) == VbX.Mid(RegSrc, 1, 2))
                    {
                        part1 = "";
                    }
                    response = part1 + nl + part2 + nl;
                }
            }
            if (response == "")
            {
                if (VbX.Mid(RegSrc, 1, 2) == VbX.Mid(RegDest, 1, 2))
                {
                    //first half matches
                    if (VbX.Mid(RegSrc, 1, 2) == VbX.Mid(RegDest, 3, 2))
                    {
                        response= "Ld " + VbX.Mid(RegKey, 2, 1) + "," + VbX.Mid(RegKey, 1, 1);
                    }
                    if (VbX.Mid(RegSrc, 3, 2) == VbX.Mid(RegDest, 3, 2))
                    {
                        response= "Ld " + VbX.Mid(RegKey, 2, 1) + "," + VbX.Mid(RegKey, 2, 1);
                    }
                    response = "Ld " + VbX.Mid(RegKey, 2, 1) + ",&" + VbX.Mid(RegDest, 3, 2);
                }
                else if (VbX.Mid(RegSrc, 3, 2) == VbX.Mid(RegDest, 3, 2))
                {
                    //second half matches
                    if (VbX.Mid(RegSrc, 1, 2) == VbX.Mid(RegDest, 1, 2))
                    {
                        response = "Ld " + VbX.Mid(RegKey, 1, 1) + "," + VbX.Mid(RegKey, 1, 1);
                    }
                    else if (VbX.Mid(RegSrc, 3, 2) == VbX.Mid(RegDest, 1, 2))
                    {
                        response = "Ld " + VbX.Mid(RegKey, 1, 1) + "," + VbX.Mid(RegKey, 2, 1);
                    }
                    else response = "Ld " + VbX.Mid(RegKey, 1, 1) + ",&" + VbX.Mid(RegDest, 1, 2);
                }
                
                    

                else response = "LD " + RegKey + ",&" + RegDest;
            }

            switch (RegKey)
            {
                case "DE":
                    globals.RegDE = RegDest; break;

                case "BC":
                    globals.RegBC = RegDest; break;

                case "HL":
                    globals.RegHL = RegDest; break;
            }



            return response;
        }


        private void AddPushes( string REG, StringBuilder st, int ct,string regorig,int xpos) {
            int decompression = VbX.CInt(txtDeCompression.Text);
            int swapped = 0;
            if (ct==0) return;

            if ( globals.RegDE == "ZZZZ")
            {
                if (ct==2){
                    if (xpos == 319)
                    {
                        st.Append("jp NextLineDecSP4" + nl);
                        globals.SkipNextline=true;
                    }
                    else
                    {
                        st.Append("DEC SP" + nl + "DEC SP" + nl + "DEC SP" + nl + "DEC SP" + nl);
                    }
                    return;
                
                }
                if (ct == 4 && xpos == 319)
                    {
                        st.Append("jp NextLineDecSP8" + nl);
                        globals.SkipNextline = true;
                        return;
                    }
                
                st.Append("ld hl,&FF" + VbX.Right("FF" + ((255 - (ct * 2)) + 1).ToString("X"), 2) + nl);
                if (xpos == 319)
                {
                    st.Append("jp NextLineSPshift" + nl);
                    globals.SkipNextline = true;
                }else 
                {
                    st.Append("add hl,sp" + nl + "ld sp,hl" + nl);
                }
                //globals.RegDE=topush;
                globals.RegHL = "";
                globals.LastHL = "";
                return;
             
            }

            if (REG == "HL" && regorig != globals.RegHL)
             
              {
                  if (ct == decompression && (globals.RegHL == "F0F0" || globals.RegHL == "0F0F" || globals.RegHL == "FFFF" || globals.RegHL == "0000"))
                  {
                      st.Append("EX DE,HL" + nl);
                      st.Append("Call PushDE_" + globals.RegHL + "x" + nl);
                      swapped = 1;
                      globals.RegHL = "";
                      ct = ct - decompression;
                   
                  }
                  else
                  {
                      st.Append(MakeConverter("HL", regorig, globals.RegHL) + nl);//thiscommand = " LD DE,&" + thispair + nl;

                  }
            }
            if (REG == "DE" && regorig != globals.RegDE)
            {
                
                
                if (ct == decompression && (globals.RegDE == "F0F0" || globals.RegDE == "0F0F" || globals.RegDE == "FFFF" || globals.RegDE == "0000"))
                {
                    if (globals.DEUsed == 0)
                    {
                        globals.ChunkDeBak = "";
                    }
                    globals.DEUsed = 1;
                    st.Append("Call PushDE_" + globals.RegDE+"x"+nl);
                    ct = ct - decompression;
                    globals.LastDE = globals.RegDE;
                    globals.RegHL = "";
                    
                    
                }
                else if (chkRst0.Checked && globals.RegDE.Substring(0, 2) == globals.RegDE.Substring(2, 2) && ct>1)
                {
                    st.Append("RST 0" + nl);
                    st.Append("Defb &" + globals.RegDE.Substring(0, 2) + nl);
                    ct-=2;
                    globals.LastDE = globals.RegDE;
                }
                else
                {
                    if (regorig != globals.RegDE)
                    {
                        if (globals.DEUsed == 0)
                        {
                            globals.ChunkDeBak = "";
                        }
                        globals.DEUsed = 1;
                        st.Append(MakeConverter("DE", regorig, globals.RegDE) + nl);//thiscommand = " LD DE,&" + thispair + nl;
                    }
                    globals.LastDE = globals.RegDE;
                }
            }

            globals.DEUsed = 1;
            if (ct == 0)
            {
                if (swapped == 1) st.Append("EX DE,HL" + nl);
                return;
            }
            if (ct <= 4 && xpos == 319)
            {
                globals.SkipNextline = true;
                st.Append(" jp NextLinePushDe" + ct.ToString() + nl); return;
            }
            if (ct == 1) {
                if (swapped == 1) st.Append("EX DE,HL" + nl);
                st.Append("  PUSH " + REG+nl); return; }
             string part = "";
            
            if (ct >= 3 && ct <= 4 && chkRst6.Checked==true)
            {
                st.Append("  RST 6 " +  nl);
                globals.RegHL = "";
                ct -= 3;
                if (ct == 0) return;
            }
            if (ct <= 4) {
                if (swapped == 1) st.Append("EX DE,HL" + nl);
                for (int i = 0; i < ct; i++)
                {
                    st.Append("  PUSH " + REG + nl);
                    
                }
                return;
            }
            // part += "       LD B," + VbX.CStr(ct) + nl;
            string mylabel = "      Label" + VbX.CStr(VbX.CInt(VbX.Rnd() * 32768000));
            if (REG == "HL")
            {
                string tmp = globals.RegDE;
                globals.RegDE = globals.RegHL;
                globals.RegHL = tmp;
                if (swapped==0) part += "EX DE,HL"+nl;

            }

            // part += "ld hl," + mylabel + nl;
            
            //part += "jp MultiPushDe" + VbX.CStr(ct) + nl;
            globals.RegHL = "";
            globals.LastHL = "";

            if (xpos == 319)
            {
                globals.MultiPushDeLast[ct] = true;
                part += "jp MultiPushDeLast" + VbX.CStr(ct) + nl;
                globals.SkipNextline = true;

            }
            else
            {

                part += "call MultiPushDe" + VbX.CStr(ct) + nl;
            }
            if (ct > globals.MaxDePush) globals.MaxDePush = ct;
            globals.DePushUsed[ct] = true;
            //part += mylabel+":"+nl;
            //part += "       PUSH " + REG+nl;
            //part += "       djnz " + mylabel + nl;
            st.Append(part);
            // RegBC = "";
            
        }


        private void ConvertImage(Bitmap b,  int[,] pxl)
        {

            for (int y = 0; y < b.Height; y++)
            {
                for (int x = 0; x < b.Width; x++)
                {
                    int xx = x / VbX.CInt(txtXScale.Text);
                    xx = xx * VbX.CInt(txtXScale.Text) + VbX.CInt(VbX.CInt(txtXScale.Text) / 2);
                    int yy = y / VbX.CInt(txtYScale.Text);
                    yy = yy * VbX.CInt(txtYScale.Text);
                    yy = yy + VbX.CInt(VbX.CInt(txtYScale.Text) / 2);
                    if (chkScaledownDither.Checked)
                    {
                        int halfscale = VbX.CInt(txtYScale.Text) / 4;
                        int linenum = y % 2;
                        if (linenum == 1) yy = yy + halfscale;
                        if (yy >= b.Height) yy = b.Height - 1;
                    }
                    else
                    {

                    }
                    Color c = b.GetPixel(xx, yy);

                    int bestcolor = 0;
                    int bestcolormatch = 255 * 3;
                    for (int i = 0; i <= 4; i++)
                    {
                        int thismatch = Math.Abs(c.R - getcolor(i).R) + Math.Abs(c.G - getcolor(i).G) + Math.Abs(c.B - getcolor(i).B);
                        if (Math.Abs(thismatch) < bestcolormatch) { bestcolor = i; bestcolormatch = Math.Abs(thismatch); }
                    }

                    for (int i = 0; i <= ss.CountItems(txtColorConv.Text, VbX.Chr(13));i++ )
                    {
                        string subpart = ss.GetItem(txtColorConv.Text, VbX.Chr(13),i);
                        int newcol = VbX.CInt(ss.GetItem(subpart, ",", 0));
                        int Tolerance = VbX.CInt(ss.GetItem(subpart, ",", 1));
                        int R = VbX.CInt(ss.GetItem(subpart, ",", 2));
                        int G = VbX.CInt(ss.GetItem(subpart, ",", 3));
                        int B = VbX.CInt(ss.GetItem(subpart, ",", 4));


                        int thismatch = Math.Abs(c.R - R) + Math.Abs(c.G - G) + Math.Abs(c.B -B);
                        if (Tolerance > 0) { 
                            if (Math.Abs(thismatch) < Tolerance) { bestcolor = newcol; bestcolormatch = Math.Abs(thismatch); }
                        }
                    }

                    // int thismatch = Math.Abs(c.R - getcolor(i).R) + Math.Abs(c.G - getcolor(i).G) + Math.Abs(c.B - getcolor(i).B);
                    //if (Math.Abs(thismatch) < bestcolormatch) { bestcolor = i; bestcolormatch = Math.Abs(thismatch); }

                    pxl[x, y] = bestcolor;


                }
            }

         
        
        }

        private void button4_Click(object sender, EventArgs e)
        {
            OpenFileDialog fd = new OpenFileDialog();
            fd.Filter = "All files (*.txt)|*.txt";
            DialogResult dr = fd.ShowDialog();
            if (dr == DialogResult.OK) txtScriptFile.Text = fd.FileName;
        }
        private void colswap() { 
        
        
        }
        private void BtnScript_Click(object sender, EventArgs e)
        {
            txtHeader.Text = "";
            Doreset();      
            System.IO.StreamReader sr = new System.IO.StreamReader(txtScriptFile.Text);
            while (!sr.EndOfStream) {
                string lin = sr.ReadLine();
                string fcmd = VbX.Trim(ss.GetItem(lin, ",", 0));
                string file1 = ss.GetItem(lin, ",", 1);
                string file2 = ss.GetItem(lin, ",", 2);
                string file3 = ss.GetItem(lin, ",", 3);
                string file4 = ss.GetItem(lin, ",", 4);
                string file5 = ss.GetItem(lin, ",", 5);

                // txtFilenameOld.Text = txtFilename.Text;
                //VbX.MsgBox(file);
                txtFilename.Text = txtWorkingPath.Text+file1;
                if (file2 == "")
                {
                    txtFilenameOld.Text = "";
                }
                else {

                    txtFilenameOld.Text = txtWorkingPath.Text + file2;
                }

                switch (fcmd.ToLower()) { 
                    case "rle":
                        btnRLE_Click(sender,e);
                        break;
                   case "rlec":
                        
                        btnRLE_Click(sender, e);
                        break;
                    case "bmp":
                        button5_Click(sender,e);
                        break;
                    case "comp":
                        button1_Click_1(sender, e);
                        break;
                    case "reset":
                        Doreset(); 
                        break;
                    case "setorg":
                         txtOrg.Text=file1;
                        break;
                    case "diff":
                        button1_Click(sender, e);
                        break;
                    case "setworkingpath":
                         txtWorkingPath.Text=file1;
                        break;
                    case "setxpos":
                        txtXpos.Text = file1;
                        break;
                    case "setypos":
                        txtYpos.Text = file1;
                        break;
                    case "setxypos":
                        txtXpos.Text = file1;
                        txtYpos.Text = file2;
                        break;
                    case "setgameengine":
                        cboEngine.Text = file1;
                        break;
                    
                    case "writeline":
                        
                        globals.globaldata.Append( lin.Substring(VbX.InStr(lin, ","), lin.Length - VbX.InStr(lin, ","))+nl);
                        textBox1.Text = globals.initdata + nl + globals.imagedata.ToString() + nl + globals.globaldata.ToString();
                        break;
                    case "writeheader":
                        txtHeader.Text += lin.Substring(VbX.InStr(lin, ","), lin.Length - VbX.InStr(lin, ",")) + VbX.Chr(13) + VbX.Chr(10);
                        break;
                    case "save":
                        {
                            System.IO.StreamWriter sw = new System.IO.StreamWriter(txtWorkingPath.Text+file1, false);
                            sw.Write(textBox1.Text);
                            sw.Close();
                        }
                        
                        break;
                        case "saveheader":
                        {
                            System.IO.StreamWriter sw = new System.IO.StreamWriter(txtWorkingPath.Text+file1, false);
                            sw.Write(txtHeader.Text);
                            sw.Close();
                        }
                        
                        break;
                    case "setbank":
                        txtBank.Text = file1;
                        break;
                    case "col0":{
                        int r=VbX.CInt(file1);
                        int g = VbX.CInt(file2);
                        int b = VbX.CInt(file3);
                        Color0.BackColor = System.Drawing.Color.FromArgb(r, g, b);
                            }
                        break;
                    case "col1":
                        {
                            int r = VbX.CInt(file1);
                            int g = VbX.CInt(file2);
                            int b = VbX.CInt(file3);
                            Color1.BackColor = System.Drawing.Color.FromArgb(r, g, b);
                        }
                        break;
                    case "col2":
                        {
                            int r = VbX.CInt(file1);
                            int g = VbX.CInt(file2);
                            int b = VbX.CInt(file3);
                            Color2.BackColor = System.Drawing.Color.FromArgb(r, g, b);
                        }
                        break;
                    case "col3":
                        {
                            int r = VbX.CInt(file1);
                            int g = VbX.CInt(file2);
                            int b = VbX.CInt(file3);
                            Color3.BackColor = System.Drawing.Color.FromArgb(r, g, b);
                        }
                        break;
                    case "cola":
                        {
                            int r = VbX.CInt(file1);
                            int g = VbX.CInt(file2);
                            int b = VbX.CInt(file3);
                            ColorA.BackColor = System.Drawing.Color.FromArgb(r, g, b);
                        }
                                                
                        break;
                    case "colswapreset":
                        txtColorConv.Text = "";
                        break;
                    case "end":{
                        sr.Close();
                        return;
                        
                    }
                    case "colswap":
                        {
                            txtColorConv.Text += file1 + "," + file2 + "," + file3 + "," + file4 + "," + file5 + VbX.Chr(13) + VbX.Chr(10);
                        
                        }
                        break;
                    case "":
                    case "//":
                        break;
                    default:
                        VbX.MsgBox("Unknown command "+lin);
                        break;

                }
            }
            sr.Close();
        }

        private void btnReset_Click(object sender, EventArgs e)
        {
            
            Doreset();      
        button1_Click(sender,e);
        }

    private void    Doreset(){

        globals.PicNumber = 0;
        txtColorConv.Text = "";
        txtYpos.Text = "0";
        txtXpos.Text = "0";
        txtBank.Text = "0";
        globals.useRLE = false;
        globals.DoRawBmp = false;
        globals.RegBC = "";
        globals.RegDE = "";
        globals.RegHL = "";
        globals.DEUsed = 0;
        globals.LastDE = "";
        globals.LastHL = "";
        globals.ChunkDeBak = "";
        globals.BitmapData = "";
        for (int i = 0; i < globals.ChunkCache; i++)
        {
            globals.ChunkCache_Name[i] = "";
            globals.ChunkCache_Data[i] = "";
            globals.ChunkCache_DE[i] = "";
            globals.ChunkCache_Reused[i] = 0;
        }
        globals.ChunkCache = 0;
        globals.GlobalsDone = 0;
        if (cboEngine.Text.ToLower() == "akuyou")
        {
            globals.initdata = globals.AkuyouInit + "org " + txtOrg.Text + VbX.Chr(13) + VbX.Chr(10); 

        } else {
            globals.initdata = "org " + txtOrg.Text + VbX.Chr(13) + VbX.Chr(10)+VbX.Chr(13) + VbX.Chr(10) + "nolist" + VbX.Chr(13) + VbX.Chr(10);
        }
        globals.initdata += "FirstByte:" + nl;

        if (chkRst6.Checked){
            globals.initdata +=  "LD hl,&D5E1" + VbX.Chr(13) + VbX.Chr(10) + "ld (&0030),hl" + VbX.Chr(13) + VbX.Chr(10) + "LD hl,&D5D5" + VbX.Chr(13) + VbX.Chr(10) + "ld (&0032),hl" + VbX.Chr(13) + VbX.Chr(10) + "LD hl,&D5E9" + VbX.Chr(13) + VbX.Chr(10) + "ld (&0034),hl" + VbX.Chr(13) + VbX.Chr(10);
        }

        if (chkRst0.Checked)
        {
            globals.initdata += "ld hl,&0000" + nl + "ld (hl),&C3" + nl + "inc hl" + nl + "ld (hl),DoubleByteDE" + nl;
        }



        globals.imagedata = new System.Text.StringBuilder();
        globals.globaldata = new System.Text.StringBuilder();
        globals.PairCache_Count = 0;
        globals.MaxDePush = 5;
        for (int i = 0; i <= 40; i++)
        {
            globals.BitmapPushLastUsed[i] = false;
            globals.DePushUsed[i] = false;
            globals.MultiPushDeLast[i] = false;
            
        }
        for (int i = 0; i <= 80; i++)
        {
            globals.BitmapDataUsed[i] = false;
        }
        for (int x = 0; x < 320; x++)
        {
            for (int y = 0; y < 200; y++)
            {
                globals.LastPixelMap[x, y] = 99;
                globals.PixelMap[x, y] = 4;
            }
        }
   
    }

        private void Form1_Load(object sender, EventArgs e)
        {
            Doreset();
        }
        private int uniuquechars(string lin) {
            int response = 0;
            string cache = "";

            for (int i = 0; i < lin.Length; i++) {
                string ch = lin.Substring(i, 1);
                if( !cache.Contains(ch)){
                    cache = cache + ch;
                }

            }
            response = cache.Length;
            return response;
        }
        private void button1_Click_1(object sender, EventArgs e)
        {
            globals.RegBC = "";
            globals.RegDE = "";
            globals.RegHL = "";
            globals.LastHL = "";
            globals.LastDE = "";
            for (int x = 0; x < 320; x++)
            {
                for (int y = 0; y < 200; y++)
                {
                    globals.LastPixelMap[x, y] = 99;
                }
            }
   
            button1_Click(sender, e);
        }

        private void button5_Click(object sender, EventArgs e)
        {

            string Filename = DoFilename(txtFilename.Text);//"Pic"+ss.GetItem(txtFilename.Text, "\\", ss.CountItems(txtFilename.Text, "\\")).Replace(".","");
              // globals.BitmapData = "";
            //; globals.ChunkCache = 0;

            StringBuilder Chunk = new StringBuilder();
            
            pictureBox1.Image = lnx.LoadImg(txtFilename.Text);
            if (!lnx.exists(txtFilename.Text)) return;


            
            string DrawOrder = "";
            string BitBlock = "";
            string BitblockLinear = "";
            
             
            int CodeBytes = 0;


 //           StringBuilder st = new StringBuilder();
            System.Drawing.Bitmap b = (System.Drawing.Bitmap) pictureBox1.Image;
            
            System.Drawing.Bitmap b2 = new Bitmap(b.Width, b.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
            if (globals.LastFrame == null) {
                globals.LastFrame = new Bitmap(b.Width, b.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
            }
            ConvertImage(b, globals.PixelMap);
            
            //globals.PixelMap[x, y] = bestcolor;
            if (txtFilenameOld.Text.Length > 0)
            {
                System.Drawing.Bitmap bold = (System.Drawing.Bitmap)lnx.LoadImg(txtFilenameOld.Text);
                globals.LastFrame = new Bitmap(b.Width, b.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
                ConvertImage(bold,  globals.LastPixelMap);
      
            }

            globals.initdata += "jp " + Filename + nl;


            


            for (int y = b.Height-1; y >=0 ; y--)
            {
                for (int x = 0; x < b.Width; x += 8)
                {
                    string thispair = GetPair(y, x);

                    BitBlock = thispair.Substring(2, 2) + "," + thispair.Substring(0, 2) + "," + BitBlock;
                }
            }
            int bytecount = BitBlock.Length / 3;
            globals.imagedata.Append(Filename + ":" + nl);
            string thiscommand = "";
            
            
            globals.imagedata.Append("ld (StackRestore_PlusRawBmp2-2),sp" + nl);
            globals.imagedata.Append("ld b,"+b.Height+nl);
            globals.imagedata.Append("ld IXL," + b.Width/8 + nl);
            globals.imagedata.Append("di" + nl);
            globals.imagedata.Append("ld sp,BitmapData+" + VbX.CStr((globals.BitmapData.Length / 3) ) + "" + nl);
            globals.imagedata.Append("ld hl,&C050-1-" + ((80 - (b2.Width / 4)) / 2) + nl + nl);
            globals.imagedata.Append("jp DrawRawBmp" + nl);
            globals.DoRawBmp = true;
            globals.BitmapData += BitBlock;


            DoGlobalData(b);
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button6_Click(object sender, EventArgs e)
        {
            string Msg = "霊写 - Shinrei (Spirit Capture)" + nl;
            Msg += nl;
            Msg += "This is the tool used to create the compiled sprites used"+nl;
            Msg += "in Chibi Akuma(s) Episode 1" + nl;
            Msg += "Please note, this program is pre Alpha quality" + nl;
            Msg += "many of its functions are buggy, do not work etc" + nl;
            Msg += "it was developed only to the point of being usable" + nl;
            Msg += "to complete the game and is nothing like 'production quality'" + nl;
            Msg +=  nl;
            Msg += "I have released it only to allow you to modify the game, and" + nl;
            Msg += "use it for inspiration for your own projects." + nl;
            VbX.MsgBox(Msg);
        }
        private void addheader() {
            string Filename = DoFilename(txtFilename.Text);//"Pic" + ss.GetItem(txtFilename.Text, "\\", ss.CountItems(txtFilename.Text, "\\")).Replace(".", "");
            txtHeader.Text += Filename + "_Bank equ " + txtBank.Text + VbX.Chr(13) + VbX.Chr(10);
            txtHeader.Text += Filename + "_Ref equ " + globals.PicNumber.ToString() + VbX.Chr(13) + VbX.Chr(10);
            if (txtFilenameOld.Text.Length > 0)
            {
                txtHeader.Text += Filename + "_ParentRef equ " + DoFilename(txtFilenameOld.Text) + "_Ref " + VbX.Chr(13) + VbX.Chr(10);
            }
            else
            {
                txtHeader.Text += Filename + "_ParentRef equ 255" + VbX.Chr(13) + VbX.Chr(10);
            }
            txtHeader.Text += VbX.Chr(13) + VbX.Chr(10);
        }
        private void addrledecoder() {
            globals.globaldata.Append(nl + globals.RleDecoder + nl);

            if (cboEngine.Text.ToLower() == "akuyou" || cboEngine.Text.ToLower() == "akuyouc000")
            {
                globals.globaldata.Append("ei"+ VbX.Chr(13) + VbX.Chr(10));
            }
            globals.globaldata.Append(nl + globals.RleDecoder2 + nl);

            if (cboEngine.Text.ToLower() == "akuyou" || cboEngine.Text.ToLower() == "akuyouc000")
            {
                globals.globaldata.Append("ei" + VbX.Chr(13) + VbX.Chr(10));
            }
            globals.globaldata.Append("ret"+ VbX.Chr(13) + VbX.Chr(10));

        }
        private void btnRLE_Click(object sender, EventArgs e)
        {

            
            string Filename = DoFilename(txtFilename.Text);//"Pic" + ss.GetItem(txtFilename.Text, "\\", ss.CountItems(txtFilename.Text, "\\")).Replace(".", "");

            addheader();

            globals.PicNumber += 3 ;
            
            //            VbX.MsgBox(globals.BinOr("11100000", "00000010"));

            //"11001100"
            // VbX.MsgBox(VbX.CStr(35 && 32));

            // globals.BitmapData = "";
            //; globals.ChunkCache = 0;


            string lastnibble = "";
            string Randombytes = "";
            int nibblecount = 1;
            StringBuilder Chunk = new StringBuilder();

            pictureBox1.Image = lnx.LoadImg(txtFilename.Text);
            if (!lnx.exists(txtFilename.Text)) return;

            globals.initdata += "jp " + Filename + nl;
            if (globals.useRLE == false) { 
                globals.useRLE=true;

                addrledecoder();
            
            }


            //           StringBuilder st = new StringBuilder();
            System.Drawing.Bitmap b = (System.Drawing.Bitmap)pictureBox1.Image;
       


            System.Drawing.Bitmap b2 = new Bitmap(b.Width, b.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
            if (globals.LastFrame == null)
            {
                globals.LastFrame = new Bitmap(b.Width, b.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
            }
            ConvertImage(b, globals.PixelMap);

            //globals.PixelMap[x, y] = bestcolor;

            int FirstY = b.Height; // intentionally backwards!
            int LastY = 0;

            if (txtFilenameOld.Text.Length > 0)
            {
                System.Drawing.Bitmap bold = (System.Drawing.Bitmap)lnx.LoadImg(txtFilenameOld.Text);
                globals.LastFrame = new Bitmap(b.Width, b.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
                ConvertImage(bold, globals.LastPixelMap);

                for (int y = 0; y < b.Height; y++)
                {

                    bool hasdifference = false;
                    for (int x = b.Width - 8; x >= 0; x -= 8)
                    {
                        if (bold.GetPixel(x, y) != b.GetPixel(x, y)) hasdifference = true;

                    }
                    if (hasdifference)
                    {
                        if ((y+1) > LastY) LastY = y + 1;
                        if (y < FirstY) FirstY = y-1;

                    }
                }



            }
            else {
                LastY = b.Height; // intentionally backwards!
                FirstY = 0;
            }

            

            // int FirstY = 0;
            //int LastY = b.Height;

            int CurrentMode = 0; //1=nibble . 2=byte 3=repeatingbytes
            int lineitem = 0;
            String RepeatingBytes = "";

            for (int y = FirstY; y < LastY ; y++)
            {


                for (int x = b.Width - 8; x >= 0; x -= 8)
                {
                    string thispair = GetPair(y, x);
                    
                    for (int by = 0; by < 2; by++) {
                        string ThisByte = "";
                        switch (by) { 
                            case 0:
                                ThisByte=thispair.Substring(0, 2);
                                break;
                            case 1:
                                ThisByte = thispair.Substring(2, 2);
                                break;
                        }
                        
                  //  VbX.MsgBox(ThisByte);
                    
                    string nibble = "";
                    for (int n = 0; n < 2; n++) {
                        switch (n) { 
                            case 1:
                                nibble=globals.BinAnd(globals.HexToBin(ThisByte),"11001100");
                                
                                nibble = nibble.Substring(0, 2) + nibble.Substring(4, 2);
                                
                                break;
                            case 0:
                                nibble = globals.BinAnd(globals.HexToBin(ThisByte), "00110011");
                                // VbX.MsgBox(nibble);
                                nibble = nibble.Substring(2 + 0, 2) + nibble.Substring(2 + 4, 2);
                                //VbX.MsgBox(nibble);
                                break;
                        }

                        if (nibble == lastnibble)
                        {
                            nibblecount++;
                            CurrentMode = 1;
                        }
                        else if (lastnibble==""){
                            lastnibble = nibble;
                            nibblecount = 1;
                        }else
                        {
                            if (nibblecount > 1 )
                            {
                                if (Randombytes.Length > 1)
                                {

                                    if (Randombytes.Length == 4)
                                    {

                                        // dobytebatch(Randombytes, Chunk);
                                         donibblebatch(Randombytes, 1, Chunk);
                                        donibblebatch(lastnibble, nibblecount, Chunk);
                                        lastnibble = "";

                                    }
                                    else
                                    {
                                        dobytebatchWithRepeater(Randombytes, Chunk);
                                        donibblebatch(lastnibble, nibblecount, Chunk);
                                    }
                                    Randombytes = "";
                                }
                                else
                                {
                                    //if (nibblecount < 3)
                                   // {
                                   //     while (nibblecount>0){

    //                                        Randombytes = lastnibble + Randombytes;
//                                            nibblecount--;
  //                                      }

      //                              }
        //                            else
                                    {
                                        donibblebatch(lastnibble, nibblecount, Chunk);
                                    }
                                }
                            }
                            else
                            {
                                if (VbX.Len(Randombytes) == 4  && n == 1)  //
                                {
                                    //finish the last byte
                                    donibblebatch(Randombytes, nibblecount, Chunk);
                                    nibblecount = 0;
                                    Randombytes = lastnibble;
                                    CurrentMode = 2;
                                }
                                else
                                {
                                    Randombytes = Randombytes + lastnibble;
                                    CurrentMode = 2;
                                    nibblecount = 0;
                                }

                            }
                            nibblecount = 1;
                            lastnibble = nibble;
                        }

                        
                    }
                    }
                }
                
            }
            dobytebatchWithRepeater(Randombytes, Chunk);
            donibblebatch(lastnibble, nibblecount, Chunk);


            //thiswidth
            FirstY = FirstY + VbX.CInt(txtYpos.Text);

            //globals.BitmapData += BitBlock;
            globals.imagedata.Append(Filename +":" + nl);
            globals.imagedata.Append("ld hl,"+Filename + "_rledata-1" + nl);
            globals.imagedata.Append("ld de," + Filename + "_rledataEnd-1" + nl);
            globals.imagedata.Append("ld b,"+ FirstY.ToString() + nl);
            int thiswidth = b.Width / 4;
                globals.imagedata.Append("ld ixh," + thiswidth.ToString() + nl);
                
                
                thiswidth = VbX.CInt(txtXpos.Text)+thiswidth-1;
                //thiswidth = ((80 - thiswidth) / 2) + thiswidth-1;
            	globals.imagedata.Append("ld IXL,"+thiswidth.ToString()+nl);
                
                globals.imagedata.Append("di" + nl);
            	globals.imagedata.Append("exx " + nl);
	            globals.imagedata.Append("push bc" + nl);
                globals.imagedata.Append("exx" + nl);
            globals.imagedata.Append("jp RLE_Draw" + nl);
            globals.imagedata.Append(Filename+"_rledata:"+ nl);
            globals.imagedata.Append( Chunk.ToString()+nl);
            globals.imagedata.Append(Filename + "_rledataEnd: defb 0" + nl);
             textBox1.Text = globals.initdata + nl + globals.imagedata.ToString() + nl + globals.globaldata.ToString();
        }
        void dobytebatchWithRepeater(string bitdata, StringBuilder Chunk)
        {

            string LastByte="";
            string ThisChunk="";
            int ThisChunkCount=0;
            int mode = 0; //1=different 2=same
            for (int i = 0; i < bitdata.Length; i += 8) {
                string thisbyte = (bitdata+"    ").Substring(i,8);
                if (LastByte == thisbyte) {
                    if (mode == 1)
                    {
                        // current bytes are not matching
                        dobytebatch(ThisChunk.Substring(0,ThisChunk.Length-8), Chunk);
                        ThisChunk = ThisChunk.Substring(ThisChunk.Length - 8, 8);
                    }
                    mode = 2;
                }
                if (LastByte != thisbyte && LastByte!="")
                {
                    if (mode == 2)
                    {
                        // Matching bytes
                        doOnebytebatch(ThisChunk, Chunk);
                        ThisChunk ="";
                    }
                    mode = 1;
                }
                LastByte = thisbyte;
                ThisChunk += thisbyte;
                ThisChunkCount++;
            }
            if (mode == 1)
            {
                dobytebatch(ThisChunk, Chunk);
            }
            else {
                doOnebytebatch(ThisChunk, Chunk);
            }
        }

        void doOnebytebatch(string bitdata, StringBuilder Chunk) {
            bitdata = bitdata.Trim();
            if (bitdata.Length == 0) return;
            int lng = bitdata.Length / 8;
            if (lng < 3) {
                // this code needs at least 3 bytes!
                dobytebatch(bitdata, Chunk);
                return;
            }
            Chunk.Append(nl + "defb &00,");          //Double Zero nibble is the marker for a repating byte batch
            while (lng >= 0)
            {

                int pp2 = lng;
                if (pp2 > 255) pp2 = 255;
                Chunk.Append("&" + (pp2).ToString("x") + ",");
                lng -= 255;
            }
            Chunk.Append("&" + globals.BinToHex(unnibble(bitdata.Substring(0, 8))));
        
        }

        void dobytebatch(string bitdata, StringBuilder Chunk) {
            bitdata = bitdata.Trim();
            if (bitdata.Length == 0) return;
            int lng = bitdata.Length / 8;
            int partnum = 0;
            for (int i = 0; i < bitdata.Length; i += 8)
            {
                //;
                string part = VbX.Mid(bitdata + "    ", i + 1, 8).Trim();
               
                if (part.Length ==8)
                {
                    if (i > 0)
                    {
                        Chunk.Append(",");
                        
                    }
                    else
                    {
                        Chunk.Append(nl+"defb ");
                        
                    }
                    // if (partnum == 14) partnum = 0;
                    if (partnum == 0) {
                        int pp = (lng - (i / 8));
                         if (pp > 15) pp = 15;
                        Chunk.Append("&"+(16*pp).ToString("x")+",");
                        if (pp == 15) { 
                            pp = (lng - (i / 8));
                            pp -= 15;
                            while (pp >= 0) {
                                
                                int pp2=pp;
                                if (pp2 > 255) pp2 = 255;
                                Chunk.Append("&" + (pp2).ToString("x") + ",");
                                pp -= 255;
                            }
                        }
                        
                    }
                    partnum = partnum + 1;
                    Chunk.Append("&" + globals.BinToHex(unnibble(part)));
                   // VbX.MsgBox("&" + globals.BinToHex(part));
                    // donibblebatch(part, 1, Chunk);
                }
                else {
                    Chunk.Append(nl);
                    donibblebatch(part, 1, Chunk);
                }
            }
            
        
        }


        /*

        void dobytebatch(string bitdata, StringBuilder Chunk)
        {

            int lng = bitdata.Length / 8;
            int partnum = 0;
            //if (bitdata.Length % 8 > 0)
            //{
                 //Chunk.Append(nl);
                 //donibblebatch(VbX.Right(bitdata,4), 1, Chunk);
            
//            }
            for (int i = 0; i < bitdata.Length; i += 8)
            {
                //;
                string part = VbX.Mid(bitdata + "    ", i + 1, 8).Trim();

                if (part.Length == 8)
                {
                    if (i > 0)
                    {
                        Chunk.Append(",");

                    }
                    else
                    {
                        Chunk.Append(nl + "defb ");

                    }
                    if (partnum == 14) partnum = 0;
                    if (partnum == 0)
                    {
                        int pp = (lng - (i / 8));
                        if (pp > 14) pp = 14;
                        Chunk.Append("&" + (16 * pp).ToString("x") + ",");

                    }
                    partnum = partnum + 1;
                    Chunk.Append("&" + globals.BinToHex(unnibble(part)));
                    // VbX.MsgBox("&" + globals.BinToHex(part));
                    // donibblebatch(part, 1, Chunk);
                }
                else
                {
                    Chunk.Append(nl);
                    donibblebatch(part, 1, Chunk);
                  // donibblebatch("1111", 1, Chunk);
                }
            }


        }
*/
        string unnibble(string nibbled) {
            //VbX.MsgBox(nibbled);
             return nibbled.Substring(0 + 4, 2) + nibbled.Substring(4 - 4, 2) + nibbled.Substring(2 + 4, 2) + nibbled.Substring(6 - 4, 2);
            //return nibbled.Substring(0, 2) + nibbled.Substring(4, 2) + nibbled.Substring(2, 2) + nibbled.Substring(6, 2);
// nibble=globals.BinAnd(globals.HexToBin(ThisByte),"11001100");
// nibble = nibble.Substring(0, 2) + nibble.Substring(4, 2);
// nibble = globals.BinAnd(globals.HexToBin(ThisByte), "00110011");
// nibble = nibble.Substring(2 + 0, 2) + nibble.Substring(2 + 4, 2);
 
        
        }
        /*
        void donibblebatchOld(string nibblename, int nibblecount,StringBuilder Chunk) {
         
         int lineitem = 0;
         while (nibblecount>0)
         {
             if (lineitem > 0)
             {     Chunk.Append(",");         }
             else
             {     Chunk.Append(nl+"defb ");        }
             
             int nc=nibblecount;
             if (nibblecount > 14) nc = 14;
             nibblecount -= nc;
             string ct = globals.IntToBin(nc).Substring(4,4);
             Chunk.Append("&" + globals.BinToHex(nibblename + ct));
             lineitem++;
         }
         
        }
        */

        void donibblebatch(string nibblename, int nibblecount, StringBuilder Chunk)
        {

            int lineitem = 0;
            //while (nibblecount > 0)
           // {
                if (lineitem > 0)
                { Chunk.Append(","); }
                else
                { Chunk.Append(nl + "defb "); }

                int nc = nibblecount;
                if (nibblecount > 15) nc = 15;
                //nibblecount -= nc;
                string ct = globals.IntToBin(nc).Substring(4, 4);
                Chunk.Append("&" + globals.BinToHex(nibblename + ct));
                nibblecount -= 15;
                 while (nibblecount >= 0) {

                                int pp2 = nibblecount;
                                if (pp2 > 255) pp2 = 255;
                                Chunk.Append(",&" + (pp2).ToString("x") );
                                nibblecount -= 255;
                            }

                lineitem++;
        //    }

        }

        private void chkScaledownDither_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void label11_Click(object sender, EventArgs e)
        {

        }

        private void button7_Click(object sender, EventArgs e)
        {
            Doreset();      
        }

    }
  }