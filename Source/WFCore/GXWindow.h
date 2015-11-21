#ifndef GXWINDOW_H
#define GXWINDOW_H

#include <QQuickWindow>
#include <QPoint>
#include "HXCore.h"

class WFCORE_EXPORT GXWindow : public QQuickWindow
{
  Q_OBJECT

  public:
    explicit GXWindow(QWindow* lParent = 0 );
    Q_INVOKABLE  QPoint fMousePosition() {
      return QCursor::pos();
    }
    Q_INVOKABLE QString fDaemonSetting(const QString &lDaemon, const QString& lParameter) const;
    Q_INVOKABLE QString fDefaultDaemon() const;

  public slots:
    void tSetGeometry(double x, double y, double width, double height) {
      setGeometry(x,y,width,height);
    }
    void tKeyPressed(int lKeyCode) { emit sKeyPressed(lKeyCode); }
    void tKeyReleased(int lKeyCode) { emit sKeyReleased(lKeyCode); }

  signals:
    void sKeyPressed(int lKeyCode);
    void sKeyReleased(int lKeyCode);
    void sScaleUp();
    void sScaleDown();
};

#endif // AXWINDOW_H
