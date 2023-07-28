#pragma once

#include <EnergySavingManagerBase.h>

class EnergySavingManager : public EnergySavingManagerBase
{
    Q_OBJECT

public:
    EnergySavingManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

public:
    void batterySaving() final override;

signals:
    void disableAutoLock(bool disable);
};

