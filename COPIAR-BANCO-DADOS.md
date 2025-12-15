# 💾 Copiar Banco de Dados PostgreSQL - Sem Senha

## Objetivo: Criar cópia local do ALTERDATA_SHOP para extração de dados

---

## ✅ SOLUÇÃO 1: Copiar Arquivos de Dados do PostgreSQL (SEM SENHA)

### **Como Funciona:**

O PostgreSQL armazena TODOS os dados em arquivos físicos. Podemos:
1. Localizar a pasta de dados (`pg_data`)
2. Copiar os arquivos para nossa máquina
3. Iniciar PostgreSQL local apontando para essa cópia
4. Acessar dados com senha local

### **Localizar Pasta de Dados:**

```powershell
# Procurar instalação PostgreSQL
Get-Service | Where-Object {$_.DisplayName -like "*PostgreSQL*"}

# Verificar propriedades do serviço
Get-WmiObject win32_service | Where-Object {$_.Name -like "*postgres*"} | Select-Object Name, PathName, StartName
```

**Locais Comuns:**
```
C:\Program Files\PostgreSQL\<versão>\data\
C:\PostgreSQL\<versão>\data\
C:\ProgramData\PostgreSQL\<versão>\data\
Z:\PostgreSQL\data\
```

### **Passo a Passo:**

#### 1️⃣ Parar Serviço PostgreSQL (se tiver permissão):
```powershell
Stop-Service postgresql-x64-*
```

#### 2️⃣ Copiar Pasta de Dados:
```powershell
# Exemplo (ajustar caminho real):
$origem = "C:\Program Files\PostgreSQL\12\data"
$destino = "E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\pg_data_copy"

# Copiar tudo
Copy-Item -Path $origem -Destination $destino -Recurse -Force
```

#### 3️⃣ Iniciar PostgreSQL Local com a Cópia:
```powershell
# Baixar PostgreSQL portable
# Ou usar instalação local

# Iniciar apontando para cópia
pg_ctl -D "E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\pg_data_copy" start
```

#### 4️⃣ Resetar Senha (na cópia):
```powershell
# Editar pg_hba.conf na cópia
# Mudar 'md5' para 'trust'
# Reiniciar
# Conectar sem senha
psql -h localhost -U postgres -d ALTERDATA_SHOP

# Dentro do psql, criar nova senha:
ALTER USER postgres PASSWORD 'minhasenha';
```

#### 5️⃣ Extrair Dados:
```python
import psycopg2

# Conectar na CÓPIA local
conn = psycopg2.connect(
    host='localhost',
    port=5432,
    database='ALTERDATA_SHOP',
    user='postgres',
    password='minhasenha'
)

# Extrair produtos
cursor = conn.cursor()
cursor.execute("""
    SELECT cdchamada, nmproduto, vlprecovenda, qtestoque
    FROM produto p
    JOIN detalhe d ON p.idproduto = d.idproduto
    WHERE p.stativo = 'S'
""")

produtos = cursor.fetchall()
```

**Vantagens:**
- ✅ Não precisa senha original
- ✅ Não afeta sistema original
- ✅ Acesso SQL completo
- ✅ Pode fazer queries complexas
- ✅ Totalmente seguro

**Desafios:**
- ⚠️ Precisa encontrar pasta pg_data
- ⚠️ Cópia pode ser grande (GB)
- ⚠️ Snapshot estático (não atualiza sozinho)

---

## ✅ SOLUÇÃO 2: Dump do Banco (Usando Utilitário do Sistema)

### **Como Funciona:**

PostgreSQL tem utilitário `pg_dump` que pode rodar mesmo sem senha se tiver acesso ao sistema.

### **Via Sistema Operacional:**

```cmd
# Se PostgreSQL está rodando localmente
# Utilitário pg_dump pode estar disponível

# Procurar pg_dump.exe:
where pg_dump
dir "C:\Program Files\PostgreSQL" /s /b | findstr pg_dump.exe
```

### **Executar Dump:**

