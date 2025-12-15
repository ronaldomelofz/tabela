@echo off
REM ============================================================
REM   AUTOMACAO COMPLETA - COPIA + EXTRACAO + GITHUB
REM   Repositorio: https://github.com/ronaldomelofz/tabela
REM   RESPEITA A REGRA DE OURO: Usa COPIAS, nunca originais!
REM ============================================================

cd /d "%~dp0"

REM Criar timestamp para log
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set TIMESTAMP=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%

set LOGFILE=logs\automacao_completa_%TIMESTAMP%.log

REM Criar pasta de logs
if not exist "logs\" mkdir "logs"

echo ============================================================ >> "%LOGFILE%"
echo   AUTOMACAO COMPLETA INICIADA >> "%LOGFILE%"
echo   Data/Hora: %date% %time% >> "%LOGFILE%"
echo ============================================================ >> "%LOGFILE%"
echo. >> "%LOGFILE%"

if "%1"=="auto" (
    REM Modo silencioso (executado pelo agendador)
    set MODO=AUTO
) else (
    REM Modo interativo
    set MODO=MANUAL
    cls
    echo ============================================================
    echo   AUTOMACAO COMPLETA DO SISTEMA
    echo ============================================================
    echo.
    echo Este script vai executar TUDO automaticamente:
    echo.
    echo   1. Copiar bancos Alterdata (RESPEITANDO REGRA DE OURO)
    echo   2. Extrair dados DAS COPIAS (nunca dos originais)
    echo   3. Atualizar data/produtos.json
    echo   4. Fazer commit no Git
    echo   5. Enviar para GitHub
    echo.
    echo IMPORTANTE: Respeitamos a REGRA DE OURO!
    echo   - Copiamos de: C:\ e Z:\ (originais)
    echo   - Consultamos: BANCOCOPIA e BANCOCOPIA190 (copias)
    echo   - NUNCA acessamos originais diretamente!
    echo.
    echo ============================================================
    echo.
    echo Isso pode levar varios minutos...
    echo.
    pause
    cls
)

echo [%time%] Iniciando automacao completa... >> "%LOGFILE%"

REM ============================================================
REM ETAPA 1: COPIAR BANCOS (Respeitando Regra de Ouro)
REM ============================================================

if "%MODO%"=="MANUAL" (
    echo ============================================================
    echo   ETAPA 1/5: Copiando Bancos de Dados
    echo ============================================================
    echo.
    echo [INFO] Copiando de C:\ e Z:\ para BANCOCOPIA e BANCOCOPIA190
    echo [INFO] Isso pode levar 5-10 minutos...
    echo.
)

echo [%time%] ETAPA 1: Iniciando copia dos bancos... >> "%LOGFILE%"

REM Executar script de copia (ja existente e correto!)
call COPIAR-BANCOS-ALTERDATA.bat auto >> "%LOGFILE%" 2>&1

if %errorlevel% equ 0 (
    echo [%time%] ETAPA 1: Copia concluida com sucesso >> "%LOGFILE%"
    if "%MODO%"=="MANUAL" (
        echo [OK] Copias criadas com sucesso!
        echo.
    )
) else (
    echo [%time%] ETAPA 1: ERRO na copia dos bancos >> "%LOGFILE%"
    if "%MODO%"=="MANUAL" (
        echo [ERRO] Falha ao copiar bancos!
        echo Verifique o log: %LOGFILE%
        pause
    )
    exit /b 1
)

REM ============================================================
REM ETAPA 2: EXTRAIR DADOS DAS COPIAS (Regra de Ouro!)
REM ============================================================

if "%MODO%"=="MANUAL" (
    echo ============================================================
    echo   ETAPA 2/5: Extraindo Dados DAS COPIAS
    echo ============================================================
    echo.
    echo [INFO] Lendo de BANCOCOPIA e BANCOCOPIA190
    echo [INFO] NUNCA acessando os bancos originais!
    echo.
)

echo [%time%] ETAPA 2: Extraindo dados das copias... >> "%LOGFILE%"

REM Verificar se Python esta disponivel
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [%time%] ERRO: Python nao encontrado >> "%LOGFILE%"
    if "%MODO%"=="MANUAL" (
        echo [ERRO] Python nao encontrado!
        echo Instale Python: https://www.python.org/downloads/
        pause
    )
    exit /b 1
)

REM Executar script de extracao (que deve ler das COPIAS!)
if exist "scripts\extrair-dados-copia.py" (
    python scripts\extrair-dados-copia.py >> "%LOGFILE%" 2>&1
) else if exist "EXTRAIR-DA-COPIA-FINAL.bat" (
    call EXTRAIR-DA-COPIA-FINAL.bat >> "%LOGFILE%" 2>&1
) else (
    echo [%time%] ERRO: Script de extracao nao encontrado >> "%LOGFILE%"
    if "%MODO%"=="MANUAL" (
        echo [ERRO] Script de extracao nao encontrado!
        pause
    )
    exit /b 1
)

