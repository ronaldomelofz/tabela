# 📋 Como Adicionar Seus Dados de Produtos

Este guia explica como converter seus dados do arquivo PDF para o formato JSON usado pelo sistema.

## 🎯 Formato Necessário

O arquivo `data/produtos.json` deve conter um array de objetos com a seguinte estrutura:

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
    "valor": 250.50,
    "estoque": 30
  }
]
```

## 📝 Passos para Converter Seus Dados

### Opção 1: Converter PDF para Excel/CSV (Recomendado)

1. **Extrair dados do PDF:**
   - Use um conversor online como [PDF to Excel](https://www.adobe.com/acrobat/online/pdf-to-excel.html)
   - Ou use ferramentas desktop como Adobe Acrobat, PDFelement, etc.

2. **Organizar as colunas:**
   - Certifique-se de ter 4 colunas: Código, Descrição, Valor, Estoque
   - Remova cabeçalhos e rodapés desnecessários

3. **Converter para JSON:**
   - Use um conversor online como [CSV to JSON](https://www.convertcsv.com/csv-to-json.htm)
   - Ou use o script abaixo

### Opção 2: Usar Script Python (Para Muitos Dados)

Crie um arquivo `converter.py`:

```python
import json
import csv

# Ler arquivo CSV
produtos = []
with open('produtos.csv', 'r', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    for row in reader:
        produtos.append({
            'codigo': row['Código'],
            'descricao': row['Descrição'],
            'valor': float(row['Valor'].replace(',', '.')),
            'estoque': int(row['Estoque'])
        })

# Salvar como JSON
with open('data/produtos.json', 'w', encoding='utf-8') as file:
    json.dump(produtos, file, indent=2, ensure_ascii=False)

print(f'✅ {len(produtos)} produtos convertidos com sucesso!')
```

Execute:
```bash
python converter.py
```

### Opção 3: Editar Manualmente (Para Poucos Dados)

1. Abra o arquivo `data/produtos.json`
2. Copie e cole seus produtos seguindo o formato
3. Salve o arquivo

**Exemplo:**

```json
[
  {
    "codigo": "001",
    "descricao": "Notebook Dell Inspiron 15",
    "valor": 3500.00,
    "estoque": 15
  },
  {
    "codigo": "002",
    "descricao": "Mouse Logitech MX Master 3",
    "valor": 450.00,
    "estoque": 45
  }
]
```

## ⚠️ Pontos Importantes

1. **Formato de Valores:**
   - Use ponto (.) para decimais, não vírgula
   - Exemplo correto: `3500.00`
   - Exemplo errado: `3.500,00`

2. **Códigos:**
   - Podem ser strings com letras e números
   - Exemplos válidos: `"001"`, `"A123"`, `"PROD-001"`

3. **Estoque:**
   - Deve ser um número inteiro (sem decimais)
   - Exemplo: `15`, não `15.0`

4. **Validação JSON:**
   - Use um validador como [JSONLint](https://jsonlint.com/) para verificar se o JSON está correto
   - Certifique-se de que todas as vírgulas, chaves e colchetes estão corretos

## 🚀 Testando os Dados

Após adicionar seus dados:

1. Execute o servidor de desenvolvimento:
```bash
pnpm dev
```

2. Acesse http://localhost:3000

3. Verifique se todos os produtos aparecem corretamente

4. Teste a busca por código e descrição

## 🔄 Atualizando Dados Regularmente

Se você precisa atualizar os dados frequentemente:

1. Mantenha uma planilha Excel/Google Sheets atualizada
2. Exporte como CSV quando necessário
3. Use o script Python para converter automaticamente
4. Faça commit e push das alterações no GitHub
5. O Netlify fará o deploy automático das atualizações

## 📞 Precisa de Ajuda?

Se tiver dificuldades para converter seus dados:

1. Verifique se o PDF está legível e os dados estão estruturados
2. Tente diferentes ferramentas de conversão
3. Entre em contato com suporte técnico se necessário

---

💡 **Dica:** Mantenha sempre um backup dos seus dados originais!