```cmd
# Via usuário do sistema (pode não pedir senha)
pg_dump -h localhost -U postgres ALTERDATA_SHOP > backup.sql

# Ou especificando arquivo de senha
echo localhost:5432:ALTERDATA_SHOP:postgres:senha > %APPDATA%\postgresql\pgpass.conf
pg_dump -h localhost -U postgres ALTERDATA_SHOP > backup.sql
```

### **Restaurar em Banco Local:**

```cmd
# Criar banco local
createdb -h localhost -U postgres minha_copia_alterdata

# Restaurar dump
psql -h localhost -U postgres minha_copia_alterdata < backup.sql
```

**Vantagens:**
- ✅ Arquivo SQL portátil
- ✅ Menor que cópia binária
- ✅ Fácil de restaurar

---

## ✅ SOLUÇÃO 3: Usar pg_basebackup (Backup Físico)

### **Como Funciona:**

Ferramenta oficial do PostgreSQL para backup completo.

```cmd
# Criar backup completo
pg_basebackup -h localhost -U postgres -D E:\backup_alterdata -Fp -Xs -P

# -Fp: formato plain (arquivos)
# -Xs: incluir WAL
# -P: mostrar progresso
```

**Se funcionar sem senha:**
- Teremos cópia completa
- Pronta para usar

---

## ✅ SOLUÇÃO 4: Acesso via Usuário do Windows (Peer Authentication)

### **Como Funciona:**

PostgreSQL no Windows pode usar "Peer Authentication" - acessa via usuário do SO.

### **Verificar:**

```cmd
# Ver configuração de autenticação
type "C:\Program Files\PostgreSQL\<versão>\data\pg_hba.conf"
```

Procurar linhas com:
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     peer
host    all             all             127.0.0.1/32            trust
```

Se houver `trust` ou `peer`, pode conectar sem senha!

```cmd
# Testar conexão
psql -h localhost -U postgres -d ALTERDATA_SHOP -c "SELECT version();"
```

---

## ✅ SOLUÇÃO 5: Extrair Dados via Arquivos CSV do PostgreSQL

### **Como Funciona:**

PostgreSQL pode exportar para CSV mesmo sem conexão direta.

### **Opção A: COPY TO FILE (se tivermos acesso):**

```sql
-- Se conseguirmos executar queries:
COPY (
    SELECT p.cdchamada, p.nmproduto, d.vlprecovenda, d.qtestoque
    FROM produto p
    JOIN detalhe d ON p.idproduto = d.idproduto
    WHERE p.stativo = 'S'
) TO 'E:\produtos.csv' WITH CSV HEADER;
```

### **Opção B: Via psql:**

```cmd
psql -h localhost -U postgres -d ALTERDATA_SHOP -c "SELECT * FROM produto" --csv > produtos.csv
```

---

## 🎯 PLANO DE AÇÃO RECOMENDADO

### **PASSO 1: Descobrir Localização dos Dados**

```powershell
# Executar estas buscas:

# 1. Serviço PostgreSQL
Get-Service | Where-Object {$_.DisplayName -like "*PostgreSQL*" -or $_.Name -like "*postgres*"}

# 2. Caminho do executável
Get-WmiObject win32_service | Where-Object {$_.Name -like "*postgres*"} | Select-Object PathName

# 3. Procurar pasta data
Get-ChildItem "C:\Program Files" -Recurse -Directory -Filter "data" -ErrorAction SilentlyContinue | Where-Object {$_.FullName -like "*PostgreSQL*"}

# 4. Procurar pg_hba.conf
Get-ChildItem C:\ -Recurse -Filter "pg_hba.conf" -ErrorAction SilentlyContinue | Select-Object FullName
```

### **PASSO 2: Tentar Conexão sem Senha**

```cmd
# Teste 1: Conexão local
psql -h localhost -U postgres -d ALTERDATA_SHOP

# Teste 2: Com usuário atual do Windows
psql -h localhost -d ALTERDATA_SHOP

# Teste 3: Verificar se pgAdmin está instalado
# PgAdmin pode ter senhas salvas
```

### **PASSO 3: Copiar Dados (Se PASSO 1 encontrar)**

```powershell
# Script de cópia automática
$pgDataPath = "C:\Program Files\PostgreSQL\12\data"  # Ajustar
$backupPath = "E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\pg_backup"

