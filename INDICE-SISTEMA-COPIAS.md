# 📑 Índice Completo - Sistema de Cópias Automáticas

## 🎯 Visão Geral

Sistema completo para automação de cópias dos bancos de dados Alterdata, garantindo consultas seguras sem impactar o ambiente de produção.

---

## 🚀 Início Rápido

### Primeira Vez?

**Opção 1 - Visual (Recomendado):**
```
Abra: _PAINEL_COPIAS_BANCOS.html
```

**Opção 2 - Menu Interativo:**
```
Execute: INICIO-RAPIDO-BANCOS.bat
```

**Opção 3 - Manual:**
```
1. COPIAR-BANCOS-ALTERDATA.bat
2. AGENDAR-COPIA-BANCOS.bat
```

---

## 📂 Estrutura de Arquivos Criados

### 🎨 Interface e Painéis

| Arquivo | Descrição | Quando Usar |
|---------|-----------|-------------|
| `_PAINEL_COPIAS_BANCOS.html` | Painel de controle visual HTML | Acesso rápido visual a todas funções |
| `INICIO-RAPIDO-BANCOS.bat` | Menu interativo em lote | Navegação fácil por terminal |

### 📖 Documentação

| Arquivo | Descrição | Conteúdo |
|---------|-----------|----------|
| `DOCUMENTACAO-BANCOS-ALTERDATA.md` | Documentação completa em Markdown | Guia detalhado com todos os procedimentos |
| `README-COPIAS-BANCOS.txt` | README em texto simples | Referência rápida de comandos e uso |
| `_LEIA-ME_SISTEMA_COPIAS.txt` | Guia inicial do sistema | Introdução e primeiros passos |
| `INDICE-SISTEMA-COPIAS.md` | Este arquivo - Índice geral | Visão geral de todos os arquivos |

### 🔧 Scripts de Execução

#### Scripts Principais

| Arquivo | Função | Uso |
|---------|--------|-----|
| `COPIAR-BANCOS-ALTERDATA.bat` | Executa cópia dos bancos | Manual ou automático via agendamento |
| `CONSULTAR-COPIAS.py` | Consulta dados das cópias | Extração e verificação de dados Python |

#### Scripts de Agendamento

| Arquivo | Função | Quando Usar |
|---------|--------|-------------|
| `AGENDAR-COPIA-BANCOS.bat` | Configura agendamento automático | Primeira configuração ou reconfiguração |
| `VER-AGENDAMENTO-COPIAS.bat` | Visualiza status do agendamento | Verificar configuração e logs |
| `REMOVER-AGENDAMENTO-COPIAS.bat` | Remove agendamento | Desinstalar automação |

#### Scripts de Teste e Verificação

| Arquivo | Função | Quando Usar |
|---------|--------|-------------|
| `TESTAR-SISTEMA-COPIAS.bat` | Testa toda a configuração | Após instalação ou troubleshooting |

### 📁 Diretórios

| Diretório | Conteúdo | Origem |
|-----------|----------|--------|
| `BANCOCOPIA190/` | Cópia do banco para ESTOQUE | `Z:\Program Files (x86)\Alterdata` |
| `BANCOCOPIA/` | Cópia do banco para PRODUTOS/PREÇOS | `C:\Program Files (x86)\Alterdata` |
| `logs/` | Logs das operações de cópia | Gerado automaticamente |

---

## 📋 Guia de Uso por Cenário

### 🆕 Configuração Inicial (Primeira Vez)

```batch
# Opção mais fácil
TESTAR-SISTEMA-COPIAS.bat         # Verificar pré-requisitos
INICIO-RAPIDO-BANCOS.bat          # Configurar tudo interativamente

# Ou manualmente
COPIAR-BANCOS-ALTERDATA.bat       # Executar primeira cópia
AGENDAR-COPIA-BANCOS.bat          # Configurar agendamento
VER-AGENDAMENTO-COPIAS.bat        # Verificar configuração
```

### 📊 Uso Diário

