#include <QDate>
#include <QDir>
#include <QMenu>
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
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::eventFilter -- 1", QString(), CXDefinitions::ELogDisk);
  if(pEvent->type() == QEvent::KeyPress) {
    QKeyEvent* pKeyEvent = static_cast<QKeyEvent*>(pEvent);
    rMainWindow->sKeyPressed(pKeyEvent->key(), pKeyEvent->modifiers());
  }
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::eventFilter -- 2", QString(), CXDefinitions::ELogDisk);
  if(pEvent->type() == QEvent::KeyRelease) {
    QKeyEvent* pKeyEvent = static_cast<QKeyEvent*>(pEvent);
    rMainWindow->sKeyReleased(pKeyEvent->key(), pKeyEvent->modifiers());
  }
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::eventFilter -- 3", QString(), CXDefinitions::ELogDisk);
  return QGuiApplication::eventFilter(pObj, pEvent);
}

bool GXGuiApplication::fPendingRequests(bool lLocalOnly) {
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fPendingRequests -- 4", QString(), CXDefinitions::ELogDisk);
  QMapIterator<quint64, SXRequest> i(mPendingRequests);
  while(i.hasNext()) {
    i.next();
    if(!lLocalOnly || i.value().lStatus != CXDefinitions::ENotAppliable) return true;
  }
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fPendingRequests -- 5", QString(), CXDefinitions::ELogDisk);
  return false;
}

void GXGuiApplication::fCheckUpdates() {
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fCheckUpdates -- 6", QString(), CXDefinitions::ELogDisk);
  if(mPulzarConnector.fConnectionStatus() == CXDefinitions::EServiceReady) {
    mPulzarConnector.tCheckUpdates(mDefinitions.fCurrentVersion(), mDefinitions.fRegion(), mDefinitions.fUpdateChannel());
  }
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fCheckUpdates -- 7", QString(), CXDefinitions::ELogDisk);
//-- Copy new version of wizard if available
  QString lWizard = cWizardExec;
  if(CXDefinitions::fCurrentOS() == CXDefinitions::EWindowsOS) lWizard.append(".exe");

  QFile mInstaller(QString("%1/%2/%3").arg(qApp->applicationDirPath()).arg(cTemporalDirectory).arg(lWizard));
  QFile mCurinstaller(QString("%1/%2").arg(qApp->applicationDirPath()).arg(lWizard));
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fCheckUpdates -- 8", QString(), CXDefinitions::ELogDisk);
  if(mInstaller.exists() && mCurinstaller.remove() && mInstaller.copy(QString("%1/%2").arg(qApp->applicationDirPath()).arg(lWizard))) {
    mInstaller.remove();
  }
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fCheckUpdates -- 9", QString(), CXDefinitions::ELogDisk);
//--
}

void GXGuiApplication::fInit() {
  fInitModels();
  mLogFile.setFileName(cDefaultLog);
  if(mDefinitions.fSaveLog() && !mLogFile.open(QIODevice::WriteOnly)) {
    fLogMessage(3200001, QStringList() << mLogFile.fileName(), QString());
  }
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fInit -- 10", QString(), CXDefinitions::ELogDisk);
  fRegisterObjects();
  QString lBackupDirName(qApp->applicationDirPath() + "/" + cDefaultBackupDirectory);
  QDir lBackupDir(lBackupDirName);
  if(!lBackupDir.exists()) {
    if(!lBackupDir.mkpath(lBackupDirName)) fLogMessage(3200002, QStringList() << lBackupDirName, QString());
  }
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fInit -- 11", QString(), CXDefinitions::ELogDisk);
  QQmlComponent lComSplash(&mEngine);
  QQmlComponent lComMain(&mEngine);
  lComSplash.loadUrl(QUrl::fromLocalFile(QString("WFUserInterface/%1/Layout/SplashScreen_UISplashScreen.qml").arg(mDefinitions.fTheme())));
  lComMain.loadUrl(QUrl::fromLocalFile(QString("WFUserInterface/%1/Layout/Panel_UIMainPanel.qml").arg(mDefinitions.fTheme())));
  setWindowIcon(QIcon(QString("WFUserInterface/%2/Images/SplashScreen_IMWorldcoinLogo.png").arg(mDefinitions.fTheme())));
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fInit -- 12", QString(), CXDefinitions::ELogDisk);
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
    QMetaObject::invokeMethod(qApp, "quit", Qt::QueuedConnection);
  }
