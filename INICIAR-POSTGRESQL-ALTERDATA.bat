@echo off
echo ============================================================
echo   INICIAR POSTGRESQL ALTERDATA
echo ============================================================
echo.

echo [INFO] Procurando instalacao do PostgreSQL Alterdata...
echo.

REM Tentar varios caminhos comuns
set PG_PATHS[0]=C:\Program Files (x86)\Alterdata\AltShop\PostgreSQL\bin\pg_ctl.exe
set PG_PATHS[1]=C:\Program Files (x86)\Alterdata\PostgreSQL\bin\pg_ctl.exe
set PG_PATHS[2]=Z:\Program Files (x86)\Alterdata\AltShop\PostgreSQL\bin\pg_ctl.exe
set PG_PATHS[3]=Z:\Program Files (x86)\Alterdata\PostgreSQL\bin\pg_ctl.exe
set PG_PATHS[4]=C:\PostgreSQL\bin\pg_ctl.exe

set FOUND=0

REM Verificar cada caminho
if exist "C:\Program Files (x86)\Alterdata\AltShop\PostgreSQL\bin\pg_ctl.exe" (
    set PG_CTL=C:\Program Files (x86)\Alterdata\AltShop\PostgreSQL\bin\pg_ctl.exe
    set PG_DATA=C:\Program Files (x86)\Alterdata\AltShop\PostgreSQL\data
    set FOUND=1
    goto INICIAR
)

if exist "C:\Program Files (x86)\Alterdata\PostgreSQL\bin\pg_ctl.exe" (
    set PG_CTL=C:\Program Files (x86)\Alterdata\PostgreSQL\bin\pg_ctl.exe
    set PG_DATA=C:\Program Files (x86)\Alterdata\PostgreSQL\data
    set FOUND=1
    goto INICIAR
)

if exist "Z:\Program Files (x86)\Alterdata\AltShop\PostgreSQL\bin\pg_ctl.exe" (
    set PG_CTL=Z:\Program Files (x86)\Alterdata\AltShop\PostgreSQL\bin\pg_ctl.exe
    set PG_DATA=Z:\Program Files (x86)\Alterdata\AltShop\PostgreSQL\data
    set FOUND=1
    goto INICIAR
)

if %FOUND%==0 (
    echo [ERRO] PostgreSQL do Alterdata nao encontrado!
    echo.
    echo SOLUCOES:
    echo.
    echo 1. Abra o programa Alterdata/iShop
    echo    O PostgreSQL iniciara automaticamente
    echo.
    echo 2. Verifique se Alterdata esta instalado em:
    echo    - C:\Program Files (x86)\Alterdata
    echo    - Z:\Program Files (x86)\Alterdata
    echo.
    echo 3. Reinstale o Alterdata se necessario
    echo.
    pause
    exit /b 1
)

:INICIAR
echo [OK] PostgreSQL encontrado!
echo Caminho: %PG_CTL%
echo Data: %PG_DATA%
echo.

echo [INFO] Tentando iniciar PostgreSQL...
echo.

"%PG_CTL%" -D "%PG_DATA%" start 2>nul

if %errorlevel% equ 0 (
    echo [OK] PostgreSQL iniciado com sucesso!
    echo.
    echo Aguardando 5 segundos para estabilizar...
    timeout /t 5 /nobreak > nul
    echo.
    echo [OK] Pronto! Agora execute:
    echo      EXECUTAR-INTEGRACAO-RAPIDA.bat
) else (
    echo [AVISO] Falha ao iniciar ou PostgreSQL ja esta rodando
    echo.
    echo Tente:
    echo 1. Abrir o programa Alterdata/iShop
    echo 2. Verificar se ja esta rodando: VERIFICAR-POSTGRESQL.bat
)

echo.
echo ============================================================
echo.
pause

