import qbs

DynamicLibrary {
  version: project.version

  name: "WFDefinitions"
  targetName: "WFDefinitions"
  destinationDirectory: project.installDirectory
  files: [ "*.cpp", "*.h" ]

  cpp.defines: ["WFDEFINITIONS_LIBRARY", "WORLDCOINPANEL_VERSION=" + "\"" + version + "\""]
  cpp.cxxLanguageVersion: "c++11"  
  Group {
    name: "Config"
    qbs.install: true
    qbs.installDir: "."
    files: [ "*.cfg" ]
  }
  Group {
    condition: qbs.targetOS.contains("linux")
    qbs.install: true
    qbs.installDir: "."
    files: [ "Worldcoin.sh" ]
  }

/*  Group {
    qbs.install: true
    qbs.installDir: "."
    fileTagsFilter: "dynamiclibrary"
  }*/
  Depends { name: "cpp" }
  Depends { name: "Qt"; submodules: ["core"]}
}
