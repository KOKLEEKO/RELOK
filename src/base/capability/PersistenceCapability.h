/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <memory>

#include <PersistenceManagerBase.h>

class PersistenceCapability
{
public:
    explicit PersistenceCapability(const std::shared_ptr<PersistenceManagerBase> &persistenceManager);

    PersistenceManagerBase *persistenceManager() const;

private:
    std::shared_ptr<PersistenceManagerBase> m_persistenceManager;
};
