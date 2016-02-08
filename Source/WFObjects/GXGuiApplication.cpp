#include <QDate>
#include <QDir>
#include <QMenu>
#include <QSystemTrayIcon>
#include <QGuiApplication>
#include <QMetaObject>
#include <QPluginLoader>
#include <QQmlComponent>
#include <QQmlContext>
#include <QTextStream>
#include <QTime>
#include <QTimer>
#include <CXMessagePool.h>
#include <CXItemModel.h>
#include <CXItemModelProxy.h>
#include <GXComponent.h>
#include <GXWindow.h>

#include "GXGuiApplication.h"
#include "CXModulePanel.h"

GXGuiApplication::GXGuiApplication(int& lArgc, char** pArgv)
                : BXGuiApplication(lArgc, pArgv), mRequestID(0) {
  rTrayIcon = 0;
  QMetaObject::invokeMethod(this, "fInit", Qt::QueuedConnection);
}

GXGuiApplication::~GXGuiApplication() {
  delete rSplashWindow;
  delete rMainWindow;
}

bool GXGuiApplication::eventFilter(QObject* pObj, QEvent* pEvent) {
  if(pEvent->type() == QEvent::KeyPress) {
    QKeyEvent* pKeyEvent = static_cast<QKeyEvent*>(pEvent);
    rMainWindow->sKeyPressed(pKeyEvent->key(), pKeyEvent->modifiers());
  }
  if(pEvent->type() == QEvent::KeyRelease) {
    QKeyEvent* pKeyEvent = static_cast<QKeyEvent*>(pEvent);
    rMainWindow->sKeyReleased(pKeyEvent->key(), pKeyEvent->modifiers());
  }
  return QGuiApplication::eventFilter(pObj, pEvent);
}

bool GXGuiApplication::fPendingRequests(bool lLocalOnly) {
  QMapIterator<quint64, SXRequest> i(mPendingRequests);
  while(i.hasNext()) {
    i.next();
    if(!lLocalOnly || i.value().lStatus != CXDefinitions::ENotAppliable) return true;
  }
  return false;
}

void GXGuiApplication::fCheckUpdates() {
  if(mPulzarConnector.fConnectionStatus() == CXDefinitions::EServiceReady) {
    mPulzarConnector.tCheckUpdates(mDefinitions.fCurrentVersion(), mDefinitions.fRegion(), mDefinitions.fUpdateChannel());
  }
//-- Copy new version of wizard if available
  QString lWizard = cWizardExec;
  if(CXDefinitions::fCurrentOS() == CXDefinitions::EWindowsOS) lWizard.append(".exe");

  QFile mInstaller(QString("%1/%2/%3").arg(qApp->applicationDirPath()).arg(cTemporalDirectory).arg(lWizard));
  QFile mCurinstaller(QString("%1/%2").arg(qApp->applicationDirPath()).arg(lWizard));
  if(mInstaller.exists() && mCurinstaller.remove() && mInstaller.copy(QString("%1/%2").arg(qApp->applicationDirPath()).arg(lWizard))) {
    mInstaller.remove();
  }
//--
}

