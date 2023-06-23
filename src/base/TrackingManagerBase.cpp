#include "TrackingManagerBase.h"

template<>
QString ManagerBase<TrackingManagerBase>::m_name{"tracking"};

TrackingManagerBase::TrackingManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                         QObject *parent)
    : ManagerBase<TrackingManagerBase>(parent)
    , PersistenceCapability(persistenceManager)
{}

void TrackingManagerBase::requestBugTracking(bool /*value*/) {}

void TrackingManagerBase::requestUsageTracking(bool /*value*/) {}
