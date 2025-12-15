@echo off
echo ============================================================
echo   REMOVER AGENDAMENTO DE COPIA DOS BANCOS
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

set TASK_NAME=CopiarBancosAlterdata

echo [INFO] Verificando tarefa agendada: %TASK_NAME%
echo.

schtasks /query /tn "%TASK_NAME%" >nul 2>&1

if %errorlevel% equ 0 (
    echo [AVISO] Tarefa encontrada!
    echo.
    schtasks /query /tn "%TASK_NAME%" /fo LIST 2>nul | findstr /C:"Nome da Tarefa" /C:"Status" /C:"Pr"
    echo.
    echo.
    choice /C SN /M "Deseja REMOVER esta tarefa agendada? (S/N)"
    
    if errorlevel 2 (
        echo.
        echo [INFO] Operacao cancelada.
        goto FIM
    )
    
    if errorlevel 1 (
        echo.
        echo [INFO] Removendo tarefa...
        schtasks /delete /tn "%TASK_NAME%" /f
        
        if %errorlevel% equ 0 (
            echo [OK] Tarefa removida com sucesso!
            echo.
            echo A copia automatica dos bancos foi desabilitada.
            echo Para reagendar, execute: AGENDAR-COPIA-BANCOS.bat
        ) else (
            echo [ERRO] Falha ao remover tarefa
        )
    )
) else (
    echo [INFO] Nenhuma tarefa agendada encontrada
    echo.
    echo Para criar agendamento:
    echo   Execute: AGENDAR-COPIA-BANCOS.bat
)

:FIM
echo.
echo ============================================================
echo.
echo Pressione qualquer tecla para fechar...
pause > nul

