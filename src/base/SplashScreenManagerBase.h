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

    Q_PROPERTY(bool enabled READ enabled CONSTANT)
    Q_PROPERTY(bool isActive MEMBER m_isActive NOTIFY isActiveChanged)

public:
    explicit SplashScreenManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    Q_INVOKABLE virtual void hideSplashScreen()
    {
        m_isActive = false;
        emit isActiveChanged();
    }

signals:
    void isActiveChanged();

protected:
    bool m_isActive = false;
};

#ifndef Q_OS_WIN
template<>
QString ManagerBase<SplashScreenManagerBase>::m_name;
#endif
