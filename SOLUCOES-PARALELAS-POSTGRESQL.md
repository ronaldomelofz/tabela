# 🔍 Soluções Paralelas - Acesso aos Dados do iShop
## Sem Credenciais PostgreSQL | Sem Instalações

**Data:** 15/12/2025  
**Objetivo:** Encontrar formas alternativas de acessar dados do iShop

---

## 🎯 SOLUÇÕES IDENTIFICADAS (Sem PostgreSQL)

### **SOLUÇÃO 1: Arquivos de Dados do PostgreSQL (pg_data)** ⭐⭐⭐⭐

**Conceito:**
- PostgreSQL armazena dados em arquivos físicos
- Localização comum: `C:\Program Files\PostgreSQL\data\` ou pasta específica
- Podemos LER diretamente esses arquivos

**Locais para Procurar:**
```
C:\Program Files\PostgreSQL\*\data\base\
C:\PostgreSQL\*\data\base\
Z:\PostgreSQL\data\
C:\Alterdata\PostgreSQL\data\
```

**Como funciona:**
```python
# Ler arquivos pg_data diretamente (sem senha)
# Biblioteca: pg_data_reader (Python)
# Status: Leitura pura, sem modificação
```

**Vantagens:**
- ✅ Não precisa senha
- ✅ Acesso direto aos dados
- ✅ Tempo real (lê arquivo atualizado)
- ✅ Somente leitura (seguro)

**Desafios:**
- ⚠️ Localizar pasta pg_data correta
- ⚠️ Decodificar formato binário PostgreSQL
- ⚠️ Identificar qual arquivo corresponde a ALTERDATA_SHOP

**Ação Necessária:**
- Procurar pasta de dados do PostgreSQL
- Verificar permissões de leitura

---

### **SOLUÇÃO 2: Logs de Transação do PostgreSQL** ⭐⭐⭐⭐⭐

**Conceito:**
- PostgreSQL gera logs de todas operações
- Logs ficam em arquivos de texto
- Contém: INSERT, UPDATE, DELETE com valores

**Locais para Procurar:**
```
C:\Program Files\PostgreSQL\*\data\pg_log\
C:\PostgreSQL\*\log\
Z:\Alterdata\Shop\logs\
C:\ProgramData\PostgreSQL\logs\
```

**Formato dos Logs:**
```sql
2025-12-15 09:30:15 LOG: statement: 
UPDATE detalhe SET vlprecovenda=45.90, qtestoque=150 
WHERE idproduto='P0001FRLKI'
```

**Como funciona:**
```python
# 1. Monitorar arquivos de log
# 2. Parsear comandos SQL
# 3. Extrair INSERT/UPDATE com dados de produtos
# 4. Atualizar cache local em tempo real
```

**Vantagens:**
- ✅ NÃO PRECISA SENHA!
- ✅ Arquivos de texto simples
- ✅ Tempo real (log instantâneo)
- ✅ Seguro (somente leitura)
- ✅ Histórico de mudanças

**Desafios:**
- ⚠️ Logs podem estar desabilitados
- ⚠️ Precisa parsear SQL
- ⚠️ Volume de dados grande

**Ação Necessária:**
- Localizar pasta de logs
- Verificar se logging está ativo

---

### **SOLUÇÃO 3: Dumps/Backups Automáticos do iShop** ⭐⭐⭐⭐⭐

**Conceito:**
- iShop provavelmente faz backups automáticos
- Backups podem estar em formato texto (SQL dump)
- Podemos processar esses dumps

**Locais para Procurar:**
```
Z:\Program Files (x86)\Alterdata\Shop\Backup\
Z:\Program Files (x86)\Alterdata\Backup-Service\
Y:\Backups\
C:\Alterdata\Backups\
```

**Formatos Possíveis:**
- `.sql` - Dump SQL (texto)
- `.backup` - Backup PostgreSQL
- `.bak` - Backup compactado
- `.csv` - Exportações CSV

**Como funciona:**
```python
# 1. Monitorar pasta de backup
# 2. Detectar novos arquivos .sql ou .csv
# 3. Processar e extrair produtos
# 4. Atualizar dados
```

**Vantagens:**
- ✅ Não precisa senha
- ✅ Dados completos
- ✅ Formato estruturado
- ✅ Gerado automaticamente pelo iShop

**Desafios:**
- ⚠️ Frequência de backup (pode ser 1x/dia)
- ⚠️ Localizar pasta correta

**Ação Necessária:**
- Explorar pastas Backup-Service
- Verificar agendamento de backups

---

### **SOLUÇÃO 4: Relatórios do iShop (Arquivos Temporários)** ⭐⭐⭐⭐

**Conceito:**
- iShop gera relatórios constantemente
- Relatórios ficam em pastas temporárias
- Podem estar em formato processável

**Locais para Procurar:**
```
Z:\Program Files (x86)\Alterdata\Shop\SHPTEMP\
Z:\Program Files (x86)\Alterdata\Shop\PCTTMP\
Z:\Program Files (x86)\Alterdata\Temp\
C:\Users\*\AppData\Local\Alterdata\
```

**Formatos Possíveis:**
- `.txt` - Relatórios texto
- `.xml` - Dados estruturados
- `.csv` - Exportações
- `.rtm` - Report Manager

**Como funciona:**
```python
# 1. Monitorar pastas TEMP do iShop
# 2. Capturar relatórios gerados
# 3. Parsear e extrair dados
# 4. Atualizar produtos.json
```

**Vantagens:**
- ✅ Não precisa senha
- ✅ Gerado automaticamente
- ✅ Formato estruturado
- ✅ Atualizações frequentes

**Desafios:**
- ⚠️ Arquivos temporários (podem ser deletados)
- ⚠️ Formato pode variar

**Ação Necessária:**
- Explorar pastas SHPTEMP e PCTTMP
- Identificar padrões de arquivos

---

### **SOLUÇÃO 5: Cache/Views do iShop** ⭐⭐⭐⭐⭐

**Conceito:**
- iShop mantém cache em arquivos para performance
- Cenários (Scenarios) armazenam estados
- Podem conter dados de produtos atualizados

**Locais para Procurar:**
```
Z:\Program Files (x86)\Alterdata\Shop\Cenarios\
Z:\Program Files (x86)\Alterdata\Shop\MDB\
Z:\Program Files (x86)\Alterdata\Shop\Lays\
```

**Arquivos Interessantes:**
```
cenario.rtm  (já existe - 48KB)
controle.xml (já vimos)
*.mdb (Access database - cache)
*.dat (dados binários)
```

**Como funciona:**
```python
# 1. Ler arquivos de cache do iShop
# 2. Processar formato proprietário
# 3. Extrair produtos e preços
# 4. Sincronizar
```

**Vantagens:**
- ✅ Não precisa senha
- ✅ Dados em cache = rápido acesso
- ✅ Atualizado pelo próprio iShop
- ✅ Seguro (leitura)

**Desafios:**
- ⚠️ Formato proprietário
- ⚠️ Pode precisar decodificação

**Ação Necessária:**
- Analisar pasta Cenarios
- Testar leitura de cenario.rtm

---

### **SOLUÇÃO 6: Monitor de Tela do iShop (OCR)** ⭐⭐

**Conceito:**
- Capturar tela do iShop quando aberto
- OCR para ler dados visíveis
- Atualizar baseado em mudanças na tela

**Vantagens:**
- ✅ Não precisa senha
- ✅ Não requer acesso a arquivos

**Desafios:**
- ⚠️ iShop precisa estar aberto
- ⚠️ Lento e pouco confiável
- ⚠️ Complexo

**Viabilidade:** 🔴 BAIXA (última opção)

---

### **SOLUÇÃO 7: Interceptar Comunicação iShop ↔ PostgreSQL** ⭐⭐⭐

**Conceito:**
- Interceptar pacotes de rede
- Ler queries SQL enviadas ao PostgreSQL
- Extrair dados das respostas

**Como funciona:**
```python
# Wireshark / tcpdump na porta 5432
# Capturar tráfego PostgreSQL
# Decodificar protocolo
# Extrair dados
```

**Vantagens:**
- ✅ Não precisa senha
- ✅ Tempo real
- ✅ Dados completos

**Desafios:**
- ⚠️ Comunicação pode ser criptografada (SSL)
- ⚠️ Precisa iShop em execução
- ⚠️ Complexo

**Viabilidade:** 🟡 MÉDIA

---

## 📊 COMPARATIVO DAS SOLUÇÕES

| Solução | Precisa Senha? | Complexidade | Tempo Real | Viabilidade |
|---------|---------------|--------------|------------|-------------|
| **Logs PostgreSQL** | ❌ Não | 🟢 Baixa | ⚡ Sim | 🟢 ALTA |
| **Backups iShop** | ❌ Não | 🟢 Baixa | ⏱️ Periódico | 🟢 ALTA |
| **Arquivos TEMP** | ❌ Não | 🟡 Média | ⚡ Sim | 🟢 ALTA |
| **Cache/Cenários** | ❌ Não | 🟡 Média | ⏱️ Frequente | 🟢 ALTA |
| **Arquivos pg_data** | ❌ Não | 🔴 Alta | ⚡ Sim | 🟡 MÉDIA |
| **Intercept Network** | ❌ Não | 🔴 Alta | ⚡ Sim | 🟡 MÉDIA |
| **OCR** | ❌ Não | 🔴 Alta | ❌ Não | 🔴 BAIXA |

---

## 🎯 RECOMENDAÇÕES

### **Top 3 - Implementar AGORA:**

#### **1️⃣ Logs do PostgreSQL** ⭐⭐⭐⭐⭐
```bash
# Procurar logs:
C:\Program Files\PostgreSQL\*\data\pg_log\
C:\PostgreSQL\*\log\

