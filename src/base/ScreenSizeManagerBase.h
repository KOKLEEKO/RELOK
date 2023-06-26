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

class ScreenSizeManagerBase : public ManagerBase<ScreenSizeManagerBase>, public PersistenceCapability
{
    Q_OBJECT
    Q_PROPERTY(bool prefersStatusBarHidden MEMBER m_prefersStatusBarHidden NOTIFY prefersStatusBarHiddenChanged)
    Q_PROPERTY(float navigationBarHeight MEMBER m_navigationBarHeight NOTIFY safeInsetsChanged)
    Q_PROPERTY(float safeInsetBottom MEMBER m_safeInsetBottom NOTIFY safeInsetsChanged)
    Q_PROPERTY(float safeInsetLeft MEMBER m_safeInsetLeft NOTIFY safeInsetsChanged)
    Q_PROPERTY(float safeInsetRight MEMBER m_safeInsetRight NOTIFY safeInsetsChanged)
    Q_PROPERTY(float safeInsetTop MEMBER m_safeInsetTop NOTIFY safeInsetsChanged)
    Q_PROPERTY(float statusBarHeight MEMBER m_statusBarHeight NOTIFY safeInsetsChanged)

public:
    ScreenSizeManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager, QObject *parent = nullptr);

    virtual void updateSafeAreaInsets();

signals:
    void prefersStatusBarHiddenChanged();
    void safeInsetsChanged();

private:
    bool m_prefersStatusBarHidden = false;
    float m_navigationBarHeight = .0;
    float m_safeInsetBottom = .0;
    float m_safeInsetLeft = .0;
    float m_safeInsetRight = .0;
    float m_safeInsetTop = .0;
    float m_statusBarHeight = .0;
};
