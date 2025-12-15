@echo off
echo ============================================================
echo   AGENDAR COPIA AUTOMATICA DOS BANCOS ALTERDATA
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

set TASK_NAME=CopiarBancosAlterdata
set SCRIPT_PATH=%~dp0COPIAR-BANCOS-ALTERDATA.bat

echo [INFO] Configurando agendamento da copia de bancos...
echo.

REM Verificar se a tarefa ja existe
schtasks /query /tn "%TASK_NAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo [AVISO] Tarefa "%TASK_NAME%" ja existe!
    echo.
    choice /C SN /M "Deseja SUBSTITUIR a tarefa existente? (S/N)"
    if errorlevel 2 goto CANCELAR
    if errorlevel 1 (
        echo.
        echo [INFO] Removendo tarefa antiga...
        schtasks /delete /tn "%TASK_NAME%" /f >nul 2>&1
    )
)

echo.
echo ============================================================
echo   OPCOES DE AGENDAMENTO
echo ============================================================
echo.
echo 1. A cada 4 horas (recomendado para ambiente de producao)
echo 2. A cada 2 horas (recomendado para desenvolvimento)
echo 3. A cada 1 hora (para testes)
echo 4. Diariamente as 08:00
echo 5. Manualmente (criar tarefa desabilitada)
echo 6. Cancelar
echo.

choice /C 123456 /M "Escolha uma opcao"

if errorlevel 6 goto CANCELAR
if errorlevel 5 goto MANUAL
if errorlevel 4 goto DIARIO
if errorlevel 3 goto HORA1
if errorlevel 2 goto HORA2
if errorlevel 1 goto HORA4

:HORA4
set INTERVALO=4
set DESCRICAO=a cada 4 horas
goto CRIAR_TASK

:HORA2
set INTERVALO=2
set DESCRICAO=a cada 2 horas
goto CRIAR_TASK

:HORA1
set INTERVALO=1
set DESCRICAO=a cada 1 hora
goto CRIAR_TASK

:CRIAR_TASK
echo.
echo [INFO] Criando tarefa para executar %DESCRICAO%...
schtasks /create /tn "%TASK_NAME%" /tr "cmd /c \"%SCRIPT_PATH%\" auto" /sc hourly /mo %INTERVALO% /ru "SYSTEM" /rl HIGHEST /f

if %errorlevel% equ 0 (
    echo [OK] Tarefa criada com sucesso!
    goto SUCESSO
) else (
    echo [ERRO] Falha ao criar tarefa agendada
    goto FIM
)

:DIARIO
echo.
echo [INFO] Criando tarefa diaria as 08:00...
schtasks /create /tn "%TASK_NAME%" /tr "cmd /c \"%SCRIPT_PATH%\" auto" /sc daily /st 08:00 /ru "SYSTEM" /rl HIGHEST /f

if %errorlevel% equ 0 (
    echo [OK] Tarefa criada com sucesso!
    goto SUCESSO
) else (
    echo [ERRO] Falha ao criar tarefa agendada
    goto FIM
)

:MANUAL
echo.
echo [INFO] Criando tarefa desabilitada (execucao manual)...
schtasks /create /tn "%TASK_NAME%" /tr "cmd /c \"%SCRIPT_PATH%\" auto" /sc daily /st 08:00 /ru "SYSTEM" /rl HIGHEST /f
schtasks /change /tn "%TASK_NAME%" /disable >nul 2>&1

if %errorlevel% equ 0 (
    echo [OK] Tarefa criada (desabilitada)!
    echo.
    echo Para habilitar: schtasks /change /tn "%TASK_NAME%" /enable
    goto FIM
) else (
    echo [ERRO] Falha ao criar tarefa
    goto FIM
)

:SUCESSO
echo.
echo ============================================================
echo   AGENDAMENTO CONFIGURADO
echo ============================================================
echo.
echo Tarefa: %TASK_NAME%
echo Script: %SCRIPT_PATH%
echo.
echo [INFO] A copia dos bancos sera executada automaticamente!
echo.
echo Para verificar o agendamento:
echo   Execute: VER-AGENDAMENTO-COPIAS.bat
echo.
echo Para remover o agendamento:
echo   schtasks /delete /tn "%TASK_NAME%" /f
echo.
goto FIM

:CANCELAR
echo.
echo [INFO] Operacao cancelada pelo usuario.
echo.

:FIM
echo ============================================================
echo.
echo Pressione qualquer tecla para fechar...
pause > nul

