import QtQuick 2.4
import ACMeasures.Lib 1.0
import QtQuick.Controls 1.3

CheckBox {
  id: cbRoot
  clip: true
  property real reHeightCm
  property real reWidthCm
  property string srDefaultValue
  property string srSetting
  property string srConnector
  property bool boUseDaemonConf: false
  property bool boValue
  height: ACMeasures.fuToDots(reHeightCm)
  width: ACMeasures.fuToDots(reWidthCm)
  function fuSave() {
    if(cbRoot.checked) {
      parent.fSetSetting(srSetting, "1", boUseDaemonConf, srConnector)
      boValue = true
    }
    else {
      parent.fSetSetting(srSetting, "0", boUseDaemonConf, srConnector)
      boValue = false
    }
  }
  function fuLoad() {
    if(parent.fSetting(srSetting, boUseDaemonConf, srConnector) === '') {
      parent.fSetSetting(srSetting, srDefaultValue, boUseDaemonConf, srConnector)
      if(srDefaultValue === "0")  {
        cbRoot.checked = false
        boValue = false
      }
      else {
        cbRoot.checked = true
        boValue = true
      }
    }
    else {
      if(parent.fSetting(srSetting, boUseDaemonConf, srConnector) === "0")  {
        cbRoot.checked = false
        boValue = false
      }
      else {
        cbRoot.checked = true
        boValue = true
      }
    }
  }
}

