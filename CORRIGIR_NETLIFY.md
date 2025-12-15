# 🔧 Como Corrigir os Erros de Build no Netlify

## ✅ Repositório Correto Configurado

O sistema está enviando para: **https://github.com/ronaldomelofz/tabela** ✓

---

## 🎯 Solução dos Erros de Build

Os erros que você está vendo no Netlify (`Build script returned non-zero exit code: 2`) acontecem porque:

1. O Netlify precisa usar `pnpm` (não npm)
2. Precisa da configuração correta do Next.js

### Configuração Necessária no Netlify

#### Passo 1: Acesse o Dashboard do Netlify

1. Vá em: https://app.netlify.com
2. Selecione seu site conectado ao repositório `ronaldomelofz/tabela`

#### Passo 2: Configure as Variáveis de Build

Vá em **Site configuration** → **Build & deploy** → **Build settings**

Configure:

```
Build command: pnpm install && pnpm run build
Publish directory: out
```

#### Passo 3: Configure o Node.js

Em **Site configuration** → **Environment variables**, adicione:

```
NODE_VERSION=18
```

#### Passo 4: Habilite pnpm

Em **Build settings**, adicione essas variáveis de ambiente:

| Key | Value |
|-----|-------|
| `NPM_FLAGS` | `--version` |
| `NETLIFY_USE_PNPM` | `true` |

---

## 🚀 Solução Alternativa (Mais Rápida)

Se os erros persistirem, você pode atualizar o arquivo `netlify.toml`:

### Edite o arquivo `netlify.toml` com este conteúdo:

```toml
[build]
  command = "pnpm install && pnpm run build"
  publish = "out"

[build.environment]
  NODE_VERSION = "18"
  NPM_FLAGS = "--version"

[[plugins]]
  package = "@netlify/plugin-nextjs"
```

Depois:
1. Salve o arquivo
2. Commit e push: 
   ```bash
   git add netlify.toml
   git commit -m "Corrige configuração Netlify"
   git push
   ```
3. Netlify detectará e fará novo deploy

---

## 📊 Verificar Status

### No Netlify:

1. Acesse: https://app.netlify.com/sites/SEU_SITE/deploys
2. Veja o log do último deploy
3. Procure por erros específicos

### Erros Comuns:

| Erro | Solução |
|------|---------|
| `pnpm: command not found` | Configure `NETLIFY_USE_PNPM=true` |
| `Module not found` | Execute `pnpm install` antes do build |
| `build script failed` | Verifique se `pnpm run build` funciona localmente |

---

## ✅ Teste Local Antes de Enviar

Sempre teste o build localmente antes de enviar:

```bash
# Limpar cache
rm -rf .next
rm -rf out
rm -rf node_modules

# Instalar dependências
pnpm install

# Build
pnpm run build

# Se der erro, corrija antes de fazer push
```

---

## 🔄 Fluxo Correto de Atualização

Com o sistema configurado, o fluxo é:

```
1. iShop atualiza dados (Y:\IN e Y:\OUT)
   ⬇️
2. Execute: ATUALIZAR-SITE-E-DEPLOY.bat
   ⬇️
3. Script processa dados e atualiza produtos.json
   ⬇️
4. Git commit e push para github.com/ronaldomelofz/tabela
   ⬇️
5. Netlify detecta mudança
   ⬇️
6. Build automático no Netlify
   ⬇️
7. Site atualizado em produção ✅
```

---

## 🎯 Apenas dados/produtos.json Será Enviado

O sistema foi configurado para enviar **APENAS** o arquivo `data/produtos.json`, sem mexer no resto do projeto, garantindo que:

✅ Build não quebre com mudanças não relacionadas  
✅ Deploy seja rápido (apenas dados mudam)  
✅ Histórico limpo no Git  
✅ Sem conflitos de código  

---

## 📞 Próximos Passos

1. **Configure o Netlify** conforme instruções acima
2. **Teste o deploy** manualmente uma vez
3. **Configure automático** com `AGENDAR-ATUALIZACAO-AUTOMATICA.bat`
4. **Monitore** os primeiros deploys para garantir sucesso

---

## 🔗 Links Úteis

- **Repositório GitHub**: https://github.com/ronaldomelofz/tabela
- **Dashboard Netlify**: https://app.netlify.com
- **Documentação Netlify + pnpm**: https://docs.netlify.com/configure-builds/manage-dependencies/#pnpm
- **Documentação Next.js + Netlify**: https://docs.netlify.com/frameworks/next-js/overview/

---

**Última atualização**: 13/12/2025



