#ifndef CXDefinitions_H
#define CXDefinitions_H

#include <QCoreApplication>
#include <QDate>
#include <QDir>
#include <QObject>
#include <QUrl>
#include "HXDefinitions.h"

const QString cDefaultConfig("WorldcoinBC.cfg");
const QString cDefaultLog("WorldcoinBC.log");
const QString cMainComponents("WorldcoinMainComponents.cfg");
const QString cExtraComponents("WorldcoinExtraComponents.cfg");
const QString cCustomComponents("WorldcoinCustomComponents.cfg");
const QString cCommandDefinitions("CommandDefinitions.cfg");
const QString cDefaultDaemon("WDC");
const QString cDefaultTheme("BlueBreeze_Desktop");

const bool cDefaultSaveLog(true);
const int cDefaultPanelMaxLines(100);
const int cDefaultServicesRetryPeriod(60);
const int cMinimumSampleTime(1);
const int cDefaultSampleTime(5000);
const int cKillDaemonWaitTime(1000);
const int cDefaultPrecision(10);
const int cDefaultMaxTries(3000);
const int cConnectorRequestQueue(100);
const int cMessageIDMaxLenght(8);
const int cDefaultMinConfForBalance(0);
const int cDefaultUpdatesCheckPeriod(6);

const qreal cInchConv = 2.54;
const QString cWizardExec("WorldcoinBC");
const QString cDefaultRegion("1");
const QString cDefaultChannel("4");
const QString cComponentsConfig("Components.cfg");
const QString cAnimationDuration("250");
const QString cDefaultBackupDirectory("Backups");
const QString cDefaultZoomFactor("1");
const QString cDefaultDateFormat("yyyy-MM-dd");
const QString cDefaultDateFormatReduced("yyyyMMdd");
const QString cDefaultTimeFormat("hh:mm:ss");
const QString cDefaultLogDirectory("Logs");
const QString cDefaultRcpResult("result");
const QString cDaemonsConf("Daemons.cfg");
const QString cDaemonsDir("Daemons");
const QString cConnectorsDir("Connectors");
const QString cWapptomsDir("Wapptoms");
const QString cMainComponentsDir("Components/Main");
const QString cExtraComponentsDir("Components/Extra");
const QString cCustomComponentsDir("Components/Custom");
const QString cComponentExtension(".qml");
const QString cTemporalExtension(".tmp");
const QString cTemporalDirectory("Temp");

class WFDEFINITIONS_EXPORT CXDefinitions : public QObject {
  Q_OBJECT
  Q_PROPERTY(bool mSaveLog READ fSaveLog WRITE fSetSaveLog NOTIFY sSaveLogChanged)
  Q_PROPERTY(int mPanelMaxLines READ fPanelMaxLines WRITE fSetPanelMaxLines NOTIFY sPanelMaxLinesChanged)
  Q_PROPERTY(double mWidth READ fWidth WRITE fSetWidth NOTIFY sWidthChanged)
  Q_PROPERTY(double mHeight READ fHeight WRITE fSetHeight NOTIFY sHeightChanged)
  Q_PROPERTY(int mX READ fX WRITE fSetX NOTIFY sXChanged)
  Q_PROPERTY(int mY READ fY WRITE fSetY NOTIFY sYChanged)
  Q_PROPERTY(QString mCurrentVersion READ fCurrentVersion WRITE fSetCurrentVersion NOTIFY sCurrentVersionChanged)
  Q_PROPERTY(QString mCurrentVersionName READ fCurrentVersionName WRITE fSetCurrentVersionName NOTIFY sCurrentVersionNameChanged)
  Q_PROPERTY(QString mTheme READ fTheme WRITE fSetTheme NOTIFY sThemeChanged)
  Q_PROPERTY(QString mZoomFactor READ fZoomFactor WRITE fSetZoomFactor NOTIFY sZoomFactorChanged)
  Q_PROPERTY(QString mAnimationDuration READ fAnimationDuration WRITE fSetAnimationDuration NOTIFY sAnimationDurationChanged)
  Q_PROPERTY(QString mUpdateCheckPeriod READ fUpdateCheckPeriod WRITE fSetUpdateCheckPeriod NOTIFY sUpdateCheckPeriodChanged)
  Q_PROPERTY(QString mUpdateChannel READ fUpdateChannel WRITE fSetUpdateChannel NOTIFY sUpdateChannelChanged)
  Q_PROPERTY(QString mMinimizeOnClose READ fMinimizeOnClose WRITE fSetMinimizeOnClose NOTIFY sMinimizeOnCloseChanged)
  Q_PROPERTY(QString mMinimizeToTray READ fMinimizeToTray WRITE fSetMinimizeToTray NOTIFY sMinimizeToTrayChanged)

