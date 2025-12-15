@echo off
echo ============================================================
echo   VISUALIZAR AGENDAMENTO DE COPIA DOS BANCOS
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

set TASK_NAME=CopiarBancosAlterdata

echo [INFO] Verificando tarefa agendada: %TASK_NAME%
echo.

schtasks /query /tn "%TASK_NAME%" /fo LIST /v 2>nul

if %errorlevel% equ 0 (
    echo.
    echo ============================================================
    echo.
    echo [INFO] Opcoes disponiveis:
    echo.
    echo Para desabilitar:
    echo   schtasks /change /tn "%TASK_NAME%" /disable
    echo.
    echo Para habilitar:
    echo   schtasks /change /tn "%TASK_NAME%" /enable
    echo.
    echo Para remover:
    echo   schtasks /delete /tn "%TASK_NAME%" /f
    echo.
    echo Para reagendar:
    echo   Execute: AGENDAR-COPIA-BANCOS.bat
    echo.
    echo Para executar manualmente agora:
    echo   Execute: COPIAR-BANCOS-ALTERDATA.bat
    echo.
) else (
    echo.
    echo ============================================================
    echo [INFO] Nenhuma tarefa agendada encontrada
    echo ============================================================
    echo.
    echo Para criar agendamento:
    echo   Execute: AGENDAR-COPIA-BANCOS.bat
    echo.
    echo Para executar copia manual:
    echo   Execute: COPIAR-BANCOS-ALTERDATA.bat
    echo.
)

echo ============================================================
echo.

REM Verificar logs recentes
echo [INFO] Ultimos logs de copia:
echo.
if exist "E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\logs\copia_bancos_*.log" (
    dir /B /O-D "E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\logs\copia_bancos_*.log" 2>nul | findstr /R "." >nul
    if %errorlevel% equ 0 (
        echo Logs encontrados em: E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\logs\
        dir /B /O-D "E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\logs\copia_bancos_*.log" 2>nul | more /E /P
    ) else (
        echo Nenhum log encontrado ainda.
    )
) else (
    echo Nenhum log encontrado ainda.
)

echo.
echo ============================================================
echo.
echo Pressione qualquer tecla para fechar...
pause > nul

