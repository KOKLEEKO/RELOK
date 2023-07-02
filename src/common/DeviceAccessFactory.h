/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <memory.h>

#include <DeviceAccess.h>

class DeviceAccessFactory
{
public:
    DeviceAccessFactory();

    static DeviceAccess *create();
};
