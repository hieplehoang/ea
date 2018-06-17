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
int TotalOpenOrders(int magicNumber) {
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