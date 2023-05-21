function getTokenFromNative(token) {
    window.getTokenCallback({access_token: token, expires_in: 900})
}

function initOnReady() {
    var datafeed = new Datafeeds.Test();
    var widget = window.tvWidget = new TradingView.widget({
        debug: true,
        fullscreen: true,
        symbol: 'probit:BTC/USDT',
        interval: '1D',
        container: "tv_chart_container",
        datafeed: datafeed,
        library_path: "charting_library/",
    });

    window.addEventListener('DOMContentLoaded', initOnReady, false);
};



function onData(key, data) {
    datafeed.onDataxxx(key, data);
}
