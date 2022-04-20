#pragma once

#include <QObject>
#include <QDebug>

class iDevice : public QObject {
  Q_OBJECT
 public:
  iDevice() = default;
  Q_INVOKABLE void request();

 signals:
};
