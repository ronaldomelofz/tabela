@echo off
chcp 65001 > nul
echo.
echo ═══════════════════════════════════════════════════════════════════
echo ⏰ CONFIGURAR ATUALIZAÇÃO AUTOMÁTICA
echo ═══════════════════════════════════════════════════════════════════
echo.
echo Este script criará uma tarefa agendada no Windows para atualizar
echo automaticamente os dados do iShop a cada hora.
echo.
echo Opções disponíveis:
echo   1. Criar agendamento (executar a cada 1 hora)
echo   2. Criar agendamento (executar a cada 30 minutos)
echo   3. Criar agendamento (executar a cada 3 horas)
echo   4. Remover agendamento
echo   5. Ver status do agendamento
echo   0. Cancelar
echo.

set /p opcao="Escolha uma opção: "

if "%opcao%"=="1" goto agendar_1h
if "%opcao%"=="2" goto agendar_30m
if "%opcao%"=="3" goto agendar_3h
if "%opcao%"=="4" goto remover
if "%opcao%"=="5" goto status
if "%opcao%"=="0" goto fim
goto erro

:agendar_1h
echo.
echo Criando agendamento para executar a cada 1 hora...
schtasks /create /tn "IntegracaoIShop" /tr "\"%~dp0atualizar-sistema.bat\"" /sc hourly /st 00:00 /f
goto sucesso

:agendar_30m
echo.
echo Criando agendamento para executar a cada 30 minutos...
schtasks /create /tn "IntegracaoIShop" /tr "\"%~dp0atualizar-sistema.bat\"" /sc minute /mo 30 /st 00:00 /f
goto sucesso

:agendar_3h
echo.
echo Criando agendamento para executar a cada 3 horas...
schtasks /create /tn "IntegracaoIShop" /tr "\"%~dp0atualizar-sistema.bat\"" /sc hourly /mo 3 /st 00:00 /f
goto sucesso

:remover
echo.
echo Removendo agendamento...
schtasks /delete /tn "IntegracaoIShop" /f
if %ERRORLEVEL% EQU 0 (
    echo ✅ Agendamento removido com sucesso!
) else (
    echo ⚠️  Nenhum agendamento encontrado ou erro ao remover
)
goto fim

:status
echo.
echo Status do agendamento:
echo.
schtasks /query /tn "IntegracaoIShop" /fo list /v
goto fim

:sucesso
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Agendamento criado com sucesso!
    echo.
    echo A tarefa "IntegracaoIShop" foi configurada e executará automaticamente.
    echo Você pode verificar em: Painel de Controle → Ferramentas Administrativas → Agendador de Tarefas
) else (
    echo.
    echo ❌ Erro ao criar agendamento. Verifique se você tem permissões de administrador.
)
goto fim

:erro
echo.
echo ❌ Opção inválida!
goto fim

:fim
echo.
pause

