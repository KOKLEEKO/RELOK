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
#ifndef Q_OS_WASM
#include <SpeechManager.h>
#endif
#include <TranslationManager.h>

#ifdef Q_OS_ANDROID
#include <SplashScreenManager.h>
#endif

DeviceAccessFactory::DeviceAccessFactory() {}

DeviceAccess *DeviceAccessFactory::create()
{
    DeviceAccess *m_deviceAccess = DeviceAccess::instance<DeviceAccess>();

    auto clockLanguage = m_deviceAccess->addManager(std::make_shared<ClockLanguageManager>());
    auto persistence = m_deviceAccess->addManager(std::make_shared<PersistenceManager>());
#ifndef Q_OS_WASM
    m_deviceAccess->addManager(std::make_shared<SpeechManager>(clockLanguage, persistence));
#endif
    m_deviceAccess->addManager(std::make_shared<TranslationManager>(persistence));
#ifdef Q_OS_ANDROID
    m_deviceAccess->addManager(m_splashScreenManager = std::make_shared<SplashScreenManager>(););
#endif

    return m_deviceAccess;
}