void GXGuiApplication::fInit() {
  fInitModels();
  fRegisterObjects();
  QString lBackupDirName(qApp->applicationDirPath() + "/" + cDefaultBackupDirectory);
  QDir lBackupDir(lBackupDirName);
  if(!lBackupDir.exists()) {
    if(!lBackupDir.mkpath(lBackupDirName)) fLogMessage(3200002, QStringList() << lBackupDirName, QString());
  }

  QQmlComponent lComSplash(&mEngine);
  QQmlComponent lComMain(&mEngine);
  lComSplash.loadUrl(QUrl::fromLocalFile(QString("WFUserInterface/%1/Layout/SplashScreen_UISplashScreen.qml").arg(mDefinitions.fTheme())));
  lComMain.loadUrl(QUrl::fromLocalFile(QString("WFUserInterface/%1/Layout/Panel_UIMainPanel.qml").arg(mDefinitions.fTheme())));
  setWindowIcon(QIcon(QString("WFUserInterface/%2/Images/SplashScreen_IMWorldcoinLogo.png").arg(mDefinitions.fTheme())));
  if(!lComSplash.isReady()) {
    qWarning("%s", qPrintable(lComSplash.errorString()));
    return;
  }
  if(!lComMain.isReady()) {
    qWarning("%s", qPrintable(lComSplash.errorString()));
    return;
  }
  if(!fLoadWapptoms(cWapptomsDir)) {
    fUpdateStatusText(3200011);
  }
  rSplashWindow = qobject_cast<GXWindow* >(lComSplash.create());
  rMainWindow = qobject_cast<GXWindow* >(lComMain.create());
  if(!fLoadConnectors(cConnectorsDir)) {
    fUpdateStatusText(3200007);
    return;
  }
  if(!fStartDaemons()) {
    fUpdateStatusText(3200007);
    return;
  }
  connect(&mEngine, SIGNAL(quit()), qApp, SLOT(quit()));
  connect(&mComponentManager, SIGNAL(sLogMessageRequest(int,QStringList,QString,int)), this, SLOT(fLogMessage(int,QStringList,QString,int)));
  connect(&mComponentManager, &CXComponentManager::sRawCallRequested, this, &GXGuiApplication::fRequestRawCall);
  connect(&mPulzarConnector, SIGNAL(sLogMessageRequest(int, QString, QString)), this, SLOT(fLogMessage(int,QString,QString)));
  connect(&mPulzarConnector, &CXPulzarConnector::sConnectionStatusChanged, this, &GXGuiApplication::fCheckUpdates);
  connect(rSplashWindow, SIGNAL(siTimeout()), rMainWindow, SLOT(show()));
  connect(rMainWindow, SIGNAL(closing(QQuickCloseEvent*)), this, SLOT(fOnClose()));
 // connect(this, SIGNAL(aboutToQuit()), this, SLOT(fOnClose()));
  connect(rMainWindow, SIGNAL(siCloseRequested()), this, SLOT(fOnClose()));
  connect(rMainWindow, SIGNAL(siLogMessageRequest(int, QString, QString)), this, SLOT(fLogMessage(int, QString, QString)));
  connect(&mCheckUpdates, &QTimer::timeout, this, &GXGuiApplication::fCheckUpdates);
  rSplashWindow->setVisible(true);
  rMainWindow->installEventFilter(this);
  mLogFile.setFileName(cDefaultLog);  
  mPulzarConnector.fSetServer(mDefinitions.fPulzarHost());
  mPulzarConnector.fSetPort(mDefinitions.fPulzarPort());
  if(mDefinitions.fSaveLog() && !mLogFile.open(QIODevice::WriteOnly)) {
    fLogMessage(3200001, QStringList() << mLogFile.fileName(), QString());
  }
  fLogMessage(1200001);
  fLogMessage(2200004);
  mPulzarConnector.tConnect();
  mCheckUpdates.start(mDefinitions.fUpdateCheckPeriod().toInt() * 3600 * 1000);

  if(QSystemTrayIcon::isSystemTrayAvailable()) {
    QAction* pQuit = new QAction(QIcon(fImageFile("Panel_IMShutdown.png")), tr("&Quit"), this);
    pQuit->setShortcuts(QKeySequence::Quit);
    pQuit->setStatusTip(tr("Shutdown WBC"));
    connect(pQuit, SIGNAL(triggered()), qApp, SLOT(quit()));
    QMenu* rTrayIconMenu = new QMenu();
    rTrayIconMenu->addAction(pQuit);
    rTrayIcon = new QSystemTrayIcon(this);
    rTrayIcon->setContextMenu(rTrayIconMenu);
    rTrayIcon->setIcon(QIcon(fImageFile("InfoBar_IMDaemonReady.svg")));
    rTrayIcon->setToolTip(tr("WBC Status: Initializing..."));
    rTrayIcon->show();
    connect(rTrayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)), this, SLOT(fRaisePanel()));
  }
}

void GXGuiApplication::fCheckMaxLines() {
  if(rLogModel->rowCount() > mDefinitions.fPanelMaxLines()) {
    int lLines = rLogModel->rowCount() - mDefinitions.fPanelMaxLines();
    rLogModel->removeRows(0, lLines);
  }
}

void GXGuiApplication::fInitModels() {
  rLogModel = new CXItemModel(0,1,this);
  rLogProxyModel = new CXItemModelProxy(this);
  rLogProxyModel->setSourceModel(rLogModel);
  QList<CXItemModelHeader*> lLabels;
  CXItemModelHeader* lCode = new CXItemModelHeader(tr("Code"), CXDefinitions::EKeyType);
  CXItemModelHeader* lDate = new CXItemModelHeader(tr("Date"), CXDefinitions::EDateType);
  CXItemModelHeader* lTime = new CXItemModelHeader(tr("Time"), CXDefinitions::ETimeType);
  CXItemModelHeader* lMessage = new CXItemModelHeader(tr("Message"), CXDefinitions::ETextType);

  lLabels << lCode << lDate << lTime << lMessage;
  rLogModel->fSetHorizontalHeaders(lLabels);
}

void GXGuiApplication::fRaisePanel() {
  if(rMainWindow->isExposed())
    rMainWindow->hide();
  else
    rMainWindow->showNormal();
}

void GXGuiApplication::fRegisterComponent(GXComponent *pComponent) {
  QString lName(QString("%1").arg(pComponent->fName()));
  mEngine.rootContext()->setContextProperty(lName, pComponent);
}

void GXGuiApplication::fRegisterObjects() {
  qmlRegisterSingletonType(QUrl(QString("file:///%1/WFUserInterface/AXLib/ACMeasures.qml").arg(qApp->applicationDirPath())), "ACMeasures.Lib", 1, 0, "ACMeasures" );
  qmlRegisterSingletonType(QUrl(QString("file:///%1/WFUserInterface/%2/SStyleSheet.qml").arg(qApp->applicationDirPath()).arg(mDefinitions.fTheme())), "SStyleSheet.Lib", 1, 0, "SStyleSheet" );
  qmlRegisterType<GXComponent>("WFCore.Lib", 1, 0, "GXComponent");
  qmlRegisterType<GXSubWindow>("WFCore.Lib", 1, 0, "GXSubWindow");
  qmlRegisterType<GXWindow>("WFCore.Lib", 1, 0, "GXWindow");
  qmlRegisterType<CXModulePanel>("WFObjects.Lib", 1, 0, "CXModulePanel");
  qmlRegisterType<CXDefinitions>("WFDefinitions.Lib", 1, 0, "CXDefinitions");

  mEngine.rootContext()->setContextProperty("mCXDefinitions", &mDefinitions);
  mEngine.rootContext()->setContextProperty("mCXStatus", &mStatus);
  mEngine.rootContext()->setContextProperty("mCXPulzarConnector", &mPulzarConnector);
  mEngine.rootContext()->setContextProperty("mLogModel", rLogProxyModel);
  mEngine.rootContext()->setContextProperty("mCXComponentManager", &mComponentManager);
}

void GXGuiApplication::fSaveMessage(const CXMessage& lMessage) {
  QTextStream lOut(&mLogFile);
  lOut << lMessage.fType() << "|" << lMessage.fCode() << "|" << QDate::currentDate().toString(cDefaultDateFormat) << "|"
       << QTime::currentTime().toString(cDefaultTimeFormat) << "|" << QString("%1. %2").arg(lMessage.fText()).arg(lMessage.fHelpText())
       << "|" << lMessage.fCustomText() << "\n";
}

