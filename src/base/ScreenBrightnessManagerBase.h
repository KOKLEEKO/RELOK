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

class ScreenBrightnessManagerBase : public ManagerBase<ScreenBrightnessManagerBase>, public PersistenceCapability
{
    Q_OBJECT

    Q_PROPERTY(float brightness MEMBER m_brightness NOTIFY brightnessChanged)
    Q_PROPERTY(float brightnessRequested WRITE setBrightnessRequested MEMBER m_brightnessRequested)

public:
    explicit ScreenBrightnessManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                         QObject *parent = nullptr);

    virtual void setBrightnessRequested(float /*brightness*/) {}
    void updateBrightness(float brightness);

signals:
    void brightnessChanged();

private:
    float m_brightness = .0;
    float m_brightnessRequested = .0;
};
