/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include <ReviewManagerBase.h>

template<>
QString ManagerBase<ReviewManagerBase>::m_name{"review"};

ReviewManagerBase::ReviewManagerBase(QObject *parent)
    : ManagerBase<ReviewManagerBase>(parent)
{}

void ReviewManagerBase::requestReview(){};