bool GXGuiApplication::fStartDaemons() {
  fUpdateStatusText(2200003);
  if(!mConnectors.contains(cDefaultDaemon)) {
    fLogMessage(3200006);
    return false;
  }
  QMapIterator<QString, QSharedPointer<BXCryptoConnector> > i(mConnectors);
  while (i.hasNext()) {
    i.next();
    if((i.value()->fName() == cDefaultDaemon) && (!i.value()->fStart())) return false;
    if(i.value()->fIsEnabled() &&  i.value()->fName() != cDefaultDaemon) fLogMessage(3200024);
  }
  return true;
}

bool GXGuiApplication::fLoadConnectors(const QString& lDirName) {
  fUpdateStatusText(2200002);
  QDir lDir = QDir(lDirName);
  QStringList lMessageParams;
  QStringList lFileEntries = lDir.entryList(QDir::Files | QDir::NoSymLinks);
  for(int i = 0; i < lFileEntries.size(); i++) {
    lMessageParams.clear();
    QFile lFile(lDirName + "/" + lFileEntries.at(i));
    if(!lFile.open(QIODevice::ReadOnly)) {
      lMessageParams << lFile.fileName();
      fLogMessage(3200001, lMessageParams, QString());
      continue;
    }
    QPluginLoader lLoader(lFile.fileName());
    QSharedPointer<BXCryptoConnector> lConnector(qobject_cast<BXCryptoConnector*> (lLoader.instance()));
    if(lConnector) {
      mConnectors.insert(lConnector->fName(), lConnector);
      connect(lConnector.data(), SIGNAL(sLogMessageRequest(int,QStringList,QString,int)), this, SLOT(fLogMessage(int,QStringList,QString,int)));
      connect(lConnector.data(), &BXCryptoConnector::sStatusChanged, this, &GXGuiApplication::fUpdateDaemonStatus);
      connect(lConnector.data(), &BXCryptoConnector::sReply, this, &GXGuiApplication::fUpdateValue);
      connect(lConnector.data(), &BXCryptoConnector::sReplyJson, this, &GXGuiApplication::fUpdateValueJson);
      lConnector->fLoadSettings();
      lConnector->fSetup();
    }
    else {
      lMessageParams << lFile.fileName() << lLoader.errorString();
      fLogMessage(3200008, lMessageParams, QString());
      mStatus.tSetDaemonStatus(/*cDefaultDaemon,*/ CXDefinitions::EServiceError);
      return false;
    }
  }
  return true;
}

bool GXGuiApplication::fLoadWapptoms(const QString& lDirName) {
  fUpdateStatusText(2200005);
  //mWapptomValues.clear();
  QDir lDir = QDir(lDirName);
  QStringList lMessageParams;
  QStringList lFileEntries = lDir.entryList(QDir::Files | QDir::NoSymLinks);
  for(int i = 0; i < lFileEntries.size(); i++) {
    lMessageParams.clear();
    QFile lFile(lDirName + "/" + lFileEntries.at(i));
    if(!lFile.open(QIODevice::ReadOnly)) {
      lMessageParams << lFile.fileName();
      fLogMessage(3200001, lMessageParams, QString());
      continue;
    }
    QPluginLoader lLoader(lFile.fileName());
    QSharedPointer<BXWapptom> lWapptom(qobject_cast<BXWapptom*> (lLoader.instance()));
    if(lWapptom) {
      mWapptoms.insert(lWapptom->fName(), lWapptom);
//      connect(lWapptom.data(), &BXCryptoConnector::sLogMessageRequest, this, &GXGuiApplication::fLogMessage);
      lWapptom->fSetup();
      connect(lWapptom.data(), &BXWapptom::sUpdateValue, this, &GXGuiApplication::fRequestUpdateWapptomValue);
      mEngine.rootContext()->setContextProperty(lWapptom->fName(), lWapptom.data());
    }
    else {
      lMessageParams << lFile.fileName() << lLoader.errorString();
      fLogMessage(3200008, lMessageParams, QString());
      mStatus.tSetDaemonStatus(/*cDefaultDaemon,*/ CXDefinitions::EServiceError);
      return false;
    }
  }
  return true;
}

