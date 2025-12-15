@echo off
REM Script unificado com menu interativo - mais facil de usar!

:MENU
cls
echo ============================================================
echo   SISTEMA DE INTEGRACAO RAPIDA ALTERDATA
echo   Escolha o que deseja fazer:
echo ============================================================
echo.
echo  PRINCIPAL:
echo  [1] Executar Integracao Agora (5-10 segundos)
echo  [2] Agendar Integracao Automatica
echo  [3] Ver Status da Integracao
echo.
echo  DIAGNOSTICO:
echo  [4] Verificar PostgreSQL (se der erro)
echo  [5] Iniciar PostgreSQL Alterdata
echo.
echo  VISUALIZACAO:
echo  [6] Ver Dados Atuais (produtos.json)
echo  [7] Abrir Logs
echo  [8] Abrir Painel HTML
echo.
echo  AJUDA:
echo  [9] Ver Documentacao
echo  [0] Sair
echo.
echo ============================================================

set /p opcao="Digite o numero da opcao: "

if "%opcao%"=="1" goto EXECUTAR
if "%opcao%"=="2" goto AGENDAR
if "%opcao%"=="3" goto STATUS
if "%opcao%"=="4" goto VERIFICAR_PG
if "%opcao%"=="5" goto INICIAR_PG
if "%opcao%"=="6" goto DADOS
if "%opcao%"=="7" goto LOGS
if "%opcao%"=="8" goto PAINEL
if "%opcao%"=="9" goto DOCS
if "%opcao%"=="0" goto SAIR

echo.
echo Opcao invalida! Pressione qualquer tecla para tentar novamente...
pause > nul
goto MENU

:EXECUTAR
cls
echo ============================================================
echo   EXECUTANDO INTEGRACAO RAPIDA
echo ============================================================
echo.
call EXECUTAR-INTEGRACAO-RAPIDA.bat
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause > nul
goto MENU

:AGENDAR
cls
call AGENDAR-INTEGRACAO-RAPIDA.bat
goto MENU

:STATUS
cls
call VER-INTEGRACAO-RAPIDA.bat
goto MENU

:VERIFICAR_PG
cls
call VERIFICAR-POSTGRESQL.bat
goto MENU

:INICIAR_PG
cls
call INICIAR-POSTGRESQL-ALTERDATA.bat
goto MENU

:DADOS
cls
call VER-DADOS-ATUAIS.bat
goto MENU

:LOGS
start "" "%~dp0logs"
echo.
echo Pasta de logs aberta!
timeout /t 2 > nul
goto MENU

:PAINEL
start "" "%~dp0_PAINEL_COPIAS_BANCOS.html"
echo.
echo Painel HTML aberto no navegador!
timeout /t 2 > nul
goto MENU

:DOCS
cls
echo ============================================================
echo   DOCUMENTACAO DISPONIVEL
echo ============================================================
echo.
echo Arquivos de documentacao:
echo.
echo  - README-SISTEMA-COMPLETO.txt
echo  - DOCUMENTACAO-INTEGRACAO-RAPIDA.md
echo  - RESUMO-INTEGRACAO-RAPIDA.txt
echo  - COMO-USAR-PAINEIS.txt
echo.
start "" "%~dp0README-SISTEMA-COMPLETO.txt"
echo.
echo README aberto! Pressione qualquer tecla para voltar...
pause > nul
goto MENU

:SAIR
cls
echo.
echo Obrigado por usar o sistema!
echo.
timeout /t 2 > nul
exit

