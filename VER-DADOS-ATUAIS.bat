@echo off
echo ============================================================
echo   DADOS ATUAIS DO SISTEMA
echo ============================================================
echo.

if exist "data\produtos.json" (
    echo [INFO] Arquivo de dados encontrado!
    echo.
    echo Arquivo: data\produtos.json
    for %%f in ("data\produtos.json") do (
        echo Tamanho: %%~zf bytes
        echo Modificado: %%~tf
    )
    echo.
    echo.
    echo [INFO] Primeiros produtos (preview):
    echo ============================================================
    powershell -Command "Get-Content 'data\produtos.json' -Encoding UTF8 | Select-Object -First 30"
    echo ============================================================
    echo.
    echo [INFO] Para ver o arquivo completo:
    echo   notepad data\produtos.json
    echo.
) else (
    echo [AVISO] Arquivo data\produtos.json nao encontrado!
    echo.
    echo Para criar o arquivo, execute:
    echo   EXECUTAR-INTEGRACAO-RAPIDA.bat
    echo.
)

echo ============================================================
echo.
pause

