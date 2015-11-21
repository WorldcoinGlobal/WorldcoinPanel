import QtQuick 2.4
import QtQuick.Controls.Private 1.0

MouseArea {
  id: maRoot
  property string text: "dddd"
  hoverEnabled: maRoot.enabled
  onExited: Tooltip.hideText()
  onCanceled: Tooltip.hideText()

  Timer {
    interval: 1000
    running: maRoot.enabled && maRoot.containsMouse && maRoot.text.length
    onTriggered: { print("dd"); Tooltip.showText(maRoot, Qt.point(maRoot.mouseX, maRoot.mouseY), maRoot.text) }
  }
}
