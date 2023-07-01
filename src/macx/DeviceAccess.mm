/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "DeviceAccess.h"

#include "src/default/SpeechManager.h"
#include <ClockLanguageManager.h>
#include <PersistenceManager.h>
#include <TranslationManager.h>

Q_LOGGING_CATEGORY(lc, "Device-macx")

DeviceAccess::DeviceAccess(QObject *parent)
    : DeviceAccessBase{parent}
{}
