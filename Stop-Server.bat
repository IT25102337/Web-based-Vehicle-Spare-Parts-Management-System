@echo off
title Stop PartTrack Server
echo Stopping all PartTrack Java server processes...
taskkill /F /IM java.exe /T 2>nul
taskkill /F /IM javaw.exe /T 2>nul
echo Done! Port 8080 is now released.
timeout /t 2 >nul
