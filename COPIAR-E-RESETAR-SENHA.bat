@echo off
:: Copiar Banco de Dados e Resetar Senha NA COPIA
:: Deixa o original intacto!

title Copiar Banco e Resetar Senha

echo ====================================================================
echo  COPIAR BANCO DE DADOS E RESETAR SENHA (NA COPIA)
echo ====================================================================
echo.
echo Este script vai:
echo   1. Copiar TODOS os dados do PostgreSQL
echo   2. Criar copia em: E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA
echo   3. Resetar senha NA COPIA (original fica intacto!)
echo   4. Iniciar PostgreSQL com a copia (porta 5434)
echo   5. Extrair dados completos
echo.
echo Tamanho aproximado: 2 GB
echo Tempo estimado: 5-10 minutos
echo.
echo SEGURO: O banco original NAO sera modificado!
echo.
pause

:: Verificar se esta rodando como Admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [ERRO] Este script precisa ser executado como Administrador!
    echo.
    echo Clique com botao direito e selecione "Executar como administrador"
    echo.
    pause
    exit /b 1
)

echo.
echo ====================================================================
echo  EXECUTANDO COPIA E CONFIGURACAO
echo ====================================================================
echo.

:: Executar script Python
python scripts\copiar-e-resetar-copia.py

if %errorLevel% neq 0 (
    echo.
    echo [ERRO] Falha no processo
    pause
    exit /b 1
)

echo.
echo ====================================================================
echo  CONCLUIDO COM SUCESSO!
echo ====================================================================
echo.
echo [OK] Banco copiado e senha resetada (NA COPIA)!
echo [OK] Banco ORIGINAL permanece intacto
echo.
echo Proximos passos:
echo   1. Use: python scripts\extrair-dados-copia.py
echo   2. Ou conecte: psql -h localhost -p 5434 -U postgres -d ALTERDATA_SHOP
echo.
pause




