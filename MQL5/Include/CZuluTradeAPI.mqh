//+------------------------------------------------------------------+
//|                                                 CZuluTradeAPI.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Base64.mqh>
#include <jason.mqh>
//+------------------------------------------------------------------+
//| Macros and constants                                             |
//+------------------------------------------------------------------+
#define ZT_STABLE_BASE_URL "http://tradingserver.zulutrade.com/"
#define ZT_BETA_BASE_URL "http://tradingserver-beta.zulutrade.com/"
#define ZT_TRADING_CONFIGURATION_URL "getTradingConfiguration"
#define MIN_AMOUNT "minAmount"
#define MIN_AMOUNT_STEP "minAmountStep"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ZT_String_Properties 
  {
   ZT_CURRENCY_NAME,
   ZT_UNIQUE_ID,
   ZT_PROVIDER_TICKET,
   ZT_BROKER_TICKET,
   ZT_START_DATE,
   ZT_END_DATE
  };

static string string_properties[6];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ZT_Double_Properties 
  {
   ZT_LOTS,
   ZT_REQUESTED_PRICE,
   ZT_STOP_VALUE,
   ZT_LIMIT_VALUE,
   ZT_ENTRY_VALUE
  };

static string double_properties[5];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ZT_Bool_Properties 
  {
   ZT_BUY
  };

static string bool_properties[1];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ZT_Int_Properties 
  {
   ZT_TRAILING_STOP_VALUE,
   ZT_TRAILING_STOP_CONDITIONAL_VALUE
  };

