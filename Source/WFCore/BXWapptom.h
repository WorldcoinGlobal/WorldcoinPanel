#ifndef BXWAPPTOM_H
#define BXWAPPTOM_H

#include <QObject>
#include <QString>
#include <QTimer>
#include <IXWapptom.h>

#include "HXCore.h"

class  WFCORE_EXPORT BXWapptom : public QObject, public IXWapptom {
  Q_INTERFACES(IXWapptom)
  Q_OBJECT
  Q_PROPERTY(bool mActive READ fActive WRITE tSetActive NOTIFY sActiveChanged)
  Q_PROPERTY(bool mSingleShot READ fSingleShot WRITE tSetSingleShot NOTIFY sSingleShotChanged)
  Q_PROPERTY(bool mResponseStateIsAnswer READ fResponseStateIsAnswer WRITE tSetResponseStateIsAnswer NOTIFY sResponseStateIsAnswerChanged)
  Q_PROPERTY(int mPollingTime READ fPollingTime WRITE tSetPollingTime NOTIFY sPollingTimeChanged)
  Q_PROPERTY(int mPrecision READ fPrecision WRITE tSetPrecision NOTIFY sPrecisionChanged)
  Q_PROPERTY(int mStatus READ fStatus NOTIFY sStatusChanged)
  Q_PROPERTY(int mStartingOffset READ fStartingOffset WRITE tSetStartingOffset NOTIFY sStartingOffsetChanged)
  Q_PROPERTY(QString mConnector READ fConnector WRITE tSetConnector NOTIFY sConnectorChanged)
  Q_PROPERTY(QString mValue READ fValue WRITE tSetValue NOTIFY sValueChanged)
  Q_PROPERTY(QString mPreviousValue READ fPreviousValue WRITE tSetPreviousValue NOTIFY sPreviousValueChanged)
  Q_PROPERTY(QString mDisplayValue READ fDisplayValue WRITE tSetDisplayValue NOTIFY sDisplayValueChanged)
  Q_PROPERTY(QString mParams READ fParams WRITE tSetParams NOTIFY sParamsChanged)
  Q_PROPERTY(QString mInput READ fInput WRITE tSetInput NOTIFY sInputChanged)
  Q_PROPERTY(QString mOutput READ fOutput WRITE tSetOutput NOTIFY sOutputChanged)
  Q_PROPERTY(QString mSource READ fSource WRITE tSetSource NOTIFY sSourceChanged)

  public:
    virtual ~BXWapptom();

    virtual QString fName() const = 0;
    virtual QString fInput() const { return mInput; }
    virtual QString fOutput() const { return mOutput; }
    virtual QString fSource() const { return mSource; }
    virtual void fSetup();
    virtual int fType() const = 0;    
    bool fSingleShot() const { return mSingleShot; }
    bool fActive() const { return mActive; }
    bool fResponseStateIsAnswer() const { return mResponseStateIsAnswer; }
    int fStartingOffset() const { return mStartingOffset; }
    int fPollingTime() const { return mPollingTime; }
    int fPrecision() const { return mPrecision; }
    int fStatus() const { return mStatus; }    
    Q_INVOKABLE bool fInitialized() const { return mInitialized; }
    QString fConnector() const { return mConnector; }
    QString fValue() const { return mValue; }
    QString fPreviousValue() const { return mPreviousValue; }
    QString fParams() const { return mParams; }
    virtual QString fDisplayValue() const { return mDisplayValue; }

  protected:
    bool mActive;
    bool mSingleShot;
    bool mInitialized;
    bool mResponseStateIsAnswer;
    quint32 mActiveComponents;
    int mPollingTime;
    int mPrecision;
    int mStatus;
    int mStartingOffset;
    QString mConnector;
    QString mValue;
    QString mPreviousValue;
    QString mParams;
    QString mDisplayValue;
    QString mInput;
    QString mOutput;
    QString mSource;
    QTimer mPollTimer;

  signals:
    void sActiveChanged();
    void sResponseStateIsAnswerChanged();
    void sPollingTimeChanged();
    void sConnectorChanged();
    void sPrecisionChanged();
    void sValueChanged();
    void sPreviousValueChanged();
    void sParamsChanged();
    void sDisplayValueChanged();
    void sStatusChanged();
    void sStartingOffsetChanged();
    void sInputChanged();
    void sOutputChanged();
    void sSourceChanged();
    void sSingleShotChanged();
    void sUpdateValue(const QString& lWapptomName);    

  public slots:
    virtual void tRequestUpdateValue();
    virtual void tSetActive(bool lActive);
    virtual void tSetResponseStateIsAnswer(bool lResponseStateIsAnswer) { mResponseStateIsAnswer = lResponseStateIsAnswer; emit sResponseStateIsAnswerChanged(); }
    virtual void tSetPollingTime(int lPollingTime) { mPollingTime = lPollingTime; emit sPollingTimeChanged(); }
    virtual void tSetConnector(const QString& lConnector) { mConnector = lConnector; emit sConnectorChanged(); }
    virtual void tSetPrecision(int lPrecision) { mPrecision = lPrecision; emit sPrecisionChanged(); }
    virtual void tSetStartingOffset(const int lStartingOffset) { mStartingOffset = lStartingOffset; emit sStartingOffsetChanged(); }
    virtual void tSetValue(const QString& lValue) { tSetPreviousValue(mValue); mValue = lValue; emit sValueChanged(); mInitialized = true; tSetDisplayValue(mValue); }
    virtual void tSetPreviousValue(const QString& lPreviousValue) { mPreviousValue = lPreviousValue; emit sPreviousValueChanged(); }
    virtual void tSetParams(const QString& lParams) { mParams = lParams; emit sParamsChanged(); }
    virtual void tSetInput(const QString& lInput) { mInput = lInput; emit sInputChanged(); }
    virtual void tSetOutput(const QString& lOutput) { mInput = lOutput; emit sOutputChanged(); }
    virtual void tSetDisplayValue(const QString& lValue) { mDisplayValue = lValue; emit sDisplayValueChanged(); }
    virtual void tSetSource(const QString& lSource) { mSource = lSource; emit sSourceChanged(); }
    virtual void tSetSingleShot(bool lSingleShot) { mSingleShot = lSingleShot; emit sSingleShotChanged(); }

  protected slots:
    virtual void tSetStatus(int lStatus) { mStatus = lStatus; emit sStatusChanged(); }
    virtual void tStart();
};

#endif // BXAPPTON_H
