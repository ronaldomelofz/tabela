#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para converter TABELACOMP.xlsx para JSON
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

def converter_tabelacomp():
    """Converte TABELACOMP.xlsx para JSON"""
    
    print("="*70)
    print("🔄 CONVERTENDO TABELACOMP.XLSX")
    print("="*70)
    print()
    
    arquivo = "TABELACOMP.xlsx"
    
    if not os.path.exists(arquivo):
        print(f"❌ Arquivo não encontrado: {arquivo}")
        return False
    
    try:
        # Lê o arquivo
        print(f"📖 Lendo: {arquivo}")
        df = pd.read_excel(arquivo)
        
        print(f"✅ {len(df)} linhas encontradas")
        print()
        
        # Mostra as colunas
        print("📋 Colunas encontradas:")
        for i, col in enumerate(df.columns, 1):
            print(f"   {i}. {col}")
        print()
        
        # Tenta identificar as colunas automaticamente
        colunas_map = {}
        
        for col in df.columns:
            col_lower = str(col).lower().strip()
            
            if 'cod' in col_lower or 'cód' in col_lower:
                colunas_map['codigo'] = col
            elif 'desc' in col_lower:
                colunas_map['descricao'] = col
            elif 'val' in col_lower or 'prec' in col_lower or 'preç' in col_lower:
                colunas_map['valor'] = col
            elif 'est' in col_lower or 'qtd' in col_lower or 'quant' in col_lower:
                colunas_map['estoque'] = col
        
        print("🔍 Mapeamento de colunas:")
        for key, val in colunas_map.items():
            print(f"   {key} → {val}")
        print()
        
        if len(colunas_map) < 4:
            print("⚠️  Não consegui identificar todas as colunas automaticamente.")
            print("📝 Por favor, renomeie as colunas no Excel para:")
            print("   - codigo (ou código)")
            print("   - descricao (ou descrição)")
            print("   - valor (ou preço)")
            print("   - estoque (ou quantidade)")
            return False
        
        # Processa produtos
        produtos = []
        erros = []
        
        print("⏳ Processando produtos...")
        
        for idx, row in df.iterrows():
            try:
                # Extrai dados
                codigo = str(row[colunas_map['codigo']]).strip()
                descricao = str(row[colunas_map['descricao']]).strip()
                valor_str = str(row[colunas_map['valor']]).strip()
                estoque_str = str(row[colunas_map['estoque']]).strip()
                
                # Valida
                if not codigo or codigo == 'nan' or codigo == '':
                    continue
                
                if not descricao or descricao == 'nan' or len(descricao) < 2:
                    continue
                
                # Converte valor
                valor_str = valor_str.replace('R$', '').replace(' ', '').replace(',', '.')
                valor = float(valor_str)
                
                if valor <= 0:
                    continue
                
                # Converte estoque
                estoque_str = estoque_str.replace('.', '').replace(',', '').strip()
                estoque = int(float(estoque_str))
                
                if estoque < 0:
                    continue
                
                # Adiciona produto
                produto = {
                    "codigo": codigo,
                    "descricao": descricao,
                    "valor": round(valor, 2),
                    "estoque": estoque
                }
                
                produtos.append(produto)
                
                if len(produtos) % 100 == 0:
                    print(f"   ✅ {len(produtos)} produtos...")
            
            except Exception as e:
                erros.append(f"Linha {idx+2}: {str(e)}")
                continue
        
        print()
        print(f"✅ {len(produtos)} produtos válidos")
        
        if erros and len(erros) <= 10:
            print()
            print(f"⚠️  {len(erros)} erro(s):")
            for erro in erros:
                print(f"   - {erro}")
        
        if produtos:
            # Salva JSON
            with open('data/produtos.json', 'w', encoding='utf-8') as f:
                json.dump(produtos, f, indent=2, ensure_ascii=False)
            
            print()
            print(f"✅ Salvo em: data/produtos.json")
            print()
            
            # Mostra exemplos
            print("📋 Primeiros 10 produtos:")
            print()
            print(f"{'CÓDIGO':<10} {'DESCRIÇÃO':<45} {'VALOR':>12} {'ESTOQUE':>8}")
            print("-" * 80)
            for p in produtos[:10]:
                print(f"{p['codigo']:<10} {p['descricao'][:45]:<45} R$ {p['valor']:>8.2f} {p['estoque']:>8}")
            
            print()
            print("🎉 Conversão concluída com sucesso!")
            print()
            print("📱 Próximos passos:")
            print("   1. Execute: pnpm dev")
            print("   2. Acesse: http://localhost:3000")
            print("   3. Verifique se os valores estão corretos")
            print("   4. Se estiver OK: git add . && git commit -m 'Atualiza dados' && git push")
            
            return True
        else:
            print()
            print("❌ Nenhum produto válido encontrado")
            return False
    
    except Exception as e:
        print(f"❌ Erro: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    converter_tabelacomp()

