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
//+------------------------------------------------------------------+
//| My function                                                      |
//+------------------------------------------------------------------+
// int MyCalculator(int value,int value2) export
//   {
//    return(value+value2);
//   }
//+------------------------------------------------------------------+

/**
@param : price: array of price. price[0] - High, price[1] - Open, price[2] - Close, price[3] - Low
*/
bool isBarUp(double &price[]) {
    return price[2] > price[1];
}

/**
@param : price : array of price. price[0] - High, price[1] - Open, price[2] - Close, price[3] - Low
@param : ratio : ratio between upperShadow, body, lowShadow. EX: 7
*/
bool isPinBar(double &price[], double bodyRatio, double shadowRatio, datetime date) {
    double high = price[0];
    double open = price[1];
    double close = price[2];
    double low = price[3];

    bool isBarUp = isBarUp(price);

    double upperShadow, lowerShadow, body;

    if(isBarUp){
        upperShadow = high - close;
        lowerShadow = open - low;
        body = close - open;
    }else{
        upperShadow = high - open;
        lowerShadow = close - low;
        body = open - close;
    }
    
     
    if (body == 0)
         body = 0.00000000001;
    if (upperShadow == 0)
         upperShadow = 0.00000000001;
    if (lowerShadow == 0)
         lowerShadow = 0.00000000001;
         
    Print(date, " high: ", high, " open: ", open, " close: ", close, " low: ", low, " upperShadow: ", upperShadow, " lowerShadow: ", lowerShadow, " body: ", body, 
    " upperShadow/lowerShadow: ", upperShadow/lowerShadow, " lowerShadow/upperShadow: ", lowerShadow/upperShadow, " lowerShadow/body: ", lowerShadow/body, " upperShadow/body: ", upperShadow/body );
    
    
    return (upperShadow / body >= bodyRatio && upperShadow / lowerShadow >= shadowRatio)
         || (lowerShadow / body >= bodyRatio && lowerShadow / upperShadow >= shadowRatio);
}


bool isInsideBar(double &previousPrice[], double &currentPrice[]){
   return previousPrice[0] >= currentPrice[0] && previousPrice[3]<= currentPrice[3];
}