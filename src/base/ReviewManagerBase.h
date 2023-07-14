/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

class ReviewManagerBase : public ManagerBase<ReviewManagerBase>
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled CONSTANT)

public:
    explicit ReviewManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    Q_INVOKABLE virtual void requestReview() {}
};

#ifndef Q_OS_WIN
template<>
QString ManagerBase<ReviewManagerBase>::m_name;
#endif
