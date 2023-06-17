#pragma once

class QString;

class TranslationManagerInterface
{
public:
    virtual void getAvailableTransalations() = 0;
    virtual void switchLanguage(QString value);
};