  Q_ENUMS(eComponentType)
  Q_ENUMS(eRole)
  Q_ENUMS(eDataType)
  Q_ENUMS(eMessageType)
  Q_ENUMS(eServiceStatus)
  Q_ENUMS(eComponentCategory)
  Q_ENUMS(eLogType)
  Q_ENUMS(eUpgradePriority)
  Q_ENUMS(eUpgradeChannel)
  Q_ENUMS(eSize)

  public:
    explicit CXDefinitions(QObject* pParent = 0);
    virtual ~CXDefinitions();

    enum eRole {
      EDisplayRole = Qt::UserRole,
      EEditRole = Qt::UserRole + 1,
      EComponentTypeRole = Qt::UserRole + 2,
      EAreaRole = Qt::UserRole + 3,
      EModuleRole = Qt::UserRole + 4,
      EConnectionTypeRole = Qt::UserRole + 5,
      EDataTypeRole = Qt::UserRole + 6,
      EMessageTypeRole = Qt::UserRole + 7,
      EComponentCategoryRole = Qt::UserRole + 8,
      EComponentDependenciesRole = Qt::UserRole + 9
    };
    enum eComponentType {
      EArea = 1,
      EModule = 2,
      EConfig = 101,
      ECustom = 102,
      EParameter = 103,
      ERegister = 104,
      ETransaction = 105,
      EDetail = 106,
      EProcess = 107,
      EReport = 108,
      ESystemParameter = 109
    };
    enum eDataType {
      EKeyType = 1,
      EForeignKeyType = 2,
      EStringType = 3,
      ENumberType = 4,
      ETextType = 5,
      ECurrencyType = 6,
      EBinType = 7,
      EDateType = 8,
      EImageType = 9,
      ESoundType = 10,
      EVideoType = 11,
      EBoolType = 12,
      ETimeType = 13,
      EPercentType = 14,
      ESecretType = 15,
      EAddressType = 16,
      EHashType = 17
    };
    enum eMessageType {
      ESuccessMessage = 1,
      EInfoMessage = 2,
      EErrorMessage = 3,
      EWarningMessage = 4,
      EBugMessage = 5
    };
    enum eServiceStatus {
      EServiceStopped = 1,
      EServiceReady = 2,
      EServiceProcessing = 3,
      EServiceError = 4,
      EServiceClosing = 5
    };
    enum eOperatingsystem {
      ELinuxOS = 1,
      EWindowsOS = 3
    };
    enum eRequestType {
      EWapptom = 1,
      ERawCall = 2
    };
    enum eWapptomType {
      EWapptomWallet = 1,
      EWapptomNetwork = 2,
      EWapptomFile = 3
    };
    enum eComponentCategory {
      EMainComponent = 1,
      EExtraComponent = 2,
      ECustomComponent = 3
    };
    enum eLogType {
      ELogNone = 1,
      ELogDisk = 2,
      ELogPanel = 3,
      ELogAll = 4
    };
    enum eRequestStatus {
      ERequestQueued = 1,
      ERequestProcessing = 2,
      ENotAppliable = 3
    };
    enum eUpgradePriority {
      EUpgradeLow = 1,
      EUpgradeMedium = 2,
      EUpgradeHigh = 3,
      EUpgradeCritical = 4
    };
    enum eUpgradeChannel {
      EChannelAlpha = 1,
      EChannelBeta = 2,
      EChannelRC = 3,
      EChannelRelease = 4
    };
    enum eSize {
      ESizeTiny = 128,
      ESizeSmall = 256,
      ESizeMedium = 512,
      ESizeLarge = 1024,
      ESizeExtraLarge = 4096
    };

    Q_INVOKABLE static int fCurrentOS();
    Q_INVOKABLE static QString fCurrentDate() { return QDate::currentDate().toString(cDefaultDateFormat); }
    Q_INVOKABLE static QString fAppDir() { return qApp->applicationDirPath(); }
    Q_INVOKABLE static QString fBackupDir() { return qApp->applicationDirPath() + "/" + cDefaultBackupDirectory; }
    Q_INVOKABLE static QString fCanonicalPath(const QString& lDir, bool lReturnStandard = false);
    Q_INVOKABLE static QString fCompressVersion(const QString& lVersion);
    Q_INVOKABLE static QString fExtendVersion(const QString& lVersion);
    Q_INVOKABLE static QString fDefaultDaemon() { return cDefaultDaemon; }
    Q_INVOKABLE static QString fStatusText(int lStatus);

    bool fSaveLog() const { return mSaveLog; }
    int fPanelMaxLines() const { return mPanelMaxLines; }    
    double fWidth() const { return mWidth; }
    double fHeight() const { return mHeight; }
    int fX() const { return mX; }
    int fY() const { return mY; }

