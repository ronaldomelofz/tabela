@echo off
echo ============================================================
echo   STATUS DA AUTOMACAO COMPLETA
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

set TASK_NAME=AutomacaoCompletaAlterdata

echo [INFO] Verificando tarefa agendada: %TASK_NAME%
echo.

schtasks /query /tn "%TASK_NAME%" /fo LIST /v 2>nul

if %errorlevel% equ 0 (
    echo.
    echo ============================================================
    echo.
    echo [INFO] Opcoes disponiveis:
    echo.
    echo Para desabilitar temporariamente:
    echo   schtasks /change /tn "%TASK_NAME%" /disable
    echo.
    echo Para habilitar novamente:
    echo   schtasks /change /tn "%TASK_NAME%" /enable
    echo.
    echo Para executar manualmente agora:
    echo   schtasks /run /tn "%TASK_NAME%"
    echo.
    echo Para remover:
    echo   schtasks /delete /tn "%TASK_NAME%" /f
    echo.
    echo Para reagendar:
    echo   Execute: AGENDAR-AUTOMACAO-COMPLETA.bat
    echo.
) else (
    echo.
    echo ============================================================
    echo [INFO] Nenhuma tarefa agendada encontrada
    echo ============================================================
    echo.
    echo Para criar automacao completa:
    echo   Execute: AGENDAR-AUTOMACAO-COMPLETA.bat
    echo.
    echo Para executar manualmente:
    echo   Execute: AUTOMACAO-COMPLETA.bat
    echo.
)

echo ============================================================
echo.

REM Verificar logs recentes
echo [INFO] Ultimos logs de automacao:
echo.
if exist "logs\automacao_completa_*.log" (
    echo Logs encontrados em: logs\
    for /f "delims=" %%f in ('dir /B /O-D "logs\automacao_completa_*.log" 2^>nul') do (
        set ULTIMO_LOG=%%f
        goto MOSTRAR_LOG
    )
) else (
    echo Nenhum log encontrado ainda.
    echo Execute a automacao para gerar logs.
)
goto VERIFICAR_DADOS

:MOSTRAR_LOG
if defined ULTIMO_LOG (
    echo.
    echo Ultimo log: %ULTIMO_LOG%
    echo.
    echo Conteudo (ultimas 20 linhas):
    echo ------------------------------------------------------------
    powershell -Command "Get-Content 'logs\%ULTIMO_LOG%' -Tail 20"
    echo ------------------------------------------------------------
)

:VERIFICAR_DADOS
echo.
echo ============================================================
echo   STATUS DOS DADOS
echo ============================================================
echo.

if exist "data\produtos.json" (
    echo [INFO] Arquivo de dados: data\produtos.json
    for %%f in ("data\produtos.json") do (
        echo   Tamanho: %%~zf bytes
        echo   Modificado: %%~tf
    )
    echo.
    
    REM Verificar ultimo commit Git
    git log -1 --pretty=format:"  Ultimo commit: %%h - %%s (%%ar)" 2>nul
    echo.
    echo.
    
    REM Verificar status Git
    git status -s 2>nul | findstr "." >nul
    if %errorlevel% equ 0 (
        echo [AVISO] Ha mudancas nao commitadas:
        git status -s
    ) else (
        echo [OK] Repositorio limpo (sem mudancas pendentes)
    )
) else (
    echo [AVISO] Arquivo data\produtos.json nao encontrado
    echo Execute a automacao para gerar os dados
)

echo.
echo ============================================================
echo.
pause

