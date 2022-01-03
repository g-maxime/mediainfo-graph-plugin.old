#NSIS: encoding=UTF-8

!ifdef PORTABLE
  RequestExecutionLevel user
!else
  RequestExecutionLevel admin
!endif

; Some defines
!define PRODUCT_NAME "MediaInfo Graph Plugin"
!define PRODUCT_PUBLISHER "MediaArea.net"
!define PRODUCT_VERSION "21.09"
!define PRODUCT_VERSION4 "${PRODUCT_VERSION}.0.0"
!define PRODUCT_WEB_SITE "http://MediaArea.net/MediaInfo"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; Compression
SetCompressor /FINAL /SOLID lzma

; x64 stuff
!include "x64.nsh"

; File size
!include FileFunc.nsh
!include WinVer.nsh

; Modern UI
!include "MUI2.nsh"
!define MUI_ABORTWARNING
!define MUI_ICON "MediaInfo.ico"

; Installer pages
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Info
VIProductVersion "${PRODUCT_VERSION4}"
VIAddVersionKey "CompanyName"      "${PRODUCT_PUBLISHER}"
VIAddVersionKey "ProductName"      "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion"   "${PRODUCT_VERSION4}"
VIAddVersionKey "FileDescription"  "Graph visualisation support for MediaInfo"
VIAddVersionKey "FileVersion"      "${PRODUCT_VERSION4}"
VIAddVersionKey "LegalCopyright"   "${PRODUCT_PUBLISHER}"
!ifdef PORTABLE
VIAddVersionKey "OriginalFilename" "MediaInfo_GraphPlugin_${PRODUCT_VERSION}_Windows_Portable.exe"
!else
VIAddVersionKey "OriginalFilename" "MediaInfo_GraphPlugin_${PRODUCT_VERSION}_Windows.exe"
!endif
BrandingText " "

; Modern UI end

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
!ifdef PORTABLE
OutFile "MediaInfo_GraphPlugin_${PRODUCT_VERSION}_Windows_Portable.exe"
!else
OutFile "MediaInfo_GraphPlugin_${PRODUCT_VERSION}_Windows.exe"
!endif
InstallDir "$PROGRAMFILES64\MediaInfo"
ShowInstDetails nevershow
ShowUnInstDetails nevershow

Function .onInit
  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}
FunctionEnd

Section "SectionPrincipale" SEC01
  SetOverwrite on
  SetOutPath "$INSTDIR"
  File "Win32\config6"
  File "Win32\cdt.dll"
  File "Win32\cgraph.dll"
  File "Win32\pathplan.dll"
  File "Win32\xdot.dll"
  File "Win32\expat.dll"
  File "Win32\gvc.dll"
  File "Win32\gvplugin_core.dll"
  File "Win32\gvplugin_gdiplus.dll"
  File "Win32\gvplugin_dot_layout.dll"
  File "Win32\gvplugin_neato_layout.dll"
  File "Win32\vcruntime140.dll"
  File "Win32\concrt140.dll"
  File "Win32\msvcp140.dll"
  File "Win32\msvcp140_1.dll"
  File "Win32\msvcp140_2.dll"
  File "Win32\msvcp140_codecvt_ids.dll"
  SetOverwrite try
  SetOutPath "$INSTDIR\Plugin\Graph"
  File "Plugin\Graph\Template.html"
  File "version.txt"
SectionEnd

Section -Post
  !ifndef PORTABLE
    WriteUninstaller "$INSTDIR\graph_plugin_uninst.exe"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName"     "$(^Name)"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon"     "$INSTDIR\MediaInfo.exe"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher"       "${PRODUCT_PUBLISHER}"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\graph_plugin_uninst.exe"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion"  "${PRODUCT_VERSION}"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout"    "${PRODUCT_WEB_SITE}"
    ${If} ${AtLeastWin7}
      WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "EstimatedSize" "0x00000928" ; Create/Write the reg key with the dword value
    ${EndIf}
  !endif
SectionEnd


Section Uninstall
  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}

  Delete "$INSTDIR\graph_plugin_uninst.exe"
  Delete "$INSTDIR\config6"
  Delete "$INSTDIR\cdt.dll"
  Delete "$INSTDIR\cgraph.dll"
  Delete "$INSTDIR\pathplan.dll"
  Delete "$INSTDIR\xdot.dll"
  Delete "$INSTDIR\expat.dll"
  Delete "$INSTDIR\gvc.dll"
  Delete "$INSTDIR\gvplugin_core.dll"
  Delete "$INSTDIR\gvplugin_gdiplus.dll"
  Delete "$INSTDIR\gvplugin_dot_layout.dll"
  Delete "$INSTDIR\gvplugin_neato_layout.dll"
  Delete "$INSTDIR\vcruntime140.dll"
  Delete "$INSTDIR\concrt140.dll"
  Delete "$INSTDIR\msvcp140.dll"
  Delete "$INSTDIR\msvcp140_1.dll"
  Delete "$INSTDIR\msvcp140_2.dll"
  Delete "$INSTDIR\msvcp140_codecvt_ids.dll"
  Delete "$INSTDIR\Plugin\Graph\Template.html"
  Delete "$INSTDIR\Plugin\Graph\version.txt"

  RMDir "$INSTDIR\Plugin\Graph"
  RMDir "$INSTDIR\Plugin"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd
