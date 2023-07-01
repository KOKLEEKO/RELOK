/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include <ShareContentManagerBase.h>

template<>
QString ManagerBase<ShareContentManagerBase>::m_name{"shareContent"};

ShareContentManagerBase::ShareContentManagerBase(QObject *parent)
    : ManagerBase(parent)
{}

void ShareContentManagerBase::share(QVariant /*content*/){};
