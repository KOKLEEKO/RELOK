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
    explicit TranslationManager(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                QObject *parent = nullptr);

    void getAvailableTransalations() override final;
    void switchLanguage(QString language) override final;
};