    QString fAnimationDuration() const { return mAnimationDuration; }
    Q_INVOKABLE QString fCurrentVersion() const { return mCurrentVersion; }
    Q_INVOKABLE QString fCurrentVersionName() const { return mCurrentVersionName; }
    QString fTheme() const { return mTheme; }
    QString fZoomFactor() const { return mZoomFactor; }
    QString fPulzarHost() const { return mPulzarHost; }
    QString fUpdateChannel() const { return mUpdateChannel; }
    QString fUpdateCheckPeriod() const { return mUpdateCheckPeriod; }
    QString fMinimizeOnClose() const { return mMinimizeOnClose; }
    QString fMinimizeToTray() const { return mMinimizeToTray; }
    QString fRegion() const { return mRegion; }


    int fPulzarPort() const { return mPulzarPort; }

    void fSetSaveLog(bool lSaveLog) {
      if(lSaveLog != mSaveLog) {
        mSaveLog = lSaveLog;
        emit sSaveLogChanged();
      }
    }
    void fSetPanelMaxLines(int lPanelMaxLines) {
      if(lPanelMaxLines != mPanelMaxLines) {
        mPanelMaxLines = lPanelMaxLines;
        emit sPanelMaxLinesChanged();
      }
    }
    void fSetWidth(long double lWidth) {
      if(lWidth != mWidth) {
        mWidth = lWidth;
        emit sWidthChanged();
      }
    }
    void fSetHeight(long double lHeight) {
      if(lHeight != mHeight) {
        mHeight = lHeight;
        emit sHeightChanged();
      }
    }
    void fSetX(int lX) {
      if(lX != mX) {
        mX = lX;
        emit sXChanged();
      }
    }
    void fSetY(int lY) {
      if(lY != mY) {
        mY = lY;
        emit sYChanged();
      }
    }
    void fSetAnimationDuration(const QString& lAnimationDuration) {
      if(lAnimationDuration != mAnimationDuration) {
        mAnimationDuration = lAnimationDuration;
        emit sAnimationDurationChanged();
      }
    }
    void fSetCurrentVersion(const QString& lCurrentVersion) {
      if(lCurrentVersion != mCurrentVersion) {
        mCurrentVersion = lCurrentVersion;
        emit sCurrentVersionChanged();
      }
    }
    void fSetCurrentVersionName(const QString& lCurrentVersionName) {
      if(lCurrentVersionName != mCurrentVersionName) {
        mCurrentVersionName = lCurrentVersionName;
        emit sCurrentVersionNameChanged();
      }
    }
    void fSetTheme(const QString& lTheme) {
      if(lTheme != mTheme) {
        mTheme = lTheme;
        emit sThemeChanged();
      }
    }
    void fSetZoomFactor(const QString& lZoomFactor) {
      if(lZoomFactor != mZoomFactor) {
        mZoomFactor = lZoomFactor;
        emit sZoomFactorChanged();
      }
    }
    void fSetUpdateChannel(const QString& lUpdateChannel) {
      if(lUpdateChannel != mUpdateChannel) {
        mUpdateChannel = lUpdateChannel;
        emit sUpdateChannelChanged();
      }
    }
    void fSetUpdateCheckPeriod(const QString& lUpdateCheckPeriod) {
      if(lUpdateCheckPeriod != mUpdateCheckPeriod) {
        mUpdateCheckPeriod = lUpdateCheckPeriod;
        emit sUpdateCheckPeriodChanged();
      }
    }
    void fSetMinimizeOnClose(const QString& lMinimizeOnClose) {
      if(lMinimizeOnClose != mMinimizeOnClose) {
        mMinimizeOnClose = lMinimizeOnClose;
        emit sMinimizeOnCloseChanged();
      }
    }
    void fSetMinimizeToTray(const QString& lMinimizeToTray) {
      if(lMinimizeToTray != mMinimizeToTray) {
        mMinimizeToTray = lMinimizeToTray;
        emit sMinimizeToTrayChanged();
      }
    }

  public slots:
    void fSaveSettings();

  signals:
    void sAnimationDurationChanged();
    void sCurrentVersionChanged();
    void sCurrentVersionNameChanged();
    void sPanelMaxLinesChanged();
    void sSaveLogChanged();
    void sThemeChanged();
    void sZoomFactorChanged();
    void sWidthChanged();
    void sHeightChanged();
    void sXChanged();
    void sYChanged();
    void sUpdateChannelChanged();
    void sUpdateCheckPeriodChanged();
    void sMinimizeOnCloseChanged();
    void sMinimizeToTrayChanged();

  private:
    bool mSaveLog;
    int mPanelMaxLines;
    double mWidth;
    double mHeight;
    int mX;
    int mY;
    int mPulzarPort;
    QString mAnimationDuration;
    QString mCurrentVersion;
    QString mCurrentVersionName;
    QString mTheme;
    QString mZoomFactor;
    QString mPulzarHost;
    QString mUpdateChannel;
    QString mUpdateCheckPeriod;
    QString mRegion;
    QString mMinimizeOnClose;
    QString mMinimizeToTray;
};

#endif // CXDefinitions_H

