@echo off
echo ============================================================
echo   AGENDAR INTEGRACAO AUTOMATICA RAPIDA
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

set TASK_NAME=IntegracaoRapidaAlterdata
set SCRIPT_PATH=%~dp0INTEGRACAO-AUTOMATICA-RAPIDA.bat

echo [INFO] Configurando integracao automatica otimizada...
echo.
echo Este sistema copia APENAS as tabelas necessarias:
echo   - produto  (codigos, descricoes)
echo   - detalhe  (precos, estoque)
echo.
echo Processo MUITO MAIS RAPIDO que copia completa!
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
echo  1. A cada 10 minutos (integracao em tempo quase real)
echo  2. A cada 20 minutos (recomendado para producao)
echo  3. A cada 30 minutos (uso moderado)
echo  4. A cada 60 minutos (1 hora)
echo  5. A cada 2 horas
echo  6. A cada 4 horas
echo  7. Manual (criar tarefa desabilitada)
echo  8. Cancelar
echo.

choice /C 12345678 /M "Escolha uma opcao"

if errorlevel 8 goto CANCELAR
if errorlevel 7 goto MANUAL
if errorlevel 6 goto HORA4
if errorlevel 5 goto HORA2
if errorlevel 4 goto MIN60
if errorlevel 3 goto MIN30
if errorlevel 2 goto MIN20
if errorlevel 1 goto MIN10

:MIN10
set INTERVALO=10
set DESCRICAO=a cada 10 minutos
goto CRIAR_TASK

:MIN20
set INTERVALO=20
set DESCRICAO=a cada 20 minutos
goto CRIAR_TASK

:MIN30
set INTERVALO=30
set DESCRICAO=a cada 30 minutos
goto CRIAR_TASK

:MIN60
set INTERVALO=60
set DESCRICAO=a cada 60 minutos (1 hora)
goto CRIAR_TASK

:HORA2
set INTERVALO=120
set DESCRICAO=a cada 2 horas
goto CRIAR_TASK

:HORA4
set INTERVALO=240
set DESCRICAO=a cada 4 horas
goto CRIAR_TASK

:CRIAR_TASK
echo.
echo [INFO] Criando tarefa para executar %DESCRICAO%...
schtasks /create /tn "%TASK_NAME%" /tr "cmd /c \"%SCRIPT_PATH%\"" /sc minute /mo %INTERVALO% /ru "SYSTEM" /rl HIGHEST /f

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
schtasks /create /tn "%TASK_NAME%" /tr "cmd /c \"%SCRIPT_PATH%\"" /sc minute /mo 30 /ru "SYSTEM" /rl HIGHEST /f
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
echo   INTEGRACAO AUTOMATICA CONFIGURADA
echo ============================================================
echo.
echo Tarefa: %TASK_NAME%
echo Frequencia: %DESCRICAO%
echo Script: %SCRIPT_PATH%
echo.
echo [OK] Sistema de integracao automatica ativo!
echo.
echo O sistema agora:
echo   1. Copia apenas as tabelas necessarias
echo   2. Extrai os dados automaticamente
echo   3. Atualiza data\produtos.json
echo.
echo Para verificar:
echo   Execute: VER-INTEGRACAO-RAPIDA.bat
echo.
echo Para remover:
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

