# 🔍 Análise: Integração em Tempo Real com iShop/Alterdata

**Data:** 15/12/2025  
**Objetivo:** Apresentar possibilidades de consulta em tempo real dos dados do iShop

---

## 📊 O Que Descobrimos Sobre o iShop

### 1. **Arquitetura do Sistema**

```
iShop/Alterdata
├── Localização: Z:\Program Files (x86)\Alterdata\Shop
├── Banco de Dados: PostgreSQL
│   ├── Nome: ALTERDATA_SHOP
│   ├── Servidor: localhost
│   └── Provider: PostgreSQL
├── Arquivos de Integração:
│   ├── Y:\IN\*.shp (arquivos incrementais)
│   ├── extracted_shp\
│   │   ├── W2IDocItem.txt
│   │   ├── W2IDocumentos.txt
│   │   └── W2IEstoque.xml
│   └── SHELL.INI (configurações)
└── Executáveis:
    ├── Wshop.exe (sistema principal)
    └── AltShop_*.exe (módulos)
```

### 2. **Estrutura dos Dados**

#### Arquivos .shp (ZIP com XMLs):
```xml
produto.xml:
- idproduto (ID interno)
- cdchamada (código do produto)
- nmproduto (descrição)
- stativo (status: S/N)

detalhe.xml:
- vlprecovenda (preço de venda)
- qtestoque (quantidade em estoque)
- stinativo (status)
```

#### Banco PostgreSQL:
- Tabelas: produtos, detalhes, estoque, etc.
- Acesso: Necessita credenciais
- Porta: 5432 (padrão) ou 5433

---

## 🚀 POSSIBILIDADES DE INTEGRAÇÃO EM TEMPO REAL

### **OPÇÃO 1: Acesso Direto ao PostgreSQL** ⭐⭐⭐⭐⭐

**Como funciona:**
- Conectar diretamente ao banco de dados ALTERDATA_SHOP
- Executar queries SQL para buscar produtos e estoque
- Atualização instantânea a cada consulta

**Implementação:**
```python
import psycopg2

# Conexão direta
conn = psycopg2.connect(
    host='localhost',
    database='ALTERDATA_SHOP',
    user='postgres',  # Descobrir credencial
    password='????'    # Descobrir senha
)

# Query em tempo real
cursor.execute("""
    SELECT p.cdchamada, p.nmproduto, d.vlprecovenda, d.qtestoque
    FROM produto p
    JOIN detalhe d ON p.idproduto = d.idproduto
    WHERE p.stativo = 'S'
""")
```

**Vantagens:**
- ✅ **Tempo real verdadeiro** (dados atualizados instantaneamente)
- ✅ Performance excelente
- ✅ Acesso a TODOS os dados
- ✅ Consultas personalizadas via SQL
- ✅ Sem dependência de arquivos externos

**Desafios:**
- ⚠️ Descobrir credenciais do PostgreSQL
- ⚠️ Permissões de acesso ao banco
- ⚠️ Risco de conflito com iShop (uso concorrente)

**Viabilidade:** 🟢 ALTA (se conseguirmos as credenciais)

**Próximos Passos:**
1. Descobrir senha do PostgreSQL
2. Mapear estrutura completa das tabelas
3. Criar views somente leitura
4. Implementar conexão read-only

---

### **OPÇÃO 2: Monitoramento da Pasta Y:\IN** ⭐⭐⭐⭐

**Como funciona:**
- Monitorar pasta Y:\IN para novos arquivos .shp
- Processar automaticamente quando detectar mudanças
- Extrair e atualizar produtos.json

**Implementação:**
```python
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class MonitorShp(FileSystemEventHandler):
    def on_created(self, event):
        if event.src_path.endswith('.shp'):
            processar_arquivo(event.src_path)
            atualizar_produtos_json()
            publicar_github()

# Monitorar continuamente
observer = Observer()
observer.schedule(MonitorShp(), "Y:\\IN", recursive=True)
observer.start()
```

**Vantagens:**
- ✅ Quase tempo real (segundos após mudança no iShop)
- ✅ Não requer credenciais
- ✅ Usa interface oficial do iShop
- ✅ Seguro (somente leitura)
- ✅ Fácil implementação

**Desafios:**
- ⚠️ Delay de segundos/minutos (não instantâneo)
- ⚠️ Arquivos podem ser incrementais (não completos)
- ⚠️ Depende do iShop gerar os arquivos

**Viabilidade:** 🟢 MUITO ALTA (já temos tudo funcionando)

