================================================================================
  DIRETORIO DE LOGS - SISTEMA DE COPIAS ALTERDATA
================================================================================

Este diretorio armazena os logs das copias automaticas dos bancos Alterdata.

FORMATO DOS ARQUIVOS:
  copia_bancos_YYYY-MM-DD_HH-MM-SS.log

CONTEUDO DOS LOGS:
  - Timestamp de cada operacao
  - Status de sucesso/erro de cada etapa
  - Detalhes de arquivos copiados (via robocopy)
  - Tempo de execucao
  - Erros e avisos

EXEMPLO DE NOME:
  copia_bancos_2025-12-15_10-30-00.log
  
  Indica uma copia executada em:
    Data: 15/12/2025
    Hora: 10:30:00

MANUTENCAO:
  - Logs antigos podem ser removidos periodicamente
  - Recomenda-se manter logs dos ultimos 30 dias
  - Para auditoria, arquive logs mais antigos

VISUALIZACAO:
  Para ver os logs:
    1. Execute: VER-AGENDAMENTO-COPIAS.bat (mostra logs recentes)
    2. Abra diretamente este diretorio
    3. Use: dir /B /O-D copia_bancos_*.log (listar por data)

IMPORTANTE:
  - NAO delete este diretorio
  - NAO modifique os logs manualmente
  - Os logs sao criados automaticamente

================================================================================

