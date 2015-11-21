import QtQuick 2.4
import WFCore.Lib 1.0

GXComponent  {
  id: rcRoot
  property Item coDefaultFocus
  property real reWidthCm
  property real reHeightCm
  transformOrigin: Item.TopLeft
  Connections {
    target: rcRoot
    onSComponentActivated: { if(coDefaultFocus != null) coDefaultFocus.forceActiveFocus() }
  }
}

