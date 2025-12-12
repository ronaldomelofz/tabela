@echo off
chcp 65001 > nul
echo ============================================================
echo    🚀 SETUP COMPLETO DO PROJETO
echo ============================================================
echo.

REM Verificar se pnpm está instalado
where pnpm >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ pnpm não encontrado!
    echo 📦 Instalando pnpm...
    npm install -g pnpm
)

echo ✅ pnpm encontrado!
echo.

REM Instalar dependências
echo 📦 Instalando dependências do projeto...
call pnpm install
if %errorlevel% neq 0 (
    echo ❌ Erro ao instalar dependências
    pause
    exit /b 1
)

echo.
echo ✅ Dependências instaladas com sucesso!
echo.

REM Verificar se Python está instalado
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo ⚠️  Python não encontrado (necessário para converter PDF)
    echo 💡 Baixe em: https://www.python.org/downloads/
    echo.
) else (
    echo ✅ Python encontrado!
    echo 🔄 Tentando converter PDF para JSON...
    python scripts\converter-pdf-para-json.py
    echo.
)

REM Fazer build de teste
echo 🔨 Testando build do projeto...
call pnpm build
if %errorlevel% neq 0 (
    echo ❌ Erro no build
    pause
    exit /b 1
)

echo.
echo ============================================================
echo    ✅ SETUP CONCLUÍDO COM SUCESSO!
echo ============================================================
echo.
echo 📋 Próximos passos:
echo.
echo 1️⃣  Executar localmente:
echo    pnpm dev
echo.
echo 2️⃣  Enviar para GitHub:
echo    git push -u origin main
echo.
echo 3️⃣  Deploy no Netlify:
echo    - Acesse: https://app.netlify.com
echo    - Conecte o repositório: ronaldomelofz/tabela
echo.
echo 📚 Documentação: README.md
echo.
pause

