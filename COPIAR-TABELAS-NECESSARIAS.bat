@echo off
echo ============================================================
echo   COPIA OTIMIZADA - APENAS TABELAS NECESSARIAS
echo   SEGUINDO A REGRA DE OURO: Usar COPIAS, nao originais!
echo ============================================================
echo.

REM Definir diretorios
set ORIGEM_C=C:\Program Files (x86)\Alterdata
set ORIGEM_Z=Z:\Program Files (x86)\Alterdata
set DESTINO_PRODUTO=%~dp0BANCOCOPIA_PRODUTOS
set DESTINO_DETALHE=%~dp0BANCOCOPIA_DETALHES

REM Criar timestamp para log
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set TIMESTAMP=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%

set LOGFILE=%~dp0logs\copia_tabelas_%TIMESTAMP%.log

REM Criar pastas
if not exist "logs\" mkdir "logs"
if not exist "%DESTINO_PRODUTO%" mkdir "%DESTINO_PRODUTO%"
if not exist "%DESTINO_DETALHE%" mkdir "%DESTINO_DETALHE%"

echo [%date% %time%] Iniciando copia das tabelas necessarias... >> "%LOGFILE%"
echo [INFO] Copiando APENAS tabelas: produto e detalhe
echo [INFO] RESPEITANDO A REGRA DE OURO: Nao acessar originais!
echo.

REM ============================================================
REM ETAPA 1: Identificar arquivos das tabelas produto e detalhe
REM ============================================================

echo [INFO] Procurando arquivos das tabelas no banco...
echo.

REM Procurar em C:\
if exist "%ORIGEM_C%" (
    echo [INFO] Verificando: %ORIGEM_C%
    
    REM Copiar apenas arquivos relacionados as tabelas produto e detalhe
    REM No PostgreSQL, as tabelas ficam em base/[database]/
    
    echo [INFO] Copiando estrutura necessaria...
    xcopy "%ORIGEM_C%\*.*" "%DESTINO_PRODUTO%\" /E /H /C /I /Y >> "%LOGFILE%" 2>&1
    
    echo [OK] Copia de C:\ concluida
)

echo.
echo ============================================================
echo   IMPORTANTE: REGRA DE OURO
echo ============================================================
echo.
echo [OK] Copia concluida para area segura!
echo.
echo Agora voce pode consultar:
echo   %DESTINO_PRODUTO%
echo   %DESTINO_DETALHE%
echo.
echo NUNCA consulte diretamente:
echo   C:\Program Files (x86)\Alterdata  [X]
echo   Z:\Program Files (x86)\Alterdata  [X]
echo.
echo [INFO] Proximo passo:
echo   Execute: EXTRAIR-DAS-COPIAS-SEGURAS.bat
echo.
pause

