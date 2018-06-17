//+------------------------------------------------------------------+
//|                                             common-bars-TEST.mq4 |
//|                                                            hle56 |
//|                                                     facebook.com |
//+------------------------------------------------------------------+
#property copyright "hle56"
#property link      "facebook.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include <UnitTest.mqh>
#include ".\common-bars.mq4"

UnitTest* unittest;

void OnStart() {
      unittest = new UnitTest();
      runAllTests();
      Print("---- all test run success -----");
  }
//+------------------------------------------------------------------+

void runAllTests() {
    isBarUpTest ();
}

void isBarUpTest () {
    unittest.addTest(__FUNCTION__);

    double price1[] = {0, 1.2005, 1.2006, 0}; // [high, open, close, low]
    bool actualRes1 = isBarUp(price1);
    bool expectedRes1 = true; // up bar

    unittest.assertEquals(__FUNCTION__, "Bar must be bar up", expectedRes1, actualRes1);

    double price2[] = {0, 1.2006, 1.2005, 0}; // [high, open, close, low]
    bool actualRes2 = isBarUp(price2);
    bool expectedRes2 = false; // down bar

    unittest.assertEquals(__FUNCTION__, "Bar must be bar down", expectedRes2, actualRes2);
}