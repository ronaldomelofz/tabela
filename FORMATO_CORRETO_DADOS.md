# 📊 FORMATO CORRETO PARA SEUS DADOS

## ✅ RECOMENDAÇÃO: USE EXCEL OU CSV

O PDF tem problemas de formatação. **Excel é muito melhor!**

---

## 📝 FORMATO DO ARQUIVO EXCEL

### Crie um arquivo chamado: `produtos.xlsx`

Com as seguintes colunas:

| codigo | descricao                  | valor  | estoque |
|--------|----------------------------|--------|---------|
| 001622 | ESQUADRO CABO METAL 12"    | 8.60   | 122     |
| 001950 | CHAVE FUNCIONAL CROMADO    | 550.02 | 132     |
| 002428 | ELETRODO 2.5MM             | 2.50   | 6013    |
| 002544 | PUXADOR ALCA 128MM         | 1.00   | 344     |

---

## ⚠️ REGRAS IMPORTANTES:

### 1. **Coluna CODIGO:**
- ✅ Correto: `001622`, `001950`, `A123`
- ❌ Errado: Vazio, espaços

### 2. **Coluna DESCRICAO:**
- ✅ Correto: `ESQUADRO CABO METAL 12"`
- ❌ Errado: Vazio, apenas números

### 3. **Coluna VALOR:** ⚠️ MUITO IMPORTANTE!
- ✅ **Correto: Use PONTO para decimal**
  - `8.60` (oito reais e sessenta centavos)
  - `550.02` (quinhentos e cinquenta reais e dois centavos)
  - `2.50` (dois reais e cinquenta centavos)
  - `1234.56` (mil duzentos e trinta e quatro reais)

- ❌ **Errado: NÃO use vírgula ou formatação**
  - `8,60` ❌
  - `R$ 8.60` ❌
  - `8.600,00` ❌
  - `8` (sem centavos funciona, mas coloque .00)

### 4. **Coluna ESTOQUE:**
- ✅ Correto: `122`, `6013`, `0`
- ❌ Errado: `122.5`, negativos

---

## 🔧 COMO CONFIGURAR NO EXCEL

### Opção 1: Excel Desktop

1. Abra Excel
2. Crie uma nova planilha
3. Na primeira linha, digite os cabeçalhos:
   ```
   A1: codigo
   B1: descricao
   C1: valor
   D1: estoque
   ```

4. **Configure a coluna VALOR:**
   - Selecione toda coluna C
   - Clique com botão direito → Formatar Células
   - Escolha: **Número**
   - Casas decimais: **2**
   - Separador de milhar: **Nenhum**
   - ✅ Use **ponto** como separador decimal

5. Preencha os dados
6. Salve como: `produtos.xlsx`

### Opção 2: Google Sheets

1. Crie uma planilha no Google Sheets
2. Configure:
   - Arquivo → Configurações de planilha
   - Localidade: **Estados Unidos** (usa ponto)
3. Preencha os dados
4. Baixe como: Arquivo → Fazer download → Excel (.xlsx)

### Opção 3: CSV (Texto simples)

Crie um arquivo `produtos.csv` com este formato:

```csv
codigo,descricao,valor,estoque
001622,ESQUADRO CABO METAL 12",8.60,122
001950,CHAVE FUNCIONAL CROMADO,550.02,132
002428,ELETRODO 2.5MM,2.50,6013
```

---

## 🚀 COMO USAR

### 1. Coloque o arquivo na pasta do projeto:

```
E:\PROJETOS-CURSOR\TABELAPRECOESTOQUE\
  └── produtos.xlsx  ← Aqui!
```

### 2. Execute o conversor:

```bash
python scripts/converter-excel-para-json.py
```

### 3. Teste o site:

```bash
pnpm dev
```

---

## 📋 EXEMPLO COMPLETO EM EXCEL

| codigo | descricao                           | valor   | estoque |
|--------|-------------------------------------|---------|---------|
| 000007 | SUPORTE L METAL P/FIXACAO RIGIDO    | 8.60    | 122     |
| 000008 | CAPA P/SUPORTE L FIXA BRANCO        | 26.45   | 39      |
| 001622 | ESQUADRO CABO METAL 12" AMATOOLS    | 8.60    | 122     |
| 001949 | FECHADURA METALICA                  | 541.25  | 278     |
| 001950 | CHAVE FUNCIONAL CROMADO             | 550.02  | 132     |
| 002428 | ELETRODO 2.5MM                      | 2.50    | 6013    |

---

## ❓ PERGUNTAS FREQUENTES

### P: Posso usar vírgula no valor?
**R:** NÃO! O sistema só aceita ponto. 
- ✅ `8.60` 
- ❌ `8,60`

### P: Preciso colocar R$ ou moeda?
**R:** NÃO! Apenas o número.
- ✅ `550.02`
- ❌ `R$ 550,02`

### P: E se meu valor for inteiro, como 100 reais?
**R:** Coloque `100.00` ou só `100` (o sistema adiciona .00)

### P: Posso usar ponto de milhar?
**R:** NÃO no Excel! Use só o ponto decimal.
- ✅ `1234.56` (mil duzentos e trinta e quatro)
- ❌ `1.234,56`

### P: Meu Excel está em português, como mudo?
**R:** Opções:
1. Use Google Sheets (mude localidade para EUA)
2. Salve como CSV e edite no Bloco de Notas
3. Configure Excel: Arquivo → Opções → Avançado → Use vírgula como separador = DESMARCAR

---

## 🎯 CONVERSÃO DO SEU PDF ATUAL

Se você tem os dados no PDF e quer passar para Excel:

### Opção 1: Copiar e Colar
1. Abra o PDF
2. Selecione a tabela
3. Copie (Ctrl+C)
4. Cole no Excel (Ctrl+V)
5. Ajuste as colunas
6. **IMPORTANTE:** Verifique a coluna de valores e ajuste para usar ponto!

### Opção 2: Converter PDF para Excel Online
- https://www.adobe.com/br/acrobat/online/pdf-to-excel.html
- https://www.ilovepdf.com/pt/pdf_para_excel
- Depois ajuste os valores para usar ponto

---

## ✅ CHECKLIST ANTES DE CONVERTER

- [ ] Arquivo salvo como `produtos.xlsx` na pasta do projeto
- [ ] Primeira linha tem: codigo, descricao, valor, estoque
- [ ] Coluna valor usa PONTO (não vírgula)
- [ ] Sem R$ ou formatação de moeda
- [ ] Todos os produtos têm código e descrição
- [ ] Valores maiores que zero
- [ ] Estoque é número inteiro

---

## 🆘 PRECISA DE AJUDA?

Se continuar com problemas:

1. Envie seu arquivo Excel para verificação
2. Ou envie uma planilha do Google Sheets (compartilhe o link)
3. Ou liste alguns produtos aqui no formato:
   ```
   001622 | ESQUADRO | 8.60 | 122
   001950 | CHAVE | 550.02 | 132
   ```

---

**Excel é 100x mais confiável que PDF!** 📊✅