//  rSplashWindow = qobject_cast<GXWindow* >(lComSplash.create());
//  rMainWindow = qobject_cast<GXWindow* >(lComMain.create());
  if(!fLoadConnectors(cConnectorsDir)) {
    fUpdateStatusText(3200007);
    QMetaObject::invokeMethod(qApp, "quit", Qt::QueuedConnection);
  }
  if(!mConnectorManager.fStartDaemons()) {
    fUpdateStatusText(3200007);
    QMetaObject::invokeMethod(qApp, "quit", Qt::QueuedConnection);
  }
  rSplashWindow = qobject_cast<GXWindow* >(lComSplash.create());
  rMainWindow = qobject_cast<GXWindow* >(lComMain.create());

// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fInit -- 14", QString(), CXDefinitions::ELogDisk);
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
  mPulzarConnector.fSetServer(mDefinitions.fPulzarHost());
  mPulzarConnector.fSetPort(mDefinitions.fPulzarPort());
  fLogMessage(1200001);
  fLogMessage(2200004);
  mPulzarConnector.tConnect();
  mCheckUpdates.start(mDefinitions.fUpdateCheckPeriod().toInt() * 3600 * 1000);
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fInit -- 15", QString(), CXDefinitions::ELogDisk);
  if(QSystemTrayIcon::isSystemTrayAvailable()) {
    QAction* pQuit = new QAction(QIcon(fImageFile("Panel_IMShutdown.png")), tr("&Quit"), this);
    pQuit->setShortcuts(QKeySequence::Quit);
    pQuit->setStatusTip(tr("Shutdown WBC"));
    connect(pQuit, SIGNAL(triggered()), qApp, SLOT(quit()));
    QMenu* rTrayIconMenu = new QMenu();
    rTrayIconMenu->addAction(pQuit);
    rTrayIcon = new QSystemTrayIcon(this);
    rTrayIcon->setContextMenu(rTrayIconMenu);
    rTrayIcon->setIcon(QIcon(fImageFile("InfoBar_IMDaemonReady.png")));
    rTrayIcon->setToolTip(tr("WBC Status: Initializing..."));
    rTrayIcon->show();
    connect(rTrayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)), this, SLOT(fRaisePanel(QSystemTrayIcon::ActivationReason)));
  }
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fInit -- 16", QString(), CXDefinitions::ELogDisk);
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

void GXGuiApplication::fRaisePanel(QSystemTrayIcon::ActivationReason eReason) {
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRaisePanel -- 21", QString(), CXDefinitions::ELogDisk);
  if(eReason == QSystemTrayIcon::Trigger) {
    if(rMainWindow->isExposed())
      rMainWindow->hide();
    else
      rMainWindow->showNormal();
  }
// fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRaisePanel -- 22", QString(), CXDefinitions::ELogDisk);
}

void GXGuiApplication::fRegisterComponent(GXComponent *pComponent) {
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRaisePanel -- 23", QString(), CXDefinitions::ELogDisk);
  QString lName(QString("%1").arg(pComponent->fName()));
  mEngine.rootContext()->setContextProperty(lName, pComponent);
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRaisePanel -- 24", QString(), CXDefinitions::ELogDisk);
}

void GXGuiApplication::fRegisterObjects() {
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRegisterObjects -- 25", QString(), CXDefinitions::ELogDisk);
  qmlRegisterSingletonType(QUrl(QString("file:///%1/WFUserInterface/AXLib/ACMeasures.qml").arg(qApp->applicationDirPath())), "ACMeasures.Lib", 1, 0, "ACMeasures" );
  qmlRegisterSingletonType(QUrl(QString("file:///%1/WFUserInterface/%2/SStyleSheet.qml").arg(qApp->applicationDirPath()).arg(mDefinitions.fTheme())), "SStyleSheet.Lib", 1, 0, "SStyleSheet" );
  qmlRegisterType<GXComponent>("WFCore.Lib", 1, 0, "GXComponent");
  qmlRegisterType<GXSubWindow>("WFCore.Lib", 1, 0, "GXSubWindow");
  qmlRegisterType<GXWindow>("WFCore.Lib", 1, 0, "GXWindow");
  qmlRegisterType<CXModulePanel>("WFObjects.Lib", 1, 0, "CXModulePanel");
  qmlRegisterType<CXDefinitions>("WFDefinitions.Lib", 1, 0, "CXDefinitions");
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRegisterObjects -- 26", QString(), CXDefinitions::ELogDisk);
  mEngine.rootContext()->setContextProperty("mCXDefinitions", &mDefinitions);
  mEngine.rootContext()->setContextProperty("mCXPulzarConnector", &mPulzarConnector);
  mEngine.rootContext()->setContextProperty("mLogModel", rLogProxyModel);
  mEngine.rootContext()->setContextProperty("mCXComponentManager", &mComponentManager);
  mEngine.rootContext()->setContextProperty("mCXConnectorManager", &mConnectorManager);
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRegisterObjects -- 27", QString(), CXDefinitions::ELogDisk);
}