void GXGuiApplication::fLogMessage(int lCode, const QString& lParameter, const QString& lCustomText) {
  fLogMessage (lCode, QStringList() << lParameter, lCustomText);
}

void GXGuiApplication::fLogMessage(int lCode, const QStringList &lParameters, const QString& lCustomText, int lLogType) {
  if(lLogType != CXDefinitions::ELogNone) {
    CXMessage lMessage(CXMessagePool::fMessage(lCode, lParameters, lCustomText));
    if((lLogType == CXDefinitions::ELogPanel) || (lLogType == CXDefinitions::ELogAll)) {
      QString lMessageText = QString("%1 %2").arg(lMessage.fText()).arg(lMessage.fHelpText());
      lMessageText.remove("\n");
      QList<QStandardItem*> lList;
      QStandardItem* lCodeItem = new QStandardItem();
      lCodeItem->setData(lCode, CXDefinitions::EDisplayRole);
      lCodeItem->setData(lMessage.fType(), CXDefinitions::EMessageTypeRole);
      QStandardItem* lDateItem = new QStandardItem();
      lDateItem->setData(QDate::currentDate().toString(cDefaultDateFormat), CXDefinitions::EDisplayRole);
      QStandardItem* lTimeItem = new QStandardItem();
      lTimeItem->setData(QTime::currentTime().toString(cDefaultTimeFormat), CXDefinitions::EDisplayRole);
      QStandardItem* lMessageItem = new QStandardItem();
      lMessageItem->setData(lMessageText, CXDefinitions::EDisplayRole);
      lList << lCodeItem << lDateItem << lTimeItem << lMessageItem;
      rLogModel->appendRow(lList);
    }
    if((lLogType == CXDefinitions::ELogDisk) || (lLogType == CXDefinitions::ELogAll))
      fSaveMessage(lMessage);

    fCheckMaxLines();
  }
}

void GXGuiApplication::fRequestRawCall(const QString& lConnector, const QString& lRawRequest, const QString &lComponentName, bool lParse, int lLogType){
  mRequestID += 1;
  if(!mConnectors.contains(lConnector)) {
    fLogMessage(5200002, QStringList() << lConnector, tr("Component : '%1'").arg(lComponentName));
    mComponentManager.fProcessMessage(CXDefinitions::EBugMessage, mRequestID, QString(), lComponentName, QString());
    return;
  }
  if(mConnectors.value(lConnector)->fStatus() != CXDefinitions::EServiceReady) {
    mComponentManager.fProcessMessage(CXDefinitions::EWarningMessage, mRequestID, QString(), lComponentName, tr("Daemon not ready ! Connector '%1'").arg(lConnector));
    return;
  }  
  SXRequest lCurrentRequest;
  lCurrentRequest.lInput = lRawRequest.simplified();
  lCurrentRequest.lOutput = QString();
  lCurrentRequest.lName = lComponentName;
  lCurrentRequest.lType = CXDefinitions::ERawCall;
  lCurrentRequest.lConnector = lConnector;
  lCurrentRequest.lResponseStateIsAnswer = false;
  lCurrentRequest.lParse = lParse;
  lCurrentRequest.lLogType = lLogType;
  if(fPendingRequests(true)) {
    lCurrentRequest.lStatus = CXDefinitions::ERequestQueued;
    mPendingRequests.insert(mRequestID, lCurrentRequest);
    QMapIterator<quint64, SXRequest> i(mPendingRequests);
    while(i.hasNext() && (mPendingRequests.count() > cConnectorRequestQueue)) {
      i.next();
      if(i.value().lStatus == CXDefinitions::ERequestQueued) mPendingRequests.remove(i.key());
    }
  }
  else {
    lCurrentRequest.lStatus = CXDefinitions::ERequestProcessing;
    mPendingRequests.insert(mRequestID, lCurrentRequest);
    mConnectors.value(lConnector)->fExecute(CXDefinitions::ERawCall, mRequestID, lCurrentRequest.lInput, lCurrentRequest.lOutput, false, lParse, lLogType);
  }
}