# Monitorar e parsear em tempo real
# Extrair INSERT/UPDATE de produtos
```

**Por quê:**
- ✅ Não precisa senha
- ✅ Tempo real
- ✅ Implementação simples
- ✅ Dados completos

---

#### **2️⃣ Backups Automáticos do iShop** ⭐⭐⭐⭐⭐
```bash
# Explorar:
Z:\Program Files (x86)\Alterdata\Shop\Backup\
Z:\Program Files (x86)\Alterdata\Backup-Service\

# Processar dumps SQL ou CSV
```

**Por quê:**
- ✅ Não precisa senha
- ✅ Dados completos
- ✅ Formato estruturado
- ✅ Gerado pelo iShop

---

#### **3️⃣ Arquivos TEMP do iShop** ⭐⭐⭐⭐
```bash
# Monitorar:
Z:\Program Files (x86)\Alterdata\Shop\SHPTEMP\
Z:\Program Files (x86)\Alterdata\Shop\PCTTMP\

# Capturar relatórios gerados
```

**Por quê:**
- ✅ Não precisa senha
- ✅ Atualização frequente
- ✅ Formato processável

---

## 🔍 AÇÕES IMEDIATAS (Investigação)

### **PASSO 1: Localizar Logs do PostgreSQL**
```bash
# Executar busca:
dir "C:\Program Files\PostgreSQL\" /s /b
dir "C:\PostgreSQL\" /s /b
dir "Z:\" /s | findstr /i "log"
```

### **PASSO 2: Explorar Backups do iShop**
```bash
# Verificar pasta:
dir "Z:\Program Files (x86)\Alterdata\Backup-Service\" /s
dir "Z:\Program Files (x86)\Alterdata\Shop\Backup\" /s
```

### **PASSO 3: Monitorar Pasta TEMP**
```bash
# Listar arquivos:
dir "Z:\Program Files (x86)\Alterdata\Shop\SHPTEMP\" /s
dir "Z:\Program Files (x86)\Alterdata\Shop\PCTTMP\" /s

