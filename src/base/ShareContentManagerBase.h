/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

#include <QQuickItem>
#include <QVariant>

class ShareContentManagerBase : public ManagerBase<ShareContentManagerBase>
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled CONSTANT)

public:
    explicit ShareContentManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    Q_INVOKABLE virtual void screenshot(QQuickItem * /*item*/) { Q_UNIMPLEMENTED(); }

protected:
    virtual void screenshotWithCallback(QQuickItem * /*item*/,
                                        const std::function<void(QImage)> & /*callback*/ = {})
    {}
};

#ifndef Q_OS_WIN
template<>
QString ManagerBase<ShareContentManagerBase>::m_name;
#endif
