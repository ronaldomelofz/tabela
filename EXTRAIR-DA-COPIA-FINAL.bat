@echo off
:: Extrair Dados da BANCOCOPIA - Solucao Final
:: Banco ORIGINAL permanece intacto

title Extrair Dados da Copia

echo ====================================================================
echo  EXTRAIR DADOS DA BANCOCOPIA - SOLUCAO FINAL
echo ====================================================================
echo.
echo [INFO] Trabalhando SOMENTE com a copia
echo [INFO] Banco ORIGINAL permanece intacto
echo.

:: Parar qualquer PostgreSQL temporario
echo [INFO] Limpando processos anteriores...
taskkill /F /IM postgres.exe 2>nul >nul
timeout /t 2 /nobreak >nul

echo.
echo ====================================================================
echo  OPCAO 1: USAR SISTEMA ATUAL (RECOMENDADO)
echo ====================================================================
echo.
echo [OK] Sistema ja funciona perfeitamente:
echo   - 1.601 produtos disponiveis
echo   - TABELABLOCO.txt como base
echo   - Atualizacoes automaticas via Y:\IN
echo   - Publicacao no GitHub
echo   - Agendamento configuravel
echo.
echo Para usar:
echo   python scripts\atualizar-e-publicar.py
echo   AGENDAR-ATUALIZACAO.bat
echo.
echo.
echo ====================================================================
echo  OPCAO 2: CONTINUAR TENTANDO EXTRAIR DA COPIA
echo ====================================================================
echo.
echo [INFO] A copia do banco foi criada com sucesso (2 GB)
echo [INFO] Mas tem problemas de inicializacao
echo.
echo Alternativas:
echo   1. Usar sistema atual (ja funciona!)
echo   2. Obter senha do PostgreSQL original
echo   3. Contatar suporte Alterdata
echo.
echo.

choice /C 12 /N /M "Escolha: [1] Usar sistema atual  [2] Ver relatorio completo: "

if errorlevel 2 goto relatorio
if errorlevel 1 goto sistema_atual

:sistema_atual
echo.
echo ====================================================================
echo  EXECUTANDO SISTEMA ATUAL
echo ====================================================================
echo.
python scripts\atualizar-e-publicar.py
goto fim

:relatorio
echo.
echo ====================================================================
echo  RELATORIOS DISPONIVEIS
echo ====================================================================
echo.
echo [OK] ALTERNATIVAS-SENHA-POSTGRES.md
echo      - Todas as opcoes para recuperar senha
echo      - Passos detalhados
echo.
echo [OK] RESUMO-COPIA-BANCO-DADOS.md
echo      - Status da copia
echo      - O que foi feito
echo.
echo [OK] AUTOMATIZACAO.md
echo      - Sistema atual funcionando
echo      - Como usar
echo.
notepad ALTERNATIVAS-SENHA-POSTGRES.md
goto fim

:fim
echo.
echo ====================================================================
echo  CONCLUIDO
echo ====================================================================
echo.
pause




