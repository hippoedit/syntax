; NOTE: this .NSI script is designed for NSIS v1.8+

Name "%Application Name%"
OutFile "setup.exe"

; Some default compiler settings (uncomment and change at will):
; SetCompress auto ; (can be off or force)
; SetDatablockOptimize on ; (can be off)
; CRCCheck on ; (can be off)
; AutoCloseWindow false ; (can be true for the window go away automatically at end)
; ShowInstDetails hide ; (can be show to have them shown, or nevershow to disable)
; SetDateSave off ; (can be on to have files restored to their orginal date)

InstallDir "$PROGRAMFILES\%Application Name%"
InstallDirRegKey HKEY_LOCAL_MACHINE "SOFTWARE\%Company Name%\%Application Name%" ""
DirShow show ; (make this hide to not let the user change it)
DirText "Select the directory to install %Application Name% in:"

Section "" ; (default section)
SetOutPath "$INSTDIR"
; add files / whatever that need to be installed here.
WriteRegStr HKEY_LOCAL_MACHINE "SOFTWARE\%Company Name%\%Application Name%" "" "$INSTDIR"
WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\%Application Name%" "DisplayName" "%Application Name% (remove only)"
WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\%Application Name%" "UninstallString" '"$INSTDIR\uninst.exe"'
; write out uninstaller
WriteUninstaller "$INSTDIR\uninst.exe"
SectionEnd ; end of default section


; begin uninstall settings/section
UninstallText "This will uninstall %Application Name% from your system"

Section Uninstall
; add delete commands to delete whatever files/registry keys/etc you installed here.
Delete "$INSTDIR\uninst.exe"
DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\%Company Name%\%Application Name%"
DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%Application Name%"
RMDir "$INSTDIR"
SectionEnd ; end of uninstall section

; eof