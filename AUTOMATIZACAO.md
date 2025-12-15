# 🤖 Sistema de Atualização Automática

Sistema completo para atualizar dados e publicar no GitHub automaticamente.

## 📋 O que faz:

1. ✅ Extrai dados do **TABELABLOCO.txt** (base completa)
2. ✅ Verifica atualizações em **Y:\IN** (se disponível)
3. ✅ Gera **data/produtos.json** atualizado
4. ✅ Faz **commit e push** para GitHub automaticamente
5. ✅ Netlify detecta mudanças e atualiza o site

## 🚀 Uso Manual

### Executar agora:

```bash
ATUALIZAR-E-PUBLICAR.bat
```

Ou via Python:

```bash
python scripts/atualizar-e-publicar.py
```

## ⏰ Agendar Atualização Automática

### Windows - Agendador de Tarefas:

1. **Execute como Administrador:**
   ```
   AGENDAR-ATUALIZACAO.bat
   ```

2. **Escolha o intervalo de atualização:**
   - 🔹 **10 minutos** - Atualização muito frequente (ideal para desenvolvimento)
   - 🔹 **20 minutos** - Atualização frequente
   - 🔹 **30 minutos** - Atualização moderada (recomendado)
   - 🔹 **60 minutos** - Atualização a cada hora
   - 🔹 **Diário às 08:00** - Uma vez por dia

3. **Gerenciar agendamento:**

### Ver status do agendamento:
```cmd
VER-AGENDAMENTO.bat
```

### Remover agendamento:
```cmd
REMOVER-AGENDAMENTO.bat
```

### Comandos manuais:

**Desabilitar temporariamente:**
```cmd
schtasks /change /tn "AtualizarProdutosGitHub" /disable
```

**Habilitar novamente:**
```cmd
schtasks /change /tn "AtualizarProdutosGitHub" /enable
```

**Remover completamente:**
```cmd
schtasks /delete /tn "AtualizarProdutosGitHub" /f
```

## 📊 Fluxo de Atualização

```
TABELABLOCO.txt  →  Extrair dados
                    ↓
Y:\IN (opcional) →  Aplicar atualizações
                    ↓
                Gerar produtos.json
                    ↓
                Git commit + push
                    ↓
                GitHub (ronaldomelofz/tabela)
                    ↓
                Netlify auto-deploy
                    ↓
                Site atualizado! 🎉
```

## 🔐 Configuração do Git (Primeira vez)

### 1. Configurar credenciais:

```bash
git config user.name "Seu Nome"
git config user.email "seu@email.com"
```

### 2. Autenticação GitHub:

#### Opção A: Personal Access Token (Recomendado)

1. Vá para GitHub → Settings → Developer settings → Personal access tokens
2. Gere um token com permissão `repo`
3. Configure:

```bash
git remote set-url origin https://SEU_TOKEN@github.com/ronaldomelofz/tabela.git
```

#### Opção B: SSH

1. Gere chave SSH:
```bash
ssh-keygen -t ed25519 -C "seu@email.com"
```

2. Adicione no GitHub: Settings → SSH Keys

3. Configure:
```bash
git remote set-url origin git@github.com:ronaldomelofz/tabela.git
```

## 📂 Arquivos Criados

| Arquivo | Descrição |
|---------|-----------|
| `scripts/atualizar-e-publicar.py` | Script Python principal |
| `ATUALIZAR-E-PUBLICAR.bat` | ▶️ Executar atualização agora |
| `AGENDAR-ATUALIZACAO.bat` | ⏰ Agendar atualização automática |
| `VER-AGENDAMENTO.bat` | 👁️ Ver status do agendamento |
| `REMOVER-AGENDAMENTO.bat` | ❌ Remover agendamento |
| `AUTOMATIZACAO.md` | 📖 Esta documentação |

## 🔍 Logs e Monitoramento

O script exibe em tempo real:
- ✅ Produtos extraídos
- 🔄 Atualizações aplicadas
- 📤 Status do push para GitHub
- 📊 Estatísticas dos dados

## ⚠️ Solução de Problemas

### Erro: "git push failed"

**Causa:** Credenciais não configuradas

**Solução:**
1. Configure Personal Access Token (ver seção acima)
2. Ou execute `git push` manualmente uma vez para salvar credenciais

### Erro: "TABELABLOCO.txt not found"

**Causa:** Arquivo não está na pasta raiz

**Solução:**
1. Certifique-se que TABELABLOCO.txt está em: `E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\`
2. Ou atualize o caminho no script

### Erro: "Y:\ not accessible"

**Causa:** Unidade Y:\ não está montada

**Solução:**
- Não é erro crítico
- O sistema usará apenas dados do TABELABLOCO.txt
- As atualizações de Y:\ são opcionais

## 🎯 Verificar se está funcionando

1. Execute `ATUALIZAR-E-PUBLICAR.bat`
2. Aguarde conclusão
3. Verifique GitHub: [https://github.com/ronaldomelofz/tabela/commits](https://github.com/ronaldomelofz/tabela/commits)
4. Site atualiza automaticamente em ~2 minutos

## 📞 Suporte

- GitHub Issues: https://github.com/ronaldomelofz/tabela/issues
- Autor: Ronaldo Melo

---

✨ **Sistema pronto para uso!** Execute `ATUALIZAR-E-PUBLICAR.bat` para testar.

