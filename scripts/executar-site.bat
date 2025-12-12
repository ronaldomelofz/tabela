@echo off
chcp 65001 > nul
echo ============================================================
echo    🌐 INICIANDO SERVIDOR DE DESENVOLVIMENTO
echo ============================================================
echo.
echo ✨ O site abrirá em: http://localhost:3000
echo.
echo 🛑 Para parar o servidor: pressione Ctrl+C
echo.
echo ============================================================
echo.

start http://localhost:3000

call pnpm dev

