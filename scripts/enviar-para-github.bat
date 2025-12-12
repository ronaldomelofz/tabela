@echo off
chcp 65001 > nul
echo ============================================================
echo    📤 ENVIAR CÓDIGO PARA GITHUB
echo ============================================================
echo.

REM Verificar se há alterações
git status

echo.
echo 📝 Adicionando arquivos...
git add .

echo.
set /p mensagem="💬 Digite uma mensagem para o commit: "
git commit -m "%mensagem%"

echo.
echo 📤 Enviando para GitHub...
git push -u origin main

if %errorlevel% neq 0 (
    echo.
    echo ⚠️  Erro ao enviar para GitHub
    echo.
    echo 💡 Possíveis soluções:
    echo    1. Configure suas credenciais do GitHub
    echo    2. Use GitHub Desktop (mais fácil): https://desktop.github.com
    echo    3. Configure SSH: https://docs.github.com/pt/authentication
    echo.
) else (
    echo.
    echo ✅ Código enviado com sucesso!
    echo.
    echo 🌐 Repositório: https://github.com/ronaldomelofz/tabela
    echo.
    echo 📋 Próximo passo: Deploy no Netlify
    echo    Acesse: https://app.netlify.com
    echo    Conecte o repositório: ronaldomelofz/tabela
    echo.
)

pause

