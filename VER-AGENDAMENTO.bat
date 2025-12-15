@echo off
echo ============================================================
echo   VISUALIZAR AGENDAMENTO ATUAL
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

set TASK_NAME=AtualizarProdutosGitHub

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
    echo   Execute: AGENDAR-ATUALIZACAO.bat
    echo.
) else (
    echo.
    echo ============================================================
    echo [INFO] Nenhuma tarefa agendada encontrada
    echo ============================================================
    echo.
    echo Para criar agendamento:
    echo   Execute: AGENDAR-ATUALIZACAO.bat
    echo.
)

echo ============================================================
echo.
echo Pressione qualquer tecla para fechar...
pause > nul