```batch
# Verificar status
VER-AGENDAMENTO-COPIAS.bat        # Ver última execução e logs

# Consultar dados
python CONSULTAR-COPIAS.py --verificar      # Verificar cópias
python CONSULTAR-COPIAS.py --tipo estoque   # Consultar estoque
python CONSULTAR-COPIAS.py --tipo produtos  # Consultar produtos
```

### 🔄 Manutenção

```batch
# Executar cópia manual
COPIAR-BANCOS-ALTERDATA.bat       # Cópia sob demanda

# Reconfigurar sistema
AGENDAR-COPIA-BANCOS.bat          # Alterar frequência
REMOVER-AGENDAMENTO-COPIAS.bat    # Remover agendamento

# Verificar sistema
TESTAR-SISTEMA-COPIAS.bat         # Testar configuração
```

### 🐛 Solução de Problemas

```batch
# Diagnóstico
TESTAR-SISTEMA-COPIAS.bat         # Verificar tudo
VER-AGENDAMENTO-COPIAS.bat        # Ver logs e status

# Documentação
# Abrir: DOCUMENTACAO-BANCOS-ALTERDATA.md
# Abrir: README-COPIAS-BANCOS.txt
```

---

## 🗃️ Estrutura dos Bancos

### BANCOCOPIA190
- **Origem:** `Z:\Program Files (x86)\Alterdata`
- **Destino:** `E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA190`
- **Conteúdo:**
  - ✅ Informações de ESTOQUE
  - ✅ Quantidades disponíveis
  - ✅ Movimentações de estoque

### BANCOCOPIA
- **Origem:** `C:\Program Files (x86)\Alterdata`
- **Destino:** `E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA`
- **Conteúdo:**
  - ✅ Cadastro de PRODUTOS
  - ✅ Informações de VALORES/PREÇOS
  - ✅ Novos produtos e exclusões

---

## 🔑 Regras de Ouro

### ✅ SEMPRE FAÇA

1. ✅ Consulte as **CÓPIAS** (BANCOCOPIA e BANCOCOPIA190)
2. ✅ Verifique os logs regularmente
3. ✅ Use as cópias para desenvolvimento e testes
4. ✅ Mantenha o agendamento ativo
5. ✅ Monitore o espaço em disco

### ❌ NUNCA FAÇA

1. ❌ Consulte diretamente os bancos de produção (C:\ ou Z:\)
2. ❌ Modifique os bancos originais sem backup
3. ❌ Ignore erros nos logs
4. ❌ Execute cópias durante horário de pico
5. ❌ Delete o diretório de logs

---

## 📝 Logs do Sistema

### Localização
```
E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\logs\
```

### Formato
```
copia_bancos_YYYY-MM-DD_HH-MM-SS.log
```

### Visualização
```batch
# Listar logs
dir logs\

# Ver log específico
type logs\copia_bancos_2025-12-15_10-30-00.log

# Ou usar o script
VER-AGENDAMENTO-COPIAS.bat
```

---

## 🐍 Integração Python

### Uso Correto

```python
from pathlib import Path

# ✅ CORRETO - Usar cópias
BANCO_ESTOQUE = Path("E:/PROJETOS-CURSOR/TABELAPRECOESTOQUE/BANCOCOPIA190")
BANCO_PRODUTOS = Path("E:/PROJETOS-CURSOR/TABELAPRECOESTOQUE/BANCOCOPIA")

# ❌ ERRADO - Não usar originais
# BANCO = Path("C:/Program Files (x86)/Alterdata")
# BANCO = Path("Z:/Program Files (x86)/Alterdata")
```

### Script de Consulta

```bash
# Verificar cópias
python CONSULTAR-COPIAS.py --verificar

# Consultar estoque
python CONSULTAR-COPIAS.py --tipo estoque

# Consultar produtos
python CONSULTAR-COPIAS.py --tipo produtos

# Consulta completa
python CONSULTAR-COPIAS.py --tipo completo

# Gerar relatório
python CONSULTAR-COPIAS.py --relatorio
```

