# 🚀 Guia de Deploy no Netlify

Este guia mostra como fazer o deploy do seu site no Netlify conectado ao GitHub.

## 📋 Pré-requisitos

- ✅ Conta no [GitHub](https://github.com)
- ✅ Conta no [Netlify](https://netlify.com) (gratuita)
- ✅ Projeto configurado localmente

## 🔧 Passo 1: Configurar o Repositório no GitHub

### 1.1 Inicializar Git

```bash
git init
git add .
git commit -m "Initial commit: Sistema de Tabela de Preços"
```

### 1.2 Criar Repositório no GitHub

1. Acesse https://github.com/ronaldomelofz/tabela
2. Se o repositório já existir, continue
3. Se não existir, crie um novo repositório com o nome `tabela`

### 1.3 Conectar e Enviar o Código

```bash
git remote add origin https://github.com/ronaldomelofz/tabela.git
git branch -M main
git push -u origin main
```

## 🌐 Passo 2: Deploy no Netlify

### Opção A: Via Interface Web (Recomendado para Iniciantes)

1. **Login no Netlify:**
   - Acesse https://app.netlify.com
   - Faça login com sua conta GitHub

2. **Importar Projeto:**
   - Clique em "Add new site" → "Import an existing project"
   - Escolha "GitHub"
   - Autorize o Netlify a acessar seus repositórios
   - Selecione o repositório `tabela`

3. **Configurações de Build:**
   ```
   Build command:    pnpm install && pnpm run build
   Publish directory: out
   ```

4. **Deploy:**
   - Clique em "Deploy site"
   - Aguarde alguns minutos
   - Seu site estará disponível em uma URL como: `nome-aleatorio.netlify.app`

5. **Personalizar URL (Opcional):**
   - Vá em "Site settings" → "Change site name"
   - Escolha um nome: `tabela-preco-estoque.netlify.app`

### Opção B: Via Netlify CLI (Para Usuários Avançados)

```bash
# Instalar Netlify CLI
npm install -g netlify-cli

# Login
netlify login

# Inicializar
netlify init

# Seguir as instruções:
# - Link to GitHub repository
# - Build command: pnpm install && pnpm run build
# - Publish directory: out

# Deploy
netlify deploy --prod
```

## ⚙️ Configurações Avançadas

### Deploy Automático

O Netlify está configurado para fazer deploy automático sempre que você:
- Fizer push para o branch `main`
- Aceitar um Pull Request

### Variáveis de Ambiente (Se Necessário)

1. Vá em "Site settings" → "Environment variables"
2. Adicione suas variáveis
3. Faça um novo deploy

### Domínio Personalizado

1. Compre um domínio (GoDaddy, Registro.br, Namecheap, etc.)
2. No Netlify: "Domain management" → "Add custom domain"
3. Siga as instruções para configurar DNS

## 🔄 Atualizando o Site

### Via Git (Recomendado)

1. Faça suas alterações localmente
2. Commit e push:
```bash
git add .
git commit -m "Atualização de produtos"
git push
```
3. O Netlify fará o deploy automaticamente

### Via Interface Netlify

1. Acesse o painel do Netlify
2. Vá em "Deploys"
3. Clique em "Trigger deploy" → "Deploy site"

## ✅ Checklist de Deploy

Antes de fazer o deploy, verifique:

- [ ] Dados em `data/produtos.json` estão corretos
- [ ] Build funciona localmente (`pnpm run build`)
- [ ] Código está no GitHub
- [ ] Netlify está conectado ao repositório
- [ ] Configurações de build estão corretas

## 🐛 Troubleshooting

### Erro: "Build failed"

1. Verifique os logs de build no Netlify
2. Teste o build localmente: `pnpm run build`
3. Certifique-se de que o `next.config.js` tem `output: 'export'`

### Erro: "Page not found"

1. Verifique se o diretório de publicação é `out`
2. Limpe o cache do Netlify: "Site settings" → "Build & deploy" → "Clear cache and retry deploy"

### Erro: "Missing dependencies"

1. Verifique se o `package.json` está atualizado
2. Delete `node_modules` e `pnpm-lock.yaml`
3. Execute `pnpm install` novamente
4. Faça commit e push

## 📊 Monitoramento

### Analytics (Opcional)

1. No Netlify: "Analytics" → "Enable analytics"
2. Veja estatísticas de visitantes, páginas mais acessadas, etc.

### Logs

1. "Deploys" → Clique em um deploy específico
2. Veja logs detalhados de build e erros

## 🎉 Pronto!

Seu site agora está online e acessível em:
```
https://seu-site.netlify.app
```

Compartilhe o link com seus clientes e usuários!

## 🔗 Links Úteis

- [Documentação Netlify](https://docs.netlify.com/)
- [Next.js Deploy](https://nextjs.org/docs/deployment)
- [Netlify Community](https://answers.netlify.com/)

---

💡 **Dica:** Configure notificações por email no Netlify para ser alertado sobre deploys com sucesso ou erros.

