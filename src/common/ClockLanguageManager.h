/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <ClockLanguageManagerBase.h>

class ClockLanguageManager : public ClockLanguageManagerBase
{
    Q_OBJECT

public:
    explicit ClockLanguageManager(QObject *parent = nullptr);

    void detectClockAvailableLocales() override final;
};