---

## ⚙️ Comandos do Agendador

### Verificar Status
```batch
schtasks /query /tn "CopiarBancosAlterdata" /fo LIST /v
```

### Controle Manual

```batch
# Executar agora
schtasks /run /tn "CopiarBancosAlterdata"

# Desabilitar
schtasks /change /tn "CopiarBancosAlterdata" /disable

# Habilitar
schtasks /change /tn "CopiarBancosAlterdata" /enable

# Remover
schtasks /delete /tn "CopiarBancosAlterdata" /f
```

---

## 🔍 Índice de Conteúdo por Tipo

### Para Aprender (Documentação)
1. `_LEIA-ME_SISTEMA_COPIAS.txt` - Comece aqui
2. `README-COPIAS-BANCOS.txt` - Referência rápida
3. `DOCUMENTACAO-BANCOS-ALTERDATA.md` - Guia completo

### Para Usar (Interface)
1. `_PAINEL_COPIAS_BANCOS.html` - Visual
2. `INICIO-RAPIDO-BANCOS.bat` - Menu interativo

### Para Executar (Scripts)
1. `COPIAR-BANCOS-ALTERDATA.bat` - Cópia manual
2. `AGENDAR-COPIA-BANCOS.bat` - Configurar
3. `VER-AGENDAMENTO-COPIAS.bat` - Monitorar
4. `CONSULTAR-COPIAS.py` - Consultar dados

### Para Verificar (Diagnóstico)
1. `TESTAR-SISTEMA-COPIAS.bat` - Teste completo
2. `VER-AGENDAMENTO-COPIAS.bat` - Status
3. `logs/` - Histórico de operações

---

## 📊 Diagrama de Fluxo

```
┌─────────────────────────────────────────────────────────┐
│                  SISTEMA DE CÓPIAS                      │
│                     ALTERDATA                            │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
           ┌───────────────────────────────┐
           │   COPIAR-BANCOS-ALTERDATA     │
           │         (Script)               │
           └───────────────────────────────┘
                     │         │
         ┌───────────┘         └───────────┐
         ▼                                  ▼
┌──────────────────┐              ┌──────────────────┐
│  Z:\ (Rede)      │              │  C:\ (Local)     │
│  Program Files   │              │  Program Files   │
│  (x86)\Alterdata │              │  (x86)\Alterdata │
└──────────────────┘              └──────────────────┘
         │                                  │
         │ CÓPIA                   CÓPIA    │
         ▼                                  ▼
┌──────────────────┐              ┌──────────────────┐
│  BANCOCOPIA190   │              │  BANCOCOPIA      │
│  (ESTOQUE)       │              │  (PRODUTOS)      │
└──────────────────┘              └──────────────────┘
         │                                  │
         └────────────┬─────────────────────┘
                      ▼
           ┌──────────────────────┐
           │  CONSULTAR-COPIAS    │
           │  (Python Script)     │
           └──────────────────────┘
                      │
                      ▼
           ┌──────────────────────┐
           │   Dados Extraídos    │
           │   (JSON/CSV/etc)     │
           └──────────────────────┘
```

---

## 🎓 Tutorial Passo a Passo

### Dia 1: Instalação e Configuração

1. **Abra o painel de controle**
   ```
   Clique duas vezes: _PAINEL_COPIAS_BANCOS.html
   ```

2. **Teste o sistema**
   ```
   Execute: TESTAR-SISTEMA-COPIAS.bat
   ```

3. **Execute a primeira cópia**
   ```
   Execute: COPIAR-BANCOS-ALTERDATA.bat
   Aguarde a conclusão (pode levar vários minutos)
   ```

4. **Configure o agendamento**
   ```
   Execute: AGENDAR-COPIA-BANCOS.bat
   Escolha: Opção 1 (a cada 4 horas)
   ```

5. **Verifique a configuração**
   ```
   Execute: VER-AGENDAMENTO-COPIAS.bat
   ```

### Dia 2+: Uso Normal

