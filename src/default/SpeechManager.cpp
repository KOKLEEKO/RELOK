/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "SpeechManager.h"

#include "ClockLanguageManagerBase.h"
#include "PersistenceManagerBase.h"

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
using namespace Default;
#endif

SpeechManager::SpeechManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : SpeechManagerBase{deviceAccess, parent}
{
    m_enabled = true;

    connect(&m_speech, &QTextToSpeech::stateChanged, this, [=](QTextToSpeech::State state) {
        if (state == QTextToSpeech::Ready)
            endOfSpeech();
    });

    initSpeechLocales();
}

void SpeechManager::say(QString text)
{
    requestAudioFocus();
    m_speech.stop();
    m_speech.say(text.toLower());
}

void SpeechManager::setSpeechLanguage(QString iso)
{
    m_speech.setLocale({iso});
    if (!m_speechAvailableVoices.contains(iso)) {
        const QVector<QVoice> &availableVoices = m_speech.availableVoices();
        setHasMutipleVoices(!availableVoices.empty());
        if (!hasMultipleVoices())
            return;
        QStringList voicesNames;
        for (const auto &voice : availableVoices)
            voicesNames << voice.name().split(" ")[0];
        m_speechAvailableVoices.insert(iso, voicesNames);
        const QString settingName = QString("Speech/%1_voice").arg(iso);
        if (deviceAccess()->manager<PersistenceManagerBase>()->value(settingName, -1).toInt()
            == -1) {
            int defaultIndex = voicesNames.indexOf(m_speech.voice().name().split(' ')[0]);
            deviceAccess()->manager<PersistenceManagerBase>()->setValue(settingName, defaultIndex);
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
    const QVector<QLocale> &speechLocales = m_speech.availableLocales();
    for (const auto &speechLocale : speechLocales) {
        if (deviceAccess()
                ->manager<ClockLanguageManagerBase>()
                ->clockAvailableLocales()
                .keys()
                .contains(speechLocale.bcp47Name().left(2))) {
            QString iso = speechLocale.bcp47Name().replace('-', '_');
            if (iso.split('_').size() != 2) {
                const QList uiLanguages{speechLocale.uiLanguages()};
                for (const auto &uiLanguage : uiLanguages) {
                    if (uiLanguage.split('-').size() == 2) {
                        iso = QString(uiLanguage).replace('-', '_');
                        break;
                    }
                }
            }
            const QString name = QString("%1 (%2)").arg(QLocale::languageToString(
                                                            speechLocale.language()),
                                                        speechLocale.nativeCountryName());
            m_speechAvailableLocales.insert(iso, name);
        }
    }
    emit speechAvailableLocalesChanged();
}
