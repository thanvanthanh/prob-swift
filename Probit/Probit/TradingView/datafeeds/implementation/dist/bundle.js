(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.Datafeeds = {}));
}(this, (function (exports) { 'use strict';

  const lastBarsCache = new Map();

  const configurationData = {
    supported_resolutions: [
      "1",
      "3",
      "5",
      "10",
      "15",
      "30",
      "60",
      "240",
      "360",
      "720",
      "1D",
      "1W",
      "1M",
    ],
    exchanges: [
      {
        value: "probit",
        name: "probit",
        desc: "probit",
      },
    ],
    symbols_types: [
      {
        name: "crypto",
        value: "crypto",
      },
    ],
    intraday_multipliers: [
      "1",
      "3",
      "5",
      "10",
      "15",
      "30",
      "60",
      "240",
      "360",
      "720",
    ],
  };

  class ApiAndSocketCompatible {
    constructor(args) {
      this.pendingPromises = [];
      this.onRealtimeCallback = () => {};
      this.onResetCacheNeededCallback = () => {};
    }

    onDataReceived = async (key, data) => {
      const { resolve } = this.pendingPromises.find(
        (promise) => promise.key === key
      );
      resolve(data);
    };

    onSocketData = async (data) => {
      if (data !== null && typeof data !== "object") {
        data = JSON.parse(data);
        const item = data[0];
        callback(item);
      }
    };

    onReady = (callback) => {
      console.log("[onReady]: Method call");
      setTimeout(() => callback(configurationData));
    };

    getBars = async (
      symbolInfo,
      resolution,
      periodParams,
      onHistoryCallback,
      onErrorCallback
    ) => {
      const { from, to, firstDataRequest } = periodParams;
      let bars = [];
      let meta = {
        noData: false
      };
      let response = {};
      try {
        response = await new Promise((resolve, reject) => {
          const key = Math.random().toString() + new Date().getTime().toString();
          // const paramFrom = new Date(from * 1000).toISOString();
          // const paramTo = new Date(to * 1000).toISOString();
          this.pendingPromises.push({
            resolve,
            reject,
            timeout: Date.now(),
            key: key,
          });

          const param = `${key}~${from}~${to}~${resolution}`;
          window.webkit.messageHandlers.ios.postMessage(param);
        });

        if (typeof response !== "object") {
          response = JSON.parse(response);
        }

        if (response.s !== "ok" && response.s !== "no_data") {
          reject(response.errmsg);
          return;
        }

        if (response.s === "no_data") {
          meta.noData = true;
          meta.nextTime = response.nextTime;
        } else {
          const volumePresent = response.v !== undefined;
          const ohlPresent = response.o !== undefined;
          for (let i = 0; i < response.t.length; ++i) {
            const barValue = {
              time: response.t[i] * 1000,
              close: parseFloat(response.c[i]),
              open: parseFloat(response.c[i]),
              high: parseFloat(response.c[i]),
              low: parseFloat(response.c[i]),
            };
            if (ohlPresent) {
              barValue.open = parseFloat(response.o[i]);
              barValue.high = parseFloat(response.h[i]);
              barValue.low = parseFloat(response.l[i]);
            }
            if (volumePresent) {
              barValue.volume = parseFloat(response.v[i]);
            }
            bars.push(barValue);
          }
        }

        if (firstDataRequest) {
          lastBarsCache.set(symbolInfo.full_name, {
            ...bars[bars.length - 1],
          });
        }
        onHistoryCallback(bars, meta);
      } catch (error) {
        console.log("[getBars]: Get error", error);
        onErrorCallback(error);
      }
    };

    resolveSymbol = async (symbolName, onSymbolResolvedCallback) => {
      const symbol = symbolName;
      const symbolInfo = {
        ticker: symbol,
        name: symbol,
        description: symbol,
        pricescale: 10000000000000,
        volume_precision: 1,
        minmov: 25,
        exchange: "",
        full_name: "",
        listed_exchange: "",
        session: "24x7",
        has_intraday: true,
        has_daily: true,
        has_weekly_and_monthly: true,
        timezone: "Asia/Ho_Chi_Minh",
        type: "bitcoin",
        supported_resolutions: configurationData.supported_resolutions,
        intraday_multipliers: configurationData.intraday_multipliers,
      };

      await onSymbolResolvedCallback(symbolInfo);
    };

    subscribeBars = async (
      symbolInfo,
      resolution,
      onRealtimeCallback,
      subscribeUID,
      onResetCacheNeededCallback
    ) => {
      this.onRealtimeCallback = onRealtimeCallback;
      this.onResetCacheNeededCallback = onResetCacheNeededCallback;
    };

    unsubscribeBars = async (subscribeUID) => {
      console.log("unsubscribeBars, UID = ", subscribeUID);
    };
  }

  exports.ApiAndSocketCompatible = ApiAndSocketCompatible;

  Object.defineProperty(exports, '__esModule', { value: true });

})));
