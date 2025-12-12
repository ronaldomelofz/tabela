@echo off
chcp 65001 > nul
echo ============================================================
echo    🌐 INICIANDO SERVIDOR DE DESENVOLVIMENTO
echo ============================================================
echo.
echo 🧹 Limpando cache anterior...
if exist .next rmdir /s /q .next > nul 2>&1
echo.
echo ✨ O site abrirá em: http://localhost:3000
echo.
echo ⏳ Aguarde alguns segundos para o site iniciar...
echo.
echo 🛑 Para parar o servidor: pressione Ctrl+C
echo.
echo ============================================================
echo.

timeout /t 5 /nobreak > nul
start http://localhost:3000

call pnpm dev

