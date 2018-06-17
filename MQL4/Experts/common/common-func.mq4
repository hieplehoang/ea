bool isGT(double a, double b){
   return a > b;
}

bool isGE(double a, double b){
   return a >= b;
}

bool isLT(double a, double b){
   return a < b;
}

bool isLE(double a, double b){
   return a <= b;
}

bool isEQ(double a, double b){
   return a == b;
}

bool IsNewBar()
  {
   static datetime RegBarTime=0;
   datetime ThisBarTime=Time[0];

   if(ThisBarTime==RegBarTime)
     {
      return(false);
     }
   else
     {
      RegBarTime=ThisBarTime;
      return(true);
     }
  }
//+------------------------------------------------------------------+


// Returns the number of total open orders for this Symbol and MagicNumber
int getTotalOpenOrders(int magicNumber) {
  int total_orders=0;

  for(int order=0; order<OrdersTotal(); order++)
    {
    if(OrderSelect(order,SELECT_BY_POS,MODE_TRADES)==false) 
      break;
    if(OrderMagicNumber()==magicNumber && OrderSymbol()==_Symbol)
      total_orders++;
    }
  return(total_orders);
}

//+------------------------------------------------------------------+

void getPrice(double &price[], int indexBar) {
   price[0] = High[indexBar];
   price[1] = Open[indexBar];
   price[2] = Close[indexBar];
   price[3] = Low[indexBar];
}

/*
   MARKET ORDER
*/
//+------------------------------------------------------------------+

int myOrderBuy(double lot, double stopLoss, double takeProfit) {

   double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   
   stopLoss = stopLoss >= minstoplevel ? stopLoss : minstoplevel;
   takeProfit = takeProfit >= minstoplevel ? takeProfit : minstoplevel;
   int ticket = OrderSend(Symbol(), OP_BUY, lot, Ask, 2, Bid-stopLoss*Point, Bid+takeProfit*Point);
   if (ticket == -1){
      int errorCode = GetLastError();
      Print("Order Buy error (", errorCode, ") : ", ErrorDescription(errorCode), ", Ask: ", Ask, ", SL: ", Bid-stopLoss*Point, ", TP: ", Bid+takeProfit*Point);
   }
   return ticket;
}


int myOrderSell(double lot, double stopLoss, double takeProfit) {

   double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   
   stopLoss = stopLoss >= minstoplevel ? stopLoss : minstoplevel;
   takeProfit = takeProfit >= minstoplevel ? takeProfit : minstoplevel;
   int ticket = OrderSend(Symbol(), OP_SELL, lot, Bid, 2, Ask+stopLoss*Point, Ask-takeProfit*Point);
   if (ticket == -1){
      int errorCode = GetLastError();
      Print("Order Sell error (", errorCode, ") : ",ErrorDescription(errorCode), ", Bid: ", Bid, ", SL: ", Ask+stopLoss*Point, ", TP: ", Ask-takeProfit*Point);
   }
   return ticket;
}

int myOrder(int orderType, double lot, double stopLoss, double takeProfit){
   if (orderType == OP_BUY)
      return myOrderBuy(lot, stopLoss, takeProfit);
   else if (orderType == OP_SELL)
      return myOrderSell(lot, stopLoss, takeProfit);
   else
      return 0;
}

/*
   PENDING ORDER
*/

int myPendingOrderBuy(int orderType, double price, double lot, double stopLoss, double takeProfit) {

   double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   
   stopLoss = stopLoss >= minstoplevel ? stopLoss : minstoplevel;
   takeProfit = takeProfit >= minstoplevel ? takeProfit : minstoplevel;
   
   
   int ticket = OrderSend(Symbol(), orderType, lot, price, 3, price-stopLoss*Point, price+takeProfit*Point, NULL, 0, Time[0] + 60*60*2);
   
   if (ticket == -1){
      int errorCode = GetLastError();
      Print("Pending Order Buy error (", errorCode, ") : ", ErrorDescription(errorCode), ", price: ", price, ", SL: ", price-stopLoss*Point, ", TP: ", price+takeProfit*Point);
   }
   return ticket;
}

int myPendingOrderSell(int orderType, double price, double lot, double stopLoss, double takeProfit) {

   double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   
   stopLoss = stopLoss >= minstoplevel ? stopLoss : minstoplevel;
   takeProfit = takeProfit >= minstoplevel ? takeProfit : minstoplevel;
   
   int ticket = OrderSend(Symbol(), orderType, lot, price, 3, price+stopLoss*Point, price-takeProfit*Point , NULL, 0, Time[0] + 60*60*2);
   if (ticket == -1){
      int errorCode = GetLastError();
      Print("Pending Order Sell error (", errorCode, ") : ",ErrorDescription(errorCode), ", price: ", price, ", SL: ", price+stopLoss*Point, ", TP: ", price-takeProfit*Point);
   }
   return ticket;
}

int myPendingOrder(int orderType, double price, double lot, double stopLoss, double takeProfit){
   if (orderType == OP_BUYLIMIT 
         || orderType == OP_BUYSTOP )
      return myPendingOrderBuy( orderType,NormalizeDouble(price, 5), lot, stopLoss, takeProfit);
   else if (orderType == OP_SELLLIMIT
            || orderType == OP_SELLSTOP)
      return myPendingOrderSell( orderType, NormalizeDouble(price, 5), lot, stopLoss, takeProfit);
   else
      return 0;
}