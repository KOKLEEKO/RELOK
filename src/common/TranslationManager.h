/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <TranslationManagerBase.h>

class TranslationManager : public TranslationManagerBase
{
    Q_OBJECT

public:
    explicit TranslationManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void getAvailableTransalations() final override;
    void switchLanguage(QString language) final override;
};

