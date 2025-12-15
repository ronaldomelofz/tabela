@echo off
REM Script para executar integracao rapida diretamente do painel HTML

cd /d "%~dp0"

echo ============================================================
echo   EXECUTANDO INTEGRACAO RAPIDA
echo ============================================================
echo.

REM Verificar Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Python nao encontrado!
    echo.
    echo Instale Python: https://www.python.org/downloads/
    pause
    exit /b 1
)

REM Executar script
echo [INFO] Executando integracao...
echo.

python scripts\integracao-rapida-alterdata.py

echo.
echo ============================================================
echo.
pause

