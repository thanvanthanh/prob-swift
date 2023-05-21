(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.Helpers = {}));
}(this, (function (exports) { 'use strict';

  function parseFullSymbol(fullSymbol) {
    const match = fullSymbol.match(/^(\w+):(\w+)\/(\w+)$/);
    if (!match) {
      return null;
    }

    return { exchange: match[1], fromSymbol: match[2], toSymbol: match[3] };
  }

  function generateSymbol(exchange, fromSymbol, toSymbol) {
    const short = `${fromSymbol}/${toSymbol}`;
    return {
      short,
      full: `${exchange}:${short}`,
    };
  }

  function countDecimals(price = "0.001") {
    const priceSplit = price.split(".");
    if (priceSplit.length === 1) {
      return 0;
    }
    return priceSplit[1].length;
  }

  exports.countDecimals = countDecimals;
  exports.generateSymbol = generateSymbol;
  exports.parseFullSymbol = parseFullSymbol;

  Object.defineProperty(exports, '__esModule', { value: true });

})));
