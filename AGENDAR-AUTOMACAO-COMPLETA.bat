@echo off
echo ============================================================
echo   AGENDAR AUTOMACAO COMPLETA
echo   Copia + Extracao + GitHub Automatico
echo ============================================================
echo.

set TASK_NAME=AutomacaoCompletaAlterdata
set SCRIPT_PATH=%~dp0AUTOMACAO-COMPLETA.bat

echo [INFO] Este agendamento vai executar TODO o processo:
echo.
echo   1. Copiar bancos (RESPEITANDO REGRA DE OURO)
echo   2. Extrair dados DAS COPIAS
echo   3. Atualizar data/produtos.json
echo   4. Commit no Git
echo   5. Push para GitHub
echo.
echo IMPORTANTE: Sempre usa COPIAS, nunca originais!
echo.
pause

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
echo Quanto tempo leva cada execucao?
echo   - Copia dos bancos: 5-10 minutos
echo   - Extracao: 30 segundos
echo   - Git push: 10 segundos
echo   TOTAL: ~10-15 minutos por execucao
echo.
echo Opcoes disponiveis:
echo.
echo  1. A cada 4 horas (Recomendado para producao)
echo  2. A cada 6 horas (Uso moderado)
echo  3. A cada 12 horas (2x por dia)
echo  4. Diariamente as 02:00 (1x por dia, madrugada)
echo  5. Diariamente as 08:00 (1x por dia, manha)
echo  6. Manual (criar tarefa desabilitada)
echo  7. Cancelar
echo.

choice /C 1234567 /M "Escolha uma opcao"

if errorlevel 7 goto CANCELAR
if errorlevel 6 goto MANUAL
if errorlevel 5 goto DIARIO_08
if errorlevel 4 goto DIARIO_02
if errorlevel 3 goto HORA12
if errorlevel 2 goto HORA6
if errorlevel 1 goto HORA4

:HORA4
set INTERVALO=4
set DESCRICAO=a cada 4 horas
goto CRIAR_TASK_INTERVALO

:HORA6
set INTERVALO=6
set DESCRICAO=a cada 6 horas
goto CRIAR_TASK_INTERVALO

:HORA12
set INTERVALO=12
set DESCRICAO=a cada 12 horas
goto CRIAR_TASK_INTERVALO

:CRIAR_TASK_INTERVALO
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

:DIARIO_02
echo.
echo [INFO] Criando tarefa diaria as 02:00...
schtasks /create /tn "%TASK_NAME%" /tr "cmd /c \"%SCRIPT_PATH%\" auto" /sc daily /st 02:00 /ru "SYSTEM" /rl HIGHEST /f

if %errorlevel% equ 0 (
    echo [OK] Tarefa criada com sucesso!
    goto SUCESSO
) else (
    echo [ERRO] Falha ao criar tarefa agendada
    goto FIM
)

:DIARIO_08
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
echo   AUTOMACAO COMPLETA CONFIGURADA!
echo ============================================================
echo.
echo Tarefa: %TASK_NAME%
echo Frequencia: %DESCRICAO%
echo Script: %SCRIPT_PATH%
echo.
echo [OK] Sistema totalmente automatizado!
echo.
echo O que sera feito automaticamente:
echo   1. Copiar bancos (RESPEITANDO REGRA DE OURO)
echo   2. Extrair dados DAS COPIAS (nunca dos originais)
echo   3. Atualizar data/produtos.json
echo   4. Fazer commit no Git
echo   5. Push para GitHub: https://github.com/ronaldomelofz/tabela
echo.
echo Para verificar:
echo   Execute: VER-AUTOMACAO-COMPLETA.bat
echo.
echo Para executar manualmente agora:
echo   schtasks /run /tn "%TASK_NAME%"
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
pause

