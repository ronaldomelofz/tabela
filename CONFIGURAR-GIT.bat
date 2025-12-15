@echo off
echo ============================================================
echo   CONFIGURAR GIT PARA AUTOMACAO
echo   Repositorio: https://github.com/ronaldomelofz/tabela
echo ============================================================
echo.

REM Verificar se Git esta instalado
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Git nao encontrado!
    echo.
    echo Instale o Git primeiro:
    echo   https://git-scm.com/downloads
    echo.
    pause
    exit /b 1
)

echo [OK] Git encontrado!
echo.

REM Verificar se ja esta em um repositorio Git
git status >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Inicializando repositorio Git...
    git init
    echo.
)

echo ============================================================
echo   CONFIGURACAO DO GIT
echo ============================================================
echo.

REM Configurar usuario (se ainda nao estiver configurado)
git config user.name >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Configurar nome de usuario Git
    set /p NOME="Digite seu nome: "
    git config user.name "!NOME!"
)

git config user.email >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Configurar email Git
    set /p EMAIL="Digite seu email: "
    git config user.email "!EMAIL!"
)

echo.
echo Configuracao atual:
echo   Nome: 
git config user.name
echo   Email: 
git config user.email
echo.

REM Verificar se remote origin existe
git remote get-url origin >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Configurando remote origin...
    echo.
    echo Seu repositorio: https://github.com/ronaldomelofz/tabela
    echo.
    git remote add origin https://github.com/ronaldomelofz/tabela.git
    echo [OK] Remote origin configurado!
) else (
    echo [OK] Remote origin ja configurado:
    git remote get-url origin
)

echo.
echo ============================================================
echo   AUTENTICACAO GITHUB
echo ============================================================
echo.
echo Para a automacao funcionar, voce precisa configurar
echo autenticacao com o GitHub.
echo.
echo OPCOES:
echo.
echo 1. Personal Access Token (Recomendado)
echo    - Acesse: https://github.com/settings/tokens
echo    - Gere um token com permissao "repo"
echo    - Use o token como senha ao fazer push
echo.
echo 2. SSH Keys
echo    - Configure chaves SSH no GitHub
echo    - Mude a URL para SSH:
echo      git remote set-url origin git@github.com:ronaldomelofz/tabela.git
echo.
echo 3. Credential Manager (Windows)
echo    - Git armazena credenciais automaticamente
echo    - Faca um push manual primeiro
echo.
echo ============================================================
echo.

echo Deseja testar a conexao agora?
choice /C SN /M "Fazer push de teste? (S/N)"

if errorlevel 2 (
    echo.
    echo [INFO] Teste pulado.
    echo Configure a autenticacao antes de usar a automacao!
    goto FIM
)

if errorlevel 1 (
    echo.
    echo [INFO] Testando conexao com GitHub...
    echo.
    
    REM Adicionar e commitar algo (se houver mudancas)
    git add .gitignore 2>nul
    git commit -m "Teste de configuracao Git" 2>nul
    
    REM Tentar push
    git push origin main 2>&1
    
    if %errorlevel% equ 0 (
        echo.
        echo [OK] Conexao com GitHub funcionando!
        echo [OK] Automacao pronta para uso!
    ) else (
        echo.
        echo [AVISO] Falha ao conectar com GitHub
        echo.
        echo Configure a autenticacao:
        echo   - Personal Access Token
        echo   - SSH Keys
        echo   - Credential Manager
        echo.
        echo Depois teste novamente.
    )
)

:FIM
echo.
echo ============================================================
echo.
echo Proximos passos:
echo   1. Configure autenticacao GitHub (se necessario)
echo   2. Execute: AGENDAR-AUTOMACAO-COMPLETA.bat
echo   3. Tudo rodara automaticamente!
echo.
echo ============================================================
echo.
pause

