@echo off
:: Script para Resetar Senha do PostgreSQL
:: Requer permissoes de Administrador

title Resetar Senha PostgreSQL

echo ====================================================================
echo  RESETAR SENHA DO POSTGRESQL - ALTERDATA SHOP
echo ====================================================================
echo.
echo Este script vai:
echo   1. Parar servico PostgreSQL
echo   2. Modificar configuracao temporariamente
echo   3. Resetar senha
echo   4. Restaurar configuracao
echo.
echo IMPORTANTE: Voce precisa de permissoes de Administrador!
echo.
pause

:: Verificar se esta rodando como Admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [ERRO] Este script precisa ser executado como Administrador!
    echo.
    echo Clique com botao direito e selecione "Executar como administrador"
    echo.
    pause
    exit /b 1
)

echo.
echo ====================================================================
echo  PASSO 1: PARAR SERVICO POSTGRESQL
echo ====================================================================
echo.

net stop postgresql-9.6

if %errorLevel% neq 0 (
    echo [AVISO] Servico ja estava parado ou erro ao parar
) else (
    echo [OK] Servico parado com sucesso
)

timeout /t 2 /nobreak >nul

echo.
echo ====================================================================
echo  PASSO 2: MODIFICAR CONFIGURACAO
echo ====================================================================
echo.

:: Executar script PowerShell para modificar pg_hba.conf
powershell -ExecutionPolicy Bypass -File "RESETAR-SENHA-POSTGRES-HELPER.ps1"

if %errorLevel% neq 0 (
    echo [ERRO] Falha ao modificar configuracao
    echo Restaurando servico...
    net start postgresql-9.6
    pause
    exit /b 1
)

echo.
echo ====================================================================
echo  PASSO 3: INICIAR SERVICO COM NOVA CONFIGURACAO
echo ====================================================================
echo.

net start postgresql-9.6

if %errorLevel% neq 0 (
    echo [ERRO] Falha ao iniciar servico
    pause
    exit /b 1
)

echo [OK] Servico iniciado
timeout /t 3 /nobreak >nul

echo.
echo ====================================================================
echo  PASSO 4: RESETAR SENHA
echo ====================================================================
echo.

:: Executar script Python para resetar senha
python scripts\resetar-senha-postgres.py

if %errorLevel% neq 0 (
    echo [ERRO] Falha ao resetar senha
    pause
    exit /b 1
)

echo.
echo ====================================================================
echo  CONCLUIDO!
echo ====================================================================
echo.
echo [OK] Senha do PostgreSQL resetada com sucesso!
echo.
echo Credenciais:
echo   Host: localhost
echo   Port: 5432
echo   User: postgres
echo   Database: ALTERDATA_SHOP
echo   Password: [a senha que voce escolheu]
echo.
echo IMPORTANTE: Anote a senha em local seguro!
echo.
pause




