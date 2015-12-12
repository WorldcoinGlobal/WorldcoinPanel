#ifndef GXSUBWINDOW_H
#define GXSUBWINDOW_H

#include <QCoreApplication>
#include <QQuickItem>
#include <QCursor>
#include <QPoint>
#include "HXCore.h"

class WFCORE_EXPORT GXSubWindow : public QQuickItem
{
  Q_OBJECT
  Q_PROPERTY(int mActive READ fIsActive WRITE tSetActive NOTIFY sIsActiveChanged)

  public:
    explicit GXSubWindow(QQuickItem* lParent = 0 );

    Q_INVOKABLE int fIsActive() const { return mActive; }
    Q_INVOKABLE void fProcessEvents() { qApp->processEvents(); }
    Q_INVOKABLE QPoint fMouseGlobalPosition() const { return QCursor::pos(); }

  public slots:
    void tSetActive(bool lActive) { mActive = lActive; emit sIsActiveChanged(); }
    void tScale() { emit sScaleRequested(); }
    void fSetGeometry(double x, double y, double lWidth, double lHeight) {
      setX(x); setY(y);
      setWidth(lWidth); setHeight(lHeight);
    }
 //   void tMoveBottomBorder() { emit sMoveBottomBorder(); }
 //   void tMoveRightBorder() { emit sMoveRightBorder(); }


  private:
    bool mActive;

  signals:
    void sScaleRequested();
    void sIsActiveChanged();
//    void sMoveBottomBorder();
//    void sMoveRightBorder();
};

#endif // GXCOMPONENT_H
