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
    : ManagerBase(parent)
    , PersistenceCapability(persistenceManager)
    , m_clockLanguageManager(clockLanguageManager)
{
    connect(&m_speech, &QTextToSpeech::stateChanged, this, [=](QTextToSpeech::State state) {
        if (state == QTextToSpeech::Ready)
            endOfSpeech();
    });
}
