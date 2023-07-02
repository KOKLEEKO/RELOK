/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"
#include <PersistenceCapability.h>

class AutoLockManagerBase : public ManagerBase<AutoLockManagerBase>, public PersistenceCapability
{
    Q_OBJECT

    Q_PROPERTY(bool isAutoLockDisabled READ isAutoLockDisabled NOTIFY isAutoLockDisabledChanged)
    Q_PROPERTY(bool isAutoLockRequested READ isAutoLockRequested WRITE requestAutoLock NOTIFY isAutoLockRequestedChanged)

public:
    explicit AutoLockManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                 QObject *parent = nullptr);

    bool isAutoLockDisabled() const { return m_isAutoLockDisabled; }
    bool isAutoLockRequested() const { return m_isAutoLockRequested; }
    Q_INVOKABLE void requestAutoLock(bool isAutoLockRequested);

    Q_INVOKABLE virtual void security(bool /*value*/) {}
    virtual void disableAutoLock(bool /*disable*/) {}

signals:
    void isAutoLockDisabledChanged();
    void isAutoLockRequestedChanged();

private:
    bool m_isAutoLockDisabled = false;
    bool m_isAutoLockRequested = false;
};
