@echo off
echo ============================================================
echo   TESTE DO SISTEMA DE COPIAS ALTERDATA
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.
echo Este script verifica se o sistema esta configurado corretamente.
echo.

set ERRO=0

echo [TESTE 1] Verificando scripts principais...
echo.

REM Verificar scripts BAT
set SCRIPTS_BAT=COPIAR-BANCOS-ALTERDATA.bat AGENDAR-COPIA-BANCOS.bat VER-AGENDAMENTO-COPIAS.bat REMOVER-AGENDAMENTO-COPIAS.bat INICIO-RAPIDO-BANCOS.bat

for %%S in (%SCRIPTS_BAT%) do (
    if exist "%%S" (
        echo [OK] %%S
    ) else (
        echo [ERRO] %%S - NAO ENCONTRADO
        set ERRO=1
    )
)

echo.
echo [TESTE 2] Verificando documentacao...
echo.

if exist "DOCUMENTACAO-BANCOS-ALTERDATA.md" (
    echo [OK] DOCUMENTACAO-BANCOS-ALTERDATA.md
) else (
    echo [ERRO] DOCUMENTACAO-BANCOS-ALTERDATA.md - NAO ENCONTRADO
    set ERRO=1
)

if exist "README-COPIAS-BANCOS.txt" (
    echo [OK] README-COPIAS-BANCOS.txt
) else (
    echo [ERRO] README-COPIAS-BANCOS.txt - NAO ENCONTRADO
    set ERRO=1
)

if exist "_LEIA-ME_SISTEMA_COPIAS.txt" (
    echo [OK] _LEIA-ME_SISTEMA_COPIAS.txt
) else (
    echo [ERRO] _LEIA-ME_SISTEMA_COPIAS.txt - NAO ENCONTRADO
    set ERRO=1
)

if exist "_PAINEL_COPIAS_BANCOS.html" (
    echo [OK] _PAINEL_COPIAS_BANCOS.html
) else (
    echo [ERRO] _PAINEL_COPIAS_BANCOS.html - NAO ENCONTRADO
    set ERRO=1
)

echo.
echo [TESTE 3] Verificando diretorios...
echo.

if exist "logs\" (
    echo [OK] Diretorio logs\ existe
) else (
    echo [AVISO] Diretorio logs\ nao existe - criando...
    mkdir "logs"
    if exist "logs\" (
        echo [OK] Diretorio logs\ criado com sucesso
    ) else (
        echo [ERRO] Falha ao criar diretorio logs\
        set ERRO=1
    )
)

if exist "BANCOCOPIA190\" (
    echo [OK] Diretorio BANCOCOPIA190\ existe
) else (
    echo [AVISO] Diretorio BANCOCOPIA190\ nao existe
    echo        Execute COPIAR-BANCOS-ALTERDATA.bat para criar
)

if exist "BANCOCOPIA\" (
    echo [OK] Diretorio BANCOCOPIA\ existe
) else (
    echo [AVISO] Diretorio BANCOCOPIA\ nao existe
    echo        Execute COPIAR-BANCOS-ALTERDATA.bat para criar
)

echo.
echo [TESTE 4] Verificando origens dos bancos...
echo.

if exist "Z:\Program Files (x86)\Alterdata\" (
    echo [OK] Origem Z:\ acessivel
) else (
    echo [AVISO] Origem Z:\ nao acessivel
    echo        Verifique se a unidade de rede esta mapeada
)

if exist "C:\Program Files (x86)\Alterdata\" (
    echo [OK] Origem C:\ acessivel
) else (
    echo [AVISO] Origem C:\ nao acessivel
    echo        Verifique se o Alterdata esta instalado
)

echo.
echo [TESTE 5] Verificando agendamento...
echo.

schtasks /query /tn "CopiarBancosAlterdata" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Tarefa agendada encontrada
    
    REM Verificar se esta habilitada
    schtasks /query /tn "CopiarBancosAlterdata" /fo LIST 2>nul | findstr /C:"Status:" | findstr /C:"Pronta" >nul
    if %errorlevel% equ 0 (
        echo [OK] Tarefa esta HABILITADA
    ) else (
        echo [AVISO] Tarefa esta DESABILITADA
        echo        Para habilitar: schtasks /change /tn "CopiarBancosAlterdata" /enable
    )
) else (
    echo [INFO] Nenhuma tarefa agendada configurada
    echo        Execute: AGENDAR-COPIA-BANCOS.bat para configurar
)

echo.
echo [TESTE 6] Verificando espaco em disco...
echo.

for /f "tokens=2" %%a in ('wmic logicaldisk where "DeviceID='E:'" get FreeSpace /value ^| find "="') do set FREESPACE=%%a

if defined FREESPACE (
    set /a FREESPACE_GB=FREESPACE/1073741824
    echo [INFO] Espaco livre em E:\: !FREESPACE_GB! GB
    
    if !FREESPACE_GB! LSS 10 (
        echo [AVISO] Espaco em disco baixo ^(!FREESPACE_GB! GB^)
        echo        Recomenda-se pelo menos 20 GB livres
    ) else (
        echo [OK] Espaco em disco suficiente
    )
) else (
    echo [AVISO] Nao foi possivel verificar espaco em disco
)

echo.
echo [TESTE 7] Verificando Python (para CONSULTAR-COPIAS.py)...
echo.

python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Python instalado
    python --version
    
    if exist "CONSULTAR-COPIAS.py" (
        echo [OK] CONSULTAR-COPIAS.py encontrado
    ) else (
        echo [ERRO] CONSULTAR-COPIAS.py NAO ENCONTRADO
        set ERRO=1
    )
) else (
    echo [AVISO] Python nao encontrado no PATH
    echo        Instale Python para usar CONSULTAR-COPIAS.py
)

echo.
echo ============================================================
echo   RESULTADO FINAL DO TESTE
echo ============================================================
echo.

if %ERRO% equ 0 (
    echo [OK] SISTEMA CONFIGURADO CORRETAMENTE!
    echo.
    echo Proximos passos:
    echo.
    echo 1. Execute COPIAR-BANCOS-ALTERDATA.bat para primeira copia
    echo 2. Execute AGENDAR-COPIA-BANCOS.bat para configurar agendamento
    echo 3. Use VER-AGENDAMENTO-COPIAS.bat para monitorar
    echo.
    echo Ou use o painel interativo:
    echo    _PAINEL_COPIAS_BANCOS.html
    echo    INICIO-RAPIDO-BANCOS.bat
) else (
    echo [ERRO] PROBLEMAS DETECTADOS NO SISTEMA
    echo.
    echo Revise os erros acima e corrija antes de continuar.
)

echo.
echo ============================================================
echo.
echo Pressione qualquer tecla para fechar...
pause > nul

