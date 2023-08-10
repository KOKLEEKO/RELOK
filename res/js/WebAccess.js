/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
.import QtWebView 1.15 as QtWebView

.import DeviceAccess 1.0 as Global

var DeviceAccess = Global.DeviceAccess
var instance = null
var isDebug = undefined

class Object {
    constructor(_instance, _isDebug)
    {
        instance = _instance
        isDebug = _isDebug
    }

    openUrl(url, fromBack = false)
    {
        if (url !== instance.webView.base_url || (fromBack && url !== webView.url.toString()))
        {
            instance.webView.url = url
        }
        if (!fromBack)
        {
            instance.open()
            instance.webView.base_url = url
        }
    }

    loadingChanged(loadRequest)
    {
        instance.webView.status = loadRequest.status
        switch (instance.webView.status)
        {
        case QtWebView.WebView.LoadStartedStatus:
            instance.webView.title = qsTr("Loading...") + DeviceAccess.managers.translation.emptyString
            break;
        case QtWebView.WebView.LoadSucceededStatus:
            instance.webView.runJavaScript("document.title", (title) => instance.webView.title = title)
            break;
        case QtWebView.WebView.LoadFailedStatus:
            instance.webView.title = qsTr("Houston, we have a problem") + DeviceAccess.managers.translation.emptyString
            instance.webView.error_string = loadRequest.errorString
            break;
        }
    }
}
