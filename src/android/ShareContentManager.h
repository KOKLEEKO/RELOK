/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "src/default/ShareContentManager.h"

class ShareContentManager : public Default::ShareContentManager
{

public:
    explicit ShareContentManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void screenshot(QQuickItem *item) final override;
};