void GXGuiApplication::fSaveMessage(const CXMessage& lMessage) {
  QTextStream lOut(&mLogFile);
  lOut << lMessage.fType() << "|" << lMessage.fCode() << "|" << QDate::currentDate().toString(cDefaultDateFormat) << "|"
       << QTime::currentTime().toString(cDefaultTimeFormat) << "|" << QString("%1. %2").arg(lMessage.fText()).arg(lMessage.fHelpText())
       << "|" << lMessage.fCustomText() << "\n";
}

void GXGuiApplication::fExecuteWizard() {
    QString lWizard = qApp->applicationDirPath() + "/" + cWizardExec;
    if(CXDefinitions::fCurrentOS() == CXDefinitions::EWindowsOS) lWizard.append(".exe");
    QProcess::startDetached(lWizard, QStringList() << "--install");
    QTimer::singleShot(0, qApp, SLOT(quit()));
}

bool GXGuiApplication::fLoadConnectors(const QString& lDirName) {
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fLoadConnectors -- 33", QString(), CXDefinitions::ELogDisk);
  fUpdateStatusText(2200002);
  QDir lDir = QDir(lDirName);
  QStringList lMessageParams;
  QStringList lFileEntries = lDir.entryList(QDir::Files | QDir::NoSymLinks);
  for(int i = 0; i < lFileEntries.size(); i++) {
    lMessageParams.clear();
    QFile lFile(lDirName + "/" + lFileEntries.at(i));
   /* if(!lFile.open(QIODevice::ReadOnly)) {
      lMessageParams << lFile.fileName();
      fLogMessage(3200001, lMessageParams, QString());
      continue;
    }*/
    QPluginLoader lLoader(lFile.fileName());
    BXCryptoConnector* pConnector = qobject_cast<BXCryptoConnector*> (lLoader.instance());
    if(pConnector) {
      mConnectorManager.insert(pConnector);
      connect(pConnector, SIGNAL(sLogMessageRequest(int,QStringList,QString,int)), this, SLOT(fLogMessage(int,QStringList,QString,int)));
      connect(pConnector, &BXCryptoConnector::sStatusChanged, this, &GXGuiApplication::fUpdateTrayIconStatus);
      connect(pConnector, &BXCryptoConnector::sReply, this, &GXGuiApplication::fUpdateValue);
      connect(pConnector, &BXCryptoConnector::sReplyJson, this, &GXGuiApplication::fUpdateValueJson);
      pConnector->fLoadSettings();
      pConnector->fSaveSettings();
      pConnector->fSetup();
    }
    else {
      lMessageParams << lFile.fileName() << lLoader.errorString();
      fLogMessage(3200008, lMessageParams, QString());
      mConnectorManager.fSetStatus(cDefaultDaemon, CXDefinitions::EServiceError);
      return false;
    }
  }
 // mEngine.rootContext()->setContextProperty("mConnectorList", &mConnectorList);
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fLoadConnectors -- 34", QString(), CXDefinitions::ELogDisk);
  return true;
}