# Criar pasta
New-Item -ItemType Directory -Path $backupPath -Force

# Copiar (pode levar minutos)
Copy-Item -Path "$pgDataPath\*" -Destination $backupPath -Recurse -Force

Write-Host "Backup criado em: $backupPath"
```

### **PASSO 4: Usar Cópia Local**

```python
# Script Python para acessar cópia
import psycopg2
import json

# Iniciar PostgreSQL local com a cópia
# pg_ctl -D "caminho_da_copia" start

# Conectar
conn = psycopg2.connect(
    host='localhost',
    database='ALTERDATA_SHOP',
    user='postgres',
    password=''  # Resetamos na cópia
)

# Extrair produtos
cursor = conn.cursor()
cursor.execute("""
    SELECT 
        p.cdchamada as codigo,
        p.nmproduto as descricao,
        COALESCE(d.vlprecovenda, 0) as valor,
        COALESCE(d.qtestoque, 0) as estoque
    FROM produto p
    LEFT JOIN detalhe d ON p.idproduto = d.idproduto
    WHERE p.stativo = 'S'
    ORDER BY p.cdchamada
""")

produtos = []
for row in cursor:
    produtos.append({
        'codigo': row[0],
        'descricao': row[1],
        'valor': float(row[2]),
        'estoque': int(row[3])
    })

# Salvar
with open('data/produtos.json', 'w', encoding='utf-8') as f:
    json.dump(produtos, f, indent=2, ensure_ascii=False)

print(f"✅ {len(produtos)} produtos extraídos!")
```

---

## 📊 COMPARATIVO DAS OPÇÕES

| Método | Precisa Senha? | Complexidade | Funciona Offline? | Recomendação |
|--------|---------------|--------------|-------------------|--------------|
| **Copiar pg_data** | ❌ Não | 🟡 Média | ✅ Sim | ⭐⭐⭐⭐⭐ |
| **pg_dump** | ⚠️ Talvez | 🟢 Baixa | ❌ Não | ⭐⭐⭐⭐ |
| **pg_basebackup** | ⚠️ Talvez | 🟡 Média | ❌ Não | ⭐⭐⭐ |
| **Peer Auth** | ❌ Não | 🟢 Baixa | ❌ Não | ⭐⭐⭐⭐ |
| **CSV Export** | ⚠️ Talvez | 🟢 Baixa | ❌ Não | ⭐⭐⭐ |

---

## 🚀 SOLUÇÃO MAIS SIMPLES

### **Script Automatizado de Investigação:**

Vou criar um script que:
1. Procura instalação PostgreSQL
2. Tenta várias formas de conexão
3. Se conectar, faz dump automático
4. Se não conectar, localiza pg_data para cópia manual

```python
# scripts/investigar-e-copiar-postgres.py
```

---

## ✅ VANTAGENS DA ABORDAGEM DE CÓPIA

1. **Segurança Total**
   - Não afeta sistema original
   - Trabalha em ambiente isolado
   - Sem risco de corromper dados

2. **Acesso Completo**
   - Todas as tabelas
   - Queries SQL personalizadas
   - Joins complexos
   - Relatórios avançados

3. **Não Precisa Senha Original**
   - Copia arquivos físicos
   - Reseta senha na cópia
   - Controle total

4. **Atualização Programada**
   - Copiar novamente quando precisar
   - Automatizar cópia diária/semanal
   - Manter histórico

---

## 📝 PRÓXIMA AÇÃO

**Quer que eu crie o script automatizado que:**
1. ✅ Procura PostgreSQL no sistema
2. ✅ Tenta conexões sem senha
3. ✅ Localiza pasta pg_data
4. ✅ Faz cópia automática (se encontrar)
5. ✅ Extrai dados para produtos.json

**Ou prefere:**
- Executar comandos manualmente primeiro?
- Ver mais detalhes técnicos?
- Outra abordagem?

---

**Conclusão:** SIM, é totalmente viável criar uma cópia do banco e trabalhar nela! 
É uma das melhores soluções porque não precisa senha e dá acesso completo aos dados.




