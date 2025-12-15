# 🔄 Sistema de Integração iShop/Shop

Sistema automatizado para sincronização de dados entre iShop e Shop.

---

## 📋 Visão Geral

O sistema monitora e processa automaticamente os arquivos de integração localizados em `Y:\`:

- **Pasta IN (`Y:\IN`)**: Arquivos do iShop → Shop (produtos e preços)
- **Pasta OUT (`Y:\OUT`)**: Arquivos do Shop → iShop (estoque e movimentações)

Os arquivos são organizados por data (formato `YY-MM-DD`) e o sistema sempre processa a pasta mais recente.

---

## 🚀 Como Usar

### Opção 1: Atualização Manual (Recomendado para início)

Execute o arquivo BAT para atualizar manualmente:

```batch
scripts\atualizar-sistema.bat
```

Ou execute o script Python diretamente:

```bash
python scripts\integrador-ishop.py
```

### Opção 2: Monitoramento Contínuo

Para monitorar continuamente e atualizar automaticamente quando houver mudanças:

```bash
python scripts\monitorar-ishop.py
```

Com intervalo personalizado (ex: 15 minutos):

```bash
python scripts\monitorar-ishop.py -i 15
```

### Opção 3: Agendamento Automático (Windows)

Configure uma tarefa agendada no Windows para executar automaticamente:

```batch
scripts\agendar-atualizacao.bat
```

Opções disponíveis:
- Executar a cada 1 hora
- Executar a cada 30 minutos
- Executar a cada 3 horas
- Remover agendamento
- Ver status do agendamento

---

## 📁 Estrutura de Arquivos

### Arquivos de Entrada (Y:\)

```
Y:\
├── IN\                    ← Dados do iShop (produtos e preços)
│   ├── 25-12-13\
│   │   ├── VK400219K0_61507.shp
│   │   ├── VK400219K1_61507.shp
│   │   └── ...
│   └── 25-12-12\
│       └── ...
│
└── OUT\                   ← Dados do Shop (estoque)
    ├── 25-12-13\
    │   └── N5E002G69_61507.shp
    └── 25-12-12\
        └── ...
```

### Arquivos Gerados

```
data\
├── produtos.json                      ← Arquivo principal (usado pelo site)
├── produtos_completo.csv              ← Dados em CSV para análise
└── produtos_backup_YYYYMMDD_HHMMSS.json  ← Backups automáticos

relatorio_integracao_YYYYMMDD_HHMMSS.txt  ← Relatórios de cada integração
```

---

## 🔍 O Que o Sistema Faz

### 1. Processamento da Pasta IN

- Identifica a pasta com data mais recente em `Y:\IN`
- Extrai todos os arquivos `.shp` (que são ZIPs)
- Processa os XMLs contendo dados de produtos e preços
- Consolida informações de múltiplos arquivos

**Dados extraídos:**
- Código/ID do produto
- Nome e descrição
- Preços (venda, custo, etc.)
- Categorias e classificações
- Dados cadastrais completos

### 2. Processamento da Pasta OUT

- Identifica a pasta com data mais recente em `Y:\OUT`
- Extrai arquivos `.shp` de estoque
- Processa XMLs de movimentação e saldo de estoque
- Mantém apenas os registros mais recentes de cada produto

**Dados extraídos:**
- Quantidade em estoque
- Data da última atualização
- Movimentações recentes
- Alertas de estoque

### 3. Mesclagem de Dados

- Combina informações de produtos (IN) com estoque (OUT)
- Cria registro completo de cada produto
- Identifica produtos sem estoque
- Calcula estatísticas consolidadas

### 4. Salvamento

- Atualiza `data/produtos.json` (usado pelo site)
- Cria backup com timestamp
- Gera CSV para análise
- Produz relatório de integração

---

## 📊 Exemplo de Dados Gerados

### produtos.json

```json
[
  {
    "IdDetalhe": "P0000WGO4B",
    "Descricao": "Nome do Produto",
    "PrecoVenda": "150.00",
    "PrecoCusto": "100.00",
    "Categoria": "Categoria A",
    "estoque": 149028,
    "data_estoque": "20251213"
  },
  ...
]
```

---

## 📈 Relatórios de Integração

Cada execução gera um relatório contendo:

```
======================================================================
RELATÓRIO DE INTEGRAÇÃO iShop/Shop
======================================================================
Data/Hora: 13/12/2025 14:30:00
Total de Produtos: 1.250
Produtos com Estoque: 1.100
Produtos sem Estoque: 150
Estoque Total: 2.547.892,00 unidades
```

---

## ⚙️ Configurações

### Alterar Caminho Base

Edite o arquivo `scripts/integrador-ishop.py`:

```python
integrador = IntegradorIShop(base_path="Y:\\")  # Alterar aqui
```

### Alterar Intervalo de Monitoramento

```bash
# Verificar a cada 15 minutos
python scripts\monitorar-ishop.py -i 15

