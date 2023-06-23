#pragma once

#include "ManagerBase.h"

class SplashScreenManagerBase : public ManagerBase<SplashScreenManagerBase>
{
    Q_OBJECT

public:
    SplashScreenManagerBase(QObject *parent = nullptr);

    Q_INVOKABLE virtual void hideSplashScreen();
};
