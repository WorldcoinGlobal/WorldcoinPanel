import qbs

Project {
  references: [
    "ConnectorWorldcoin/ConnectorWorldcoin.qbs",
    "ConnectorBitcoin/ConnectorBitcoin.qbs",
    "ConnectorLitecoin/ConnectorLitecoin.qbs",
    "ConnectorDogecoin/ConnectorDogecoin.qbs"
  ]
}
