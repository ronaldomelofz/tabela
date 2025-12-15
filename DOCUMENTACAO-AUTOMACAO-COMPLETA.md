# 🤖 Documentação - Automação Completa

## 📋 Visão Geral

Sistema **totalmente automatizado** que executa todo o fluxo:
1. ✅ Copia bancos de dados (respeitando **REGRA DE OURO**)
2. ✅ Extrai dados das **CÓPIAS** (nunca dos originais)
3. ✅ Atualiza `data/produtos.json`
4. ✅ Faz commit no Git
5. ✅ Envia para GitHub

**Repositório:** https://github.com/ronaldomelofz/tabela

---

## 🎯 REGRA DE OURO (Fundamental!)

```
╔════════════════════════════════════════════════════════════╗
║              ⚠️ REGRA DE OURO ⚠️                          ║
╠════════════════════════════════════════════════════════════╣
║  ✅ SEMPRE use as CÓPIAS (BANCOCOPIA e BANCOCOPIA190)    ║
║  ❌ NUNCA acesse os bancos originais diretamente          ║
╚════════════════════════════════════════════════════════════╝
```

Este sistema **RESPEITA** a regra de ouro em todas as etapas!

---

## 🚀 Início Rápido

### **Passo 1: Configurar Git** (Uma vez)
```batch
CONFIGURAR-GIT.bat
```
- Configura nome e email
- Adiciona remote do GitHub
- Testa conexão

### **Passo 2: Testar Manualmente** (Primeira vez)
```batch
AUTOMACAO-COMPLETA.bat
```
- Executa todo o processo manualmente
- Verifica se tudo funciona
- Tempo: ~10-15 minutos

### **Passo 3: Agendar Automação**
```batch
AGENDAR-AUTOMACAO-COMPLETA.bat
```
- Escolha: Opção 1 (a cada 4 horas)
- Configuração automática

### **Passo 4: Monitorar**
```batch
VER-AUTOMACAO-COMPLETA.bat
```
- Ver status
- Ver logs
- Ver último commit

---

## 📊 Fluxo Completo

```
1. COPIAR BANCOS (5-10 min)
   C:\ → BANCOCOPIA
   Z:\ → BANCOCOPIA190
   ↓
2. EXTRAIR DADOS (30 seg)
   Lê de: BANCOCOPIA e BANCOCOPIA190
   Nunca de: C:\ ou Z:\ (originais)
   ↓
3. ATUALIZAR JSON (instantâneo)
   Atualiza: data/produtos.json
   ↓
4. GIT COMMIT (5 seg)
   git add data/produtos.json
   git commit -m "Atualização automática"
   ↓
5. GIT PUSH (10 seg)
   git push origin main
   ↓
6. GITHUB ATUALIZADO! 🎉
   https://github.com/ronaldomelofz/tabela
```

**Tempo total:** ~10-15 minutos por execução

---

## ⚙️ Scripts Disponíveis

### 1. **AUTOMACAO-COMPLETA.bat**
**Função:** Executa todo o processo

**Uso Manual:**
```batch
AUTOMACAO-COMPLETA.bat
```

**Uso Automático:**
```batch
AUTOMACAO-COMPLETA.bat auto
```

### 2. **AGENDAR-AUTOMACAO-COMPLETA.bat**
**Função:** Configura agendamento automático

**Opções:**
- A cada 4 horas (recomendado)
- A cada 6 horas
- A cada 12 horas
- Diariamente às 02:00
- Diariamente às 08:00
- Manual (desabilitado)

### 3. **VER-AUTOMACAO-COMPLETA.bat**
**Função:** Monitora status e logs

**Mostra:**
- Status da tarefa agendada
- Últimos logs
- Última modificação do `produtos.json`
- Último commit Git
- Status do repositório

### 4. **CONFIGURAR-GIT.bat**
**Função:** Configura Git para automação

**Configura:**
- Nome e email do usuário
- Remote origin (GitHub)
- Testa conexão
- Verifica autenticação

---

## 🔐 Configuração GitHub

### **Autenticação Necessária**

Para a automação funcionar, configure uma destas opções:

#### **Opção 1: Personal Access Token** (Recomendado)

1. Acesse: https://github.com/settings/tokens
2. Clique em "Generate new token" → "Classic"
3. Dê um nome: "Automação Alterdata"
4. Marque: `repo` (Full control of private repositories)
5. Gere o token e **COPIE** (não poderá ver novamente!)
6. Use o token como senha ao fazer push

**Usar o token:**
```batch
# Windows Credential Manager armazenará
git push origin main
# Username: ronaldomelofz
# Password: [cole o token]
```

#### **Opção 2: SSH Keys**

1. Gere chave SSH: `ssh-keygen -t ed25519 -C "seu@email.com"`
2. Adicione ao GitHub: https://github.com/settings/keys
3. Mude URL para SSH:
```batch
git remote set-url origin git@github.com:ronaldomelofz/tabela.git
```

