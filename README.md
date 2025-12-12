# 🛍️ Tabela de Preços e Estoque

Sistema moderno e funcional para consulta de preços e estoque de produtos, desenvolvido com Next.js e shadcn/ui.

## ✨ Funcionalidades

- 🔍 **Pesquisa Inteligente**: Busca por código ou descrição do produto
- 💰 **Cálculo Automático**: Exibe valor à vista com 10% de desconto
- 📊 **Dashboard com Estatísticas**: Visualize totais e informações resumidas
- 🎨 **Interface Moderna**: Design responsivo e intuitivo
- 📱 **Mobile First**: Totalmente responsivo para todos os dispositivos
- ⚡ **Performance**: Carregamento rápido e otimizado

## 🚀 Tecnologias Utilizadas

- **[Next.js 15](https://nextjs.org/)** - Framework React para produção
- **[React 18](https://react.dev/)** - Biblioteca para interfaces
- **[TypeScript](https://www.typescriptlang.org/)** - JavaScript com tipagem estática
- **[Tailwind CSS](https://tailwindcss.com/)** - Framework CSS utilitário
- **[shadcn/ui](https://ui.shadcn.com/)** - Componentes reutilizáveis e acessíveis
- **[Lucide React](https://lucide.dev/)** - Ícones modernos
- **[pnpm](https://pnpm.io/)** - Gerenciador de pacotes eficiente

## 📦 Instalação

### Pré-requisitos

- Node.js 18+ instalado
- pnpm instalado (`npm install -g pnpm`)

### Passos

1. Clone o repositório:
```bash
git clone https://github.com/ronaldomelofz/tabela.git
cd tabela
```

2. Instale as dependências:
```bash
pnpm install
```

3. Execute o projeto em modo de desenvolvimento:
```bash
pnpm dev
```

4. Acesse no navegador:
```
http://localhost:3000
```

## 🗂️ Estrutura de Dados

Os produtos estão armazenados em `data/produtos.json` com a seguinte estrutura:

```json
[
  {
    "codigo": "001",
    "descricao": "Nome do Produto",
    "valor": 100.00,
    "estoque": 50
  }
]
```

### Campos:
- **codigo**: Código único do produto (string)
- **descricao**: Descrição/nome do produto (string)
- **valor**: Preço normal do produto (number)
- **estoque**: Quantidade disponível em estoque (number)

## 📝 Como Adicionar Seus Produtos

Para adicionar seus próprios produtos, edite o arquivo `data/produtos.json` seguindo o formato acima. O sistema calculará automaticamente:

- ✅ Valor à vista (10% de desconto)
- ✅ Economia gerada
- ✅ Status do estoque
- ✅ Totalizadores

## 🌐 Deploy no Netlify

### Via Interface Web (Recomendado)

1. Acesse [netlify.com](https://www.netlify.com/) e faça login
2. Clique em "Add new site" → "Import an existing project"
3. Conecte seu repositório do GitHub
4. Configure:
   - **Build command**: `pnpm install && pnpm run build`
   - **Publish directory**: `out`
5. Clique em "Deploy site"

### Via Netlify CLI

```bash
# Instale o Netlify CLI
npm install -g netlify-cli

# Faça login
netlify login

# Inicie o deploy
netlify init

# Build e deploy
pnpm run build
netlify deploy --prod
```

## 🛠️ Scripts Disponíveis

```bash
# Desenvolvimento
pnpm dev

# Build para produção
pnpm build

# Iniciar servidor de produção
pnpm start

# Executar linter
pnpm lint
```

## 📱 Responsividade

O site é totalmente responsivo e otimizado para:
- 📱 Mobile (320px+)
- 📱 Tablet (768px+)
- 💻 Desktop (1024px+)
- 🖥️ Large Desktop (1280px+)

## 🎨 Personalização

### Cores

As cores podem ser personalizadas editando o arquivo `app/globals.css`:

```css
:root {
  --primary: 221.2 83.2% 53.3%;
  --secondary: 210 40% 96.1%;
  /* ... outras variáveis */
}
```

### Componentes

Todos os componentes UI estão em `components/ui/` e podem ser customizados conforme necessário.

## 📄 Licença

Este projeto está sob a licença MIT.

## 👨‍💻 Autor

Desenvolvido por [Ronaldo Melo](https://github.com/ronaldomelofz)

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.

---

⭐ Se este projeto foi útil para você, considere dar uma estrela no GitHub!