**Próximos Passos:**
1. Implementar FileWatcher
2. Processar .shp automaticamente
3. Atualizar produtos.json
4. Push automático para GitHub

---

### **OPÇÃO 3: API REST do iShop (se existir)** ⭐⭐⭐

**Como funciona:**
- Verificar se iShop tem API/Web Service
- Fazer requisições HTTP para buscar dados
- Integração via JSON/XML

**Verificar:**
```
Arquivos a investigar:
- Wshop.exe (tem módulo web?)
- AltShop_Configuracoes.exe
- Documentação Alterdata
- Porta 80/443/8080 (servidor web?)
```

**Vantagens:**
- ✅ Interface oficial e suportada
- ✅ Documentação disponível
- ✅ Seguro e estável
- ✅ Facilita integração futura

**Desafios:**
- ⚠️ Precisa verificar se existe API
- ⚠️ Documentação necessária
- ⚠️ Configuração adicional

**Viabilidade:** 🟡 MÉDIA (precisa investigar)

**Próximos Passos:**
1. Verificar documentação Alterdata
2. Testar portas HTTP
3. Procurar por módulo Wshop Web

---

### **OPÇÃO 4: Webhooks/Triggers do PostgreSQL** ⭐⭐⭐⭐

**Como funciona:**
- Criar triggers no PostgreSQL
- Notificar nosso sistema quando houver mudanças
- Processar apenas dados alterados

**Implementação:**
```sql
-- Trigger no PostgreSQL
CREATE OR REPLACE FUNCTION notificar_mudanca()
RETURNS trigger AS $$
BEGIN
    PERFORM pg_notify('produto_alterado', 
        json_build_object('codigo', NEW.cdchamada)::text
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_produto_alterado
AFTER INSERT OR UPDATE ON produto
FOR EACH ROW EXECUTE FUNCTION notificar_mudanca();
```

```python
# Python listener
import psycopg2

conn = psycopg2.connect(...)
conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
cursor = conn.cursor()
cursor.execute("LISTEN produto_alterado;")

while True:
    conn.poll()
    while conn.notifies:
        notify = conn.notifies.pop()
        atualizar_produto(notify.payload)
```

**Vantagens:**
- ✅ Tempo real verdadeiro
- ✅ Eficiente (só processa mudanças)
- ✅ Baixo uso de recursos
- ✅ Event-driven architecture

**Desafios:**
- ⚠️ Requer acesso ao PostgreSQL
- ⚠️ Precisa criar triggers (alteração no banco)
- ⚠️ Manutenção de conexão persistente

**Viabilidade:** 🟡 MÉDIA (precisa acesso ao banco)

---

### **OPÇÃO 5: Arquivos W2I (Interface de Integração)** ⭐⭐⭐⭐

**Como funciona:**
- Usar arquivos W2I já existentes (extracted_shp)
- Monitorar W2IEstoque.xml
- Interface oficial do Alterdata

**Arquivos Disponíveis:**
```
extracted_shp/
├── W2IDocItem.txt     (itens de documentos)
├── W2IDocumentos.txt  (documentos fiscais)
└── W2IEstoque.xml     (movimentação estoque)
```

**Implementação:**
```python
# Monitorar W2IEstoque.xml
def processar_w2i_estoque():
    tree = ET.parse('extracted_shp/W2IEstoque.xml')
    for row in tree.findall('.//ROW'):
        id_produto = row.get('IdDetalhe')
        qt_estoque = row.get('QtEstoque')
        atualizar_estoque(id_produto, qt_estoque)
```

**Vantagens:**
- ✅ Interface oficial Alterdata
- ✅ Arquivos já existem
- ✅ Formato estruturado (XML)
- ✅ Seguro

**Desafios:**
- ⚠️ Atualização pode não ser instantânea
- ⚠️ Precisa verificar frequência de geração

**Viabilidade:** 🟢 ALTA (já temos os arquivos)

---

## 📊 COMPARATIVO DAS OPÇÕES

| Opção | Tempo Real | Facilidade | Segurança | Viabilidade | Recomendação |
|-------|-----------|------------|-----------|-------------|--------------|
| **PostgreSQL Direto** | ⚡ Instantâneo | 🔧 Média | ⚠️ Risco médio | 🟢 Alta* | ⭐⭐⭐⭐⭐ |
| **Monitor Y:\IN** | ⏱️ Segundos | ✅ Fácil | ✅ Seguro | 🟢 Muito Alta | ⭐⭐⭐⭐⭐ |
| **API REST** | ⚡ Instantâneo | ❓ Depende | ✅ Seguro | 🟡 Média | ⭐⭐⭐ |
| **Triggers PostgreSQL** | ⚡ Instantâneo | 🔧 Complexa | ⚠️ Risco médio | 🟡 Média | ⭐⭐⭐⭐ |
| **Arquivos W2I** | ⏱️ Minutos | ✅ Fácil | ✅ Seguro | 🟢 Alta | ⭐⭐⭐⭐ |

