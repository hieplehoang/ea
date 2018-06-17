//+------------------------------------------------------------------+
//|                                                            a.mq4 |
//|                                                            hle56 |
//|                                                     facebook.com |
//+------------------------------------------------------------------+
#property library
#property copyright "hle56"
#property link      "facebook.com"
#property version   "1.00"
#property strict


void getMA(double &ma[], string symbol, int timeFrame , int maPeriod, int maMethod, int appliedPrice, int fromBar){
   int numberBar = ArraySize(ma);
   
   for( int i= 0; i < numberBar; i++) {
      ma[i] = iMA( symbol, timeFrame, maPeriod, 0, maMethod, appliedPrice, fromBar + i);
   }
}

void getCurrentMA(double &maData[], int maPeriod, int maMethod, int appliedPrice, int numberBar, int fromBar) {
   ArrayResize(maData, numberBar);
   getMA(maData, NULL, 0,  maPeriod, maMethod, appliedPrice, fromBar );
 }
 
void getCurrentCloseMA(double &maData[], int maPeriod, int numberBar, int fromBar) {
   getCurrentMA(maData, maPeriod, MODE_EMA, PRICE_CLOSE, numberBar, fromBar );
}

/*
 return: 1 -> move up, -1 > move down, 0 can not detected
*/
int currentMACrossOver(int maPeriodFast, int maPeriodMedium, int maPeriodLow){
   double maFast[], maMedium[], maLow[];
   int numberBar = 10;
   int fromBar = 0;
   
   getCurrentCloseMA(maFast, maPeriodFast, numberBar, fromBar);
   getCurrentCloseMA(maMedium, maPeriodMedium, numberBar, fromBar);
   getCurrentCloseMA(maLow, maPeriodLow, numberBar, fromBar);
   
   
   
   //Print(maFast[0], " : ", maLow[0], " | ", maFast[1], " : ", maLow[1]);

   //Print(maFast[0],"|",maFast[1],"|",maFast[2],"|",maFast[3],"|",maFast[4],"|",maFast[5],"|",maFast[6],"|",maFast[7],"|",maFast[8],"|",maFast[9]);  
   int maDirection = 0;
   int x = 1;
   while (x >= 0) {
      if (maFast[x] >= maLow[x]
            && maFast[x+1] < maLow[x+1]) {
            maDirection++;
      } else if (maFast[x] <= maLow[x]
            && maFast[x+1] > maLow[x+1]) {
            maDirection--;
      }
      x--;
   }
   
   int y = 1;
   while (y >= 0) {
      if (maMedium[y] >= maLow[y]
            && maMedium[y+1] < maLow[y+1]) {
            maDirection++;
      } else if (maMedium[y] <= maLow[y]
            && maMedium[y+1] > maLow[y+1]) {
            maDirection--;
      }
      y--;
   }
   
   return maDirection;
}