bool GXGuiApplication::fLoadWapptoms(const QString& lDirName) {
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fLoadWapptoms -- 35", QString(), CXDefinitions::ELogDisk);
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
      lWapptom->fSetName(lWapptom->fBaseName());
      mWapptoms.insert(lWapptom->fName(), lWapptom);
//      connect(lWapptom.data(), &BXCryptoConnector::sLogMessageRequest, this, &GXGuiApplication::fLogMessage);
      lWapptom->fSetup();
      lWapptom->tSetConnector("WDC");
      connect(lWapptom.data(), &BXWapptom::sUpdateValue, this, &GXGuiApplication::fRequestUpdateWapptomValue);
      mEngine.rootContext()->setContextProperty(lWapptom->fName(), lWapptom.data());

      //### BTC
      QSharedPointer<BXWapptom> lWapptomBTC(lWapptom.data()->fCreate());
      if(lWapptomBTC) {
        lWapptomBTC->fSetName(lWapptom->fBaseName() + "BTC");
        mWapptoms.insert(lWapptomBTC->fName(), lWapptomBTC);
        lWapptomBTC->fSetup();
        lWapptomBTC->tSetConnector("BTC");
        connect(lWapptomBTC.data(), &BXWapptom::sUpdateValue, this, &GXGuiApplication::fRequestUpdateWapptomValue);
        mEngine.rootContext()->setContextProperty(lWapptomBTC->fName(), lWapptomBTC.data());
      }
      //###

      //### LTC
      QSharedPointer<BXWapptom> lWapptomLTC(lWapptom.data()->fCreate());
      if(lWapptomLTC) {
        lWapptomLTC->fSetName(lWapptom->fBaseName() + "LTC");
        mWapptoms.insert(lWapptomLTC->fName(), lWapptomLTC);
        lWapptomLTC->fSetup();
        lWapptomLTC->tSetConnector("LTC");
        connect(lWapptomLTC.data(), &BXWapptom::sUpdateValue, this, &GXGuiApplication::fRequestUpdateWapptomValue);
        mEngine.rootContext()->setContextProperty(lWapptomLTC->fName(), lWapptomLTC.data());
      }
      //###

      //### DOGE
      QSharedPointer<BXWapptom> lWapptomDOGE(lWapptom.data()->fCreate());
      if(lWapptomDOGE) {
        lWapptomDOGE->fSetName(lWapptom->fBaseName() + "DOGE");
        mWapptoms.insert(lWapptomDOGE->fName(), lWapptomDOGE);
        lWapptomDOGE->fSetup();
        lWapptomDOGE->tSetConnector("DOGE");
        connect(lWapptomDOGE.data(), &BXWapptom::sUpdateValue, this, &GXGuiApplication::fRequestUpdateWapptomValue);
        mEngine.rootContext()->setContextProperty(lWapptomDOGE->fName(), lWapptomDOGE.data());
      }
      //###
    }
    else {
      lMessageParams << lFile.fileName() << lLoader.errorString();
      fLogMessage(3200008, lMessageParams, QString());
      mConnectorManager.fSetStatus(cDefaultDaemon, CXDefinitions::EServiceError);
      return false;
    }
  }
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fLoadWapptoms -- 35", QString(), CXDefinitions::ELogDisk);
  return true;
}

void GXGuiApplication::fLogMessage(int lCode, const QString& lParameter, const QString& lCustomText) {
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fLogMessage -- 36", QString(), CXDefinitions::ELogDisk);
  fLogMessage (lCode, QStringList() << lParameter, lCustomText);
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fLogMessage -- 37", QString(), CXDefinitions::ELogDisk);
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
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRequestRawCall -- 41", QString(), CXDefinitions::ELogDisk);
  mRequestID += 1;
  if(!mConnectorManager.contains(lConnector)) {
    fLogMessage(5200002, QStringList() << lConnector, tr("Component : '%1'").arg(lComponentName));
    mComponentManager.fProcessMessage(CXDefinitions::EBugMessage, mRequestID, QString(), lComponentName, QString(), lConnector);
    return;
  }
  if(mConnectorManager.fConnector(lConnector)->fStatus() != CXDefinitions::EServiceReady) {
    mComponentManager.fProcessMessage(CXDefinitions::EWarningMessage, mRequestID, QString(), lComponentName, tr("Daemon not ready ! Connector '%1'").arg(lConnector), lConnector);
    return;
  }  
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRequestRawCall -- 42", QString(), CXDefinitions::ELogDisk);
  SXRequest lCurrentRequest;
  lCurrentRequest.lInput = lRawRequest.simplified();
  lCurrentRequest.lOutput = QString();
  lCurrentRequest.lName = lComponentName;
  lCurrentRequest.lType = CXDefinitions::ERawCall;
  lCurrentRequest.lConnector = lConnector;
  lCurrentRequest.lResponseStateIsAnswer = false;
  lCurrentRequest.lParse = lParse;
  lCurrentRequest.lLogType = lLogType;
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRequestRawCall -- 43", QString(), CXDefinitions::ELogDisk);
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
    mConnectorManager.fConnector(lConnector)->fExecute(CXDefinitions::ERawCall, mRequestID, lCurrentRequest.lInput, lCurrentRequest.lOutput, false, lParse, lLogType);
  }
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRequestRawCall -- 44", QString(), CXDefinitions::ELogDisk);
}

