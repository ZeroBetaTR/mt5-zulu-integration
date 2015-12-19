//+------------------------------------------------------------------+
//|                                                       Base64.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                  MT5 version © 2012, Investeo.pl |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright Â© 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
 
static uchar ExtBase64Encode[64]={ 'A','B','C','D','E','F','G','H','I','J','K','L','M',
                                 'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
                                 'a','b','c','d','e','f','g','h','i','j','k','l','m',
                                 'n','o','p','q','r','s','t','u','v','w','x','y','z',
                                 '0','1','2','3','4','5','6','7','8','9','+','/'      };
                                 
static uchar ExtBase64Decode[256]={
                    -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
                    -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
                    -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,  -1,  63,
                    52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -2,  -1,  -1,
                    -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
                    15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
                    -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
                    41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
                    -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
                    -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
                    -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
                    -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
                    -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
                    -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
                    -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
                    -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1 };
                               

string Base64Encode(string in)
  {
   string out;
   int i=0,pad=0,len=StringLen(in);

   while(i<len)
     {
      
      int b3,b2,b1=StringGetCharacter(in,i);
      i++;
      if(i>=len) { b2=0; b3=0; pad=2; }
      else
        {
         b2=StringGetCharacter(in,i);
         i++;
         if(i>=len) { b3=0; pad=1; }
         else       { b3=StringGetCharacter(in,i); i++; }
        }
      //----
      int c1=(b1 >> 2);
      int c2=(((b1 & 0x3) << 4) | (b2 >> 4));
      int c3=(((b2 & 0xf) << 2) | (b3 >> 6));
      int c4=(b3 & 0x3f);
 
      out=out+CharToString(ExtBase64Encode[c1]);
      out=out+CharToString(ExtBase64Encode[c2]);
      switch(pad)
        {
         case 0:
           out=out+CharToString(ExtBase64Encode[c3]);
           out=out+CharToString(ExtBase64Encode[c4]);
           break;
         case 1:
           out=out+CharToString(ExtBase64Encode[c3]);
           out=out+"=";
           break;
         case 2:
           out=out+"==";
           break;
        }
     }
     return out;
//----
  }

string Base64Decode(string in)
  {
   string out;
   int i=0,len=StringLen(in);
   int shift=0,accum=0;

   while(i<len)
     {
      int value=ExtBase64Decode[StringGetCharacter(in,i)];
      if(value<0 || value>63) break;
      
      accum<<=6;
      shift+=6;
      accum|=value;
      if(shift>=8)
        {
         shift-=8;
         value=accum >> shift;
         out=out+CharToString((uchar)(value & 0xFF));
        } 
      i++;
     }
     return out;
//----
  }
//+------------------------------------------------------------------+