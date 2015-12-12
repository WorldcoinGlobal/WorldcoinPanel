#ifndef GXWINDOW_H
#define GXWINDOW_H

#include <QEvent>
#include <QQuickWindow>
#include <QPoint>
#include "HXCore.h"

class WFCORE_EXPORT GXWindow : public QQuickWindow
{
  Q_OBJECT

  public:
    explicit GXWindow(QWindow* lParent = 0 );
    Q_INVOKABLE  QPoint fMouseGlobalPosition() { return QCursor::pos(); }
    Q_INVOKABLE QString fDaemonSetting(const QString &lDaemon, const QString& lParameter) const;

  public slots:
    void fSetGeometry(double x, double y, double lWidth, double lHeight) {
      setGeometry(x, y, lWidth, lHeight);
    }

  signals:
    void sKeyPressed(int lKeyCode, int lModifiers);
    void sKeyReleased(int lKeyCode, int lModifiers);
};

#endif // GXWINDOW_H