void GXGuiApplication::fRequestUpdateWapptomValue(const QString &lWapptomName) {
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRequestUpdateWapptomValue -- 45", QString(), CXDefinitions::ELogDisk);
  BXWapptom* pWapptom = 0;
  if(!mWapptoms.contains(lWapptomName)) {
    fLogMessage(5200003, QStringList() << pWapptom->fName() << pWapptom->fConnector(), QString());
    return;
  }
  pWapptom = mWapptoms.value(lWapptomName).data();
  if(mConnectorManager.fStatus(pWapptom->fConnector()) != CXDefinitions::EServiceReady)
    return;
  QString lConnector(pWapptom->fConnector());
  if(pWapptom->fType() == CXDefinitions::EWapptomWallet) {
    if(!mConnectorManager.contains(lConnector)) {
      fLogMessage(5200002, QStringList() << pWapptom->fConnector(), QString());
      return;
    }
  }
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRequestUpdateWapptomValue -- 46", QString(), CXDefinitions::ELogDisk);
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
      mConnectorManager.fConnector(lConnector)->fExecute(CXDefinitions::EWapptom, mRequestID, pWapptom->fInput(), pWapptom->fOutput(), pWapptom->fResponseStateIsAnswer(), true);
    }
  }
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRequestUpdateWapptomValue -- 47", QString(), CXDefinitions::ELogDisk);
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
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fRequestUpdateWapptomValue -- 48", QString(), CXDefinitions::ELogDisk);
}

void GXGuiApplication::fProcessNetworkRequest() {
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fProcessNetworkRequest -- 49", QString(), CXDefinitions::ELogDisk);
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
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fProcessNetworkRequest -- 50", QString(), CXDefinitions::ELogDisk);
  SXRequest lRequest = mPendingRequests.value(lRequestID);
  if((pReply->error() == QNetworkReply::NoError)) {
    BXWapptom* pWapptom = mWapptoms.value(lRequest.lName).data();
    if(pWapptom->fOutput().isEmpty()) pWapptom->tSetValue(QString(pReply->readAll()));
    else {
      QString lResponse(QString(pReply->readAll()));
      lResponse = pWapptom->fPreProcess(lResponse);
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
      fLogMessage(2200010, QStringList() <<QString("/// %1").arg(lResponse), QString(), CXDefinitions::ELogDisk);
      pWapptom->tSetValue(lResponse);
    }
  }
  else fLogMessage(3200022, QStringList() << lRequest.lName << QString::number(lRequestID) << lRequest.lInput << pReply->errorString(), QString());
  pReply->deleteLater();
  mPendingRequests.remove(lRequestID);
fLogMessage(2200010, QStringList() << "void GXGuiApplication::fProcessNetworkRequest -- 52", QString(), CXDefinitions::ELogDisk);
}

