/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "src/default/SpeechManager.h"

class SpeechManager : public Default::SpeechManager
{
    Q_OBJECT

public:
    explicit SpeechManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void setSpeechLanguage(QString iso) final override;
    void setSpeechVoice(int index) final override;

protected:
    void endOfSpeech() const final override;
    void requestAudioFocus() final override;
};
