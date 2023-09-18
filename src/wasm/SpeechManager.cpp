/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "SpeechManager.h"

#include <emscripten.h>

#include "ClockLanguageManagerBase.h"
#include "PersistenceManagerBase.h"

extern "C" {
EMSCRIPTEN_KEEPALIVE
void disableSpeechManager()
{
    DeviceAccessBase::instance()->manager<SpeechManagerBase>()->disable();
}

EMSCRIPTEN_KEEPALIVE
void clearAll()
{
    static_cast<SpeechManager *>(DeviceAccessBase::instance()->manager<SpeechManagerBase>())
        ->clearAll();
}

EMSCRIPTEN_KEEPALIVE
bool isLocaleSupported(const char *iso)
{
    return DeviceAccessBase::instance()
        ->manager<ClockLanguageManagerBase>()
        ->clockAvailableLocales()
        .keys()
        .contains(iso);
}

EMSCRIPTEN_KEEPALIVE
void processVoice(const char *lang, const char *name, int index)
{
    static_cast<SpeechManager *>(DeviceAccessBase::instance()->manager<SpeechManagerBase>())
        ->processVoice(lang, name, index);
}

EMSCRIPTEN_KEEPALIVE
void notifyLocalesAndVoicesChanged()
{
    static_cast<SpeechManager *>(DeviceAccessBase::instance()->manager<SpeechManagerBase>())
        ->notifyLocalesAndVoicesChanged();
}
}

/* clang-format off */
EM_JS(void, processVoices, (),
{
    Module._clearAll();
    const voices = window.speechSynthesis.getVoices();
    var lastIndex = 0;
    voices.forEach((voice, index) => {
        const iso = stringToNewUTF8(voice.lang.split('-')[0]);
        if (Module._isLocaleSupported(iso)) {
            _free(iso);
            const lang = stringToNewUTF8(voice.lang.replace('-', "_"));
            const name = stringToNewUTF8(voice.name.split(' ')[0]);
            Module._processVoice(lang, name, index);
            lastIndex = index;
            _free(lang);
            _free(name);
        }
    });
    Module._notifyLocalesAndVoicesChanged();
});
/* clang-format on */

SpeechManager::SpeechManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : SpeechManagerBase{deviceAccess, parent}
{
    m_enabled = true;

    connect(deviceAccess->manager<PersistenceManagerBase>(),
            &PersistenceManagerBase::settingsReady,
            this,
            [=] { initSpeechLocales(); });
}

void SpeechManager::say(QString text)
{
    if (m_selectedVoiceIndex != -1) {
        /* clang-format off */
        EM_ASM({
            const synth = window.speechSynthesis;
            synth.cancel();
            const voiceIndex = $0;
            const textToSay = UTF8ToString($1);
            const utterance = new SpeechSynthesisUtterance(textToSay);
            var voice = synth.getVoices()[voiceIndex];
            utterance.lang = voice.lang;
            utterance.voice = voice;
            synth.speak(utterance);
        }, m_selectedVoiceIndex, text.toStdString().c_str());
        /* clang-format on */
    }
}
void SpeechManager::setSpeechLanguage(QString iso)
{
    m_selectedIso = iso;
}
void SpeechManager::setSpeechVoice(int index)
{
    m_selectedVoiceIndex = -1;
    if (m_voiceIndices.contains(m_selectedIso)) {
        QIntList indices = m_voiceIndices[m_selectedIso];
        if (indices.length() > index) {
            m_selectedVoiceIndex = indices.at(index);
        }
    }
}

void SpeechManager::clearAll()
{
    m_speechAvailableLocales.clear();
    m_speechAvailableVoices.clear();
}

void SpeechManager::processVoice(QString iso, QString name, int index)
{
    if (!m_speechAvailableVoices.contains(iso)) {
        const QLocale speechLocale(iso);
        const QString localeName = QString("%1 (%2)").arg(QLocale::languageToString(
                                                              speechLocale.language()),
                                                          speechLocale.nativeCountryName());
        m_speechAvailableLocales.insert(iso, localeName);
    }

    QIntList indices = m_voiceIndices.value(iso);
    indices.push_back(index);
    m_voiceIndices.insert(iso, indices);

    QStringList voices = m_speechAvailableVoices.value(iso).toStringList();
    voices.push_back(name);
    m_speechAvailableVoices.insert(iso, voices);
}

void SpeechManager::notifyLocalesAndVoicesChanged()
{
    for (const auto &locale : m_speechAvailableLocales.keys()) {
        if (deviceAccess()->manager<PersistenceManagerBase>()->value(
                QString("Speech/%1_voice").arg(locale))
            == QVariant::Invalid) {
            deviceAccess()
                ->manager<PersistenceManagerBase>()
                ->setValue(QString("Speech/%1_voice").arg(locale),
                           m_speechAvailableVoices[locale].toStringList().size() - 1);
        }
    }
    setHasMutipleVoices((m_speechAvailableVoices.size() > 0));
    emit speechAvailableLocalesChanged();
    emit speechAvailableVoicesChanged();
}

void SpeechManager::endOfSpeech() const {};
void SpeechManager::initSpeechLocales()
{
    /* clang-format off */
    EM_ASM({
        if ('speechSynthesis' in window) {
            processVoices();
            window.speechSynthesis.onvoiceschanged = () => processVoices();
        } else {
            Module._disableSpeechManager();
        }
    });
    /* clang-format on */
};
