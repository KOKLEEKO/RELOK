/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <SpeechManagerBase.h>

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
namespace Default {
#endif

class SpeechManager : public SpeechManagerBase
{
    Q_OBJECT

public:
    explicit SpeechManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void say(QString text) final override;
    void setSpeechLanguage(QString iso) override;
    void setSpeechVoice(int index) override;

protected:
    void initSpeechLocales() final override;
};

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
} //Default
#endif
