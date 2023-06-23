#pragma once

#include "ManagerBase.h"

#include <QVariantMap>

class ClockLanguageManagerBase : public ManagerBase<ClockLanguageManagerBase>
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap clockAvailableLocales READ clockAvailableLocales CONSTANT)

    void detectClockAvailableLocales();

public:
    ClockLanguageManagerBase(QObject *parent = nullptr);

    QVariantMap clockAvailableLocales() const;

private:
    QVariantMap m_clockAvailableLocales;
};

