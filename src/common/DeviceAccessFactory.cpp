/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "DeviceAccessFactory.h"

#include <ClockLanguageManager.h>
#include <PersistenceManager.h>
#include <TranslationManager.h>

#ifndef Q_OS_WASM
//#include <ReviewManager.h>
#include <SpeechManager.h>
#endif

#ifdef Q_OS_ANDROID
#include <SplashScreenManager.h>
#endif

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
#include <AutoLockManager.h>
#include <ScreenBrightnessManager.h>
#include <ScreenSizeManager.h>
#include <ShareContentManager.h>
#include <SpeechManager.h>

#include "src/default/BatteryManager.h"
#include "src/default/EnergySavingManager.h"
#endif

#ifndef Q_OS_WEBOS
#include "src/default/ShareContentManager.h"
#endif

DeviceAccessFactory::DeviceAccessFactory() {}

DeviceAccess *DeviceAccessFactory::create()
{
    static DeviceAccess *deviceAccess = static_cast<DeviceAccess *>(DeviceAccess::instance());
    deviceAccess->addManager(std::make_shared<ClockLanguageManager>(deviceAccess));
    deviceAccess->addManager(std::make_shared<PersistenceManager>(deviceAccess));
    deviceAccess->addManager(std::make_shared<TranslationManager>(deviceAccess));

#ifndef Q_OS_WASM
    deviceAccess->addManager(std::make_shared<SpeechManager>(deviceAccess));
    //deviceAccess->addManager(std::make_shared<ReviewManager>(deviceAccess));
#endif

#ifdef Q_OS_ANDROID
    deviceAccess->addManager(std::make_shared<SplashScreenManager>(deviceAccess));
#endif

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    deviceAccess->addManager(std::make_shared<AutoLockManager>(deviceAccess));
    deviceAccess->addManager(std::make_shared<BatteryManager>(deviceAccess));
    deviceAccess->addManager(std::make_shared<EnergySavingManager>(deviceAccess));
    deviceAccess->addManager(std::make_shared<ScreenBrightnessManager>(deviceAccess));
    deviceAccess->addManager(std::make_shared<ScreenSizeManager>(deviceAccess));
    deviceAccess->addManager(std::make_shared<SpeechManager>(deviceAccess));
#endif

#ifndef Q_OS_WEBOS
    deviceAccess->addManager(std::make_shared<ShareContentManager>(deviceAccess));
#endif

    deviceAccess->specificInitializationSteps();

    return deviceAccess;
}
