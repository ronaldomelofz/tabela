@echo off
chcp 65001 > nul
echo.
echo ═══════════════════════════════════════════════════════════════════
echo 🔄 ATUALIZANDO SISTEMA COM DADOS DO iShop
echo ═══════════════════════════════════════════════════════════════════
echo.

cd /d "%~dp0\.."

python scripts\integrador-ishop.py

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ═══════════════════════════════════════════════════════════════════
    echo ✅ Atualização concluída com sucesso!
    echo ═══════════════════════════════════════════════════════════════════
) else (
    echo.
    echo ═══════════════════════════════════════════════════════════════════
    echo ❌ Erro durante a atualização
    echo ═══════════════════════════════════════════════════════════════════
)

echo.
pause



