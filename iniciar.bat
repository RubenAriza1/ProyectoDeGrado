@echo off
title MusicApp Valledupar - Loader
echo ===================================================
echo   Iniciando MusicApp Valledupar (Backend + Frontend)
echo ===================================================
echo.

echo [1/2] Levantando el servidor Backend en una nueva ventana...
:: Abre una nueva ventana de línea de comandos, le cambia el título, entra a backend y lo corre.
start "Backend - MusicApp" cmd /k "cd backend && npm run dev"

echo [2/2] Ejecutando Flutter...
:: Esperamos un par de segundos para que el backend tenga tiempo de encender
timeout /t 3 /nobreak >nul

:: Corre flutter en esta misma ventana para conservar los comandos como "r" para hot-reload
flutter run