void GXGuiApplication::fRequestUpdateWapptomValue(const QString &lWapptomName) {
  if(mStatus.fDaemonStatus() != CXDefinitions::EServiceReady)
    return;
  BXWapptom* pWapptom = 0;
  if(!mWapptoms.contains(lWapptomName)) {
    fLogMessage(5200003, QStringList() << pWapptom->fName() << pWapptom->fConnector(), QString());
    return;
  }
  pWapptom = mWapptoms.value(lWapptomName).data();
  QString lConnector(pWapptom->fConnector());
  if(pWapptom->fType() == CXDefinitions::EWapptomWallet) {
    if(!mConnectors.contains(lConnector)) {
      fLogMessage(5200002, QStringList() << pWapptom->fConnector(), QString());
      return;
    }
  }
  mRequestID += 1;
  SXRequest lCurrentRequest;
  lCurrentRequest.lInput = pWapptom->fInput();
  lCurrentRequest.lOutput = pWapptom->fOutput();
  lCurrentRequest.lName = pWapptom->fName();
  lCurrentRequest.lType = CXDefinitions::EWapptom;
  lCurrentRequest.lConnector = lConnector;
  lCurrentRequest.lResponseStateIsAnswer = pWapptom->fResponseStateIsAnswer();
  lCurrentRequest.lParse = true;
  lCurrentRequest.lLogType = CXDefinitions::ELogAll;

  if(pWapptom->fType() == CXDefinitions::EWapptomWallet) {
    if(fPendingRequests(true)) {
      lCurrentRequest.lStatus = CXDefinitions::ERequestQueued;
      mPendingRequests.insert(mRequestID, lCurrentRequest);
      QMapIterator<quint64, SXRequest> i(mPendingRequests);
      while(i.hasNext() && (mPendingRequests.count() > cConnectorRequestQueue)) {
        i.next();
        if(i.value().lStatus == CXDefinitions::ERequestQueued) mPendingRequests.remove(i.key());
      }
    }
    else {
      lCurrentRequest.lStatus = CXDefinitions::ERequestProcessing;
      mPendingRequests.insert(mRequestID, lCurrentRequest);
      mConnectors.value(lConnector)->fExecute(CXDefinitions::EWapptom, mRequestID, pWapptom->fInput(), pWapptom->fOutput(), pWapptom->fResponseStateIsAnswer(), true);
    }
  }
  if(pWapptom->fType() == CXDefinitions::EWapptomNetwork) {
    lCurrentRequest.lStatus = CXDefinitions::ENotAppliable;
    mPendingRequests.insert(mRequestID, lCurrentRequest);
    QNetworkRequest lRequest;
    lRequest.setUrl(QUrl(pWapptom->fInput()));

    QNetworkReply* pNetworkReply = rNetworkAccess->get(lRequest);
    connect(pNetworkReply, SIGNAL(finished()), this, SLOT(fProcessNetworkRequest()));
//    connect(pNetworkReply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(tProcessNetworkError(QNetworkReply::NetworkError)));
    pNetworkReply->setProperty("yRequestID", mRequestID);
  }
}

