/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "SpeechManager.h"

#include <emscripten.h>

SpeechManager::SpeechManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : SpeechManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void SpeechManager::say(QString text)
{
    Q_UNUSED(text)
}
void SpeechManager::setSpeechLanguage(QString iso)
{
    Q_UNUSED(iso)
}
void SpeechManager::setSpeechVoice(int index)
{
    Q_UNUSED(index)
}
void SpeechManager::endOfSpeech() const {};
void SpeechManager::initSpeechLocales(){};
