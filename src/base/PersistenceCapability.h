#pragma once

#include <memory>

#include "PersistenceManagerBase.h"

class PersistenceCapability
{
public:
    explicit PersistenceCapability(const std::shared_ptr<PersistenceManagerBase> &persistenceManager);

    PersistenceManagerBase *persistenceManager() const;

private:
    std::shared_ptr<PersistenceManagerBase> m_persistenceManager;
};
