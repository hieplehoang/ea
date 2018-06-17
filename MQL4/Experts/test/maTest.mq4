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
#include "..\common\common-MA.mq4"
#include "..\common\common-draw-vline.mq4"
#include  "..\..\Libraries\stdlib.mq4"



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

int OnInit() {
   //ChartApplyTemplate(0, "CandleStick-MA6-12-24.tpl");
   return(INIT_SUCCEEDED);
 }

void OnTick() {
  if (IsNewBar()) {
      int direction = currentMACrossOver( 6, 12, 24);
      
      int tp = 150;
      int sl = 200;
      
      /*
      if (direction >= 2){
         myOrder(OP_BUY, 0.1, sl, tp);
         Print("OrderBuy");
      }else if (direction <= -2) {
         myOrder(OP_SELL, 0.1, sl, tp);
         Print("OrderSell");
      } else {
         //Print("Cannot detect");
      }
      */
      
      if (direction >= 2){
         myPendingOrder(OP_BUYLIMIT, NormalizeDouble (Close[1] - (High[1] - Low[1])/2, 5), 0.1, sl, tp);
         Print("OrderBuy");
      }else if (direction <= -2) {
         myPendingOrder(OP_SELLLIMIT,NormalizeDouble ( Open[1] - (High[1] - Low[1])/2, 5 ), 0.1, sl, tp);
         Print("OrderSell");
      } else {
         //Print("Cannot detect");
      }
   }
}
//+------------------------------------------------------------------+
