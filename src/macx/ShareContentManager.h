#pragma once

#include "src/default/ShareContentManager.h"

class ShareContentManager : public Default::ShareContentManager
{
    Q_OBJECT

public:
    explicit ShareContentManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void screenshot(QQuickItem *item) final override;
};
