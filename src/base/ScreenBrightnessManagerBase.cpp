#include "ScreenBrightnessManagerBase.h"

template<>
QString ManagerBase<ScreenBrightnessManagerBase>::m_name{"screenBrightness"};

ScreenBrightnessManagerBase::ScreenBrightnessManagerBase(
    const std::shared_ptr<PersistenceManagerBase> &persistenceManager, QObject *parent)
    : ManagerBase<ScreenBrightnessManagerBase>(parent)
    , PersistenceCapability(persistenceManager)
{}

void ScreenBrightnessManagerBase::setBrightnessRequested(float /*brightness*/) {}

void ScreenBrightnessManagerBase::updateBrightness(float brightness)
{
    m_brightness = qRound(brightness * 100);
    qCDebug(lc) << "R brightness:" << m_brightness;
    emit brightnessChanged();
}
