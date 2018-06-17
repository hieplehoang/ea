#include ".\common\setup-init.mq4"
#include ".\common\common-func.mq4"

input int            TakeProfit=80;
input int            StopLoss=40;
input double         LotSize=0.1;
input int            Slippage=3;
input int            MagicNumber=5555;


//--- global variables
double MyPoint;
int    MySlippage;

//--- indicators
double MACD[2],fast_MA[3],slow_MA[3];


int OnInit() {
   MyPoint=MyPoint();
   MySlippage=MySlippage(Slippage);

   return(INIT_SUCCEEDED);
}


void OnDeinit(const int reason){}


void OnTick() {
   if(TotalOpenOrders(MagicNumber)==0 && IsNewBar()) {
      if(BuySignal()) {
        OpenBuy();
      } else if(SellSignal()) { 
          OpenSell();
      }
    }
}



void InitIndicators()
  {
   for(int i=0;i<2;i++)
     {
      // MACD (0-MODE_MAIN, 1-MODE_SIGNAL)
      MACD[i]=iMACD(_Symbol,PERIOD_D1,12,26,9,PRICE_CLOSE,i,0);

      // Fast MA
      fast_MA[i+1]=iMA(_Symbol,PERIOD_CURRENT,12,0,MODE_EMA,PRICE_CLOSE,1+i);

      // Slow MA
      slow_MA[i+1]=iMA(_Symbol,PERIOD_CURRENT,16,0,MODE_EMA,PRICE_CLOSE,1+i);
     }
  }
bool BuySignal()
  {
// MACD zero line filter
   if(!(MACD[0] > 0 && MACD[1] > 0))return(false);

// MACD trend filter
   if(!(MACD[0] > MACD[1]))return(false);

// Check Signal
   if(fast_MA[1] > slow_MA[1] && fast_MA[2] < slow_MA[2])return(true);

   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SellSignal()
  {
// MACD zero line filter
   if(!(MACD[0] < 0 && MACD[1] < 0))return(false);

// MACD trend filter
   if(!(MACD[0] < MACD[1]))return(false);

// Check Signal
   if(fast_MA[1] < slow_MA[1] && fast_MA[2] > slow_MA[2])return(true);

   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenBuy()
  {
// Open Buy Order
   int ticket=OrderSend(_Symbol,OP_BUY,LotSize,Ask,MySlippage,0,0,"BUY",MagicNumber);

   if(ticket<0) Print("Buy Order Send failed with error #",GetLastError());
   else Print("Buy Order placed successfully");

// Modify Buy Order
   bool res=OrderModify(ticket,OrderOpenPrice(),Ask-StopLoss*MyPoint,Ask+TakeProfit*MyPoint,0);

   if(!res) Print("Error in OrderModify. Error code=",GetLastError());
   else Print("Order modified successfully.");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenSell()
  {
//Open Sell Order
   int ticket=OrderSend(_Symbol,OP_SELL,LotSize,Bid,MySlippage,0,0,"SELL",MagicNumber);

   if(ticket<0) Print("Sell Order Send failed with error #",GetLastError());
   else Print("Sell Order placed successfully");

// Modify Sell Order
   bool res=OrderModify(ticket,OrderOpenPrice(),Bid+StopLoss*MyPoint,Bid-TakeProfit*MyPoint,0);

   if(!res) Print("Error in OrderModify. Error code=",GetLastError());
   else Print("Order modified successfully.");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


