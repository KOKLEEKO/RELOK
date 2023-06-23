#pragma once

#include "ManagerBase.h"

class ReviewManagerBase : public ManagerBase<ReviewManagerBase>
{
    Q_OBJECT

public:
    ReviewManagerBase(QObject *parent = nullptr);

    Q_INVOKABLE virtual void requestReview();
};
