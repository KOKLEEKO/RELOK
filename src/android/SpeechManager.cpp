/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "SpeechManager.h"

#include <QtAndroid>

SpeechManager::SpeechManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : Default::SpeechManager{deviceAccess, parent}
{}

void SpeechManager::setSpeechLanguage(QString iso)
{
    m_speech.setLocale({iso});
    if (m_speechAvailableLocales.empty())
        initSpeechLocales();
}
void SpeechManager::setSpeechVoice(int /*index*/) {}

void SpeechManager::endOfSpeech() const
{
    QtAndroid::androidActivity().callMethod<void>("abandonAudioFocus");
}

void SpeechManager::requestAudioFocus()
{
    QtAndroid::androidActivity().callMethod<void>("requestAudioFocus");
}
