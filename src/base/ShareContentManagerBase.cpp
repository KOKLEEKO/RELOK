#include "ShareContentManagerBase.h"

template<>
QString ManagerBase<ShareContentManagerBase>::m_name{"shareContent"};

ShareContentManagerBase::ShareContentManagerBase(QObject *parent)
    : ManagerBase<ShareContentManagerBase>(parent)
{}

void ShareContentManagerBase::share(QVariant /*content*/){};
