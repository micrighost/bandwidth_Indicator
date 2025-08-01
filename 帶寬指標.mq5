//+------------------------------------------------------------------+
//|                                                     帶寬指標.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//指標說明:
//帶寬指標（Bandwidth）是布林通道的衍生技術指標，主要用於量化市場的波動性和預測價格變化
//當帶寬指標越小時，市場可能隨時會發生突破，且有較高的機率出現大行情
//
//帶寬指標的百分比計算方式:
//((布林通道的上軌值-布林通道的下軌值) / 布林通道的中軌值)*100 = 帶寬指標



double UpperBuffer2[];  //布林上軌
double LowerBuffer2[];  //布林下軌
double MiddleBuffer2[]; //布林中軌
double bandwidth = 0;           //帶寬指標的數值

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{

   //獲取布林通道的指標句柄，使用當前圖表和時間週期，計算20期的布林通道，標準差為2，使用開盤價
   int ib2 = iBands(NULL, PERIOD_CURRENT, 20, 0, 2, PRICE_OPEN);
   
   //從布林通道的中軌緩衝區複製數據到 MiddleBuffer2
   CopyBuffer(ib2, 0, 0, 1, MiddleBuffer2);
   
   //從布林通道的上軌緩衝區複製數據到 UpperBuffer2
   CopyBuffer(ib2, 1, 0, 1, UpperBuffer2);
   
   //從布林通道的下軌緩衝區複製數據到 LowerBuffer2
   CopyBuffer(ib2, 2, 0, 1, LowerBuffer2);
   
   //設定計時器，每60秒觸發一次 OnTimer() 事件
   EventSetTimer(60);
   
   // 返回初始化成功的狀態，讓 EA 繼續運行
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- destroy timer
   EventKillTimer();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{

   //獲取布林通道的指標句柄，使用當前圖表和時間週期，計算20期的布林通道，標準差為2，使用開盤價
   int ib2 = iBands(NULL, PERIOD_CURRENT, 20, 0, 2, PRICE_OPEN);
   
   //從布林通道的中軌緩衝區複製數據到 MiddleBuffer2
   CopyBuffer(ib2, 0, 0, 1, MiddleBuffer2);
   
   //從布林通道的上軌緩衝區複製數據到 UpperBuffer2
   CopyBuffer(ib2, 1, 0, 1, UpperBuffer2);
   
   //從布林通道的下軌緩衝區複製數據到 LowerBuffer2
   CopyBuffer(ib2, 2, 0, 1, LowerBuffer2);
   
   //計算上軌和下軌之間的差值，得到帶寬的上限
   double b_deviation = UpperBuffer2[0] - LowerBuffer2[0];
   
   //獲取布林通道的中軌值
   double b_mid = MiddleBuffer2[0];
   
   //確保不會除以零
   if (b_mid != 0)
   {
       //計算帶寬，將結果乘以100使帶寬指標的值轉換為百分比形式
       bandwidth = (b_deviation / b_mid) * 100;
   }
   else
   {
       //如果中軌為零，則將帶寬設為0，以避免除以零的錯誤
       bandwidth = 0; // 避免除以零
   }
   
   //輸出帶寬值，格式化為浮點數
   //在格式化字符串中，% 符號需要用 %% 來表示
   printf("Bandwidth: %f %%", bandwidth); 
}
