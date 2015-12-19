//+------------------------------------------------------------------+
//|                                                ZuluTradeTest.mq5 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs

input string zulutrade_account;
input string zulutrade_password;
#include <ZuluTradeAPI.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   ZuluTradeAPIResponse response;
   ZuluTradeAPI ztapi(zulutrade_account,zulutrade_password);
   
   ZuluTradeAPIRequest req_open_market2(ZT_OPEN_PENDING);
   req_open_market2.SetAttribute(ZT_CURRENCY_NAME,"EURUSD");
   req_open_market2.SetAttribute(ZT_BUY,true);
   req_open_market2.SetAttribute(ZT_LOTS,0.1);
   req_open_market2.SetAttribute(ZT_REQUESTED_PRICE,2.5);
   // req_open_market.SetAttribute(ZT_UNIQUE_ID,TimeToString(TimeCurrent(),TIME_SECONDS));
   ztapi.SendRequest(req_open_market2,response);
   string dresponse;
   response.GetPayload().Serialize(dresponse);
   Print(dresponse);
   
   ZuluTradeAPIRequest req_open_market(ZT_UPDATE_TRAILING_STOP);
   req_open_market.SetAttribute(ZT_CURRENCY_NAME,"EURUSD");
   req_open_market.SetAttribute(ZT_BUY,true);
   req_open_market.SetAttribute(ZT_LOTS,0.1);
   req_open_market.SetAttribute(ZT_REQUESTED_PRICE,1.2);
   // req_open_market.SetAttribute(ZT_UNIQUE_ID,TimeToString(TimeCurrent(),TIME_SECONDS));
   req_open_market.SetAttribute(ZT_PROVIDER_TICKET ,"1512203.");
   req_open_market.SetAttribute(ZT_BROKER_TICKET,"4139460");
   req_open_market.SetAttribute(ZT_ENTRY_VALUE,2.8);
   req_open_market.SetAttribute(ZT_TRAILING_STOP_VALUE,50);
   req_open_market.SetAttribute(ZT_START_DATE,TimeCurrent());
   ztapi.SendRequest(req_open_market,response);
   response.GetPayload().Serialize(dresponse);
   Print(dresponse);   
  }
//+------------------------------------------------------------------+
