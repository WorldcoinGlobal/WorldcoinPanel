#ifndef CXCOMPONENTMANAGER_H
#define CXCOMPONENTMANAGER_H

#include <QMap>
#include <QObject>
#include <QStringList>
#include <CXDefinitions.h>

#include "GXComponent.h"
#include "GXSubWindow.h"
#include "HXCore.h"

class WFCORE_EXPORT CXComponentManager : public QObject {
  Q_OBJECT

  public:
    explicit CXComponentManager(QObject* pParent = 0);
    ~CXComponentManager();

    Q_INVOKABLE bool fIsComponentLoaded(const QString& lComponentName) const { if(mComponents.contains(lComponentName)) return true; return false; }
    Q_INVOKABLE QString fComponentDirectory(int lComponentCategory);
    Q_INVOKABLE QString fComponentExtension() { return cComponentExtension; }
    Q_INVOKABLE void fRegisterComponent(const QString& lComponentName, QObject* lComponent, QObject* lComponentContent);
    Q_INVOKABLE void fScaleComponents();
    Q_INVOKABLE void fSetActiveComponent(const QString& lComponentName);
   // Q_INVOKABLE void fMoveBottomBorder();
   // Q_INVOKABLE void fMoveRightBorder();
    Q_INVOKABLE GXSubWindow* fComponent(const QString& lComponentName);
    Q_INVOKABLE GXComponent* fComponentContent(const QString& lComponentName);
    void fProcessMessage(int lMessageType, int lRequestID, const QString& lInput, const QString& lComponentName, QString lMessage);
    void fProcessMessage(int lMessageType, int lRequestID, const QString& lInput, const QString& lComponentName, const QJsonValue& lValue);

  protected:
    QMap<QString, GXSubWindow* > mComponents;
    QMap<QString, GXComponent* > mComponentContent;

  signals:
    void sLogMessageRequest(int lCode, QStringList lParameters, const QString& lCustomText, int lLogType = CXDefinitions::ELogAll);
    void sRawCallRequested(const QString& lConnector, const QString& lRawRequest, const QString& lComponentName, bool lParse, int lLogType);
};

#endif
