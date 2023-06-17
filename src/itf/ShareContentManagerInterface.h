#pragma once

class QVariant;

class ShareContentManagerInterface
{
    virtual bool share(QVariant content) = 0;
};
