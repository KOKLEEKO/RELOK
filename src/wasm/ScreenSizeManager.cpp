/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include <ScreenSizeManager.h>

#include <emscripten.h>

ScreenSizeManager::ScreenSizeManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ScreenSizeManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void ScreenSizeManager::toggleFullScreen()
{
    /* clang-format off */
    EM_ASM({
        if (document.fullscreenElement)
            document.exitFullscreen();
        else
            document.documentElement.requestFullscreen();
    });
    /* clang-format off */
}
