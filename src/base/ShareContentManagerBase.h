#pragma once

#include "ManagerBase.h"

#include <QVariant>

class ShareContentManagerBase : public ManagerBase<ShareContentManagerBase>
{
    Q_OBJECT

public:
    ShareContentManagerBase(QObject *parent = nullptr);

    Q_INVOKABLE virtual void share(QVariant content);
};
