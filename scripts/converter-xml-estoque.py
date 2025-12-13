#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para converter o arquivo XML de estoque em formatos utilizáveis
"""

import xml.etree.ElementTree as ET
import csv
import json
from datetime import datetime
from collections import defaultdict

def converter_data(data_str):
    """Converte data do formato YYYYMMDD para DD/MM/YYYY"""
    try:
        dt = datetime.strptime(data_str, "%Y%m%d")
        return dt.strftime("%d/%m/%Y")
    except:
        return data_str

def analisar_xml_estoque(xml_path):
    """Analisa e converte o XML de estoque"""
    
    print("\n" + "="*70)
    print("📦 CONVERSÃO DE DADOS DE ESTOQUE")
    print("="*70)
    
    try:
        # Ler e parsear o XML
        tree = ET.parse(xml_path)
        root = tree.getroot()
        
        # Encontrar todos os registros
        rows = root.findall('.//ROW')
        
        print(f"\n✓ Arquivo XML lido com sucesso!")
        print(f"  Total de registros: {len(rows)}")
        
        # Extrair dados
        registros = []
        produtos_unicos = set()
        datas_unicas = set()
        
        for row in rows:
            registro = {
                'Data': converter_data(row.get('DtReferencia', '')),
                'DataOriginal': row.get('DtReferencia', ''),
                'Quantidade': row.get('QtEstoque', '0'),
                'IdProduto': row.get('IdDetalhe', ''),
                'CodEmpresa': row.get('CdEmpresa', '')
            }
            registros.append(registro)
            produtos_unicos.add(registro['IdProduto'])
            datas_unicas.add(registro['DataOriginal'])
        
        # Estatísticas
        print(f"\n📊 ESTATÍSTICAS:")
        print(f"  Produtos únicos: {len(produtos_unicos)}")
        print(f"  Datas únicas: {len(datas_unicas)}")
        print(f"  Datas: {', '.join(sorted([converter_data(d) for d in datas_unicas]))}")
        
        # Agrupar por produto (último registro)
        produtos_estoque = {}
        for registro in registros:
            id_prod = registro['IdProduto']
            if id_prod not in produtos_estoque or registro['DataOriginal'] >= produtos_estoque[id_prod]['DataOriginal']:
                produtos_estoque[id_prod] = registro
        
        print(f"\n💾 SALVANDO ARQUIVOS...")
        
        # 1. Salvar CSV completo (todos os registros)
        csv_completo = 'estoque_completo.csv'
        with open(csv_completo, 'w', newline='', encoding='utf-8-sig') as f:
            writer = csv.DictWriter(f, fieldnames=['Data', 'IdProduto', 'Quantidade', 'CodEmpresa'])
            writer.writeheader()
            for reg in registros:
                writer.writerow({
                    'Data': reg['Data'],
                    'IdProduto': reg['IdProduto'],
                    'Quantidade': reg['Quantidade'],
                    'CodEmpresa': reg['CodEmpresa']
                })
        print(f"  ✓ {csv_completo} (todos os {len(registros)} registros)")
        
        # 2. Salvar CSV com estoque atual (último registro de cada produto)
        csv_atual = 'estoque_atual.csv'
        with open(csv_atual, 'w', newline='', encoding='utf-8-sig') as f:
            writer = csv.DictWriter(f, fieldnames=['IdProduto', 'Quantidade', 'UltimaAtualizacao', 'CodEmpresa'])
            writer.writeheader()
            for id_prod, reg in sorted(produtos_estoque.items()):
                writer.writerow({
                    'IdProduto': reg['IdProduto'],
                    'Quantidade': reg['Quantidade'],
                    'UltimaAtualizacao': reg['Data'],
                    'CodEmpresa': reg['CodEmpresa']
                })
        print(f"  ✓ {csv_atual} ({len(produtos_estoque)} produtos únicos)")
        
        # 3. Salvar JSON completo
        json_file = 'estoque_completo.json'
        with open(json_file, 'w', encoding='utf-8') as f:
            json.dump(registros, f, indent=2, ensure_ascii=False)
        print(f"  ✓ {json_file}")
        
        # 4. Salvar JSON estoque atual
        json_atual = 'estoque_atual.json'
        estoque_atual_list = [v for k, v in sorted(produtos_estoque.items())]
        with open(json_atual, 'w', encoding='utf-8') as f:
            json.dump(estoque_atual_list, f, indent=2, ensure_ascii=False)
        print(f"  ✓ {json_atual}")
        
        # 5. Análise por data
        print(f"\n📅 ANÁLISE POR DATA:")
        registros_por_data = defaultdict(list)
        for reg in registros:
            registros_por_data[reg['Data']].append(reg)
        
        for data in sorted(registros_por_data.keys(), key=lambda x: datetime.strptime(x, "%d/%m/%Y")):
            regs = registros_por_data[data]
            total_positivo = sum(float(r['Quantidade']) for r in regs if float(r['Quantidade']) > 0)
            total_negativo = sum(float(r['Quantidade']) for r in regs if float(r['Quantidade']) < 0)
            print(f"  {data}: {len(regs)} produtos | Positivo: {total_positivo:,.0f} | Negativo: {total_negativo:,.0f}")
        
        # 6. Top 10 produtos com maior estoque
        print(f"\n🏆 TOP 10 PRODUTOS COM MAIOR ESTOQUE:")
        produtos_ordenados = sorted(
            produtos_estoque.values(),
            key=lambda x: float(x['Quantidade']),
            reverse=True
        )
        for i, prod in enumerate(produtos_ordenados[:10], 1):
            print(f"  {i:2d}. {prod['IdProduto']}: {float(prod['Quantidade']):>10,.2f} unidades")
        
        # 7. Produtos com estoque negativo
        produtos_negativos = [p for p in produtos_estoque.values() if float(p['Quantidade']) < 0]
        print(f"\n⚠️  PRODUTOS COM ESTOQUE NEGATIVO: {len(produtos_negativos)}")
        if produtos_negativos:
            print(f"  Salvando lista em: produtos_estoque_negativo.csv")
            with open('produtos_estoque_negativo.csv', 'w', newline='', encoding='utf-8-sig') as f:
                writer = csv.DictWriter(f, fieldnames=['IdProduto', 'Quantidade', 'UltimaAtualizacao'])
                writer.writeheader()
                for prod in sorted(produtos_negativos, key=lambda x: float(x['Quantidade'])):
                    writer.writerow({
                        'IdProduto': prod['IdProduto'],
                        'Quantidade': prod['Quantidade'],
                        'UltimaAtualizacao': prod['Data']
                    })
        
        print("\n" + "="*70)
        print("✅ CONVERSÃO CONCLUÍDA COM SUCESSO!")
        print("="*70)
        
        print(f"\n📄 ARQUIVOS GERADOS:")
        print(f"  1. estoque_completo.csv - Todos os registros com histórico")
        print(f"  2. estoque_atual.csv - Estoque atual de cada produto")
        print(f"  3. estoque_completo.json - Dados completos em JSON")
        print(f"  4. estoque_atual.json - Estoque atual em JSON")
        if produtos_negativos:
            print(f"  5. produtos_estoque_negativo.csv - Produtos com estoque negativo")
        
        return True
        
    except Exception as e:
        print(f"\n❌ Erro ao processar XML: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    analisar_xml_estoque("extracted_shp/W2IEstoque.xml")