static string int_properties[2];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ZTOperations 
  {
   ZT_OPEN_MARKET,
   ZT_OPEN_PENDING,
   ZT_CLOSE_MARKET,
   ZT_CLOSE_PENDING,
   ZT_UPDATE_STOP,
   ZT_UPDATE_LIMIT,
   ZT_UPDATE_ENTRY,
   ZT_UPDATE_TRAILING_STOP,
   ZT_UPDATE_CONDITIONAL_STOP,
   ZT_GET_OPEN_TRADES,
   ZT_GET_HISTORIC_TRADES_ORDERS,
   ZT_GET_PROVIDER_STATISTICS,
   ZT_GET_TRADING_CONFIGURATION
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CZuluTradeAPIRequest
  {
private:
   int               int_attributes[2];
   double            double_attributes[5];
   string            string_attributes[6];
   bool              bool_attributes[1];
   ZTOperations      operation;
   string            GetRequestBaseURL() const;
   string            BuildURLParams() const;
   string            FixSlashForCurrencyPair(string value);
   string            ParseDate(datetime value);
public:

                     CZuluTradeAPIRequest(ZTOperations op);
                    ~CZuluTradeAPIRequest();
   string            GetRequestURL() const;
   void              SetAttribute(ZT_Double_Properties index,double value);
   double            GetAttribute(ZT_Double_Properties index);
   void              SetAttribute(ZT_String_Properties index,string value);
   void              SetAttribute(ZT_String_Properties index,datetime value);
   string            GetAttribute(ZT_String_Properties index);
   void              SetAttribute(ZT_Bool_Properties index,bool value);
   bool              GetAttribute(ZT_Bool_Properties index);
   void              SetAttribute(ZT_Int_Properties index,int value);
   int               GetAttribute(ZT_Int_Properties index);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIRequest::CZuluTradeAPIRequest(ZTOperations op) 
  {
   this.operation=op;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIRequest::~CZuluTradeAPIRequest() 
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPIRequest::FixSlashForCurrencyPair(string value) 
  {
   string first_pair=StringSubstr(value,0,3);
   string second_pair=StringSubstr(value,3,3);
   return first_pair + "/" + second_pair;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIRequest::SetAttribute(ZT_String_Properties index,string value) 
  {
// Fix the slash for CZuluTrade
   value=index==ZT_CURRENCY_NAME ? FixSlashForCurrencyPair(value) : value;
   string_attributes[index]=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPIRequest::ParseDate(datetime value) 
  {
   MqlDateTime dt_struct;
   TimeToStruct(value,dt_struct);
   return IntegerToString(dt_struct.year) + "-" + IntegerToString(dt_struct.mon) + "-" + IntegerToString(dt_struct.day);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIRequest::SetAttribute(ZT_String_Properties index,datetime value) 
  {
   string_attributes[index]=ParseDate(value);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPIRequest::GetAttribute(ZT_String_Properties index) 
  {
   return string_attributes[index];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIRequest::SetAttribute(ZT_Bool_Properties index,bool value) 
  {
   bool_attributes[index]=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CZuluTradeAPIRequest::GetAttribute(ZT_Int_Properties index) 
  {
   return int_attributes[index];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIRequest::SetAttribute(ZT_Int_Properties index,int value) 
  {
   int_attributes[index]=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CZuluTradeAPIRequest::GetAttribute(ZT_Bool_Properties index) 
  {
   return bool_attributes[index];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIRequest::SetAttribute(ZT_Double_Properties index,double value) 
  {
   double_attributes[index]=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CZuluTradeAPIRequest::GetAttribute(ZT_Double_Properties index) 
  {
   return double_attributes[index];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPIRequest::GetRequestBaseURL() const 
  {
   switch(operation) 
     {
      case ZT_OPEN_MARKET:
         return "/open/market/";
      case ZT_OPEN_PENDING:
         return "/open/pending/";
      case ZT_CLOSE_MARKET:
         return "/close/market/";
      case ZT_CLOSE_PENDING:
         return "/close/pending/";
      case ZT_UPDATE_STOP:
         return "/update/stop/";
      case ZT_UPDATE_LIMIT:
         return "/update/limit/";
      case ZT_UPDATE_ENTRY:
         return "/update/entry/";
      case ZT_UPDATE_TRAILING_STOP:
         return "/update/stop/trailing/";
      case ZT_UPDATE_CONDITIONAL_STOP:
         return "/update/stop/trailingCondition/";
      case ZT_GET_OPEN_TRADES:
         return "/getOpen/";
      case ZT_GET_HISTORIC_TRADES_ORDERS:
         return "/getHistory/";
      case ZT_GET_PROVIDER_STATISTICS:
         return "/getProviderStatistics/";
      case ZT_GET_TRADING_CONFIGURATION:
         return "/getTradingConfiguration/";
      default:
         return "";
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPIRequest::BuildURLParams(void) const 
  {
   string to_return="?";
   for(int i=0; i<ArraySize(string_attributes); i++) 
     {
      to_return+=CZuluTradeAPI::GetPropertyLabel((ZT_String_Properties)i)+"="+string_attributes[i]+"&";
     }
   for(int i=0; i<ArraySize(bool_attributes); i++) 
     {
      to_return+=CZuluTradeAPI::GetPropertyLabel((ZT_Bool_Properties)i)+"="+((bool_attributes[i]) ? "true" : "false")+"&";
     }
   for(int i=0; i<ArraySize(double_attributes); i++) 
     {
      to_return+=CZuluTradeAPI::GetPropertyLabel((ZT_Double_Properties)i)+"="+DoubleToString(double_attributes[i])+"&";
     }
   for(int i=0; i<ArraySize(int_attributes); i++) 
     {
      to_return+=CZuluTradeAPI::GetPropertyLabel((ZT_Int_Properties)i)+"="+DoubleToString(int_attributes[i])+"&";
     }
   return to_return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPIRequest::GetRequestURL(void) const 
  {
   return GetRequestBaseURL() + BuildURLParams();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CZuluTradeAPIResponse
  {
private:
   CJAVal            payload;
   int               status_code;
public:
                     CZuluTradeAPIResponse();
                     CZuluTradeAPIResponse(CJAVal &res,int status_code=0);
                    ~CZuluTradeAPIResponse();
   CJAVal            GetPayload();
   void              SetPayload(CJAVal &res);
   int               GetStatusCode();
   void              SetStatusCode(int code);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIResponse::CZuluTradeAPIResponse() 
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIResponse::~CZuluTradeAPIResponse() 
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIResponse::CZuluTradeAPIResponse(CJAVal &res,int code=0) 
  {
   this.status_code=code;
   this.payload=res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CJAVal CZuluTradeAPIResponse::GetPayload(void) 
  {
   return payload;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CZuluTradeAPIResponse::GetStatusCode(void) 
  {
   return status_code;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIResponse::SetPayload(CJAVal &res) 
  {
   payload=res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPIResponse::SetStatusCode(int code) 
  {
   status_code=code;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CZuluTradeAPI
  {
private:
   bool              m_beta;
   string            m_auth_header;
   double            m_min_amount;
   double            m_min_amount_step;
   string            GetDefaultHTTPHeaders();
   string            GetTradingConfigurationURL(void);
   string            GetBaseURL(void);

public:
                     CZuluTradeAPI(string account,string password,bool beta_in=false);
                    ~CZuluTradeAPI();
   static string     GetPropertyLabel(ZT_String_Properties property);
   static string     GetPropertyLabel(ZT_Double_Properties property);
   static string     GetPropertyLabel(ZT_Bool_Properties property);
   static string     GetPropertyLabel(ZT_Int_Properties property);
   void              SendRequest(const CZuluTradeAPIRequest &request,CZuluTradeAPIResponse &response);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPI::CZuluTradeAPI(string account,string password,bool beta_in=false)
  {
   string_properties[ZT_CURRENCY_NAME]="currencyName";
   string_properties[ZT_UNIQUE_ID]="uniqueId";
   string_properties[ZT_BROKER_TICKET]="brokerTicket";
   string_properties[ZT_PROVIDER_TICKET]="providerTicket";
   string_properties[ZT_START_DATE]="startDate";
   string_properties[ZT_END_DATE]="endDate";

   double_properties[ZT_LOTS]="lots";
   double_properties[ZT_REQUESTED_PRICE]="requestedPrice";
   double_properties[ZT_STOP_VALUE]="stopValue";
   double_properties[ZT_LIMIT_VALUE]="limitValue";

   bool_properties[ZT_BUY]="buy";

   int_properties[ZT_TRAILING_STOP_VALUE]="trailingStopValue";
   int_properties[ZT_TRAILING_STOP_CONDITIONAL_VALUE]="trailingStopConditionPipsValue";

   m_auth_header="Authorization: Basic "+Base64Encode(account+":"+password);
   m_beta=beta_in;
   int response_code;
   char data[],result[];
   string headers;
   response_code=WebRequest(
                            "GET",
                            GetTradingConfigurationURL(),
                            GetDefaultHTTPHeaders(),
                            5000,
                            data,
                            result,
                            headers
                            );
   CJAVal response_json;
   response_json.Deserialize(CharArrayToString(result));
   m_min_amount=response_json[MIN_AMOUNT].ToDbl();
   m_min_amount_step=response_json[MIN_AMOUNT_STEP].ToDbl();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CZuluTradeAPI::~CZuluTradeAPI()
  {
  }
//+------------------------------------------------------------------+
string CZuluTradeAPI::GetBaseURL(void) 
  {
   return m_beta ? ZT_BETA_BASE_URL : ZT_STABLE_BASE_URL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPI::GetTradingConfigurationURL(void) 
  {
   return GetBaseURL() + ZT_TRADING_CONFIGURATION_URL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPI::GetDefaultHTTPHeaders(void) 
  {
   return "Content-Type: application/json\r\n" + m_auth_header;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPI::GetPropertyLabel(ZT_String_Properties property) 
  {
   return string_properties[property];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPI::GetPropertyLabel(ZT_Int_Properties property) 
  {
   return int_properties[property];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPI::GetPropertyLabel(ZT_Bool_Properties property) 
  {
   return bool_properties[property];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CZuluTradeAPI::GetPropertyLabel(ZT_Double_Properties property) 
  {
   return double_properties[property];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CZuluTradeAPI::SendRequest(const CZuluTradeAPIRequest &request,CZuluTradeAPIResponse &response) 
  {
   int response_code;
   char data[],result[];
   string headers;
   Print(GetBaseURL()+request.GetRequestURL());
   response_code=WebRequest(
                            "GET",
                            GetBaseURL()+request.GetRequestURL(),
                            GetDefaultHTTPHeaders(),
                            5000,
                            data,
                            result,
                            headers
                            );
   CJAVal response_json;
   response_json.Deserialize(CharArrayToString(result));
   Print(CharArrayToString(result));
   response.SetPayload(response_json);
   response.SetStatusCode(response_code);
  } 
//+------------------------------------------------------------------+