1. **Manhã: Verificar execução**
   ```
   Execute: VER-AGENDAMENTO-COPIAS.bat
   Verifique se a última cópia foi bem-sucedida
   ```

2. **Trabalho: Consultar dados**
   ```
   python CONSULTAR-COPIAS.py --tipo estoque
   python CONSULTAR-COPIAS.py --tipo produtos
   ```

3. **Quando necessário: Cópia manual**
   ```
   Execute: COPIAR-BANCOS-ALTERDATA.bat
   ```

---

## 🆘 Solução Rápida de Problemas

| Problema | Solução | Arquivo |
|----------|---------|---------|
| Não sei por onde começar | Execute o teste do sistema | `TESTAR-SISTEMA-COPIAS.bat` |
| Cópia não funciona | Verifique os logs | `VER-AGENDAMENTO-COPIAS.bat` |
| Agendamento não executa | Reconfigure | `AGENDAR-COPIA-BANCOS.bat` |
| Erro desconhecido | Consulte documentação | `DOCUMENTACAO-BANCOS-ALTERDATA.md` |
| Preciso entender tudo | Leia o guia completo | `_LEIA-ME_SISTEMA_COPIAS.txt` |

---

## 📞 Suporte e Recursos

### Documentação Local
- `DOCUMENTACAO-BANCOS-ALTERDATA.md` - Guia completo
- `README-COPIAS-BANCOS.txt` - Referência rápida
- `_LEIA-ME_SISTEMA_COPIAS.txt` - Introdução
- `INDICE-SISTEMA-COPIAS.md` - Este arquivo

### Online
- **Repositório:** https://github.com/ronaldomelofz/tabela

### Diagnóstico
```batch
TESTAR-SISTEMA-COPIAS.bat         # Teste completo
VER-AGENDAMENTO-COPIAS.bat        # Status e logs
```

---

## 📈 Roadmap e Melhorias Futuras

### Implementado ✅
- ✅ Cópia automática de dois bancos
- ✅ Agendamento flexível
- ✅ Sistema de logs
- ✅ Scripts de verificação
- ✅ Painel de controle HTML
- ✅ Menu interativo
- ✅ Documentação completa
- ✅ Script Python de consulta

### Possíveis Melhorias 🎯
- 🎯 Notificações por email em caso de erro
- 🎯 Dashboard web em tempo real
- 🎯 Backup incremental (apenas alterações)
- 🎯 Compressão automática de cópias antigas
- 🎯 Integração com sistemas de monitoramento
- 🎯 API REST para consultas remotas

---

## 📋 Checklist de Configuração

Use este checklist para garantir que tudo está funcionando:

- [ ] Todos os scripts BAT criados
- [ ] Documentação completa disponível
- [ ] Diretório `logs/` criado
- [ ] Primeira cópia executada com sucesso
- [ ] Agendamento configurado
- [ ] Tarefa agendada ativa
- [ ] Python instalado (para CONSULTAR-COPIAS.py)
- [ ] Espaço em disco suficiente (>20GB)
- [ ] Bancos de origem acessíveis (C:\ e Z:\)
- [ ] Logs sendo gerados corretamente

Execute `TESTAR-SISTEMA-COPIAS.bat` para verificar automaticamente!

---

## 🏁 Conclusão

Este sistema fornece uma solução completa e robusta para gerenciar cópias dos bancos de dados Alterdata, garantindo:

- ✅ Segurança (não impacta produção)
- ✅ Automação (cópias regulares)
- ✅ Rastreabilidade (logs detalhados)
- ✅ Facilidade de uso (múltiplas interfaces)
- ✅ Documentação completa

**Para começar agora:**
```
Abra: _PAINEL_COPIAS_BANCOS.html
```

Ou

```
Execute: INICIO-RAPIDO-BANCOS.bat
```

**Boa sorte! 🚀**

---

*Versão: 1.0 | Data: 15/12/2025*  
*Repositório: https://github.com/ronaldomelofz/tabela*

