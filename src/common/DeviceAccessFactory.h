#pragma once

#include <memory.h>

#include <DeviceAccess.h>

class DeviceAccessFactory
{
public:
    DeviceAccessFactory();

    static DeviceAccess *create();
};
