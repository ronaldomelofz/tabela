# 📱 Configuração do WhatsApp

## Como configurar o número do WhatsApp para envio de pedidos

### Opção 1: Variável de Ambiente (Recomendado)

1. Crie um arquivo `.env.local` na raiz do projeto:

```env
NEXT_PUBLIC_WHATSAPP_NUMBER=5511999999999
```

2. Substitua `5511999999999` pelo seu número no formato:
   - Código do país (Brasil: 55)
   - DDD (sem parênteses)
   - Número (sem espaços ou hífens)

**Exemplo:**
- Número: (11) 98765-4321
- Formato correto: `5511987654321`

### Opção 2: Editar Diretamente no Código

Edite o arquivo `components/cart.tsx` e altere a linha:

```typescript
const numeroWhatsApp = process.env.NEXT_PUBLIC_WHATSAPP_NUMBER || "5511999999999";
```

Substitua `"5511999999999"` pelo seu número.

### Formato do Número

- ✅ Correto: `5511987654321`
- ❌ Errado: `+55 11 98765-4321`
- ❌ Errado: `(11) 98765-4321`
- ❌ Errado: `11 98765-4321`

### Teste

Após configurar, adicione produtos ao carrinho e clique em "Enviar para WhatsApp". 
O WhatsApp Web será aberto com a mensagem formatada do pedido.
