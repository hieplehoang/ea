//+------------------------------------------------------------------+
//|                                                  pinBarsTest.mq4 |
//|                                                            hle56 |
//|                                                     facebook.com |
//+------------------------------------------------------------------+
#property copyright "hle56"
#property link      "facebook.com"
#property version   "1.00"
#property strict

#include "..\common\common-func.mq4"
#include "..\common\common-bars.mq4"
#include "..\common\common-draw-vline.mq4"


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

int n = 0;
input color           InpColor=clrRed;     // Line color
input ENUM_LINE_STYLE InpStyle=STYLE_DASH; // Line style
input int             InpWidth=1;          // Line width
input bool            InpBack=false;       // Background line
input bool            InpSelection=true;   // Highlight to move
input bool            InpHidden=true;      // Hidden in the object list
input long            InpZOrder=0;         // Priority for mouse click

void OnTick() {
   if (IsNewBar()) {
      double price[4] = {0,0,0,0};
      getPrice(price, 1);
      
      double previousPrice[4] = {0,0,0,0};
      getPrice(previousPrice, 2);
      
      if (isPinBar( price, 4, 2, Time[1]) 
            && isInsideBar(previousPrice, price) 
          ){
           if(!VLineCreate(0,"name " + n++,0,Time[0],InpColor,InpStyle,InpWidth,InpBack,
              InpSelection,InpHidden,InpZOrder)){
                Alert("Cannot create VLine");
              }
             
      }
   }
}
//+------------------------------------------------------------------+
