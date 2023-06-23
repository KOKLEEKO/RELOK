#include "ScreenSizeManagerBase.h"

template<>
QString ManagerBase<ScreenSizeManagerBase>::m_name{"screenSize"};

ScreenSizeManagerBase::ScreenSizeManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                             QObject *parent)
    : ManagerBase<ScreenSizeManagerBase>(parent)
    , PersistenceCapability(persistenceManager)
{}

void ScreenSizeManagerBase::updateSafeAreaInsets(){};
