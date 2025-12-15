@echo off
REM Script executado automaticamente pelo agendador

REM Criar timestamp para log
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set TIMESTAMP=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%

set LOGFILE=%~dp0logs\integracao_rapida_%TIMESTAMP%.log

REM Criar pasta de logs se nao existir
if not exist "%~dp0logs\" mkdir "%~dp0logs"

echo [%date% %time%] Iniciando integracao automatica rapida... >> "%LOGFILE%"

REM Executar script Python de extracao direta
cd /d "%~dp0"

python scripts\extrair-dados-copia.py >> "%LOGFILE%" 2>&1

if %errorlevel% equ 0 (
    echo [%date% %time%] [OK] Integracao concluida com sucesso >> "%LOGFILE%"
) else (
    echo [%date% %time%] [ERRO] Falha na integracao >> "%LOGFILE%"
)

echo [%date% %time%] Processo finalizado >> "%LOGFILE%"

exit /b 0

