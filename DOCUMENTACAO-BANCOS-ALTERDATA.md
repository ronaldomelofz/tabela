# Sistema de Cópia Automática dos Bancos Alterdata

## 📋 Visão Geral

Este sistema automatiza a cópia e gerenciamento dos bancos de dados Alterdata, permitindo consultas seguras sem impactar os bancos de produção.

## 🗂️ Estrutura dos Bancos

### BANCOCOPIA190 (Origem: Z:\)
- **Fonte:** `Z:\Program Files (x86)\Alterdata`
- **Destino:** `E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA190`
- **Conteúdo:**
  - ✅ Informações de ESTOQUE
  - ✅ Quantidades disponíveis
  - ✅ Movimentações de estoque

**USO:** Consultar informações de estoque e disponibilidade

### BANCOCOPIA (Origem: C:\)
- **Fonte:** `C:\Program Files (x86)\Alterdata`
- **Destino:** `E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA`
- **Conteúdo:**
  - ✅ Cadastro de PRODUTOS (novos e excluídos)
  - ✅ Informações de VALORES/PREÇOS
  - ✅ Dados de catálogo

**USO:** Consultar informações de produtos, preços e cadastros

## 🚀 Scripts Disponíveis

### 1. COPIAR-BANCOS-ALTERDATA.bat
**Função:** Executa a cópia completa dos dois bancos de dados

**Uso Manual:**
```batch
COPIAR-BANCOS-ALTERDATA.bat
```

**Uso Automático (sem pausa):**
```batch
COPIAR-BANCOS-ALTERDATA.bat auto
```

**Características:**
- ✅ Copia recursiva completa
- ✅ Mantém permissões e atributos
- ✅ Multi-thread (8 threads) para maior velocidade
- ✅ Retry automático (3 tentativas)
- ✅ Log detalhado de operações
- ✅ Tratamento de erros robusto

### 2. AGENDAR-COPIA-BANCOS.bat
**Função:** Configura agendamento automático das cópias

**Opções de Agendamento:**
1. A cada 4 horas (recomendado para produção)
2. A cada 2 horas (recomendado para desenvolvimento)
3. A cada 1 hora (para testes)
4. Diariamente às 08:00
5. Manual (tarefa desabilitada)

**Uso:**
```batch
AGENDAR-COPIA-BANCOS.bat
```

**Características:**
- ✅ Execução com privilégios SYSTEM
- ✅ Nível de execução HIGHEST
- ✅ Substituição de tarefas existentes
- ✅ Múltiplas opções de frequência

### 3. VER-AGENDAMENTO-COPIAS.bat
**Função:** Visualiza o status do agendamento

**Uso:**
```batch
VER-AGENDAMENTO-COPIAS.bat
```

**Informações Exibidas:**
- ✅ Status da tarefa (ativa/inativa)
- ✅ Próxima execução programada
- ✅ Última execução
- ✅ Logs recentes de cópia

### 4. REMOVER-AGENDAMENTO-COPIAS.bat
**Função:** Remove o agendamento automático

**Uso:**
```batch
REMOVER-AGENDAMENTO-COPIAS.bat
```

## 📊 Sistema de Logs

### Localização
```
E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\logs\
```

### Formato dos Logs
```
copia_bancos_YYYY-MM-DD_HH-MM-SS.log
```

### Conteúdo dos Logs
- Timestamp de cada operação
- Status de sucesso/erro
- Detalhes de arquivos copiados
- Tempo de execução
- Erros e avisos

### Exemplo:
```
copia_bancos_2025-12-15_10-30-00.log
```

## 🔄 Fluxo de Trabalho Recomendado

### Configuração Inicial

1. **Execute a primeira cópia manual:**
```batch
COPIAR-BANCOS-ALTERDATA.bat
```

2. **Configure o agendamento:**
```batch
AGENDAR-COPIA-BANCOS.bat
```

3. **Verifique o agendamento:**
```batch
VER-AGENDAMENTO-COPIAS.bat
```

### Operação Diária

O sistema executará automaticamente conforme configurado. Para verificar:

```batch
VER-AGENDAMENTO-COPIAS.bat
```

### Consulta aos Dados

**SEMPRE** use as cópias locais para consultas:

**Para informações de ESTOQUE:**
```
Fonte: BANCOCOPIA190
```

