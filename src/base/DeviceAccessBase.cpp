/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "DeviceAccessBase.h"

#include "AdvertisingManagerBase.h"
#include "AutoLockManagerBase.h"
#include "BatteryManagerBase.h"
#include "ClockLanguageManagerBase.h"
#include "EnergySavingManagerBase.h"
#include "PersistenceManagerBase.h"
#include "ReviewManagerBase.h"
#include "ScreenBrightnessManagerBase.h"
#include "ScreenSizeManagerBase.h"
#include "ShareContentManagerBase.h"
#include "SpeechManagerBase.h"
#include "SplashScreenManagerBase.h"
#include "TrackingManagerBase.h"
#include "TranslationManagerBase.h"

DeviceAccessBase::DeviceAccessBase(QObject *parent)
    : QObject(parent)
{
    addManager(std::make_unique<PersistenceManagerBase>(this, parent));

    addManager(std::make_unique<AutoLockManagerBase>(this, parent));
    addManager(std::make_unique<BatteryManagerBase>(this, parent));
    addManager(std::make_unique<ClockLanguageManagerBase>(this, parent));

    addManager(std::make_unique<AdvertisingManagerBase>(this, parent));
    addManager(std::make_unique<EnergySavingManagerBase>(this, parent));
    addManager(std::make_unique<ReviewManagerBase>(this, parent));
    addManager(std::make_unique<ScreenBrightnessManagerBase>(this, parent));
    addManager(std::make_unique<ScreenSizeManagerBase>(this, parent));
    addManager(std::make_unique<ShareContentManagerBase>(this, parent));
    addManager(std::make_unique<SpeechManagerBase>(this, parent));
    addManager(std::make_unique<SplashScreenManagerBase>(this, parent));
    addManager(std::make_unique<TrackingManagerBase>(this, parent));
    addManager(std::make_unique<TranslationManagerBase>(this, parent));
}
