#include "PersistenceCapability.h"

PersistenceCapability::PersistenceCapability(const std::shared_ptr<PersistenceManagerBase> &persistenceManager)
    : m_persistenceManager(persistenceManager)
{}

PersistenceManagerBase *PersistenceCapability::persistenceManager() const
{
    return m_persistenceManager.get();
};