void GXGuiApplication::fProcessNetworkRequest() {
  QNetworkReply* pReply = qobject_cast<QNetworkReply* > (sender());
  if(!pReply) {
    fLogMessage(5200010, QStringList(), QString());
    return;
  }
  quint64 lRequestID = pReply->property("yRequestID").toULongLong();
  if(!mPendingRequests.contains(lRequestID)) {
   fLogMessage(5200004, QStringList() << QString::number(lRequestID), QString());
     pReply->deleteLater();
    return;
  }
  SXRequest lRequest = mPendingRequests.value(lRequestID);
  if((pReply->error() == QNetworkReply::NoError)) {
    BXWapptom* pWapptom = mWapptoms.value(lRequest.lName).data();
    if(pWapptom->fOutput().isEmpty()) pWapptom->tSetValue(QString(pReply->readAll()));
    else {
      QString lResponse(QString(pReply->readAll()));
      lResponse.remove(0,1);
      lResponse.remove(lResponse.size() - 1,1);
      lResponse.remove("\"");
      QStringList lVals(lResponse.split(","));
      for(const QString& lVal : lVals) {
         QString lCur = lVal.section(":",0,0).simplified();
         if(lCur == pWapptom->fOutput()) {
           lResponse = lVal.section(":",1,-1);
           break;
         }
      }
      pWapptom->tSetValue(lResponse);
    }
  }
  else fLogMessage(3200022, QStringList() << lRequest.lName << QString::number(lRequestID) << lRequest.lInput << pReply->errorString(), QString());
  pReply->deleteLater();
  mPendingRequests.remove(lRequestID);
}

void GXGuiApplication::fUpdateValue(bool lSuccess, quint64 lRequestID, const QString &lValue) {
 /* if(!mPendingRequests.contains(lRequestID)) {
    fLogMessage(5200004, QStringList() << QString::number(lRequestID), QString());
    return;
  } */
  SXRequest lRequest = mPendingRequests.value(lRequestID);
  int lMessageType;
  if(lSuccess) lMessageType = CXDefinitions::ESuccessMessage;
  else lMessageType = CXDefinitions::EErrorMessage;
  mPendingRequests.remove(lRequestID);
  if(lSuccess && lRequest.lType == CXDefinitions::EWapptom) {
    bool lInitialized = mWapptoms.value(lRequest.lName)->fInitialized();
    mWapptoms.value(lRequest.lName)->tSetValue(lValue);
    if(rTrayIcon && (lRequest.lName == "WABalance") && lInitialized) {
      double lPrevious = mWapptoms.value(lRequest.lName)->fPreviousValue().toDouble();
      double lCurrent = mWapptoms.value(lRequest.lName)->fValue().toDouble();
      double lTotal = lCurrent - lPrevious;
      if(lTotal > 0) rTrayIcon->showMessage(tr("Coins arrived!"), tr("Amount: %1\nNew balance: %2").arg(QString::number(lTotal, 'f', 8)).arg(QString::number(lPrevious, 'f', 8)), QSystemTrayIcon::Information);
      if(lTotal < 0) rTrayIcon->showMessage(tr("Coins sent!"), tr("Amount: %1\nNew balance: %2").arg(QString::number(lTotal, 'f', 8)).arg(QString::number(lPrevious, 'f', 8)), QSystemTrayIcon::Information);
    }
  }
  if(lRequest.lType == CXDefinitions::ERawCall) mComponentManager.fProcessMessage(lMessageType, lRequestID, lRequest.lInput, lRequest.lName, lValue);
  QMapIterator<quint64, SXRequest> i(mPendingRequests);
  while(i.hasNext()) {
    i.next();
    if(i.value().lStatus == CXDefinitions::ERequestQueued) {
      mPendingRequests[i.key()].lStatus = CXDefinitions::ERequestProcessing;
      mConnectors.value(i.value().lConnector)->fExecute(i.value().lType, i.key(), i.value().lInput, i.value().lOutput, i.value().lResponseStateIsAnswer, i.value().lParse, i.value().lLogType);
      break;
    }
  }
}

