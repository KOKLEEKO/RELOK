#include "SplashScreenManagerBase.h"

template<>
QString ManagerBase<SplashScreenManagerBase>::m_name{"splashScreen"};

SplashScreenManagerBase::SplashScreenManagerBase(QObject *parent)
    : ManagerBase<SplashScreenManagerBase>(parent)
{}

void SplashScreenManagerBase::hideSplashScreen(){};
