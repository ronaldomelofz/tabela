@echo off
echo ============================================================
echo   INICIO RAPIDO - SISTEMA DE COPIAS ALTERDATA
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.
echo Este assistente vai configurar o sistema de copias automaticas
echo dos bancos de dados Alterdata.
echo.
echo ============================================================
echo.

:MENU
echo ESCOLHA UMA OPCAO:
echo.
echo 1. Executar PRIMEIRA COPIA (configuracao inicial)
echo 2. Configurar AGENDAMENTO AUTOMATICO
echo 3. Verificar STATUS do agendamento
echo 4. Visualizar LOGS recentes
echo 5. Extrair DADOS das copias
echo 6. DOCUMENTACAO completa
echo 7. Sair
echo.

choice /C 1234567 /M "Digite o numero da opcao"

if errorlevel 7 goto SAIR
if errorlevel 6 goto DOCS
if errorlevel 5 goto EXTRAIR
if errorlevel 4 goto LOGS
if errorlevel 3 goto STATUS
if errorlevel 2 goto AGENDAR
if errorlevel 1 goto COPIA

:COPIA
cls
echo ============================================================
echo   EXECUTANDO PRIMEIRA COPIA
echo ============================================================
echo.
echo [INFO] Isso pode levar varios minutos...
echo [INFO] Aguarde ate a conclusao.
echo.
call COPIAR-BANCOS-ALTERDATA.bat
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause > nul
cls
goto MENU

:AGENDAR
cls
echo ============================================================
echo   CONFIGURAR AGENDAMENTO
echo ============================================================
echo.
call AGENDAR-COPIA-BANCOS.bat
cls
goto MENU

:STATUS
cls
echo ============================================================
echo   STATUS DO AGENDAMENTO
echo ============================================================
echo.
call VER-AGENDAMENTO-COPIAS.bat
cls
goto MENU

:LOGS
cls
echo ============================================================
echo   LOGS RECENTES
echo ============================================================
echo.
if exist "logs\copia_bancos_*.log" (
    echo Listando ultimos 5 logs:
    echo.
    dir /B /O-D logs\copia_bancos_*.log | findstr /R "." | more
    echo.
    echo.
    set /p LOGFILE="Digite o nome do log para visualizar (ou ENTER para voltar): "
    if not "!LOGFILE!"=="" (
        if exist "logs\!LOGFILE!" (
            cls
            echo Conteudo de: !LOGFILE!
            echo ============================================================
            type "logs\!LOGFILE!"
            echo ============================================================
        )
    )
) else (
    echo [INFO] Nenhum log encontrado ainda.
    echo.
    echo Execute a primeira copia para gerar logs.
)
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause > nul
cls
goto MENU

:EXTRAIR
cls
echo ============================================================
echo   EXTRAIR DADOS DAS COPIAS
echo ============================================================
echo.
if exist "EXTRAIR-DA-COPIA-FINAL.bat" (
    call EXTRAIR-DA-COPIA-FINAL.bat
) else (
    echo [AVISO] Script de extracao nao encontrado.
    echo.
    echo Certifique-se de que EXTRAIR-DA-COPIA-FINAL.bat existe.
)
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause > nul
cls
goto MENU

:DOCS
cls
echo ============================================================
echo   DOCUMENTACAO
echo ============================================================
echo.
if exist "DOCUMENTACAO-BANCOS-ALTERDATA.md" (
    echo Abrindo documentacao...
    start "" "DOCUMENTACAO-BANCOS-ALTERDATA.md"
    echo.
    echo [OK] Documentacao aberta no editor padrao.
) else (
    echo [ERRO] Arquivo de documentacao nao encontrado.
)
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause > nul
cls
goto MENU

:SAIR
cls
echo.
echo ============================================================
echo   RESUMO DO SISTEMA
echo ============================================================
echo.
echo Estrutura dos Bancos:
echo.
echo   BANCOCOPIA190 (Z:\) - Informacoes de ESTOQUE
echo   BANCOCOPIA (C:\)    - Informacoes de PRODUTOS/PRECOS
echo.
echo Scripts Disponiveis:
echo.
echo   COPIAR-BANCOS-ALTERDATA.bat      - Executar copia manual
echo   AGENDAR-COPIA-BANCOS.bat         - Configurar agendamento
echo   VER-AGENDAMENTO-COPIAS.bat       - Verificar status
echo   REMOVER-AGENDAMENTO-COPIAS.bat   - Remover agendamento
echo.
echo Documentacao:
echo.
echo   DOCUMENTACAO-BANCOS-ALTERDATA.md - Guia completo
echo.
echo ============================================================
echo.
echo Obrigado por usar o sistema!
echo.
pause
exit

