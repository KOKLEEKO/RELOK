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
    addManager(std::make_shared<PersistenceManagerBase>(this, parent));

    addManager(std::make_shared<AutoLockManagerBase>(this, parent));
    addManager(std::make_shared<BatteryManagerBase>(this, parent));
    addManager(std::make_shared<ClockLanguageManagerBase>(this, parent));

    addManager(std::make_shared<AdvertisingManagerBase>(this, parent));
    addManager(std::make_shared<EnergySavingManagerBase>(this, parent));
    addManager(std::make_shared<ReviewManagerBase>(this, parent));
    addManager(std::make_shared<ScreenBrightnessManagerBase>(this, parent));
    addManager(std::make_shared<ScreenSizeManagerBase>(this, parent));
    addManager(std::make_shared<ShareContentManagerBase>(this, parent));
    addManager(std::make_shared<SpeechManagerBase>(this, parent));
    addManager(std::make_shared<SplashScreenManagerBase>(this, parent));
    addManager(std::make_shared<TrackingManagerBase>(this, parent));
    addManager(std::make_shared<TranslationManagerBase>(this, parent));
}