*Depende de conseguir credenciais

---

## 🎯 RECOMENDAÇÕES

### **Implementação Ideal (Combinação):**

```
┌─────────────────────────────────────────────────┐
│  CAMADA 1: Monitor Y:\IN (Principal)            │
│  - Monitoramento contínuo de novos .shp         │
│  - Processamento automático                     │
│  - Atualização a cada 30 segundos               │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│  CAMADA 2: PostgreSQL Direto (Backup)           │
│  - Consulta direta quando disponível            │
│  - Validação dos dados                          │
│  - Query sob demanda                            │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│  CAMADA 3: Cache Local (produtos.json)          │
│  - Arquivo local sempre disponível              │
│  - Fallback se outras fontes falharem           │
│  - Publicação no GitHub                         │
└─────────────────────────────────────────────────┘
```

### **Roadmap de Implementação:**

**FASE 1 - Curto Prazo (Já Implementado):** ✅
- ✅ Extração de TABELABLOCO.txt
- ✅ Processamento de Y:\IN (manual/agendado)
- ✅ Publicação no GitHub
- ✅ Atualização automática (10-60 min)

**FASE 2 - Médio Prazo (Próximos Passos):**
- 📋 Monitor em tempo real de Y:\IN (FileWatcher)
- 📋 Processar .shp automaticamente
- 📋 Reduzir delay para 30 segundos
- 📋 Monitorar arquivos W2I

**FASE 3 - Longo Prazo (Ideal):**
- 📋 Descobrir credenciais PostgreSQL
- 📋 Implementar consulta direta ao banco
- 📋 Criar API própria para consultas
- 📋 Dashboard em tempo real

---

## 🔐 DESCOBRINDO CREDENCIAIS DO POSTGRESQL

### Locais para Verificar:

```
1. Arquivo de Configuração:
   Z:\Program Files (x86)\Alterdata\Shop\SHELL.INI
   Z:\Program Files (x86)\Alterdata\Config\

2. Registro do Windows:
   HKEY_LOCAL_MACHINE\SOFTWARE\Alterdata
   HKEY_CURRENT_USER\SOFTWARE\Alterdata

3. Arquivos de Conexão:
   *.ini
   *.config
   *.xml (configurações)

4. Tentar Senhas Comuns:
   - postgres / postgres
   - alterdata / alterdata
   - admin / admin
   - (vazio) / (vazio)
```

### Comando para Testar:
```bash
psql -h localhost -U postgres -d ALTERDATA_SHOP
# Ou porta alternativa:
psql -h localhost -p 5433 -U postgres -d ALTERDATA_SHOP
```

---

## 📝 CONCLUSÃO

### **Melhor Opção para Implementar AGORA:**

**OPÇÃO 2: Monitor Y:\IN em Tempo Real**

**Por quê?**
- ✅ Não requer credenciais
- ✅ Interface oficial do iShop
- ✅ Seguro (somente leitura)
- ✅ Delay aceitável (30-60 segundos)
- ✅ Fácil implementação
- ✅ Mantém tudo que já funciona

**O que precisamos fazer:**
1. Implementar FileWatcher Python
2. Monitorar Y:\IN continuamente
3. Processar .shp automaticamente quando criados
4. Atualizar produtos.json
5. Push automático para GitHub

**Resultado:**
- Sistema atualizado em ~30-60 segundos após mudança no iShop
- Sem necessidade de credenciais
- Totalmente automatizado
- Mantém compatibilidade com sistema atual

---

## 🚀 PRÓXIMA AÇÃO RECOMENDADA

Implementar **FileWatcher** para monitorar Y:\IN em tempo real:

**Benefícios:**
- Reduz delay de 30 minutos para 30 segundos
- Mantém tudo que já funciona
- Não requer acesso ao banco
- Implementação simples e segura

**Alternativa:**
- Continuar tentando descobrir credenciais do PostgreSQL
- Implementar acesso direto quando disponível
- Usar como fonte principal de dados

---

**Autor:** Sistema de Análise  
**Data:** 15/12/2025  
**Status:** Análise Completa - Aguardando Decisão




