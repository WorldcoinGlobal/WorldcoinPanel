#ifndef CXMESSAGE_H
#define CXMESSAGE_H

#include <QObject>
#include <QString>

#include "HXCore.h"

class WFCORE_EXPORT CXMessage
{  
  public:
    explicit CXMessage(int lType = 0, int lCode = 0, const QString& lText = QString(), const QString& lHelpText = QString(), const QString& lCustomText = QString());
    ~CXMessage();

    int fCode() const { return mCode; }
    int fType() const { return mType; }
    QString fText() const { return mText; }
    QString fCustomText() const { return mCustomText; }
    QString fHelpText() const { return mHelpText; }
    void fSetText(const QString& lText) { mText = lText; }
    void fSetCustomText(const QString& lCustomText) { mCustomText = lCustomText; }
    void fSetHelpText(const QString& lText) { mHelpText = lText; }

  private:
    int mCode;
    int mType;
    QString mCustomText;
    QString mHelpText;
    QString mText;
};

#endif // CXMESSAGE_H
