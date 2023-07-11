/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

#include <QVariantMap>

class ClockLanguageManagerBase : public ManagerBase<ClockLanguageManagerBase>
{
    Q_OBJECT

    Q_PROPERTY(QVariantMap clockAvailableLocales READ clockAvailableLocales CONSTANT)

    virtual void detectClockAvailableLocales() {}

public:
    ClockLanguageManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    QVariantMap clockAvailableLocales() const { return m_clockAvailableLocales; }

protected:
    QVariantMap m_clockAvailableLocales;
};

template<>
QString ManagerBase<ClockLanguageManagerBase>::m_name;