#### **Opção 3: Credential Manager** (Windows)

1. Faça push manual primeiro
2. Windows Credential Manager armazena credenciais
3. Automação usa credenciais armazenadas

---

## 📈 Opções de Agendamento

| Opção | Frequência | Uso Recomendado |
|-------|-----------|-----------------|
| **1** | A cada 4 horas | ⭐ Produção (6x/dia) |
| **2** | A cada 6 horas | Uso moderado (4x/dia) |
| **3** | A cada 12 horas | Uso leve (2x/dia) |
| **4** | Diário às 02:00 | Madrugada (1x/dia) |
| **5** | Diário às 08:00 | Manhã (1x/dia) |
| **6** | Manual | Sob demanda |

### **Recomendação:**
- **Produção:** A cada 4 horas
- **Desenvolvimento:** A cada 6 horas
- **Backup:** Diário às 02:00

---

## 📝 Logs do Sistema

### **Localização:**
```
logs/automacao_completa_YYYY-MM-DD_HH-MM-SS.log
```

### **Conteúdo:**
- Timestamp de cada etapa
- Status de sucesso/erro
- Detalhes das operações
- Informações do Git

### **Visualizar:**
```batch
VER-AUTOMACAO-COMPLETA.bat  # Ver último log
dir logs\                    # Listar todos
type logs\[arquivo].log      # Ver conteúdo
```

---

## 🔧 Comandos Úteis

### **Agendador:**
```batch
# Ver status
schtasks /query /tn "AutomacaoCompletaAlterdata"

# Executar agora
schtasks /run /tn "AutomacaoCompletaAlterdata"

# Desabilitar
schtasks /change /tn "AutomacaoCompletaAlterdata" /disable

# Habilitar
schtasks /change /tn "AutomacaoCompletaAlterdata" /enable

# Remover
schtasks /delete /tn "AutomacaoCompletaAlterdata" /f
```

### **Git:**
```batch
# Ver último commit
git log -1

# Ver status
git status

# Ver remote
git remote -v

# Testar push
git push origin main
```

---

## ⚠️ Solução de Problemas

### **Erro: Git push falha**

**Causa:** Credenciais não configuradas

**Solução:**
1. Configure Personal Access Token
2. Ou configure SSH Keys
3. Ou faça push manual primeiro

---

### **Erro: Arquivos não encontrados**

**Causa:** Caminhos incorretos

**Solução:**
1. Verifique se está na pasta do projeto
2. Execute `CONFIGURAR-GIT.bat`
3. Teste `AUTOMACAO-COMPLETA.bat` manualmente

---

### **Erro: Python não encontrado**

**Causa:** Python não instalado

**Solução:**
1. Instale Python: https://www.python.org/downloads/
2. Marque "Add to PATH" na instalação
3. Reinicie terminal

---

### **Erro: Agendamento não executa**

**Causa:** Tarefa desabilitada ou erro

**Solução:**
```batch
# Habilitar
schtasks /change /tn "AutomacaoCompletaAlterdata" /enable

# Ver logs
VER-AUTOMACAO-COMPLETA.bat

# Testar manual
AUTOMACAO-COMPLETA.bat
```

---

## 📊 Monitoramento

### **Diário:**
```batch
VER-AUTOMACAO-COMPLETA.bat
```
- Verificar última execução
- Ver se há erros nos logs

### **Semanal:**
- Verificar GitHub: https://github.com/ronaldomelofz/tabela
- Ver histórico de commits
- Validar dados em produção

### **Mensal:**
- Limpar logs antigos (manter últimos 30 dias)
- Revisar configurações
- Atualizar documentação se necessário

---

## ✅ Checklist de Configuração

- [ ] Git instalado e configurado
- [ ] Python instalado
- [ ] Configuração Git completa (`CONFIGURAR-GIT.bat`)
- [ ] Autenticação GitHub configurada
- [ ] Teste manual realizado (`AUTOMACAO-COMPLETA.bat`)
- [ ] Agendamento configurado (`AGENDAR-AUTOMACAO-COMPLETA.bat`)
- [ ] Tarefa agendada ativa
- [ ] Primeiro push bem-sucedido
- [ ] Monitoramento configurado

---

## 🎯 Resultado Final

Com tudo configurado, você terá:

✅ **Sistema 100% Automatizado**  
✅ **Dados sempre atualizados no GitHub**  
✅ **Respeita a REGRA DE OURO** (usa cópias)  
✅ **Monitoramento completo via logs**  
✅ **Zero intervenção manual necessária**

**Repositório atualizado automaticamente:**  
https://github.com/ronaldomelofz/tabela

---

**Versão:** 1.0  
**Data:** 15/12/2025  
**Sistema:** Automação Completa Alterdata  
**Repositório:** https://github.com/ronaldomelofz/tabela

