@echo off
echo ============================================================
echo   AGENDAR ATUALIZACAO AUTOMATICA
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.
echo Este script vai agendar a atualizacao automatica para:
echo   - Atualiza dados do TABELABLOCO.txt
echo   - Verifica atualizacoes em Y:\
echo   - Publica no GitHub automaticamente
echo.
echo ============================================================
echo.
echo ESCOLHA O INTERVALO DE ATUALIZACAO:
echo.
echo   1. A cada 10 minutos
echo   2. A cada 20 minutos
echo   3. A cada 30 minutos
echo   4. A cada 60 minutos (1 hora)
echo   5. Uma vez por dia (08:00)
echo   6. Cancelar
echo.
echo ============================================================
echo.

set /p OPCAO=Digite o numero da opcao [1-6]: 

set SCRIPT_PATH=%~dp0ATUALIZAR-E-PUBLICAR.bat
set TASK_NAME=AtualizarProdutosGitHub

if "%OPCAO%"=="1" (
    set INTERVALO=10
    set TIPO=minutos
    set COMANDO=schtasks /create /tn "%TASK_NAME%" /tr "%SCRIPT_PATH%" /sc minute /mo 10 /f
) else if "%OPCAO%"=="2" (
    set INTERVALO=20
    set TIPO=minutos
    set COMANDO=schtasks /create /tn "%TASK_NAME%" /tr "%SCRIPT_PATH%" /sc minute /mo 20 /f
) else if "%OPCAO%"=="3" (
    set INTERVALO=30
    set TIPO=minutos
    set COMANDO=schtasks /create /tn "%TASK_NAME%" /tr "%SCRIPT_PATH%" /sc minute /mo 30 /f
) else if "%OPCAO%"=="4" (
    set INTERVALO=60
    set TIPO=minutos
    set COMANDO=schtasks /create /tn "%TASK_NAME%" /tr "%SCRIPT_PATH%" /sc minute /mo 60 /f
) else if "%OPCAO%"=="5" (
    set INTERVALO=diario
    set TIPO=08:00
    set COMANDO=schtasks /create /tn "%TASK_NAME%" /tr "%SCRIPT_PATH%" /sc daily /st 08:00 /f
) else if "%OPCAO%"=="6" (
    echo.
    echo [INFO] Operacao cancelada pelo usuario
    goto FIM
) else (
    echo.
    echo [ERRO] Opcao invalida!
    goto FIM
)

echo.
echo [INFO] Criando tarefa agendada...
echo [INFO] Intervalo: %INTERVALO% %TIPO%
echo.

%COMANDO%

if %errorlevel% equ 0 (
    echo.
    echo ============================================================
    echo [OK] TAREFA AGENDADA COM SUCESSO!
    echo ============================================================
    echo.
    echo Configuracao:
    echo   - Nome: %TASK_NAME%
    if "%OPCAO%"=="5" (
        echo   - Frequencia: Diario as %TIPO%
    ) else (
        echo   - Frequencia: A cada %INTERVALO% %TIPO%
    )
    echo   - Script: %SCRIPT_PATH%
    echo.
    echo Para gerenciar:
    echo   - Abra "Agendador de Tarefas" do Windows
    echo   - Ou execute: taskschd.msc
    echo.
    echo Para desabilitar:
    echo   - schtasks /change /tn "%TASK_NAME%" /disable
    echo.
    echo Para remover:
    echo   - schtasks /delete /tn "%TASK_NAME%" /f
    echo.
    echo ============================================================
) else (
    echo.
    echo ============================================================
    echo [ERRO] FALHA AO CRIAR TAREFA AGENDADA
    echo ============================================================
    echo.
    echo Execute este arquivo como Administrador:
    echo   1. Clique com botao direito no arquivo
    echo   2. Selecione "Executar como administrador"
    echo.
)

:FIM
echo.
echo Pressione qualquer tecla para fechar...
pause > nul

