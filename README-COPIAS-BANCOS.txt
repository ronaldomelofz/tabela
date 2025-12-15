================================================================================
  SISTEMA DE COPIAS AUTOMATICAS - BANCOS ALTERDATA
  Versao: 1.0
  Data: 15/12/2025
================================================================================

INICIO RAPIDO
================================================================================

1. PRIMEIRA EXECUCAO (Configuracao Inicial):
   
   Execute: INICIO-RAPIDO-BANCOS.bat
   
   Ou manualmente:
   a) COPIAR-BANCOS-ALTERDATA.bat          (fazer primeira copia)
   b) AGENDAR-COPIA-BANCOS.bat             (configurar agendamento)


2. VERIFICAR STATUS:
   
   Execute: VER-AGENDAMENTO-COPIAS.bat


3. USO DIARIO:
   
   O sistema copia automaticamente conforme agendado.
   Voce pode verificar os logs em: logs\


ESTRUTURA DOS BANCOS
================================================================================

BANCOCOPIA190 (Origem: Z:\Program Files (x86)\Alterdata)
  - Informacoes de ESTOQUE
  - Quantidades disponiveis
  - Movimentacoes

BANCOCOPIA (Origem: C:\Program Files (x86)\Alterdata)
  - Cadastro de PRODUTOS
  - Informacoes de VALORES/PRECOS
  - Novos produtos e exclusoes


SCRIPTS DISPONIVEIS
================================================================================

COPIAR-BANCOS-ALTERDATA.bat
  - Executa copia completa dos dois bancos
  - Uso manual ou automatico
  - Gera logs detalhados

AGENDAR-COPIA-BANCOS.bat
  - Configura agendamento automatico
  - Opcoes: a cada 1h, 2h, 4h, diario, manual

VER-AGENDAMENTO-COPIAS.bat
  - Visualiza status do agendamento
  - Mostra logs recentes
  - Opcoes de gerenciamento

REMOVER-AGENDAMENTO-COPIAS.bat
  - Remove agendamento automatico
  - Confirma antes de remover

INICIO-RAPIDO-BANCOS.bat
  - Menu interativo
  - Acesso rapido a todas funcoes
  - Ideal para iniciantes

CONSULTAR-COPIAS.py
  - Script Python para consultar dados
  - Usa SEMPRE as copias (nunca originais)
  - Opcoes: estoque, produtos, completo


LOGS DO SISTEMA
================================================================================

Localizacao: E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\logs\

Formato: copia_bancos_YYYY-MM-DD_HH-MM-SS.log

Conteudo:
  - Timestamp de cada operacao
  - Status de sucesso/erro
  - Detalhes de arquivos copiados
  - Tempo de execucao


REGRA DE OURO
================================================================================

  SEMPRE CONSULTE AS COPIAS, NUNCA OS BANCOS ORIGINAIS!

  [OK]  BANCOCOPIA190 - para informacoes de ESTOQUE
  [OK]  BANCOCOPIA    - para informacoes de PRODUTOS/PRECOS

  [X]   C:\Program Files (x86)\Alterdata  - NAO CONSULTAR!
  [X]   Z:\Program Files (x86)\Alterdata  - NAO CONSULTAR!


COMANDOS RAPIDOS
================================================================================

Executar copia agora:
  COPIAR-BANCOS-ALTERDATA.bat

Verificar status:
  VER-AGENDAMENTO-COPIAS.bat

Configurar agendamento:
  AGENDAR-COPIA-BANCOS.bat

Ver logs:
  dir logs\

Desabilitar temporariamente:
  schtasks /change /tn "CopiarBancosAlterdata" /disable

Habilitar novamente:
  schtasks /change /tn "CopiarBancosAlterdata" /enable

Executar manualmente pelo agendador:
  schtasks /run /tn "CopiarBancosAlterdata"


SOLUCAO DE PROBLEMAS
================================================================================

"Diretorio de origem nao encontrado":
  - Verifique se Z:\ esta mapeada
  - Verifique se C:\ tem Alterdata instalado

"Falha ao copiar banco":
  - Execute como Administrador
  - Feche o sistema Alterdata
  - Verifique permissoes de acesso

"Espaco em disco insuficiente":
  - Limpe logs antigos em logs\
  - Verifique espaco disponivel em E:\

"Tarefa agendada nao executa":
  - Execute: VER-AGENDAMENTO-COPIAS.bat
  - Reconfigure: AGENDAR-COPIA-BANCOS.bat


INTEGRACAO COM PYTHON
================================================================================

Exemplo de uso correto em seus scripts:

  from pathlib import Path
  
  # Configuracao CORRETA (usar copias)
  BANCO_ESTOQUE = Path("E:/PROJETOS-CURSOR/TABELAPRECOESTOQUE/BANCOCOPIA190")
  BANCO_PRODUTOS = Path("E:/PROJETOS-CURSOR/TABELAPRECOESTOQUE/BANCOCOPIA")
  
  # NUNCA fazer isso:
  # BANCO = Path("C:/Program Files (x86)/Alterdata")  # ERRADO!
  # BANCO = Path("Z:/Program Files (x86)/Alterdata")  # ERRADO!


DOCUMENTACAO COMPLETA
================================================================================

Para documentacao detalhada, consulte:
  DOCUMENTACAO-BANCOS-ALTERDATA.md


SUPORTE
================================================================================

Repositorio: https://github.com/ronaldomelofz/tabela

Para problemas:
  1. Verifique os logs em logs\
  2. Consulte DOCUMENTACAO-BANCOS-ALTERDATA.md
  3. Execute VER-AGENDAMENTO-COPIAS.bat


================================================================================
  FIM DO README
================================================================================

