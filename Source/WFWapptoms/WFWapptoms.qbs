import qbs

Project {
  references: [
    "WapptomBalance/WapptomBalance.qbs",
    "WapptomBestBlockHash/WapptomBestBlockHash.qbs",
    "WapptomBlockCount/WapptomBlockCount.qbs",
    "WapptomConnectionCount/WapptomConnectionCount.qbs",
    "WapptomDifficulty/WapptomDifficulty.qbs",
    "WapptomNetworkHashPS/WapptomNetworkHashPS.qbs",
    "WapptomTotalBlockCount/WapptomTotalBlockCount.qbs",
    "WapptomBalanceWithoutConf/WapptomBalanceWithoutConf.qbs",
    "WapptomEncrypted/WapptomEncrypted.qbs",
    "WapptomExchangeRate/WapptomExchangeRate.qbs"
  ]
}