void GXGuiApplication::fUpdateValue(bool lSuccess, quint64 lRequestID, const QString &lValue) {
 /* if(!mPendingRequests.contains(lRequestID)) {
    fLogMessage(5200004, QStringList() << QString::number(lRequestID), QString());
    return;
  } */
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fUpdateValue -- 53", QString(), CXDefinitions::ELogDisk);
  SXRequest lRequest = mPendingRequests.value(lRequestID);
  int lMessageType;
  if(lSuccess) lMessageType = CXDefinitions::ESuccessMessage;
  else lMessageType = CXDefinitions::EErrorMessage;
  mPendingRequests.remove(lRequestID);
//qDebug(QString("%1 - %2 :: %3").arg(lRequest.lName).arg(lRequest.lConnector).arg(lRequest.lStatus).toLatin1());
  if(lSuccess && lRequest.lType == CXDefinitions::EWapptom) {
    bool lInitialized = mWapptoms.value(lRequest.lName)->fInitialized();
    mWapptoms.value(lRequest.lName)->tSetValue(lValue);
    if(rTrayIcon && (lRequest.lName == "WABalance") && lInitialized) {
      double lPrevious = mWapptoms.value(lRequest.lName)->fPreviousValue().toDouble();
      double lCurrent = mWapptoms.value(lRequest.lName)->fValue().toDouble();
      double lTotal = lCurrent - lPrevious;
      if(lTotal > 0) rTrayIcon->showMessage(tr("WDC Coins arrived!"), tr("Amount: %1\nNew balance: %2").arg(QString::number(lTotal, 'f', 8)).arg(QString::number(lCurrent, 'f', 8)), QSystemTrayIcon::Information);
      if(lTotal < 0) rTrayIcon->showMessage(tr("WDC Coins sent!"), tr("Amount: %1\nNew balance: %2").arg(QString::number(lTotal, 'f', 8)).arg(QString::number(lCurrent, 'f', 8)), QSystemTrayIcon::Information);
    }
    if(rTrayIcon && (lRequest.lName == "WABalanceBTC") && lInitialized) {
      double lPrevious = mWapptoms.value(lRequest.lName)->fPreviousValue().toDouble();
      double lCurrent = mWapptoms.value(lRequest.lName)->fValue().toDouble();
      double lTotal = lCurrent - lPrevious;
      if(lTotal > 0) rTrayIcon->showMessage(tr("BTC Coins arrived!"), tr("Amount: %1\nNew balance: %2").arg(QString::number(lTotal, 'f', 8)).arg(QString::number(lCurrent, 'f', 8)), QSystemTrayIcon::Information);
      if(lTotal < 0) rTrayIcon->showMessage(tr("BTC Coins sent!"), tr("Amount: %1\nNew balance: %2").arg(QString::number(lTotal, 'f', 8)).arg(QString::number(lCurrent, 'f', 8)), QSystemTrayIcon::Information);
    }
    if(rTrayIcon && (lRequest.lName == "WABalanceLTC") && lInitialized) {
      double lPrevious = mWapptoms.value(lRequest.lName)->fPreviousValue().toDouble();
      double lCurrent = mWapptoms.value(lRequest.lName)->fValue().toDouble();
      double lTotal = lCurrent - lPrevious;
      if(lTotal > 0) rTrayIcon->showMessage(tr("LTC Coins arrived!"), tr("Amount: %1\nNew balance: %2").arg(QString::number(lTotal, 'f', 8)).arg(QString::number(lCurrent, 'f', 8)), QSystemTrayIcon::Information);
      if(lTotal < 0) rTrayIcon->showMessage(tr("LTC Coins sent!"), tr("Amount: %1\nNew balance: %2").arg(QString::number(lTotal, 'f', 8)).arg(QString::number(lCurrent, 'f', 8)), QSystemTrayIcon::Information);
    }
    if(rTrayIcon && (lRequest.lName == "WABalanceDOGE") && lInitialized) {
      double lPrevious = mWapptoms.value(lRequest.lName)->fPreviousValue().toDouble();
      double lCurrent = mWapptoms.value(lRequest.lName)->fValue().toDouble();
      double lTotal = lCurrent - lPrevious;
      if(lTotal > 0) rTrayIcon->showMessage(tr("DOGE Coins arrived!"), tr("Amount: %1\nNew balance: %2").arg(QString::number(lTotal, 'f', 8)).arg(QString::number(lCurrent, 'f', 8)), QSystemTrayIcon::Information);
      if(lTotal < 0) rTrayIcon->showMessage(tr("DOGE Coins sent!"), tr("Amount: %1\nNew balance: %2").arg(QString::number(lTotal, 'f', 8)).arg(QString::number(lCurrent, 'f', 8)), QSystemTrayIcon::Information);
    }
  }
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fUpdateValue -- 54", QString(), CXDefinitions::ELogDisk);
  if(lRequest.lType == CXDefinitions::ERawCall) mComponentManager.fProcessMessage(lMessageType, lRequestID, lRequest.lInput, lRequest.lName, lValue, lRequest.lConnector);
  QMapIterator<quint64, SXRequest> i(mPendingRequests);
  while(i.hasNext()) {
    i.next();
    if(i.value().lStatus == CXDefinitions::ERequestQueued) {
      mPendingRequests[i.key()].lStatus = CXDefinitions::ERequestProcessing;
      mConnectorManager.fConnector(i.value().lConnector)->fExecute(i.value().lType, i.key(), i.value().lInput, i.value().lOutput, i.value().lResponseStateIsAnswer, i.value().lParse, i.value().lLogType);
      break;
    }
  }
//  fLogMessage(2200010, QStringList() << "void GXGuiApplication::fUpdateValue -- 55", QString(), CXDefinitions::ELogDisk);
}

