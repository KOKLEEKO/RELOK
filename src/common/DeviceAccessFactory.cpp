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
#if __has_include(<SpeechManager.h>)
#include <SpeechManager.h>
#else
#include "src/default/SpeechManager.h"
#endif
#include <TranslationManager.h>

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
#include "src/default/EnergySavingManager.h"
#include <AutoLockManager.h>
#include <ScreenSizeManager.h>
#endif
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
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
    deviceAccess->addManager(std::make_unique<ClockLanguageManager>(deviceAccess));
    deviceAccess->addManager(std::make_unique<PersistenceManager>(deviceAccess));
    deviceAccess->addManager(std::make_unique<SpeechManager>(deviceAccess));
    deviceAccess->addManager(std::make_unique<TranslationManager>(deviceAccess));

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_MACOS) || defined(Q_OS_WASM)
    deviceAccess->addManager(std::make_unique<ShareContentManager>(deviceAccess));
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_MACOS)
    deviceAccess->addManager(std::make_unique<ReviewManager>(deviceAccess));
#endif
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_WASM)
    deviceAccess->addManager(std::make_unique<AutoLockManager>(deviceAccess));
    deviceAccess->addManager(std::make_unique<BatteryManager>(deviceAccess));
    deviceAccess->addManager(std::make_unique<EnergySavingManager>(deviceAccess));
    deviceAccess->addManager(std::make_unique<ScreenSizeManager>(deviceAccess));
#endif
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    deviceAccess->addManager(std::make_unique<ScreenBrightnessManager>(deviceAccess));
    deviceAccess->addManager(std::make_unique<SpeechManager>(deviceAccess));
#ifdef Q_OS_ANDROID
    deviceAccess->addManager(std::make_unique<SplashScreenManager>(deviceAccess));
#endif
#endif
#endif

    deviceAccess->specificInitializationSteps();

    return deviceAccess;
}
