@echo off
title PartTrack Server Manager
cd /d "C:\Users\User\Desktop\SparePartSystem"

echo ===================================================
echo   PartTrack Spare Parts System - Server Launcher
echo ===================================================
echo.
echo Freeing port 8080 and preparing server...
taskkill /F /IM java.exe /T 2>nul
taskkill /F /IM javaw.exe /T 2>nul
timeout /t 1 >nul

echo.
echo ===================================================
echo Starting PartTrack on http://localhost:8080 ...
echo Keep this window open or minimized while using the system.
echo ===================================================
echo.

"C:\Program Files\Java\jdk-25\bin\java.exe" -jar "C:\Users\User\Desktop\SparePartSystem\target\SparePartSystem-0.0.1-SNAPSHOT.jar"

echo.
echo Server has stopped.
pause
