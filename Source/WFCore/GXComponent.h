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
  Q_PROPERTY(bool mOkVisible READ fOkVisible WRITE fSetOkVisible NOTIFY sOkVisibleChanged)
  Q_PROPERTY(bool mCancelVisible READ fCancelVisible WRITE fSetCancelVisible NOTIFY sCancelVisibleChanged)
  Q_PROPERTY(QString mOkText READ fOkText WRITE fSetOkText NOTIFY sOkTextChanged)
  Q_PROPERTY(QString mCancelText READ fCancelText WRITE fSetCancelText NOTIFY sCancelTextChanged)

  public:
    explicit GXComponent(QQuickItem* lParent = 0 );

    Q_INVOKABLE void fRawCallRequested(const QString& lConnector, const QString& lRawRequest, bool lParse = true, int lLogType = CXDefinitions::ELogAll);
    Q_INVOKABLE int fType() const { return mType; }
    Q_INVOKABLE QString fName() const { return mName; }
    Q_INVOKABLE void fSetName(const QString& lName ) { mName = lName; emit sNameChanged(); }
    Q_INVOKABLE QString fSetting(const QString& lSetting, bool lUseDaemonConf, const QString& lConnector) const;
    Q_INVOKABLE QString fImageFile(const QString& lImageName) const;
    Q_INVOKABLE int fMinConf() const { return cDefaultMinConfForBalance; }
    Q_INVOKABLE bool fStatus() const { return mStatus; }
    Q_INVOKABLE void fQuitApplication();
    Q_INVOKABLE bool fOkVisible() const { return mOkVisible; }
    Q_INVOKABLE QString fCancelText() const { return mCancelText; }
    Q_INVOKABLE QString fOkText() const { return mOkText; }
    Q_INVOKABLE bool fCancelVisible() const { return mCancelVisible; }
    QVariantList fJsonToList(const QJsonValue& lJsonValue) const;

  private:
    bool mStatus;
    bool mCancelVisible;
    bool mOkVisible;
    int mType;
    QString mName;
    QString mCancelText;
    QString mOkText;

  public slots:
    void tSetType(int lType) { mType = lType; }
    void fSetSetting(const QString& lSetting, const QString& lValue, bool lUseDaemonConf, const QString& lConnector);
    void fSetCancelVisible(bool lVisible) { mCancelVisible = lVisible; emit sCancelVisibleChanged(); }
    void fSetCancelText(const QString& lLabel) { mCancelText = lLabel; emit sCancelTextChanged(); }
    void fSetOkVisible(bool lVisible) { mOkVisible = lVisible; emit sOkVisibleChanged(); }
    void fSetOkText(const QString& lLabel) { mOkText = lLabel; emit sOkTextChanged(); }

    void tSetStatus(bool lStatus) { mStatus = lStatus; emit sStatusChanged(); }

  signals:
    void sMessageArrived(int lMessageType, const QString& lRequestID, const QString& lInput, const QString& lMessage);
    void sMessageArrivedJson(int lMessageType, const QString& lRequestID, const QString& lInput, const QVariantList& lList);
    void sRawCallRequested(const QString& lConnector, const QString& lRawRequest, const QString& lComponentName, bool lParse, int lLogType);
    void sComponentActivated();
    void sComponentProcessing(bool mProcessing);
    void sNameChanged();
    void sStatusChanged();
    void sOkVisibleChanged();
    void sOkTextChanged();
    void sCancelVisibleChanged();
    void sCancelTextChanged();
    void sChangeTrayIconTooltip(const QString& lText);
};

#endif // GXCOMPONENT_H
