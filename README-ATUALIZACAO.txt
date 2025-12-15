================================================================================
  SISTEMA DE ATUALIZACAO AUTOMATICA DE PRODUTOS
  Repositorio: https://github.com/ronaldomelofz/tabela
================================================================================

ARQUIVOS DISPONIVEIS:

  ATUALIZAR-E-PUBLICAR.bat
    -> Executar atualizacao AGORA (manual)
    -> Extrai dados, verifica Y:\ e publica no GitHub
  
  AGENDAR-ATUALIZACAO.bat
    -> Agendar atualizacao automatica
    -> Execute como ADMINISTRADOR
    -> Escolha o intervalo: 10, 20, 30, 60 minutos ou diario
  
  VER-AGENDAMENTO.bat
    -> Ver status da tarefa agendada
    -> Mostra frequencia e proxima execucao
  
  REMOVER-AGENDAMENTO.bat
    -> Remover agendamento automatico
    -> Cancela a tarefa agendada

================================================================================

COMO USAR:

1. CONFIGURAR PELA PRIMEIRA VEZ:
   - Execute AGENDAR-ATUALIZACAO.bat como ADMINISTRADOR
   - Escolha o intervalo desejado
   - Pronto! O sistema vai rodar automaticamente

2. EXECUTAR MANUALMENTE (quando quiser):
   - Execute ATUALIZAR-E-PUBLICAR.bat
   - Aguarde conclusao
   - Dados publicados no GitHub

3. VERIFICAR SE ESTA FUNCIONANDO:
   - Execute VER-AGENDAMENTO.bat
   - Ou acesse: Agendador de Tarefas do Windows

4. CANCELAR AGENDAMENTO:
   - Execute REMOVER-AGENDAMENTO.bat
   - Confirme a remocao

================================================================================

INTERVALOS DISPONIVEIS:

  [1] A cada 10 minutos
      - Atualizacao muito frequente
      - Ideal para: Desenvolvimento/testes
      - GitHub commits: ~144 por dia

  [2] A cada 20 minutos
      - Atualizacao frequente
      - Ideal para: Ambiente de teste
      - GitHub commits: ~72 por dia

  [3] A cada 30 minutos (RECOMENDADO)
      - Atualizacao moderada
      - Ideal para: Uso normal
      - GitHub commits: ~48 por dia

  [4] A cada 60 minutos
      - Atualizacao a cada hora
      - Ideal para: Dados menos volateis
      - GitHub commits: ~24 por dia

  [5] Uma vez por dia (08:00)
      - Atualizacao diaria
      - Ideal para: Dados estaticos
      - GitHub commits: 1 por dia

================================================================================

FLUXO DE ATUALIZACAO:

  TABELABLOCO.txt
      |
      v
  Extrai produtos (1.601 produtos)
      |
      v
  Verifica Y:\IN (opcional)
      |
      v
  Aplica atualizacoes
      |
      v
  Gera data/produtos.json
      |
      v
  Git commit + push
      |
      v
  GitHub (ronaldomelofz/tabela)
      |
      v
  Netlify detecta mudanca
      |
      v
  Build automatico
      |
      v
  Site atualizado! (2-3 minutos)

================================================================================

SOLUCAO DE PROBLEMAS:

[ERRO] "Falha ao criar tarefa agendada"
  -> Execute o arquivo como ADMINISTRADOR
  -> Clique com botao direito > "Executar como administrador"

[ERRO] "git push failed"
  -> Configure credenciais do Git
  -> Veja documentacao em AUTOMATIZACAO.md

[ERRO] "TABELABLOCO.txt not found"
  -> Certifique-se que o arquivo esta na pasta raiz do projeto
  -> Caminho correto: E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\TABELABLOCO.txt

[AVISO] "Y:\ not accessible"
  -> Nao e erro critico
  -> Sistema usara apenas TABELABLOCO.txt
  -> Atualizacoes de Y:\ sao opcionais

================================================================================

VERIFICAR SE ESTA FUNCIONANDO:

1. Execute: VER-AGENDAMENTO.bat
2. Verifique: https://github.com/ronaldomelofz/tabela/commits
3. Aguarde: Site atualiza em ~2-3 minutos apos commit

================================================================================

SUPORTE:

- Documentacao completa: AUTOMATIZACAO.md
- GitHub: https://github.com/ronaldomelofz/tabela
- Issues: https://github.com/ronaldomelofz/tabela/issues

================================================================================
Desenvolvido por: Ronaldo Melo
Ultima atualizacao: 15/12/2025
================================================================================




