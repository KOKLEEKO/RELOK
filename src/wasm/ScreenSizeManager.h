#pragma once

#include <ScreenSizeManagerBase.h>

class ScreenSizeManager : public ScreenSizeManagerBase
{
    Q_OBJECT
public:
    explicit ScreenSizeManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void toggleFullScreen() final override;
};

