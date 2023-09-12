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
#include <SpeechManager.h>
#endif

#ifdef Q_OS_ANDROID
#include <SplashScreenManager.h>
#endif

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_MACOS) || defined(Q_OS_WASM)
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_MACOS)
#include <ReviewManager.h>
#include <ShareContentManager.h>
#endif
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_WASM)
#include "src/default/BatteryManager.h"
#include <AutoLockManager.h>
#include <ScreenSizeManager.h>
#endif
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
#include "src/default/EnergySavingManager.h"
#include <ScreenBrightnessManager.h>
#include <SpeechManager.h>
#endif
#ifdef Q_OS_WASM
#include "src/default/ShareContentManager.h"
#endif
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
#endif

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_MACOS) || defined(Q_OS_WASM)
    deviceAccess->addManager(std::make_shared<ShareContentManager>(deviceAccess));
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_MACOS)
    deviceAccess->addManager(std::make_shared<ReviewManager>(deviceAccess));
#endif
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_WASM)
    deviceAccess->addManager(std::make_shared<AutoLockManager>(deviceAccess));
    deviceAccess->addManager(std::make_shared<BatteryManager>(deviceAccess));
    deviceAccess->addManager(std::make_shared<ScreenSizeManager>(deviceAccess));
#endif
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    deviceAccess->addManager(std::make_shared<EnergySavingManager>(deviceAccess));
    deviceAccess->addManager(std::make_shared<ScreenBrightnessManager>(deviceAccess));
    deviceAccess->addManager(std::make_shared<SpeechManager>(deviceAccess));
#ifdef Q_OS_ANDROID
    deviceAccess->addManager(std::make_shared<SplashScreenManager>(deviceAccess));
#endif
#endif
#endif

    deviceAccess->specificInitializationSteps();

    return deviceAccess;
}
