@echo off
echo ============================================================
echo   STATUS DA INTEGRACAO AUTOMATICA RAPIDA
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

set TASK_NAME=IntegracaoRapidaAlterdata

echo [INFO] Verificando tarefa agendada: %TASK_NAME%
echo.

schtasks /query /tn "%TASK_NAME%" /fo LIST /v 2>nul

if %errorlevel% equ 0 (
    echo.
    echo ============================================================
    echo.
    echo [INFO] Opcoes disponiveis:
    echo.
    echo Para desabilitar:
    echo   schtasks /change /tn "%TASK_NAME%" /disable
    echo.
    echo Para habilitar:
    echo   schtasks /change /tn "%TASK_NAME%" /enable
    echo.
    echo Para executar agora:
    echo   schtasks /run /tn "%TASK_NAME%"
    echo.
    echo Para remover:
    echo   schtasks /delete /tn "%TASK_NAME%" /f
    echo.
    echo Para reagendar:
    echo   Execute: AGENDAR-INTEGRACAO-RAPIDA.bat
    echo.
) else (
    echo.
    echo ============================================================
    echo [INFO] Nenhuma tarefa agendada encontrada
    echo ============================================================
    echo.
    echo Para criar integracao automatica:
    echo   Execute: AGENDAR-INTEGRACAO-RAPIDA.bat
    echo.
)

echo ============================================================
echo.

REM Verificar logs recentes
echo [INFO] Ultimos logs de integracao:
echo.
if exist "logs\integracao_rapida_*.log" (
    echo Logs encontrados em: logs\
    dir /B /O-D "logs\integracao_rapida_*.log" 2>nul | findstr /R "." >nul
    if %errorlevel% equ 0 (
        for /f "delims=" %%f in ('dir /B /O-D "logs\integracao_rapida_*.log" 2^>nul') do (
            set ULTIMO_LOG=%%f
            goto MOSTRAR_LOG
        )
    )
) else (
    echo Nenhum log encontrado ainda.
)

:MOSTRAR_LOG
if defined ULTIMO_LOG (
    echo.
    echo Ultimo log: %ULTIMO_LOG%
    echo.
    echo Conteudo (ultimas 15 linhas):
    echo ------------------------------------------------------------
    powershell -Command "Get-Content 'logs\%ULTIMO_LOG%' -Tail 15"
    echo ------------------------------------------------------------
)

echo.
echo ============================================================
echo.

REM Verificar arquivo de dados
if exist "data\produtos.json" (
    echo [INFO] Arquivo de dados: data\produtos.json
    for %%f in ("data\produtos.json") do (
        echo   Tamanho: %%~zf bytes
        echo   Modificado: %%~tf
    )
) else (
    echo [AVISO] Arquivo data\produtos.json nao encontrado
    echo Execute a integracao manualmente primeiro
)

echo.
echo ============================================================
echo.
echo Pressione qualquer tecla para fechar...
pause > nul

