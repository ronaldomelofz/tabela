@echo off
echo ============================================================
echo   EXTRACAO RAPIDA - DADOS DAS TABELAS COPIADAS
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

REM Verificar se Python esta disponivel
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Python nao encontrado!
    echo [INFO] Instale Python para usar este script
    goto FIM
)

REM Executar script Python de extracao
echo [INFO] Extraindo dados das copias otimizadas...
echo.

python scripts\extrair-dados-copia.py

if %errorlevel% equ 0 (
    echo.
    echo [OK] Extracao concluida com sucesso!
    echo [INFO] Dados salvos em: data\produtos.json
) else (
    echo.
    echo [ERRO] Falha na extracao
    echo [INFO] Verifique se o PostgreSQL COPIA esta rodando
)

:FIM
echo.
echo ============================================================
echo.

if "%1"=="auto" (
    exit /b 0
) else (
    echo Pressione qualquer tecla para fechar...
    pause > nul
)

