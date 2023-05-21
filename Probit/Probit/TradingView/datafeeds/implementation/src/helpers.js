export function parseFullSymbol(fullSymbol) {
  const match = fullSymbol.match(/^(\w+):(\w+)\/(\w+)$/);
  if (!match) {
    return null;
  }

  return { exchange: match[1], fromSymbol: match[2], toSymbol: match[3] };
}

export function generateSymbol(exchange, fromSymbol, toSymbol) {
  const short = `${fromSymbol}/${toSymbol}`;
  return {
    short,
    full: `${exchange}:${short}`,
  };
}

export function countDecimals(price = "0.001") {
  const priceSplit = price.split(".");
  if (priceSplit.length === 1) {
    return 0;
  }
  return priceSplit[1].length;
}
