# 🤖 Instalação Automática - Para Quem Não É Programador

Este guia é especialmente feito para quem não tem conhecimento técnico em programação.

## 🎯 O Que Você Precisa Fazer

Apenas **3 CLIQUES** e tudo estará funcionando!

---

## 🚀 PASSO A PASSO SUPER SIMPLES

### 1️⃣ Instalar Tudo Automaticamente

**Clique duas vezes** no arquivo:
```
scripts/setup-completo.bat
```

Este script vai:
- ✅ Instalar todas as dependências necessárias
- ✅ Converter seu PDF para o formato correto (se tiver Python)
- ✅ Testar se tudo está funcionando
- ✅ Preparar o site para uso

**Tempo estimado:** 2-5 minutos

---

### 2️⃣ Ver o Site Funcionando no Seu Computador

**Clique duas vezes** no arquivo:
```
scripts/executar-site.bat
```

O navegador abrirá automaticamente em: http://localhost:3000

Você verá seu site funcionando! 🎉

**Para fechar:** Pressione `Ctrl+C` na janela preta que abriu

---

### 3️⃣ Publicar na Internet (Netlify)

#### Opção A: Usando GitHub Desktop (MAIS FÁCIL) ⭐

1. **Baixe o GitHub Desktop:**
   - Acesse: https://desktop.github.com
   - Instale o programa

2. **Configure uma conta:**
   - Abra o GitHub Desktop
   - Faça login com sua conta GitHub

3. **Publique o projeto:**
   - Clique em "Publish repository"
   - Nome do repositório: `tabela`
   - Desmarque "Keep this code private" se quiser público
   - Clique em "Publish repository"

4. **Deploy no Netlify:**
   - Acesse: https://app.netlify.com
   - Clique em "Add new site" → "Import an existing project"
   - Escolha "GitHub"
   - Selecione o repositório `tabela`
   - Clique em "Deploy site"

**PRONTO!** Em 2-3 minutos seu site estará online!

#### Opção B: Usando Script Automático

**Clique duas vezes** no arquivo:
```
scripts/enviar-para-github.bat
```

Siga as instruções na tela.

---

## 📱 Acessando Seu Site Publicado

Depois do deploy no Netlify, você receberá um link como:

```
https://seu-site.netlify.app
```

Compartilhe este link com quem quiser! 🌐

---

## 📝 Como Atualizar os Produtos

### Método 1: Converter PDF Automaticamente

Se você tem Python instalado:

```
python scripts/converter-pdf-para-json.py
```

### Método 2: Editar Manualmente (MAIS FÁCIL)

1. Abra o arquivo: `data/produtos.json`

2. Use um editor como:
   - Bloco de Notas
   - Notepad++
   - VSCode

3. Copie e cole seus produtos neste formato:

```json
[
  {
    "codigo": "001",
    "descricao": "Nome do Produto",
    "valor": 100.00,
    "estoque": 50
  },
  {
    "codigo": "002",
    "descricao": "Outro Produto",
    "valor": 250.00,
    "estoque": 30
  }
]
```

4. Salve o arquivo

5. Execute novamente: `executar-site.bat`

---

## 🆘 Problemas Comuns

### ❌ "pnpm não é reconhecido"

**Solução:** Instale o Node.js
- Baixe: https://nodejs.org/pt-br/download/
- Instale normalmente
- Reinicie o computador
- Execute `setup-completo.bat` novamente

### ❌ "Python não encontrado"

**Solução (Opcional):** O Python só é necessário para converter o PDF automaticamente
- Baixe: https://www.python.org/downloads/
- Durante a instalação, marque "Add Python to PATH"
- Ou edite o `produtos.json` manualmente

### ❌ Erro ao enviar para GitHub

**Solução:** Use o GitHub Desktop (mais fácil)
- Baixe: https://desktop.github.com
- Siga as instruções da Opção A acima

---

## 📞 Checklist de Instalação

- [ ] Executei `setup-completo.bat`
- [ ] Executei `executar-site.bat` e vi o site funcionando
- [ ] Atualizei os produtos em `data/produtos.json`
- [ ] Publiquei no GitHub Desktop
- [ ] Fiz deploy no Netlify
- [ ] Recebi o link do site publicado
- [ ] Testei o link e está funcionando

---

## 🎓 Vídeos Tutoriais Recomendados

Se preferir aprender vendo:

1. **Como usar GitHub Desktop:**
   - https://www.youtube.com/results?search_query=github+desktop+tutorial+português

2. **Como fazer deploy no Netlify:**
   - https://www.youtube.com/results?search_query=netlify+deploy+tutorial+português

---

## 💡 Dicas Importantes

1. **Mantenha o arquivo original:** Sempre faça backup de `produtos.json` antes de editar

2. **Teste localmente primeiro:** Use `executar-site.bat` para ver as mudanças antes de publicar

3. **Atualizações automáticas:** Depois de configurado, toda mudança que você fizer e enviar para o GitHub será automaticamente publicada no Netlify

4. **Domínio personalizado:** No Netlify você pode configurar um domínio próprio (ex: www.meusite.com.br)

---

## ✅ RESUMO ULTRA RÁPIDO

```
1. Clique: setup-completo.bat
2. Clique: executar-site.bat
3. Use GitHub Desktop para publicar
4. Configure no Netlify
5. PRONTO! ✨
```

**Tempo total:** 10-15 minutos
**Dificuldade:** ⭐☆☆☆☆ (Muito Fácil)

---

💬 **Precisa de ajuda?** Abra uma issue no GitHub ou consulte os arquivos:
- `README.md` - Documentação completa
- `INICIO_RAPIDO.md` - Guia de início rápido
- `DEPLOY_NETLIFY.md` - Guia detalhado de deploy

