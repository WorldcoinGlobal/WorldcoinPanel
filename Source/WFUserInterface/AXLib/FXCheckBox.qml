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
  property bool boValue
  height: ACMeasures.fuToDots(reHeightCm)
  width: ACMeasures.fuToDots(reWidthCm)
  function fuSave() {
    if(cbRoot.checked) {
      parent.tSetSetting(srSetting, "1")
      boValue = true
    }
    else {
      parent.tSetSetting(srSetting, "0")
      boValue = false
    }
  }
  function fuLoad() {
    if(parent.fSetting(srSetting) === '') {
      parent.tSetSetting(srSetting, srDefaultValue)
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
      if(parent.fSetting(srSetting) === "0")  {
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

