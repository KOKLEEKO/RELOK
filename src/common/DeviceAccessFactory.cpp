#include "DeviceAccessFactory.h"

#include <ClockLanguageManager.h>
#include <PersistenceManager.h>
#include <SpeechManager.h>
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
    m_deviceAccess->addManager(std::make_shared<SpeechManager>(clockLanguage, persistence));
    m_deviceAccess->addManager(std::make_shared<TranslationManager>(persistence));
#ifdef Q_OS_ANDROID
    m_deviceAccess->addManager(m_splashScreenManager = std::make_shared<SplashScreenManager>(););
#endif

    return m_deviceAccess;
}