**Para informações de PRODUTOS/PREÇOS:**
```
Fonte: BANCOCOPIA
```

## ⚙️ Comandos Úteis do Agendador

### Verificar Status
```batch
schtasks /query /tn "CopiarBancosAlterdata" /fo LIST /v
```

### Desabilitar Temporariamente
```batch
schtasks /change /tn "CopiarBancosAlterdata" /disable
```

### Habilitar Novamente
```batch
schtasks /change /tn "CopiarBancosAlterdata" /enable
```

### Executar Manualmente Agora
```batch
schtasks /run /tn "CopiarBancosAlterdata"
```

### Remover Agendamento
```batch
schtasks /delete /tn "CopiarBancosAlterdata" /f
```

## 🛡️ Segurança e Boas Práticas

### ✅ FAÇA:
- ✅ SEMPRE consulte as CÓPIAS (BANCOCOPIA e BANCOCOPIA190)
- ✅ Verifique os logs regularmente
- ✅ Mantenha backups dos bancos originais
- ✅ Execute cópias em horários de baixo uso
- ✅ Monitore o espaço em disco

### ❌ NÃO FAÇA:
- ❌ NUNCA consulte diretamente os bancos de produção (C:\ ou Z:\)
- ❌ NUNCA modifique os bancos originais sem backup
- ❌ NUNCA execute cópias durante horário de pico
- ❌ NUNCA ignore erros nos logs

## 🔧 Solução de Problemas

### Erro: "Diretório de origem não encontrado"

**Causa:** Unidade de rede Z:\ não está mapeada ou C:\ não tem o Alterdata

**Solução:**
```batch
# Verificar se Z:\ está acessível
dir Z:\

# Verificar se C:\ tem Alterdata
dir "C:\Program Files (x86)\Alterdata"
```

### Erro: "Falha ao copiar banco"

**Causa:** Permissões insuficientes ou banco em uso

**Solução:**
1. Execute como Administrador
2. Verifique se nenhum processo está usando os arquivos
3. Tente fechar o sistema Alterdata

### Espaço em Disco Insuficiente

**Verificar espaço:**
```batch
wmic logicaldisk get caption,freespace,size
```

**Liberar espaço:**
- Limpe logs antigos em `logs\`
- Remova backups antigos se necessário

### Tarefa Agendada Não Executa

**Verificar:**
```batch
VER-AGENDAMENTO-COPIAS.bat
```

**Reconfigurar:**
```batch
REMOVER-AGENDAMENTO-COPIAS.bat
AGENDAR-COPIA-BANCOS.bat
```

## 📈 Monitoramento

### Verificar Última Execução

1. Execute `VER-AGENDAMENTO-COPIAS.bat`
2. Verifique a seção "Última Hora de Execução"
3. Confira os logs mais recentes

### Verificar Tamanho das Cópias

```batch
dir "E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA" /s
dir "E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA190" /s
```

## 🔄 Integração com Outros Sistemas

### Scripts Python de Consulta

Ao desenvolver scripts Python para consultar os bancos:

```python
# Configuração correta dos caminhos
BANCO_ESTOQUE = r"E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA190"
BANCO_PRODUTOS = r"E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA"

# NUNCA usar:
# BANCO_PRODUCAO = r"C:\Program Files (x86)\Alterdata"  # ❌ ERRADO!
```

### Scripts de Atualização Web

Certifique-se de que todos os scripts usam as cópias:

```python
# Em seus scripts de extração
def get_connection():
    # Use sempre as cópias
    return connect_to_copy(BANCOCOPIA)
```

## 📅 Manutenção

### Diária
- ✅ Verificar execução automática (logs)

### Semanal
- ✅ Revisar logs de erro
- ✅ Verificar espaço em disco
- ✅ Validar integridade das cópias

### Mensal
- ✅ Limpar logs antigos
- ✅ Revisar performance das cópias
- ✅ Atualizar documentação se necessário

## 📞 Suporte

Para problemas ou dúvidas:
1. Verifique os logs em `logs\`
2. Consulte a seção "Solução de Problemas"
3. Verifique o repositório: https://github.com/ronaldomelofz/tabela

---

**Versão:** 1.0  
**Última Atualização:** 15/12/2025  
**Autor:** Sistema de Automação Tabela Preço Estoque

