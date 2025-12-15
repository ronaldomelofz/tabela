@echo off
echo ============================================================
echo   COPIA AUTOMATICA DOS BANCOS DE DADOS ALTERDATA
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

REM Definir diretorios de origem e destino
set ORIGEM_Z=Z:\Program Files (x86)\Alterdata
set DESTINO_190=E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA190

set ORIGEM_C=C:\Program Files (x86)\Alterdata
set DESTINO_PRINCIPAL=E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA

REM Criar timestamp para log
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set TIMESTAMP=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%

set LOGFILE=E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\logs\copia_bancos_%TIMESTAMP%.log

REM Criar pasta de logs se nao existir
if not exist "E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\logs\" mkdir "E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\logs"

echo [%date% %time%] Iniciando copia dos bancos de dados... >> "%LOGFILE%"
echo [%date% %time%] Iniciando copia dos bancos de dados...
echo.

REM ============================================================
REM ETAPA 1: COPIAR BANCO DE Z:\ PARA BANCOCOPIA190
REM ============================================================
echo ============================================================
echo ETAPA 1: Copiando banco de dados da unidade Z:\
echo Origem: %ORIGEM_Z%
echo Destino: %DESTINO_190%
echo ============================================================
echo.
echo [%date% %time%] ETAPA 1: Copiando de Z:\ para BANCOCOPIA190... >> "%LOGFILE%"

if not exist "%ORIGEM_Z%" (
    echo [ERRO] Diretorio de origem Z:\ nao encontrado: %ORIGEM_Z%
    echo [%date% %time%] [ERRO] Diretorio Z:\ nao encontrado >> "%LOGFILE%"
    goto ETAPA2
)

REM Criar diretorio de destino se nao existir
if not exist "%DESTINO_190%" mkdir "%DESTINO_190%"

REM Copiar arquivos com robocopy (mais eficiente para grandes volumes)
echo Copiando arquivos... (Isso pode levar alguns minutos)
robocopy "%ORIGEM_Z%" "%DESTINO_190%" /E /COPYALL /R:3 /W:5 /MT:8 /NFL /NDL /NP /LOG+:"%LOGFILE%"

if %errorlevel% LEQ 7 (
    echo [OK] Copia do banco Z:\ concluida com sucesso!
    echo [%date% %time%] [OK] Copia Z:\ concluida >> "%LOGFILE%"
) else (
    echo [ERRO] Falha ao copiar banco de Z:\
    echo [%date% %time%] [ERRO] Falha na copia Z:\ >> "%LOGFILE%"
)

echo.

:ETAPA2
REM ============================================================
REM ETAPA 2: COPIAR BANCO DE C:\ PARA BANCOCOPIA
REM ============================================================
echo ============================================================
echo ETAPA 2: Copiando banco de dados da unidade C:\
echo Origem: %ORIGEM_C%
echo Destino: %DESTINO_PRINCIPAL%
echo ============================================================
echo.
echo [%date% %time%] ETAPA 2: Copiando de C:\ para BANCOCOPIA... >> "%LOGFILE%"

if not exist "%ORIGEM_C%" (
    echo [ERRO] Diretorio de origem C:\ nao encontrado: %ORIGEM_C%
    echo [%date% %time%] [ERRO] Diretorio C:\ nao encontrado >> "%LOGFILE%"
    goto FIM
)

REM Criar diretorio de destino se nao existir
if not exist "%DESTINO_PRINCIPAL%" mkdir "%DESTINO_PRINCIPAL%"

REM Copiar arquivos com robocopy
echo Copiando arquivos... (Isso pode levar alguns minutos)
robocopy "%ORIGEM_C%" "%DESTINO_PRINCIPAL%" /E /COPYALL /R:3 /W:5 /MT:8 /NFL /NDL /NP /LOG+:"%LOGFILE%"

if %errorlevel% LEQ 7 (
    echo [OK] Copia do banco C:\ concluida com sucesso!
    echo [%date% %time%] [OK] Copia C:\ concluida >> "%LOGFILE%"
) else (
    echo [ERRO] Falha ao copiar banco de C:\
    echo [%date% %time%] [ERRO] Falha na copia C:\ >> "%LOGFILE%"
)

echo.

:FIM
REM ============================================================
REM RESUMO FINAL
REM ============================================================
echo ============================================================
echo   RESUMO DA OPERACAO
echo ============================================================
echo.
echo [INFO] Uso dos bancos de dados:
echo.
echo   BANCOCOPIA190 (origem Z:\):
echo     - Informacoes de ESTOQUE
echo     - Consultas de quantidade disponivel
echo.
echo   BANCOCOPIA (origem C:\):
echo     - Informacoes de PRODUTOS (novos, excluidos)
echo     - Informacoes de VALORES/PRECOS
echo     - Cadastro de produtos
echo.
echo [INFO] SEMPRE utilize as COPIAS para consultas e extracao!
echo.
echo [INFO] Log detalhado salvo em:
echo   %LOGFILE%
echo.
echo ============================================================
echo [%date% %time%] Processo finalizado >> "%LOGFILE%"
echo.

if "%1"=="auto" (
    REM Se executado automaticamente, nao pausar
    exit /b 0
) else (
    REM Se executado manualmente, pausar para ver resultado
    echo Pressione qualquer tecla para fechar...
    pause > nul
)

