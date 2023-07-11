#pragma once

#include <DeviceAccessBase.h>

class DeviceAccess : public DeviceAccessBase
{
    Q_OBJECT

public:
    explicit DeviceAccess(QObject *parent = nullptr);
};

