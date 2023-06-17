#pragma once

class QString;
class QVariant;

class PersistenceManagerInterface
{
public:
    virtual QVariant read(QString key, QVariant defaultValue) const = 0;
    virtual void save(QString key, QVariant value) = 0;
};

