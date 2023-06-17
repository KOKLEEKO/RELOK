#pragma once

class QString;

class SpeechManagerInterface
{
public:
    virtual void endOfSpeech() const = 0;
    virtual void say(QString text) const = 0;
    virtual void setSpeechLanguage(QString iso) = 0;
    virtual void setSpeechVoice(int index) = 0;
    virtual void availableLocales() = 0;
};
