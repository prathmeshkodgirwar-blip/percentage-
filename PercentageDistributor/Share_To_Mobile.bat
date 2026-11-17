@echo off
title Share Percentage Splitter to Mobile
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0Server.ps1"
pause
