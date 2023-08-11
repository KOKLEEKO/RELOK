#pragma once

#include <ReviewManagerBase.h>

class ReviewManager : public ReviewManagerBase
{
    Q_OBJECT

public:
    explicit ReviewManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void requestReview() final override;
};

