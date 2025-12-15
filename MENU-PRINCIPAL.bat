@echo off
:MENU
cls
echo ============================================================
echo   MENU PRINCIPAL - SISTEMA INTEGRACAO ALTERDATA
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.
echo  INTEGRACAO RAPIDA (Recomendado - 100x mais rapido):
echo  =====================================================
echo  1. Executar Integracao Agora (5-10 segundos)
echo  2. Agendar Integracao Automatica (10, 20, 30 min)
echo  3. Ver Status da Integracao
echo  4. Ver Dados Atuais (produtos.json)
echo.
echo  SISTEMA DE COPIA COMPLETA (Opcional):
echo  =====================================================
echo  5. Executar Copia Completa (5-10 minutos)
echo  6. Agendar Copia Completa
echo  7. Ver Agendamento de Copias
echo.
echo  VISUALIZACAO E DOCUMENTACAO:
echo  =====================================================
echo  8. Abrir Painel de Controle (HTML)
echo  9. Abrir Guia Visual Integracao Rapida
echo  10. Abrir Pasta de Logs
echo  11. Ver Documentacao
echo.
echo  0. Sair
echo.
echo ============================================================

choice /C 1234567890AB /N /M "Escolha uma opcao: "

if errorlevel 12 goto DOCS
if errorlevel 11 goto LOGS
if errorlevel 10 goto GUIA
if errorlevel 9 goto PAINEL
if errorlevel 8 goto VER_COPIA
if errorlevel 7 goto AGENDAR_COPIA
if errorlevel 6 goto COPIA
if errorlevel 5 goto DADOS
if errorlevel 4 goto STATUS
if errorlevel 3 goto AGENDAR
if errorlevel 2 goto EXECUTAR
if errorlevel 1 goto SAIR

:EXECUTAR
cls
call EXECUTAR-INTEGRACAO-RAPIDA.bat
goto MENU

:AGENDAR
cls
call AGENDAR-INTEGRACAO-RAPIDA.bat
goto MENU

:STATUS
cls
call VER-INTEGRACAO-RAPIDA.bat
goto MENU

:DADOS
cls
call VER-DADOS-ATUAIS.bat
goto MENU

:COPIA
cls
call COPIAR-BANCOS-ALTERDATA.bat
goto MENU

:AGENDAR_COPIA
cls
call AGENDAR-COPIA-BANCOS.bat
goto MENU

:VER_COPIA
cls
call VER-AGENDAMENTO-COPIAS.bat
goto MENU

:PAINEL
start "" "%~dp0_PAINEL_COPIAS_BANCOS.html"
goto MENU

:GUIA
start "" "%~dp0_COMECE_AQUI_INTEGRACAO_RAPIDA.html"
goto MENU

:LOGS
start "" "%~dp0logs"
goto MENU

:DOCS
cls
echo ============================================================
echo   DOCUMENTACAO DISPONIVEL
echo ============================================================
echo.
echo 1. DOCUMENTACAO-INTEGRACAO-RAPIDA.md   (Guia completo)
echo 2. RESUMO-INTEGRACAO-RAPIDA.txt        (Referencia rapida)
echo 3. RESUMO-FINAL-OTIMIZACAO.txt         (Resumo do sistema)
echo 4. _COMECE_AQUI_INTEGRACAO_RAPIDA.html (Guia visual)
echo 5. _PAINEL_COPIAS_BANCOS.html          (Painel de controle)
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause > nul
goto MENU

:SAIR
cls
echo.
echo Obrigado por usar o sistema!
echo.
timeout /t 2 > nul
exit

