#include "ReviewManagerBase.h"

template<>
QString ManagerBase<ReviewManagerBase>::m_name{"review"};

ReviewManagerBase::ReviewManagerBase(QObject *parent)
    : ManagerBase<ReviewManagerBase>(parent)
{}

void ReviewManagerBase::requestReview(){};
