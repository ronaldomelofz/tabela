#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import zipfile
import xml.etree.ElementTree as ET
import glob

arquivos = glob.glob('Y:\\IN\\25-12-13\\*.shp')
print(f"\n🔍 Analisando {len(arquivos)} arquivos...\n")

arquivos_com_produtos = []
total_produtos = 0

for arquivo in arquivos:
    try:
        with zipfile.ZipFile(arquivo, 'r') as zip_ref:
            arquivos_xml = zip_ref.namelist()
            
            if 'produto.xml' in arquivos_xml:
                with zip_ref.open('produto.xml') as f:
                    tree = ET.parse(f)
                    root = tree.getroot()
                    rows = root.findall('.//ROW')
                    qtd = len(rows)
                    
                    if qtd > 0:
                        nome_arquivo = arquivo.split('\\')[-1]
                        print(f"✓ {nome_arquivo}: {qtd} produtos")
                        arquivos_com_produtos.append(arquivo)
                        total_produtos += qtd
    except:
        pass

print(f"\n📊 RESUMO:")
print(f"   Total de arquivos com produtos: {len(arquivos_com_produtos)}")
print(f"   Total de produtos encontrados: {total_produtos}")

