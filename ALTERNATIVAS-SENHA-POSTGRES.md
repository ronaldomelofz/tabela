# 🔐 RECUPERAR SENHA POSTGRESQL - Todas as Alternativas

**Data:** 15/12/2025
**Status:** Banco protegido por senha

---

## ✅ O QUE JÁ FOI FEITO:

### 1. **Investigação Completa** ✅
- PostgreSQL encontrado e funcionando
- Versão: 9.6
- Porta: 5432
- Banco: ALTERDATA_SHOP

### 2. **Cópia Completa do Banco** ✅
- 21/21 componentes copiados (2 GB)
- Destino: `E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\BANCOCOPIA`
- Banco ORIGINAL permanece 100% intacto

### 3. **Testes de Conexão** ✅
- Testadas TODAS as formas de conexão sem senha
- **Resultado:** Banco está protegido - senha necessária

---

## 🎯 ALTERNATIVAS DISPONÍVEIS:

### **ALTERNATIVA 1: Encontrar Senha Armazenada** ⭐ MAIS RÁPIDA

#### **Opção A: Verificar pgAdmin**
O pgAdmin (ferramenta gráfica do PostgreSQL) pode ter senhas salvas.

**Como fazer:**
1. Abrir pgAdmin 4
2. Procurar por: `C:\Users\[Usuario]\AppData\Roaming\pgAdmin\`
3. Verificar arquivo `pgpass.conf` ou `servers.json`

**Comando:**
```cmd
dir "C:\Users\%USERNAME%\AppData\Roaming\pgAdmin" /s /b
type "C:\Users\%USERNAME%\AppData\Roaming\pgAdmin\pgpass.conf" 2>nul
```

#### **Opção B: Verificar Arquivo .pgpass**
PostgreSQL pode armazenar senhas em arquivo oculto.

**Locais:**
- Windows: `%APPDATA%\postgresql\pgpass.conf`
- Windows: `%USERPROFILE%\.pgpass`

**Comando:**
```cmd
type "%APPDATA%\postgresql\pgpass.conf" 2>nul
type "%USERPROFILE%\.pgpass" 2>nul
```

#### **Opção C: Verificar Registro do Windows**
Senha pode estar no registro (se salva por algum aplicativo).

**Comando:**
```cmd
reg query "HKCU\Software\PostgreSQL" /s
reg query "HKLM\SOFTWARE\PostgreSQL" /s
```

---

### **ALTERNATIVA 2: Resetar Senha** ⚠️ REQUER ADMIN

#### **Como Funciona:**
1. Parar serviço PostgreSQL
2. Modificar `pg_hba.conf` (trocar 'md5' por 'trust')
3. Reiniciar serviço
4. Conectar sem senha e definir nova
5. Restaurar configuração original

#### **IMPORTANTE:**
- ⚠️ Vai PARAR o sistema iShop temporariamente
- ⚠️ Requer permissões de administrador
- ⚠️ Pode afetar outras aplicações que usam o banco
- ⏱️ Tempo de inatividade: 5-10 minutos

#### **Script Pronto:**
Já criado: `COPIAR-E-RESETAR-SENHA.bat`

**Passos:**
```cmd
1. Parar iShop
2. Executar como Administrador: COPIAR-E-RESETAR-SENHA.bat
3. Seguir instruções
4. Reiniciar iShop
```

---

### **ALTERNATIVA 3: Contatar Alterdata/Administrador** ⭐ RECOMENDADA

#### **Opção A: Suporte Alterdata**
- Empresa que desenvolveu o iShop
- Podem fornecer senha padrão ou método de recuperação
- Telefone/email de suporte

#### **Opção B: Administrador do Sistema**
- Quem instalou o iShop deve ter a senha
- Verificar documentação da instalação
- Pode estar em documento de configuração

#### **Opção C: Fornecedor/Revendedor**
- Empresa que vendeu/instalou o sistema
- Geralmente guardam credenciais de acesso
- Suporte técnico contratado

---

### **ALTERNATIVA 4: Usar Sistema Atual** ✅ JÁ FUNCIONA PERFEITAMENTE

#### **O que já temos funcionando:**
```
✅ Extração de 1.601 produtos
✅ Dados de TABELABLOCO.txt
✅ Atualização automática via Y:\IN
✅ Sistema agendado (10, 20, 30, 60 min, diário)
✅ Publicação automática no GitHub
✅ Zero dependência de senha PostgreSQL
```

**Scripts disponíveis:**
- `scripts/atualizar-e-publicar.py`
- `AGENDAR-ATUALIZACAO.bat`
- `VER-AGENDAMENTO.bat`

**GitHub:** https://github.com/ronaldomelofz/tabela

#### **Vantagens:**
- ✅ Funcionando 100%
- ✅ Não precisa senha
- ✅ Não afeta sistema original
- ✅ Atualizações automáticas
- ✅ Dados completos (1.601 produtos)

---

### **ALTERNATIVA 5: Senha Padrão Alterdata** 🔍 TENTAR

Sistemas Alterdata geralmente usam senhas padrão. Vamos testar:

**Senhas comuns Alterdata:**
- `alterdata`
- `Alterdata`
- `ALTERDATA`
- `admin`
- `Admin123`
- `ishop`
- `iShop`
- `master`
- `postgres`
- `Postgres`
- `123456`
- `admin123`

**Script para testar:**
```python
python scripts/testar-senhas-comuns.py
```

---

### **ALTERNATIVA 6: Extração via Backup Automático** 🔄

Se o iShop faz backups automáticos, podemos:
1. Localizar backups (.backup, .sql, .dump)
2. Restaurar em PostgreSQL local
3. Extrair dados do backup

**Locais comuns de backup:**
- `Z:\Backup-Service\`
- `C:\Alterdata\Backup\`
- `Z:\Program Files (x86)\Alterdata\Backup\`

---

## 📊 COMPARATIVO DAS ALTERNATIVAS:

| Alternativa | Tempo | Risco | Precisa Admin | Sucesso | Recomendação |
|-------------|-------|-------|---------------|---------|--------------|
| **1. Encontrar senha salva** | 5 min | 🟢 Zero | ❌ Não | 🟡 Médio | ⭐⭐⭐⭐ |
| **2. Resetar senha** | 10 min | 🟡 Médio | ✅ Sim | 🟢 Alto | ⭐⭐⭐ |
| **3. Contatar suporte** | 1-24h | 🟢 Zero | ❌ Não | 🟢 Alto | ⭐⭐⭐⭐⭐ |
| **4. Usar sistema atual** | 0 min | 🟢 Zero | ❌ Não | ✅ 100% | ⭐⭐⭐⭐⭐ |
| **5. Testar senhas padrão** | 2 min | 🟢 Zero | ❌ Não | 🟡 Baixo | ⭐⭐⭐ |
| **6. Usar backup** | 30 min | 🟢 Zero | ❌ Não | 🟡 Médio | ⭐⭐⭐ |

---

## 🚀 PLANO DE AÇÃO RECOMENDADO:

### **PASSO 1: Tentar senhas padrão** (2 minutos)
```cmd
python scripts\testar-senhas-comuns.py
```

### **PASSO 2: Procurar senha armazenada** (5 minutos)
```cmd
# Verificar pgAdmin
dir "C:\Users\%USERNAME%\AppData\Roaming\pgAdmin" /s /b

