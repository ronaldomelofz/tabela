@echo off
chcp 65001 > nul
cls
echo.
echo ═══════════════════════════════════════════════════════════
echo ⏰ CONFIGURAR ATUALIZAÇÃO AUTOMÁTICA DO SITE
echo ═══════════════════════════════════════════════════════════
echo.
echo Este script criará uma tarefa que irá:
echo   • Ler dados do iShop (Y:\IN e Y:\OUT)
echo   • Atualizar produtos.json
echo   • Enviar para GitHub automaticamente
echo   • Netlify fará deploy automático
echo.
echo Tudo de forma automática em intervalos regulares!
echo.
echo Escolha uma opção:
echo.
echo   1. Atualizar a cada 1 HORA (recomendado)
echo   2. Atualizar a cada 30 MINUTOS
echo   3. Atualizar a cada 2 HORAS
echo   4. Remover atualização automática
echo   5. Ver status da tarefa
echo   0. Cancelar
echo.
set /p opcao="Digite o número da opção: "

if "%opcao%"=="1" goto agendar_1h
if "%opcao%"=="2" goto agendar_30m
if "%opcao%"=="3" goto agendar_2h
if "%opcao%"=="4" goto remover
if "%opcao%"=="5" goto status
if "%opcao%"=="0" goto fim
goto erro

:agendar_1h
echo.
echo Configurando atualização a cada 1 hora...
schtasks /create /tn "AtualizarSiteIShop" /tr "\"%~dp0ATUALIZAR-SITE-E-DEPLOY.bat\"" /sc hourly /st 00:00 /f
goto verificar

:agendar_30m
echo.
echo Configurando atualização a cada 30 minutos...
schtasks /create /tn "AtualizarSiteIShop" /tr "\"%~dp0ATUALIZAR-SITE-E-DEPLOY.bat\"" /sc minute /mo 30 /st 00:00 /f
goto verificar

:agendar_2h
echo.
echo Configurando atualização a cada 2 horas...
schtasks /create /tn "AtualizarSiteIShop" /tr "\"%~dp0ATUALIZAR-SITE-E-DEPLOY.bat\"" /sc hourly /mo 2 /st 00:00 /f
goto verificar

:verificar
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo ✅ ATUALIZAÇÃO AUTOMÁTICA CONFIGURADA COM SUCESSO!
    echo ═══════════════════════════════════════════════════════════
    echo.
    echo O site será atualizado automaticamente no intervalo escolhido.
    echo Você pode fechar esta janela.
) else (
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo ❌ ERRO ao configurar
    echo ═══════════════════════════════════════════════════════════
    echo.
    echo IMPORTANTE: Execute este arquivo como Administrador!
    echo Clique com botão direito e escolha "Executar como administrador"
)
goto fim

:remover
echo.
echo Removendo atualização automática...
schtasks /delete /tn "AtualizarSiteIShop" /f
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Atualização automática removida com sucesso!
) else (
    echo.
    echo ⚠️  Nenhuma tarefa encontrada ou erro ao remover
)
goto fim

:status
echo.
echo ═══════════════════════════════════════════════════════════
echo STATUS DA ATUALIZAÇÃO AUTOMÁTICA:
echo ═══════════════════════════════════════════════════════════
echo.
schtasks /query /tn "AtualizarSiteIShop" /fo list /v 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Atualização automática NÃO está configurada.
)
goto fim

:erro
echo.
echo ❌ Opção inválida! Digite um número de 0 a 5.
timeout /t 2 >nul
cls
goto inicio

:fim
echo.
pause

