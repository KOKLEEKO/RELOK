/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "SpeechManager.h"

SpeechManager::SpeechManager(const std::shared_ptr<ClockLanguageManagerBase> &clockLanguageManager,
                             const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                             QObject *parent)
    : SpeechManagerBase{clockLanguageManager, persistenceManager, parent}
{
    m_enabled = true;
    initSpeechLocales();
}

void SpeechManager::say(QString text)
{
    m_speech.stop();
    m_speech.say(text.toLower());
}

void SpeechManager::setSpeechLanguage(QString iso)
{
    m_speech.setLocale({iso});
    if (!m_speechAvailableVoices.contains(iso)) {
        const QVector<QVoice> &availableVoices = m_speech.availableVoices();
        setHasMutipleVoices(!availableVoices.empty());
        if (!hasMutipleVoices())
            return;
        QStringList voicesNames;
        for (const auto &voice : availableVoices)
            voicesNames << voice.name().split(" ")[0];
        m_speechAvailableVoices.insert(iso, voicesNames);
        const QString settingName = QString("Appearance/%1_voice").arg(iso);
        if (persistenceManager()->value(settingName, -1).toInt() == -1) {
            int defaultIndex = voicesNames.indexOf(m_speech.voice().name().split(" ")[0]);
            if (iso == "fr_FR" && m_speechAvailableVoices[iso].toStringList().size() > 9)
                defaultIndex = 9;
            persistenceManager()->setValue(QString("Appearance/%1_voice").arg(iso),
                                           defaultIndex == -1 ? 0 : defaultIndex);
        }
        emit speechAvailableVoicesChanged();
    }
}

void SpeechManager::setSpeechVoice(int index)
{
    if (m_speech.availableVoices().size() > index)
        m_speech.setVoice(m_speech.availableVoices().at(index));
}

void SpeechManager::initSpeechLocales()
{
    const QVector<QLocale> &locales = m_speech.availableLocales();
    for (const auto &locale : locales) {
        if (m_speechFilter.contains(locale.bcp47Name().left(2))) {
            QString iso;
            const QList uiLanguages{locale.uiLanguages()};
            for (const auto &uiLanguage : uiLanguages)
                if (uiLanguage.split('-').count() == 2)
                    iso = QString(uiLanguage).replace('-', '_');
            const QString name = QString("%1 (%2)").arg(QLocale::languageToString(locale.language()),
                                                        locale.nativeCountryName());
            qCDebug(lc) << iso << name;
            m_speechAvailableLocales.insert(iso, name);
        }
    }
}
