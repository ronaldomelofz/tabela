@echo off
chcp 65001 > nul
cls
echo.
echo ═══════════════════════════════════════════════════════════
echo 🔄 ATUALIZANDO SITE E FAZENDO DEPLOY
echo ═══════════════════════════════════════════════════════════
echo.
echo Este script irá:
echo   1. Ler dados mais recentes de Y:\IN e Y:\OUT
echo   2. Atualizar data/produtos.json
echo   3. Fazer commit e push para GitHub
echo   4. Netlify fará deploy automático
echo.
echo Aguarde...
echo.

cd /d "%~dp0"
python scripts\atualizar-site.py

set EXITCODE=%ERRORLEVEL%

echo.
echo ═══════════════════════════════════════════════════════════
echo ✅ PROCESSO CONCLUÍDO! 
echo ═══════════════════════════════════════════════════════════
echo.
echo ✓ Dados atualizados localmente
echo ✓ Enviado para GitHub
echo ✓ Netlify está fazendo o deploy (1-2 minutos)
echo.
    echo 🌐 Repositório: https://github.com/ronaldomelofz/tabela
echo 🌐 Site ficará disponível em instantes!
echo.

echo.
pause

