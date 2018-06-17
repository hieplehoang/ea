//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MyPoint(){
   double CalcPoint=0;

   if(_Digits==2 || _Digits==3) CalcPoint=0.01;
   else if(_Digits==4 || _Digits==5) CalcPoint=0.0001;

   return(CalcPoint);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MySlippage( int slippage ) {
   int CalcSlippage=0;

   if(_Digits==2 || _Digits==4) CalcSlippage=slippage;
   else if(_Digits==3 || _Digits==5) CalcSlippage=slippage*10;

   return(CalcSlippage);
}