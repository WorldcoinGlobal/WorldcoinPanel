import qbs
  
Product {
  version: project.version
  name: "Components"

  Group {
    name: "ComponentAddressDetail"
    qbs.install: true
    qbs.installDir: "Components/Main/ComponentAddressDetail"
    files: [ "Main/ComponentAddressDetail/*" ]
  }
  Group {
    name: "ComponentBackupSettings"
    qbs.install: true
    qbs.installDir: "Components/Main/ComponentBackupSettings"
    files: [ "Main/ComponentBackupSettings/*" ]
  }
  Group {
    name: "ComponentBackupWallet"
    qbs.install: true
    qbs.installDir: "Components/Main/ComponentBackupWallet"
    files: [ "Main/ComponentBackupWallet/*" ]
  }
  Group {
    name: "ComponentCryptoConsole"
    qbs.install: true
    qbs.installDir: "Components/Main/ComponentCryptoConsole"
    files: [ "Main/ComponentCryptoConsole/*" ]
  }
  Group {
    name: "ComponentDaemonSettings"
    qbs.install: true
    qbs.installDir: "Components/Main/ComponentDaemonSettings"
    files: [ "Main/ComponentDaemonSettings/*" ]
  }
  Group {
    name: "ComponentEncryptWallet"
    qbs.install: true
    qbs.installDir: "Components/Main/ComponentEncryptWallet"
    files: [ "Main/ComponentEncryptWallet/*" ]
  }
  Group {
    name: "ComponentTransferCrypto"
    qbs.install: true
    qbs.installDir: "Components/Main/ComponentTransferCrypto"
    files: [ "Main/ComponentTransferCrypto/*" ]
  }
  Group {
    name: "ComponentTransactionList"
    qbs.install: true
    qbs.installDir: "Components/Main/ComponentTransactionList"
    files: [ "Main/ComponentTransactionList/*" ]
  }
  Group {
    name: "ComponentUpdater"
    qbs.install: true
    qbs.installDir: "Components/Main/ComponentUpdater"
    files: [ "Main/ComponentUpdater/*" ]
  }
  Group {
    name: "ComponentWalletsSummary"
    qbs.install: true
    qbs.installDir: "Components/Main/ComponentWalletsSummary"
    files: [ "Main/ComponentWalletsSummary/*" ]
  }
}
