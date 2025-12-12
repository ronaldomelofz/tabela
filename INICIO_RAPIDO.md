# ⚡ Início Rápido

## 🚀 Começando em 3 Passos

### 1️⃣ Instalar Dependências

```bash
pnpm install
```

### 2️⃣ Adicionar Seus Dados

Edite o arquivo `data/produtos.json` com seus produtos:

```json
[
  {
    "codigo": "001",
    "descricao": "Seu Produto",
    "valor": 100.00,
    "estoque": 50
  }
]
```

### 3️⃣ Executar Localmente

```bash
pnpm dev
```

Acesse: http://localhost:3000

## 📤 Deploy no Netlify

```bash
# 1. Inicializar Git
git init
git add .
git commit -m "Initial commit"

# 2. Enviar para GitHub
git remote add origin https://github.com/ronaldomelofz/tabela.git
git push -u origin main

# 3. Deploy no Netlify
# Acesse netlify.com e conecte seu repositório
```

## 📚 Guias Completos

- [📋 Como Adicionar Dados](COMO_ADICIONAR_DADOS.md)
- [🚀 Deploy no Netlify](DEPLOY_NETLIFY.md)
- [📖 Documentação Completa](README.md)

## 🆘 Comandos Úteis

```bash
pnpm dev          # Executar em desenvolvimento
pnpm build        # Build para produção
pnpm start        # Executar build de produção
pnpm lint         # Verificar código
```

## ✅ Checklist Inicial

- [ ] Instalar dependências
- [ ] Adicionar seus dados em `data/produtos.json`
- [ ] Testar localmente
- [ ] Configurar Git
- [ ] Enviar para GitHub
- [ ] Deploy no Netlify

---

💡 **Dica:** Use o arquivo de exemplo em `data/produtos.json` como referência!

