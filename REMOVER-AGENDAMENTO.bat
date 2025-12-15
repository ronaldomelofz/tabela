@echo off
echo ============================================================
echo   REMOVER AGENDAMENTO AUTOMATICO
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

set TASK_NAME=AtualizarProdutosGitHub

echo [INFO] Verificando tarefa: %TASK_NAME%
echo.

schtasks /query /tn "%TASK_NAME%" >nul 2>&1

if %errorlevel% equ 0 (
    echo [INFO] Tarefa encontrada
    echo.
    set /p CONFIRMA=Deseja remover o agendamento? (S/N): 
    
    if /i "%CONFIRMA%"=="S" (
        echo.
        echo [INFO] Removendo tarefa agendada...
        schtasks /delete /tn "%TASK_NAME%" /f
        
        if %errorlevel% equ 0 (
            echo.
            echo ============================================================
            echo [OK] AGENDAMENTO REMOVIDO COM SUCESSO!
            echo ============================================================
            echo.
            echo Para criar novo agendamento:
            echo   Execute: AGENDAR-ATUALIZACAO.bat
            echo.
        ) else (
            echo.
            echo [ERRO] Falha ao remover agendamento
            echo Execute este arquivo como Administrador
        )
    ) else (
        echo.
        echo [INFO] Operacao cancelada
    )
) else (
    echo.
    echo ============================================================
    echo [INFO] Nenhuma tarefa agendada encontrada
    echo ============================================================
    echo.
    echo Nada para remover
    echo.
)

echo.
echo Pressione qualquer tecla para fechar...
pause > nul

