/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

class SplashScreenManagerBase : public ManagerBase<SplashScreenManagerBase>
{
    Q_OBJECT

public:
    SplashScreenManagerBase(QObject *parent = nullptr);

    Q_INVOKABLE virtual void hideSplashScreen() {}
};
