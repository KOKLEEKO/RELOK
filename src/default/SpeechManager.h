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

    Q_PROPERTY(QVariantMap speechAvailableVoices MEMBER m_speechAvailableVoices NOTIFY speechAvailableVoicesChanged)

public:
    explicit SpeechManager(const std::shared_ptr<ClockLanguageManagerBase> &clockLanguageManager,
                           const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                           QObject *parent = nullptr);

    void say(QString text) override;
    void setSpeechLanguage(QString iso) override;
    void endOfSpeech() const override {}
    void initSpeechLocales() override final;

    Q_INVOKABLE void setSpeechVoice(int index);

private:
    QVariantMap m_speechAvailableVoices{};
};

