#pragma once

#include <DeviceAccessBase.h>

class DeviceAccess : public DeviceAccessBase
{
    Q_OBJECT

public:
    DeviceAccess() = delete;

    void specificInitializationSteps() final override;
};