void GXGuiApplication::fUpdateValueJson(bool lSuccess, quint64 lRequestID, const QJsonValue& lValue) {
 /* if(!mPendingRequests.contains(lRequestID)) {
    fLogMessage(5200004, QStringList() << QString::number(lRequestID), QString());
    return;
  } */
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fUpdateValueJson -- 56", QString(), CXDefinitions::ELogDisk);
  SXRequest lRequest = mPendingRequests.value(lRequestID);
  int lMessageType;
  if(lSuccess) lMessageType = CXDefinitions::ESuccessMessage;
  else lMessageType = CXDefinitions::EErrorMessage;
  if(lRequest.lType == CXDefinitions::ERawCall) mComponentManager.fProcessMessage(lMessageType, lRequestID, lRequest.lInput, lRequest.lName, lValue, lRequest.lConnector);
  mPendingRequests.remove(lRequestID);
  QMapIterator<quint64, SXRequest> i(mPendingRequests);
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fUpdateValueJson -- 57", QString(), CXDefinitions::ELogDisk);
  while(i.hasNext()) {
    i.next();
    if(i.value().lStatus == CXDefinitions::ERequestQueued) {
      mPendingRequests[i.key()].lStatus = CXDefinitions::ERequestProcessing;
      mConnectorManager.fConnector(i.value().lConnector)->fExecute(i.value().lType, i.key(), i.value().lInput, i.value().lOutput, i.value().lResponseStateIsAnswer, i.value().lParse, i.value().lLogType);
      break;
    }
  }
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fUpdateValueJson -- 58", QString(), CXDefinitions::ELogDisk);
}

void GXGuiApplication::fUpdateTrayIconStatus() {
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fUpdateDaemonStatus -- 59", QString(), CXDefinitions::ELogDisk);
  BXCryptoConnector* pConnector = qobject_cast<BXCryptoConnector*> (sender());
  QString lConnectorName = pConnector->fName();
  int lDaemonStatus = pConnector->fStatus();
  if(lConnectorName == cDefaultDaemon) {
    if(lDaemonStatus == CXDefinitions::EServiceStopped) fUpdateStatusText(2200007, QStringList() << lConnectorName);
    if(lDaemonStatus == CXDefinitions::EServiceProcessing) fUpdateStatusText(2200008, QStringList() << lConnectorName);
    if(lDaemonStatus == CXDefinitions::EServiceReady) fUpdateStatusText(2200001);
    if(lDaemonStatus == CXDefinitions::EServiceError) fUpdateStatusText(3200015, QStringList() << lConnectorName);
    if(rTrayIcon) rTrayIcon->setToolTip(tr("WBC Status: %1").arg(mDefaultDaemonStatusText));
  }
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fUpdateDaemonStatus -- 60", QString(), CXDefinitions::ELogDisk);
}

void GXGuiApplication::fUpdateStatusText(int lCode, const QStringList& lParameters) {
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fUpdateStatusText -- 61", QString(), CXDefinitions::ELogDisk);
  CXMessage lMessage(CXMessagePool::fMessage(lCode, lParameters, QString()));
  mDefaultDaemonStatusText = lMessage.fText();
  emit sStatusTextChanged(mDefaultDaemonStatusText);
//fLogMessage(2200010, QStringList() << "void GXGuiApplication::fUpdateStatusText -- 62", QString(), CXDefinitions::ELogDisk);
}


void GXGuiApplication::fOnClose() {    
  fUpdateStatusText(2200009);
  mDefinitions.fSaveSettings();
  mConnectorManager.fEndService();
  QDir lLogDir(cDefaultLogDirectory);
  if(!lLogDir.exists()) {
    if(!QDir::current().mkdir(cDefaultLogDirectory)) BXGuiApplication::fInstance()->fLogMessage(3200002, QStringList() << cDefaultLogDirectory, QString());
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

  QMetaObject::invokeMethod(qApp, "quit", Qt::QueuedConnection);
}
