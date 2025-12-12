# 🔧 Como Converter TABELACOMP.xlsx

## ❌ Problema Encontrado:

O arquivo `TABELACOMP.xlsx` tem propriedades incompatíveis com as bibliotecas Python.

**Erro:** `WindowWidth` - Propriedade antiga do Excel não suportada.

---

## ✅ SOLUÇÕES (escolha uma):

### SOLUÇÃO 1: Salvar como Novo Excel (MAIS FÁCIL)

1. **Abra o arquivo `TABELACOMP.xlsx` no Excel**

2. **Clique em:** Arquivo → Salvar Como

3. **Escolha o nome:** `produtos.xlsx`

4. **Formato:** Pasta de Trabalho do Excel (*.xlsx)

5. **Salve na mesma pasta**

6. **Execute:**
   ```bash
   python scripts/converter-excel-para-json.py
   ```

---

### SOLUÇÃO 2: Salvar como CSV (RECOMENDADO)

1. **Abra `TABELACOMP.xlsx` no Excel**

2. **Arquivo → Salvar Como**

3. **Nome:** `produtos.csv`

4. **Formato:** CSV (Separado por vírgulas) (*.csv)

5. **Salve**

6. **Execute:**
   ```bash
   python scripts/converter-excel-para-json.py
   ```

---

### SOLUÇÃO 3: Copiar Dados Manualmente

Se as soluções acima não funcionarem:

1. **Abra `TABELACOMP.xlsx`**

2. **Selecione TODAS as células com dados** (Ctrl+A)

3. **Copie** (Ctrl+C)

4. **Abra um NOVO Excel em branco**

5. **Cole** (Ctrl+V)

6. **Certifique-se que as colunas são:**
   - Coluna A: `codigo`
   - Coluna B: `descricao`
   - Coluna C: `valor` (com PONTO para decimal)
   - Coluna D: `estoque`

7. **Salve como:** `produtos.xlsx`

8. **Execute:**
   ```bash
   python scripts/converter-excel-para-json.py
   ```

---

## ⚠️ IMPORTANTE - COLUNA VALOR:

Certifique-se que a coluna de valor usa **PONTO** e não vírgula:

✅ **CORRETO:**
```
8.60
49.00
550.02
1234.56
```

❌ **ERRADO:**
```
8,60
49,00
550,02
1.234,56
```

---

## 🔄 ALTERNATIVA: Me Envie uma Amostra

Se tiver dificuldade, copie 20 linhas do seu Excel e cole aqui no formato:

```
001622 | ESQUADRO CABO METAL | 8.60 | 122
001950 | CHAVE FUNCIONAL | 550.02 | 132
002428 | ELETRODO | 2.50 | 6013
```

Eu crio o arquivo correto para você!

---

## 📝 CHECKLIST:

- [ ] Arquivo salvo como `produtos.xlsx` ou `produtos.csv`
- [ ] Primeira linha tem: codigo, descricao, valor, estoque
- [ ] Coluna valor usa PONTO (não vírgula)
- [ ] Arquivo está na pasta do projeto
- [ ] Executei o conversor
- [ ] Testei com `pnpm dev`

---

**Escolha a SOLUÇÃO 1 ou 2 que vai funcionar perfeitamente!** ✅

