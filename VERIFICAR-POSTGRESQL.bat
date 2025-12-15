@echo off
echo ============================================================
echo   VERIFICAR POSTGRESQL ALTERDATA
echo ============================================================
echo.

echo [INFO] Verificando servicos PostgreSQL...
echo.

REM Verificar servicos do PostgreSQL
echo Servicos PostgreSQL instalados:
echo ------------------------------------------------------------
sc query | findstr /I "postgres" 2>nul

if %errorlevel% neq 0 (
    echo [AVISO] Nenhum servico PostgreSQL encontrado
) else (
    echo.
    echo ------------------------------------------------------------
)

echo.
echo [INFO] Verificando portas abertas (5432, 5433, 5434)...
echo.

REM Verificar porta 5432
netstat -an | findstr ":5432" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Porta 5432 - ATIVA
    netstat -ano | findstr ":5432"
) else (
    echo [X] Porta 5432 - NAO ATIVA
)

echo.

REM Verificar porta 5433
netstat -an | findstr ":5433" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Porta 5433 - ATIVA
    netstat -ano | findstr ":5433"
) else (
    echo [X] Porta 5433 - NAO ATIVA
)

echo.

REM Verificar porta 5434
netstat -an | findstr ":5434" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Porta 5434 - ATIVA
    netstat -ano | findstr ":5434"
) else (
    echo [X] Porta 5434 - NAO ATIVA
)

echo.
echo ============================================================
echo   COMO RESOLVER
echo ============================================================
echo.
echo OPCAO 1 - Abrir o sistema Alterdata/iShop:
echo   1. Abra o programa Alterdata ou iShop
echo   2. Isso iniciara o PostgreSQL automaticamente
echo   3. Execute novamente: EXECUTAR-INTEGRACAO-RAPIDA.bat
echo.
echo OPCAO 2 - Iniciar servico manualmente:
echo   Execute: INICIAR-POSTGRESQL-ALTERDATA.bat
echo.
echo OPCAO 3 - Verificar instalacao:
echo   1. Verifique se Alterdata esta instalado
echo   2. Procure por: C:\Program Files (x86)\Alterdata
echo   3. Ou: Z:\Program Files (x86)\Alterdata
echo.
echo ============================================================
echo.
pause