# Verificar pgpass
type "%APPDATA%\postgresql\pgpass.conf"

# Verificar registro
reg query "HKCU\Software\PostgreSQL" /s
```

### **PASSO 3: Contatar suporte** (1-24 horas)
- Ligar para suporte Alterdata
- Email para administrador do sistema
- Verificar documentação de instalação

### **PASSO 4: Enquanto isso...** ✅
**Usar sistema atual que JÁ FUNCIONA:**
```cmd
python scripts\atualizar-e-publicar.py
AGENDAR-ATUALIZACAO.bat
```

---

## 💡 SE CONSEGUIR A SENHA:

Quando obtiver a senha, use:

```python
# scripts/extrair-dados-com-senha.py
import psycopg2
import json

conn = psycopg2.connect(
    host='localhost',
    port=5432,
    database='ALTERDATA_SHOP',
    user='postgres',
    password='SENHA_AQUI'  # ← Colocar senha obtida
)

cursor = conn.cursor()
cursor.execute("""
    SELECT 
        p.cdchamada,
        p.nmproduto,
        d.vlprecovenda,
        d.qtestoque
    FROM produto p
    LEFT JOIN detalhe d ON p.idproduto = d.idproduto
    WHERE p.stativo = 'S'
""")

produtos = cursor.fetchall()
# Processar e salvar...
```

---

## ✅ RESUMO EXECUTIVO:

### **O que temos:**
- ✅ PostgreSQL identificado e funcionando
- ✅ Cópia completa do banco (2 GB)
- ✅ Sistema alternativo funcionando 100%
- ✅ 1.601 produtos disponíveis
- ✅ Atualização automática via Y:\IN
- ✅ GitHub integrado

### **O que falta:**
- ⚠️ Senha do PostgreSQL

### **Próximos passos:**
1. **Imediato:** Testar senhas padrão Alterdata
2. **Curto prazo:** Procurar senha armazenada
3. **Médio prazo:** Contatar suporte Alterdata
4. **Enquanto isso:** Usar sistema atual (já funciona!)

---

## 📞 CONTATOS ÚTEIS:

### **Alterdata Software**
- Site: https://www.alterdata.com.br
- Suporte: Verificar site para telefone/email
- Chat online disponível

### **Documentação:**
- Manual do iShop
- Documentação de instalação
- Notas de configuração

---

## 🎯 CONCLUSÃO:

**MELHOR CAMINHO:**
1. ✅ **Usar sistema atual** (já funciona, sem senha)
2. 📞 **Contatar Alterdata** (obter senha oficial)
3. 🔄 **Integrar PostgreSQL** (quando tiver senha)

**Sistema atual é excelente e não depende de senha!**

Todos os dados estão disponíveis, atualizações automáticas funcionando, e GitHub integrado.

---

**Documentos relacionados:**
- `COPIAR-BANCO-DADOS.md` - Análise técnica completa
- `RESUMO-COPIA-BANCO-DADOS.md` - Resumo da cópia
- `AUTOMATIZACAO.md` - Sistema atual funcionando




