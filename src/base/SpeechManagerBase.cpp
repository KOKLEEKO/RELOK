/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "SpeechManagerBase.h"

template<>
QString ManagerBase<SpeechManagerBase>::m_name{"speech"};

SpeechManagerBase::SpeechManagerBase(DeviceAccessBase *deviceAccess, QObject *parent)
    : ManagerBase(deviceAccess, parent)
{}

void SpeechManagerBase::setHasMutipleVoices(bool newHasMutipleVoices)
{
    if (m_hasMultipleVoices == newHasMutipleVoices)
        return;
    m_hasMultipleVoices = newHasMutipleVoices;
    emit hasMultipleVoicesChanged();
}
