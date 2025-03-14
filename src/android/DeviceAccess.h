/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <DeviceAccessBase.h>

class DeviceAccess : public DeviceAccessBase
{
    Q_OBJECT

public:
    DeviceAccess() = delete;

    void specificInitializationSteps() final override;

    Q_INVOKABLE void moveTaskToBack();
};
