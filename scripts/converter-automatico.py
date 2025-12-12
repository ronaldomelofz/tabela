#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Conversor automático robusto - tenta múltiplas estratégias
"""

import json
import sys
import os
import subprocess

def instalar_dependencias():
    """Instala todas as bibliotecas necessárias"""
    bibliotecas = ['pandas', 'openpyxl', 'xlrd', 'pyxlsb']
    for lib in bibliotecas:
        try:
            __import__(lib)
        except:
            print(f"📦 Instalando {lib}...")
            subprocess.check_call([sys.executable, "-m", "pip", "install", lib], 
                                stdout=subprocess.DEVNULL, 
                                stderr=subprocess.DEVNULL)

instalar_dependencias()

import pandas as pd

def tentar_ler_excel(arquivo):
    """Tenta ler Excel com múltiplas estratégias"""
    
    print(f"📖 Tentando ler: {arquivo}")
    print()
    
    # Estratégia 1: openpyxl com data_only
    try:
        print("   Tentativa 1: openpyxl padrão...")
        df = pd.read_excel(arquivo, engine='openpyxl')
        print("   ✅ Sucesso com openpyxl!")
        return df
    except Exception as e:
        print(f"   ❌ Falhou: {str(e)[:50]}...")
    
    # Estratégia 2: openpyxl com data_only=True
    try:
        print("   Tentativa 2: openpyxl data_only...")
        df = pd.read_excel(arquivo, engine='openpyxl', data_only=True)
        print("   ✅ Sucesso com data_only!")
        return df
    except Exception as e:
        print(f"   ❌ Falhou: {str(e)[:50]}...")
    
    # Estratégia 3: xlrd (para arquivos .xls antigos)
    try:
        print("   Tentativa 3: xlrd...")
        df = pd.read_excel(arquivo, engine='xlrd')
        print("   ✅ Sucesso com xlrd!")
        return df
    except Exception as e:
        print(f"   ❌ Falhou: {str(e)[:50]}...")
    
    # Estratégia 4: Converter para CSV primeiro usando Excel
    try:
        print("   Tentativa 4: Usando win32com (Excel COM)...")
        import win32com.client
        
        excel = win32com.client.Dispatch("Excel.Application")
        excel.Visible = False
        
        caminho_completo = os.path.abspath(arquivo)
        wb = excel.Workbooks.Open(caminho_completo)
        ws = wb.Worksheets(1)
        
        # Salva como CSV
        csv_temp = "temp_produtos.csv"
        wb.SaveAs(os.path.abspath(csv_temp), FileFormat=6)  # 6 = CSV
        wb.Close(False)
        excel.Quit()
        
        df = pd.read_csv(csv_temp, encoding='utf-8-sig')
        os.remove(csv_temp)
        
        print("   ✅ Sucesso com Excel COM!")
        return df
    except Exception as e:
        print(f"   ❌ Falhou: {str(e)[:50]}...")
    
    print()
    print("❌ Não foi possível ler o arquivo com nenhum método")
    return None

def processar_dataframe(df):
    """Processa o DataFrame e converte para produtos"""
    
    # Identifica colunas
    print("📋 Analisando colunas...")
    print(f"   Colunas encontradas: {list(df.columns)}")
    print()
    
    # Mapeia colunas automaticamente
    mapa = {}
    for col in df.columns:
        col_lower = str(col).lower().strip()
        
        if 'cod' in col_lower or 'cód' in col_lower:
            mapa['codigo'] = col
        elif 'desc' in col_lower:
            mapa['descricao'] = col
        elif 'val' in col_lower or 'prec' in col_lower or 'preç' in col_lower:
            mapa['valor'] = col
        elif 'est' in col_lower or 'qtd' in col_lower or 'quant' in col_lower:
            mapa['estoque'] = col
    
    print("🔍 Mapeamento:")
    for key, val in mapa.items():
        print(f"   {key:12} → {val}")
    print()
    
    if len(mapa) < 4:
        print("⚠️  Tentando usar as 4 primeiras colunas...")
        colunas = list(df.columns[:4])
        mapa = {
            'codigo': colunas[0],
            'descricao': colunas[1],
            'valor': colunas[2],
            'estoque': colunas[3]
        }
        print("   Assumindo ordem: codigo, descricao, valor, estoque")
        print()
    
    # Processa produtos
    produtos = []
    print("⏳ Processando produtos...")
    
    for idx, row in df.iterrows():
        try:
            codigo = str(row[mapa['codigo']]).strip()
            if not codigo or codigo == 'nan' or codigo == '' or codigo == 'None':
                continue
            
            descricao = str(row[mapa['descricao']]).strip()
            if not descricao or descricao == 'nan' or len(descricao) < 2:
                continue
            
            # Processa valor - aceita vírgula ou ponto
            valor_str = str(row[mapa['valor']]).strip()
            valor_str = valor_str.replace('R$', '').replace(' ', '')
            
            # Se tem vírgula, assume formato brasileiro e converte
            if ',' in valor_str and '.' in valor_str:
                # Formato: 1.234,56 -> remove ponto, troca vírgula por ponto
                valor_str = valor_str.replace('.', '').replace(',', '.')
            elif ',' in valor_str:
                # Formato: 1234,56 -> troca vírgula por ponto
                valor_str = valor_str.replace(',', '.')
            
            valor = float(valor_str)
            if valor <= 0:
                continue
            
            # Processa estoque
            estoque_str = str(row[mapa['estoque']]).strip()
            estoque_str = estoque_str.replace('.', '').replace(',', '').strip()
            estoque = int(float(estoque_str))
            
            if estoque < 0:
                continue
            
            produto = {
                "codigo": codigo,
                "descricao": descricao,
                "valor": round(valor, 2),
                "estoque": estoque
            }
            
            produtos.append(produto)
            
            if len(produtos) % 200 == 0:
                print(f"   ✅ {len(produtos)} produtos processados...")
        
        except Exception as e:
            continue
    
    return produtos

def main():
    print("="*70)
    print("🤖 CONVERSOR AUTOMÁTICO INTELIGENTE")
    print("="*70)
    print()
    
    # Procura arquivo
    arquivos = ['TABELACOMP.xlsx', 'TABELACOMP.xls', 'tabelacomp.xlsx', 
                'produtos.xlsx', 'tabela.xlsx']
    
    arquivo_encontrado = None
    for arq in arquivos:
        if os.path.exists(arq):
            arquivo_encontrado = arq
            break
    
    if not arquivo_encontrado:
        print("❌ Nenhum arquivo encontrado!")
        print("   Arquivos procurados:", ', '.join(arquivos))
        return False
    
    print(f"✅ Arquivo encontrado: {arquivo_encontrado}")
    print()
    
    # Tenta ler
    df = tentar_ler_excel(arquivo_encontrado)
    
    if df is None:
        print()
        print("❌ Não foi possível ler o arquivo automaticamente")
        print()
        print("📝 SOLUÇÃO MANUAL:")
        print("   1. Abra o arquivo no Excel")
        print("   2. Salve Como → produtos.xlsx (novo arquivo)")
        print("   3. Execute este script novamente")
        return False
    
    print()
    print(f"✅ Arquivo lido: {len(df)} linhas")
    print()
    
    # Processa
    produtos = processar_dataframe(df)
    
    if not produtos:
        print()
        print("❌ Nenhum produto válido encontrado")
        return False
    
    print()
    print(f"✅ {len(produtos)} produtos processados")
    print()
    
    # Salva
    with open('data/produtos.json', 'w', encoding='utf-8') as f:
        json.dump(produtos, f, indent=2, ensure_ascii=False)
    
    print("✅ Salvo em: data/produtos.json")
    print()
    
    # Mostra exemplos
    print("📋 Primeiros 10 produtos:")
    print()
    print(f"{'CÓDIGO':<10} {'DESCRIÇÃO':<45} {'VALOR':>12} {'ESTOQUE':>8}")
    print("-" * 80)
    for p in produtos[:10]:
        print(f"{p['codigo']:<10} {p['descricao'][:45]:<45} R$ {p['valor']:>8.2f} {p['estoque']:>8}")
    
    if len(produtos) > 10:
        print(f"... e mais {len(produtos)-10} produtos")
    
    print()
    print("🎉 CONVERSÃO CONCLUÍDA COM SUCESSO!")
    print()
    print("📱 Testando build...")
    
    return True

if __name__ == "__main__":
    sucesso = main()
    sys.exit(0 if sucesso else 1)

