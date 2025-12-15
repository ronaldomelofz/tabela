@echo off
echo ============================================================
echo   SISTEMA DE ATUALIZACAO AUTOMATICA
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

cd /d "%~dp0"

echo [INFO] Ativando ambiente Python...
call .venv\Scripts\activate.bat

echo.
echo [INFO] Executando atualizacao...
python scripts\atualizar-e-publicar.py

echo.
echo [INFO] Pressione qualquer tecla para fechar...
pause > nul