# Ver conteúdo de cenarios:
dir "Z:\Program Files (x86)\Alterdata\Shop\Cenarios\" /s
```

### **PASSO 4: Procurar pg_data**
```bash
# Buscar pasta de dados:
dir C:\ /s /b | findstr /i "pg_data"
dir C:\ /s /b | findstr /i "postgresql.*data"
```

---

## 📝 ESTRATÉGIA HÍBRIDA FINAL

```
┌─────────────────────────────────────────┐
│ 1. Monitor Y:\IN (.shp)                 │
│    Delay: 30-60 segundos                │
│    Status: ✅ JÁ FUNCIONA               │
└─────────────────────────────────────────┘
              +
┌─────────────────────────────────────────┐
│ 2. Logs PostgreSQL (se encontrar)      │
│    Delay: 0 segundos (tempo real)       │
│    Status: 🔍 INVESTIGAR                │
└─────────────────────────────────────────┘
              +
┌─────────────────────────────────────────┐
│ 3. Backups iShop (se existir)          │
│    Delay: minutos/horas                 │
│    Status: 🔍 INVESTIGAR                │
└─────────────────────────────────────────┘
              +
┌─────────────────────────────────────────┐
│ 4. TEMP Files (complementar)            │
│    Delay: segundos                      │
│    Status: 🔍 INVESTIGAR                │
└─────────────────────────────────────────┘
```

---

## 🚀 PRÓXIMA AÇÃO

**Executar Investigação:**

1. **Buscar Logs PostgreSQL**
   - Encontrar pasta de logs
   - Verificar se está habilitado
   - Analisar formato

2. **Explorar Backups**
   - Pasta Backup-Service
   - Verificar agendamento
   - Identificar formato

3. **Monitorar TEMP**
   - SHPTEMP
   - PCTTMP
   - Cenarios

4. **Implementar Melhor Opção**
   - Parser de logs (se viável)
   - Processador de backups
   - Monitor TEMP

---

## 💡 CONCLUSÃO

**Temos MÚLTIPLAS soluções paralelas que NÃO precisam de senha do PostgreSQL:**

✅ **Logs PostgreSQL** - Melhor opção (tempo real)
✅ **Backups iShop** - Segunda melhor (dados completos)
✅ **Arquivos TEMP** - Complementar (frequente)
✅ **Y:\IN** - Já funciona (30-60s delay)

**Recomendação:**
1. Investigar logs PostgreSQL primeiro
2. Se não tiver logs, usar backups
3. Complementar com monitor TEMP
4. Manter Y:\IN como fallback

**Resultado esperado:**
- Sistema com delay de 0-60 segundos
- Sem necessidade de senha PostgreSQL
- Múltiplas fontes de dados
- Redundância e confiabilidade

---

**Status:** Soluções Identificadas - Aguardando Investigação  
**Próximo:** Executar buscas para localizar arquivos




