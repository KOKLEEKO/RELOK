/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "SpeechManager.h"

#include <emscripten.h>

extern "C" {
EMSCRIPTEN_KEEPALIVE
void disableSpeechManagers()
{
    DeviceAccessBase::instance()->manager<SpeechManagerBase>()->disable();
}
}

SpeechManager::SpeechManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : SpeechManagerBase{deviceAccess, parent}
{
    m_enabled = true;

    initSpeechLocales();
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
void SpeechManager::initSpeechLocales()
{
    /* clang-format off */
    EM_ASM({
        if ('speechSynthesis' in window) {
            console.log("now", window.speechSynthesis.getVoices());
            window.speechSynthesis.onvoiceschanged = () => {
                console.log("later", window.speechSynthesis.getVoices());
            };
        } else {
            Module._disableSpeechManagers();
        }
    });
    /* clang-format on */
};
