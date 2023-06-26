/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include <DeviceAccessBase.h>

DeviceAccessBase::DeviceAccessBase(QObject *parent)
    : QObject(parent)
{}

DeviceAccessBase &DeviceAccessBase::instance()
{
    static DeviceAccessBase deviceAccessBase;
    return deviceAccessBase;
}

bool DeviceAccessBase::isCompleted() const
{
    return m_isCompleted;
}

void DeviceAccessBase::complete()
{
    m_isCompleted = true;
}
