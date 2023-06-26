/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include <SpeechManagerBase.h>

template<>
QString ManagerBase<SpeechManagerBase>::m_name{"speech"};

SpeechManagerBase::SpeechManagerBase(const std::shared_ptr<ClockLanguageManagerBase> &clockLanguageManager,
                                     const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                     QObject *parent)
    : ManagerBase<SpeechManagerBase>(parent)
    , PersistenceCapability(persistenceManager)
    , m_clockLanguageManager(clockLanguageManager)
{
    connect(&m_speech, &QTextToSpeech::stateChanged, this, [=](QTextToSpeech::State state) {
        if (state == QTextToSpeech::Ready)
            endOfSpeech();
    });
}

void SpeechManagerBase::endOfSpeech() const {};

void SpeechManagerBase::initSpeechLocales(){};

void SpeechManagerBase::say(QString text)
{
    m_speech.stop();
    m_speech.say(text.toLower());
};

void SpeechManagerBase::setSpeechLanguage(QString /*iso*/){};

void SpeechManagerBase::setSpeechVoice(int index)
{
    if (m_speech.availableVoices().size() > index)
        m_speech.setVoice(m_speech.availableVoices().at(index));
};
