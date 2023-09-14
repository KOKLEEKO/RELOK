/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <SpeechManagerBase.h>

/* DISCLAIMER:
 *
 * A better way of doing this would be to create a plugin with QTextToSpeechPlugin and QTextToSpeechEngine
 * pointing to SpeechSynthesis (Web Speech API).
 *
 * Examples:
 * https://code.qt.io/cgit/qt/qtspeech.git/tree/src/plugins/tts?h=5.15
 *
 * Here, for the sake of simplicity, we'll only redefine SpeechManager's virtual methods to make direct calls
 * to SpeechSynthesis, omitting the use of QTextToSpeech.
 */

using QIntList = QList<int>;

class SpeechManager : public SpeechManagerBase
{
public:
    explicit SpeechManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void say(QString text) final override;
    void setSpeechLanguage(QString iso) override;
    void setSpeechVoice(int index) override;

    void clearAll();
    void processVoice(QString lang, QString name, int index);
    void notifyLocalesAndVoicesChanged();

protected:
    void endOfSpeech() const final override;
    void initSpeechLocales() final override;

private:
    QMap<QString, QIntList> m_voiceIndices{};
    QString m_selectedIso{};
    int m_selectedVoiceIndex = 0;
};