void GXGuiApplication::fUpdateValueJson(bool lSuccess, quint64 lRequestID, const QJsonValue& lValue) {
 /* if(!mPendingRequests.contains(lRequestID)) {
    fLogMessage(5200004, QStringList() << QString::number(lRequestID), QString());
    return;
  } */
  SXRequest lRequest = mPendingRequests.value(lRequestID);
  int lMessageType;
  if(lSuccess) lMessageType = CXDefinitions::ESuccessMessage;
  else lMessageType = CXDefinitions::EErrorMessage;
  if(lRequest.lType == CXDefinitions::ERawCall) mComponentManager.fProcessMessage(lMessageType, lRequestID, lRequest.lInput, lRequest.lName, lValue);
  mPendingRequests.remove(lRequestID);
  QMapIterator<quint64, SXRequest> i(mPendingRequests);
  while(i.hasNext()) {
    i.next();
    if(i.value().lStatus == CXDefinitions::ERequestQueued) {
      mPendingRequests[i.key()].lStatus = CXDefinitions::ERequestProcessing;
      mConnectors.value(i.value().lConnector)->fExecute(i.value().lType, i.key(), i.value().lInput, i.value().lOutput, i.value().lResponseStateIsAnswer, i.value().lParse, i.value().lLogType);
      break;
    }
  }
}

void GXGuiApplication::fUpdateDaemonStatus(const QString& lConnectorName, int lDaemonStatus) {
  if(lConnectorName == cDefaultDaemon) {
    mStatus.tSetDaemonStatus(/*lConnectorName,*/ lDaemonStatus);
    if(lDaemonStatus == CXDefinitions::EServiceStopped) fUpdateStatusText(2200007, QStringList() << lConnectorName);
    if(lDaemonStatus == CXDefinitions::EServiceProcessing) fUpdateStatusText(2200008, QStringList() << lConnectorName);
    if(lDaemonStatus == CXDefinitions::EServiceReady) fUpdateStatusText(2200001);
    if(lDaemonStatus == CXDefinitions::EServiceError) fUpdateStatusText(3200015, QStringList() << lConnectorName);
    if(rTrayIcon) rTrayIcon->setToolTip(tr("WBC Status: %1").arg(mStatus.fStatusText()));
  }
}

void GXGuiApplication::fUpdateStatusText(int lCode, const QStringList& lParameters) {
  CXMessage lMessage(CXMessagePool::fMessage(lCode, lParameters, QString()));
  mStatus.tSetStatusText(lMessage.fText());
}


void GXGuiApplication::fOnClose() {    
  if(mDefinitions.fMinimizeOnClose().toInt()) {
    rMainWindow->hide();
  }
  else {
    fUpdateStatusText(2200009);
    mDefinitions.fSaveSettings();

    QMapIterator<QString, QSharedPointer<BXCryptoConnector> > i(mConnectors);
    while (i.hasNext()) {
      i.next();
      i.value()->fEndService();
    }
    QDir lLogDir(cDefaultLogDirectory);
    if(!lLogDir.exists()) {
      if(!QDir::current().mkdir(cDefaultLogDirectory)) fLogMessage(3200002, QStringList() << cDefaultLogDirectory, QString());
    }
    else {
      QString lBackupName;
      int lBackupNumber = 1;
      while(true) {
        lBackupName = cDefaultLogDirectory + "/" + cDefaultLog.section(".",0,0) + "_" + QDate::currentDate().toString(cDefaultDateFormat) + "." + cDefaultLog.section(".",1,-1) + "." + QString::number(lBackupNumber);
        QFile lBackupFile(lBackupName);
        if(lBackupFile.exists()) lBackupNumber++;
        else break;
      }
      if(mLogFile.isOpen()) mLogFile.close();
      if(!QFile::copy(cDefaultLog, lBackupName)) fLogMessage(3200003, QStringList() << cDefaultLogDirectory << lBackupName, QString());
      if(mLogFile.exists() && !mLogFile.remove()) fLogMessage(3200004, QStringList() << mLogFile.fileName(), QString());
    }
    qApp->quit();
  }
}
