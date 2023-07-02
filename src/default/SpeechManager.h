/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <SpeechManagerBase.h>

class SpeechManager : public SpeechManagerBase
{
    Q_OBJECT

public:
    explicit SpeechManager(const std::shared_ptr<ClockLanguageManagerBase> &clockLanguageManager,
                           const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                           QObject *parent = nullptr);

    void endOfSpeech() const override {}
    void say(QString text) override;
    void setSpeechLanguage(QString iso) override;
    void setSpeechVoice(int index) override;
    void initSpeechLocales() override;
};
