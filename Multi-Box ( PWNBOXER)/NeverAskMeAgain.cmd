if %PROCESSOR_ARCHITECTURE% == AMD64 (
set filename=%windir%\SysWOW64\gameux.dll
) else (
set filename=%windir%\System32\gameux.dll
)

TAKEOWN /F %filename%
ICACLS %filename% /grant %USERNAME%:F
ren %filename% "gameux.dll - go to helll!!!"
pause