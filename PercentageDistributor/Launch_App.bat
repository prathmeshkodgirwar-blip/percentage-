@echo off
setlocal
cd /d "%~dp0"

echo Starting Percentage Distribution Calculator...

:: Try launching in Edge App mode (looks and feels like a native desktop app)
where msedge >nul 2>nul
if %ERRORLEVEL% equ 0 (
    start msedge --app="file:///%~dp0index.html"
    exit
)

:: Try Chrome App mode
where chrome >nul 2>nul
if %ERRORLEVEL% equ 0 (
    start chrome --app="file:///%~dp0index.html"
    exit
)

:: Fallback to default system browser
start "" "%~dp0index.html"
exit
