/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/

#include <ScreenSizeManager.h>

#include <emscripten.h>

#include <QGuiApplication>
#include <QQmlApplicationEngine>

extern "C" {
EMSCRIPTEN_KEEPALIVE
void updateIsFullScreen(bool isFullScreen)
{
    static_cast<ScreenSizeManager *>(DeviceAccessBase::instance()->manager<ScreenSizeManagerBase>())
        ->updateIsFullScreen(isFullScreen);
}
}

ScreenSizeManager::ScreenSizeManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ScreenSizeManagerBase{deviceAccess, parent}
{
    m_enabled = EM_ASM_INT({ return document.fullscreenEnabled; });
}

void ScreenSizeManager::updateIsFullScreen(bool isFullScreen)
{
    if (m_isFullScreen == isFullScreen)
        return;
    m_isFullScreen = isFullScreen;
    emit isFullScreenChanged();
}

/* clang-format off */
EM_JS(void, toggleFullScreenCallBack, (),
{
    Module._updateIsFullScreen(document.fullscreenElement !== null);
});
/* clang-format on */

void ScreenSizeManager::toggleFullScreen()
{
    /* clang-format off */
    EM_ASM({
        if (document.fullscreenElement)
            document.exitFullscreen().then(toggleFullScreenCallBack);
        else
            document.documentElement.requestFullscreen().then(toggleFullScreenCallBack);
    });
    /* clang-format on */
}
