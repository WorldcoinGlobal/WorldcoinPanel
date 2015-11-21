#ifndef GXCOMPONENT_H
#define GXCOMPONENT_H

#include <QQuickItem>
#include <QVariantList>
#include <CXDefinitions.h>

#include "HXCore.h"

class WFCORE_EXPORT GXComponent : public QQuickItem
{
  Q_OBJECT
  Q_PROPERTY(QString mName READ fName WRITE fSetName NOTIFY sNameChanged)
  Q_PROPERTY(bool mStatus READ fStatus WRITE tSetStatus NOTIFY sStatusChanged)

  public:
    explicit GXComponent(QQuickItem* lParent = 0 );

    Q_INVOKABLE void fRawCallRequested(const QString& lConnector, const QString& lRawRequest, bool lParse = true, int lLogType = CXDefinitions::ELogAll);
    Q_INVOKABLE int fType() const { return mType; }
    Q_INVOKABLE QString fName() const { return mName; }
    Q_INVOKABLE void fSetName(const QString& lName ) { mName = lName; emit sNameChanged(); }
    Q_INVOKABLE QString fSetting(const QString& lParameter) const;
    Q_INVOKABLE QString fImageFile(const QString& lImageName) const;
    Q_INVOKABLE int fMinConf() const { return cDefaultMinConfForBalance; }
    Q_INVOKABLE bool fStatus() const { return mStatus; }
    Q_INVOKABLE void fQuitApplication();
    QVariantList fJsonToList(const QJsonValue& lJsonValue) const;

  private:
    bool mStatus;
    int mType;
    QString mName;

  public slots:
    void tSetType(int lType) { mType = lType; }
    void tSetSetting(const QString& lSetting, const QString& lValue);
    void tSetStatus(bool lStatus) { mStatus = lStatus; emit sStatusChanged(); }

  signals:
    void sMessageArrived(int lMessageType, const QString& lRequestID, const QString& lInput, const QString& lMessage);
    void sMessageArrivedJson(int lMessageType, const QString& lRequestID, const QString& lInput, const QVariantList& lList);
    void sRawCallRequested(const QString& lConnector, const QString& lRawRequest, const QString& lComponentName, bool lParse, int lLogType);
    void sComponentActivated();
    void sComponentProcessing(bool mProcessing);
    void sNameChanged();
    void sStatusChanged();
};

#endif // GXCOMPONENT_H
