#include <ScreenSizeManager.h>

#include <emscripten/val.h>

ScreenSizeManager::ScreenSizeManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ScreenSizeManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void ScreenSizeManager::toggleFullScreen()
{
    using emscripten::val;
    const val document = val::global("document");
    const val fullscreenElement = document["fullscreenElement"];
    if (fullscreenElement.isUndefined() || fullscreenElement.isNull())
        document["documentElement"].call<void>("requestFullscreen");
    else
        document.call<void>("exitFullscreen");
}
