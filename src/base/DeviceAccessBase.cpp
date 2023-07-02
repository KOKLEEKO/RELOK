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
    auto persistence = addManager(std::make_shared<PersistenceManagerBase>(parent));

    auto autoLock = addManager(std::make_shared<AutoLockManagerBase>(persistence, parent));
    auto battery = addManager(std::make_shared<BatteryManagerBase>(parent));
    auto clockLanguage = addManager(std::make_shared<ClockLanguageManagerBase>(parent));

    addManager(std::make_shared<AdvertisingManagerBase>(persistence, parent));
    addManager(std::make_shared<EnergySavingManagerBase>(autoLock, battery, persistence, parent));
    addManager(std::make_shared<ReviewManagerBase>(parent));
    addManager(std::make_shared<ScreenBrightnessManagerBase>(persistence, parent));
    addManager(std::make_shared<ScreenSizeManagerBase>(persistence, parent));
    addManager(std::make_shared<ShareContentManagerBase>(parent));
    addManager(std::make_shared<SpeechManagerBase>(clockLanguage, persistence, parent));
    addManager(std::make_shared<SplashScreenManagerBase>(parent));
    addManager(std::make_shared<TrackingManagerBase>(persistence, parent));
    addManager(std::make_shared<TranslationManagerBase>(persistence, parent));
}
