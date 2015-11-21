#ifndef CXMESSAGEPOOL_H
#define CXMESSAGEPOOL_H

#include <QObject>
#include <QStringList>

#include "CXMessage.h"
#include "HXCore.h"

class WFCORE_EXPORT CXMessagePool : public QObject {
  Q_OBJECT

  public:
    explicit CXMessagePool(QObject* pParent = 0);

    static const CXMessage fMessage(int lCode, const QStringList& lParameters, const QString& lCustomText);
    static int fMessageType(int lCode);
};

#endif // CXMessagePool_H
