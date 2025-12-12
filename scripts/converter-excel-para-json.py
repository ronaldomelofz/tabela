#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para converter Excel para JSON - FORMATO CORRETO
"""

import json
import sys
import os

try:
    import pandas as pd
except ImportError:
    print("📦 Instalando pandas e openpyxl...")
    import subprocess
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pandas", "openpyxl"])
    import pandas as pd

def converter_excel_para_json(arquivo_excel, arquivo_json):
    """
    Converte Excel para JSON com validação
    
    FORMATO ESPERADO NO EXCEL:
    Coluna A: codigo (ex: 001622, 001950, etc)
    Coluna B: descricao (ex: ESQUADRO CABO METAL 12")
    Coluna C: valor (ex: 8.60, 12.50, 541.25) - USAR PONTO para decimal
    Coluna D: estoque (ex: 122, 85, 278)
    """
    
    print("="*70)
    print("🔄 CONVERSOR EXCEL PARA JSON")
    print("="*70)
    print()
    
    # Verifica se arquivo existe
    if not os.path.exists(arquivo_excel):
        print(f"❌ Arquivo não encontrado: {arquivo_excel}")
        print()
        print("📋 FORMATOS ACEITOS:")
        print("   - produtos.xlsx")
        print("   - produtos.xls")
        print("   - produtos.csv")
        print()
        print("📝 FORMATO DO ARQUIVO:")
        print()
        print("   | codigo | descricao              | valor  | estoque |")
        print("   |--------|------------------------|--------|---------|")
        print("   | 001622 | ESQUADRO CABO METAL    | 8.60   | 122     |")
        print("   | 001950 | CHAVE FUNCIONAL        | 550.02 | 132     |")
        print("   | 002428 | ELETRODO 2.5MM         | 2.50   | 6013    |")
        print()
        print("⚠️  IMPORTANTE:")
        print("   - Use PONTO (.) para separar decimais, não vírgula!")
        print("   - Correto: 8.60")
        print("   - Errado: 8,60")
        return False
    
    try:
        # Lê o arquivo Excel
        print(f"📖 Lendo arquivo: {arquivo_excel}")
        
        if arquivo_excel.endswith('.csv'):
            df = pd.read_csv(arquivo_excel)
        else:
            df = pd.read_excel(arquivo_excel)
        
        print(f"✅ {len(df)} linhas encontradas")
        print()
        
        # Verifica colunas obrigatórias
        colunas_necessarias = ['codigo', 'descricao', 'valor', 'estoque']
        colunas_faltando = [col for col in colunas_necessarias if col not in df.columns]
        
        if colunas_faltando:
            print("❌ Colunas faltando no arquivo:")
            for col in colunas_faltando:
                print(f"   - {col}")
            print()
            print("📝 Seu arquivo deve ter estas colunas:")
            print("   | codigo | descricao | valor | estoque |")
            return False
        
        # Processa dados
        produtos = []
        erros = []
        
        print("⏳ Processando produtos...")
        print()
        
        for idx, row in df.iterrows():
            try:
                # Valida código
                codigo = str(row['codigo']).strip()
                if not codigo or codigo == 'nan':
                    continue
                
                # Valida descrição
                descricao = str(row['descricao']).strip()
                if not descricao or descricao == 'nan' or len(descricao) < 2:
                    erros.append(f"Linha {idx+2}: Descrição inválida")
                    continue
                
                # Valida e converte valor
                valor = float(str(row['valor']).replace(',', '.').strip())
                if valor <= 0:
                    erros.append(f"Linha {idx+2}: Valor deve ser maior que zero")
                    continue
                
                # Valida e converte estoque
                estoque = int(float(str(row['estoque']).replace(',', '').strip()))
                if estoque < 0:
                    erros.append(f"Linha {idx+2}: Estoque não pode ser negativo")
                    continue
                
                # Adiciona produto
                produto = {
                    "codigo": codigo,
                    "descricao": descricao,
                    "valor": round(valor, 2),
                    "estoque": estoque
                }
                
                produtos.append(produto)
                
                # Mostra progresso a cada 100 produtos
                if len(produtos) % 100 == 0:
                    print(f"   ✅ {len(produtos)} produtos processados...")
            
            except Exception as e:
                erros.append(f"Linha {idx+2}: {str(e)}")
                continue
        
        print()
        print(f"✅ {len(produtos)} produtos válidos")
        
        # Mostra erros se houver
        if erros:
            print()
            print(f"⚠️  {len(erros)} erro(s) encontrado(s):")
            for erro in erros[:10]:  # Mostra só os 10 primeiros
                print(f"   - {erro}")
            if len(erros) > 10:
                print(f"   ... e mais {len(erros)-10} erro(s)")
        
        # Salva JSON
        if produtos:
            with open(arquivo_json, 'w', encoding='utf-8') as f:
                json.dump(produtos, f, indent=2, ensure_ascii=False)
            
            print()
            print(f"✅ Arquivo salvo: {arquivo_json}")
            print()
            
            # Mostra exemplos
            print("📋 Primeiros produtos:")
            for p in produtos[:5]:
                print(f"   {p['codigo']:<8} {p['descricao'][:40]:<42} R$ {p['valor']:>8.2f}  Est: {p['estoque']:>5}")
            
            print()
            print("🎉 Conversão concluída com sucesso!")
            print()
            print("📱 Próximos passos:")
            print("   1. Verifique os dados em: data/produtos.json")
            print("   2. Execute: pnpm dev")
            print("   3. Acesse: http://localhost:3000")
            print("   4. Teste a busca e os valores")
            
            return True
        else:
            print()
            print("❌ Nenhum produto válido encontrado")
            return False
    
    except Exception as e:
        print(f"❌ Erro ao processar arquivo: {str(e)}")
        return False

def main():
    # Procura arquivo Excel
    arquivos_possiveis = [
        'produtos.xlsx',
        'produtos.xls', 
        'produtos.csv',
        'tabela.xlsx',
        'tabela.xls',
        'tabela.csv',
        'PRODUTOS.xlsx',
        'TABELA.xlsx'
    ]
    
    arquivo_encontrado = None
    for arquivo in arquivos_possiveis:
        if os.path.exists(arquivo):
            arquivo_encontrado = arquivo
            break
    
    if arquivo_encontrado:
        converter_excel_para_json(arquivo_encontrado, 'data/produtos.json')
    else:
        print("❌ Nenhum arquivo Excel encontrado!")
        print()
        print("📝 Crie um arquivo chamado: produtos.xlsx")
        print()
        print("📋 COM AS SEGUINTES COLUNAS:")
        print()
        print("┌─────────┬──────────────────────────┬─────────┬─────────┐")
        print("│ codigo  │ descricao                │ valor   │ estoque │")
        print("├─────────┼──────────────────────────┼─────────┼─────────┤")
        print("│ 001622  │ ESQUADRO CABO METAL 12\"  │ 8.60    │ 122     │")
        print("│ 001950  │ CHAVE FUNCIONAL CROMADO  │ 550.02  │ 132     │")
        print("│ 002428  │ ELETRODO 2.5MM           │ 2.50    │ 6013    │")
        print("└─────────┴──────────────────────────┴─────────┴─────────┘")
        print()
        print("⚠️  IMPORTANTE:")
        print("   - Primeira linha deve ter os nomes das colunas")
        print("   - Use PONTO (.) para decimais no valor")
        print("   - Não use formatação de moeda (R$, vírgula de milhares)")

if __name__ == "__main__":
    main()

