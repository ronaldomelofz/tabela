@echo off
echo ============================================================
echo   COPIA OTIMIZADA - APENAS TABELAS NECESSARIAS
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

REM Definir caminhos
set PG_BIN=C:\Program Files (x86)\Alterdata\AltShop\PostgreSQL\bin
set BACKUP_DIR=%~dp0backups_otimizados
set TIMESTAMP=%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%

REM Criar diretorio de backup se nao existir
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

echo [INFO] Sistema de copia otimizada
echo [INFO] Copiando APENAS as tabelas: produto e detalhe
echo.

REM ============================================================
REM ETAPA 1: DUMP DAS TABELAS ESPECIFICAS
REM ============================================================
echo ============================================================
echo ETAPA 1: Fazendo dump das tabelas necessarias
echo ============================================================
echo.

REM Verificar se PostgreSQL original esta rodando
echo [INFO] Verificando PostgreSQL original (porta 5432/5433)...

REM Tentar porta 5432 primeiro
"%PG_BIN%\pg_isready.exe" -h localhost -p 5432 >nul 2>&1
if %errorlevel% equ 0 (
    set PG_PORT=5432
    echo [OK] PostgreSQL encontrado na porta 5432
) else (
    REM Tentar porta 5433
    "%PG_BIN%\pg_isready.exe" -h localhost -p 5433 >nul 2>&1
    if %errorlevel% equ 0 (
        set PG_PORT=5433
        echo [OK] PostgreSQL encontrado na porta 5433
    ) else (
        echo [ERRO] PostgreSQL nao esta rodando
        echo [INFO] Inicie o servico Alterdata primeiro
        goto FIM
    )
)

echo.
echo [INFO] Extraindo tabela PRODUTO...

"%PG_BIN%\pg_dump.exe" ^
    -h localhost ^
    -p %PG_PORT% ^
    -U postgres ^
    -d ALTERDATA_SHOP ^
    -t produto ^
    --no-owner ^
    --no-privileges ^
    -f "%BACKUP_DIR%\produto_%TIMESTAMP%.sql" 2>nul

if %errorlevel% equ 0 (
    echo [OK] Tabela PRODUTO exportada
) else (
    echo [AVISO] Erro ao exportar PRODUTO (pode necessitar senha)
)

echo.
echo [INFO] Extraindo tabela DETALHE...

"%PG_BIN%\pg_dump.exe" ^
    -h localhost ^
    -p %PG_PORT% ^
    -U postgres ^
    -d ALTERDATA_SHOP ^
    -t detalhe ^
    --no-owner ^
    --no-privileges ^
    -f "%BACKUP_DIR%\detalhe_%TIMESTAMP%.sql" 2>nul

if %errorlevel% equ 0 (
    echo [OK] Tabela DETALHE exportada
) else (
    echo [AVISO] Erro ao exportar DETALHE (pode necessitar senha)
)

echo.
echo ============================================================
echo ETAPA 2: Informacoes dos arquivos criados
echo ============================================================
echo.

if exist "%BACKUP_DIR%\produto_%TIMESTAMP%.sql" (
    echo [OK] Arquivo: produto_%TIMESTAMP%.sql
    dir "%BACKUP_DIR%\produto_%TIMESTAMP%.sql" | findstr /R "[0-9].*produto"
)

if exist "%BACKUP_DIR%\detalhe_%TIMESTAMP%.sql" (
    echo [OK] Arquivo: detalhe_%TIMESTAMP%.sql
    dir "%BACKUP_DIR%\detalhe_%TIMESTAMP%.sql" | findstr /R "[0-9].*detalhe"
)

echo.
echo ============================================================
echo   RESUMO DA OPERACAO
echo ============================================================
echo.
echo [INFO] Backups salvos em: %BACKUP_DIR%
echo.
echo [INFO] Tabelas exportadas:
echo   - produto  (codigos, descricoes, status)
echo   - detalhe  (precos, estoque)
echo.
echo [INFO] Estas sao as UNICAS tabelas necessarias para o sistema!
echo.
echo [INFO] Proximos passos:
echo   1. Execute: EXTRAIR-DA-COPIA-RAPIDA.bat
echo   2. Os dados serao atualizados em: data\produtos.json
echo.

:FIM
echo ============================================================
echo.

if "%1"=="auto" (
    exit /b 0
) else (
    echo Pressione qualquer tecla para fechar...
    pause > nul
)