# Verificar a cada 5 minutos
python scripts\monitorar-ishop.py -i 5
```

---

## 🔧 Solução de Problemas

### Erro: "Nenhuma pasta encontrada em IN/OUT"

**Causa:** Pasta Y:\ não está acessível ou não contém subpastas IN/OUT

**Solução:**
- Verifique se a unidade Y:\ está mapeada corretamente
- Confirme que as pastas IN e OUT existem
- Verifique permissões de acesso

### Erro: "Arquivo não é um ZIP válido"

**Causa:** Arquivo .shp corrompido ou formato diferente

**Solução:**
- Verifique a integridade do arquivo
- Tente processar novamente após nova exportação do iShop

### Produtos sem Estoque

**Causa:** Produto existe no iShop mas não tem movimentação no Shop

**Solução:**
- Normal para produtos novos ou inativos
- Verifique o relatório para identificar quais produtos

---

## 📝 Logs e Monitoramento

### Visualizar Logs em Tempo Real

Ao executar o monitoramento, você verá:

```
[2025-12-13 14:30:00] ℹ️ PROCESSANDO PASTA IN (iShop → Shop)
[2025-12-13 14:30:05] ℹ️ Encontrados 24 arquivos para processar
[2025-12-13 14:30:10] ✅ Total de produtos únicos: 1250
[2025-12-13 14:30:15] ℹ️ PROCESSANDO PASTA OUT (Shop → iShop)
[2025-12-13 14:30:18] ✅ Total de itens em estoque: 1100
[2025-12-13 14:30:20] ✅ INTEGRAÇÃO CONCLUÍDA COM SUCESSO!
```

---

## 🎯 Fluxo de Trabalho Recomendado

### Configuração Inicial

1. Execute manualmente pela primeira vez:
   ```batch
   scripts\atualizar-sistema.bat
   ```

2. Verifique se os dados foram gerados corretamente:
   - Confira `data/produtos.json`
   - Revise o relatório de integração

3. Configure o agendamento automático:
   ```batch
   scripts\agendar-atualizacao.bat
   ```
   - Recomendação: executar a cada 1 hora

### Uso Diário

- O sistema executará automaticamente
- Verifique os relatórios periodicamente
- Monitore produtos sem estoque
- Revise backups em caso de problemas

---

## 📦 Dependências

### Python

Bibliotecas necessárias (já incluídas no Python padrão):
- `zipfile` - Para extrair arquivos .shp
- `xml.etree.ElementTree` - Para processar XMLs
- `json` - Para gerar arquivos JSON
- `csv` - Para gerar CSVs
- `datetime` - Para manipulação de datas
- `pathlib` - Para manipulação de caminhos
- `glob` - Para buscar arquivos

**Nenhuma instalação adicional necessária!** ✅

---

## 🔐 Segurança

### Backups Automáticos

O sistema cria backups automáticos com timestamp antes de cada atualização:
- `data/produtos_backup_YYYYMMDD_HHMMSS.json`

### Recuperação de Dados

Para restaurar um backup anterior:

```bash
# Renomear backup para arquivo principal
copy data\produtos_backup_20251213_143000.json data\produtos.json
```

---

## 📞 Suporte

### Arquivos de Ajuda

- `RELATORIO_ANALISE_SHAPEFILE.md` - Análise detalhada do formato dos arquivos
- `INTEGRACAO_ISHOP.md` - Este arquivo
- Relatórios de integração em `relatorio_integracao_*.txt`

### Scripts Disponíveis

| Script | Descrição |
|--------|-----------|
| `integrador-ishop.py` | Script principal de integração |
| `atualizar-sistema.bat` | Atalho para atualização manual |
| `monitorar-ishop.py` | Monitoramento contínuo |
| `agendar-atualizacao.bat` | Configurar agendamento Windows |
| `converter-xml-estoque.py` | Conversão específica de estoque |

---

## ✅ Checklist de Verificação

Após cada integração, verifique:

- [ ] Arquivo `data/produtos.json` foi atualizado
- [ ] Backup foi criado com timestamp atual
- [ ] Relatório de integração foi gerado
- [ ] Número de produtos está correto
- [ ] Dados de estoque estão atualizados
- [ ] Sem erros nos logs

---

## 🚀 Próximos Passos

### Melhorias Futuras

1. **Interface Web** - Dashboard para visualizar integrações
2. **Alertas** - Notificações por email em caso de erro
3. **Validações** - Verificar consistência dos dados
4. **Histórico** - Manter histórico de mudanças de preço
5. **API** - Endpoint REST para consultar dados

---

**Última Atualização:** 13/12/2025  
**Versão:** 1.0  
**Status:** ✅ Pronto para produção