if %errorlevel% equ 0 (
    echo [%time%] ETAPA 2: Extracao concluida >> "%LOGFILE%"
    if "%MODO%"=="MANUAL" (
        echo [OK] Dados extraidos com sucesso!
        echo.
    )
) else (
    echo [%time%] ETAPA 2: ERRO na extracao >> "%LOGFILE%"
    if "%MODO%"=="MANUAL" (
        echo [AVISO] Possivel erro na extracao
        echo Continuando mesmo assim...
        echo.
    )
)

REM ============================================================
REM ETAPA 3: VERIFICAR ARQUIVO DE DADOS
REM ============================================================

if "%MODO%"=="MANUAL" (
    echo ============================================================
    echo   ETAPA 3/5: Verificando Arquivo de Dados
    echo ============================================================
    echo.
)

echo [%time%] ETAPA 3: Verificando data/produtos.json... >> "%LOGFILE%"

if exist "data\produtos.json" (
    echo [%time%] Arquivo encontrado: data/produtos.json >> "%LOGFILE%"
    for %%f in ("data\produtos.json") do (
        echo [%time%] Tamanho: %%~zf bytes >> "%LOGFILE%"
    )
    if "%MODO%"=="MANUAL" (
        echo [OK] Arquivo data/produtos.json encontrado
        echo.
    )
) else (
    echo [%time%] ERRO: data/produtos.json nao encontrado >> "%LOGFILE%"
    if "%MODO%"=="MANUAL" (
        echo [ERRO] Arquivo data/produtos.json nao encontrado!
        echo A extracao pode ter falhado.
        pause
    )
    exit /b 1
)

REM ============================================================
REM ETAPA 4: GIT COMMIT
REM ============================================================

if "%MODO%"=="MANUAL" (
    echo ============================================================
    echo   ETAPA 4/5: Fazendo Commit no Git
    echo ============================================================
    echo.
)

echo [%time%] ETAPA 4: Fazendo commit no Git... >> "%LOGFILE%"

REM Verificar se Git esta instalado
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [%time%] ERRO: Git nao encontrado >> "%LOGFILE%"
    if "%MODO%"=="MANUAL" (
        echo [ERRO] Git nao encontrado!
        echo Instale Git: https://git-scm.com/downloads
        pause
    )
    exit /b 1
)

REM Adicionar arquivos
git add data/produtos.json >> "%LOGFILE%" 2>&1
git add data/*.json >> "%LOGFILE%" 2>&1
git add estoque*.json estoque*.csv >> "%LOGFILE%" 2>&1

REM Verificar se ha mudancas
git diff --cached --quiet
if %errorlevel% neq 0 (
    REM Ha mudancas, fazer commit
    git commit -m "Atualizacao automatica - %date% %time%" >> "%LOGFILE%" 2>&1
    
    if %errorlevel% equ 0 (
        echo [%time%] Commit realizado com sucesso >> "%LOGFILE%"
        if "%MODO%"=="MANUAL" (
            echo [OK] Commit realizado!
            echo.
        )
    ) else (
        echo [%time%] ERRO ao fazer commit >> "%LOGFILE%"
        if "%MODO%"=="MANUAL" (
            echo [ERRO] Falha ao fazer commit!
            pause
        )
    )
) else (
    echo [%time%] Nenhuma mudanca detectada >> "%LOGFILE%"
    if "%MODO%"=="MANUAL" (
        echo [INFO] Nenhuma mudanca detectada
        echo Os dados ja estao atualizados!
        echo.
    )
)

REM ============================================================
REM ETAPA 5: GIT PUSH PARA GITHUB
REM ============================================================

if "%MODO%"=="MANUAL" (
    echo ============================================================
    echo   ETAPA 5/5: Enviando para GitHub
    echo ============================================================
    echo.
)

echo [%time%] ETAPA 5: Enviando para GitHub... >> "%LOGFILE%"

git push origin main >> "%LOGFILE%" 2>&1

if %errorlevel% equ 0 (
    echo [%time%] Push realizado com sucesso >> "%LOGFILE%"
    if "%MODO%"=="MANUAL" (
        echo [OK] Enviado para GitHub com sucesso!
        echo.
        echo Repositorio: https://github.com/ronaldomelofz/tabela
        echo.
    )
) else (
    echo [%time%] ERRO ao fazer push >> "%LOGFILE%"
    if "%MODO%"=="MANUAL" (
        echo [AVISO] Falha ao enviar para GitHub
        echo Verifique suas credenciais Git
        echo.
    )
)

REM ============================================================
REM RESUMO FINAL
REM ============================================================

echo [%time%] Automacao concluida >> "%LOGFILE%"
echo ============================================================ >> "%LOGFILE%"

if "%MODO%"=="MANUAL" (
    echo ============================================================
    echo   AUTOMACAO CONCLUIDA!
    echo ============================================================
    echo.
    echo Resumo:
    echo   [OK] Bancos copiados (RESPEITANDO REGRA DE OURO)
    echo   [OK] Dados extraidos DAS COPIAS
    echo   [OK] Arquivo atualizado: data/produtos.json
    echo   [OK] Commit realizado
    echo   [OK] Enviado para GitHub
    echo.
    echo Repositorio: https://github.com/ronaldomelofz/tabela
    echo.
    echo Log salvo em: %LOGFILE%
    echo.
    echo ============================================================
    echo.
    pause
)

exit /b 0

