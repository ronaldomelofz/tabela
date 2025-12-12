#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Extrai dados diretamente do XML dentro do arquivo Excel
"""

import json
import zipfile
import xml.etree.ElementTree as ET
import re
import os

def extrair_do_xml(arquivo_excel):
    """Extrai dados lendo o XML interno do Excel"""
    
    print("🔬 Extraindo dados do XML interno do Excel...")
    print()
    
    try:
        # Excel é um arquivo ZIP
        with zipfile.ZipFile(arquivo_excel, 'r') as zip_ref:
            # Lista arquivos
            arquivos = zip_ref.namelist()
            
            # Procura o arquivo de dados da planilha
            sheet_file = None
            for arq in arquivos:
                if 'xl/worksheets/sheet' in arq:
                    sheet_file = arq
                    break
            
            if not sheet_file:
                print("❌ Não encontrei os dados da planilha no arquivo")
                return None
            
            print(f"✅ Encontrei: {sheet_file}")
            
            # Lê strings compartilhadas (se existir)
            shared_strings = []
            try:
                with zip_ref.open('xl/sharedStrings.xml') as f:
                    xml_content = f.read()
                    root = ET.fromstring(xml_content)
                    
                    # Namespace do XML
                    ns = {'x': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
                    
                    for si in root.findall('.//x:si', ns):
                        t = si.find('.//x:t', ns)
                        if t is not None and t.text:
                            shared_strings.append(t.text)
                
                print(f"✅ {len(shared_strings)} strings encontradas")
            except:
                print("⚠️  Sem strings compartilhadas")
            
            # Lê a planilha
            with zip_ref.open(sheet_file) as f:
                xml_content = f.read()
                root = ET.fromstring(xml_content)
                
                ns = {'x': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
                
                # Extrai todas as linhas
                linhas = []
                for row in root.findall('.//x:row', ns):
                    linha_dados = []
                    for cell in row.findall('.//x:c', ns):
                        v = cell.find('.//x:v', ns)
                        t_attr = cell.get('t')
                        
                        if v is not None and v.text:
                            # Se é string compartilhada
                            if t_attr == 's':
                                idx = int(v.text)
                                if idx < len(shared_strings):
                                    linha_dados.append(shared_strings[idx])
                                else:
                                    linha_dados.append('')
                            else:
                                # É número
                                linha_dados.append(v.text)
                        else:
                            linha_dados.append('')
                    
                    if linha_dados:
                        linhas.append(linha_dados)
                
                return linhas
    
    except Exception as e:
        print(f"❌ Erro: {str(e)}")
        return None

def processar_linhas(linhas):
    """Processa as linhas extraídas"""
    
    if not linhas or len(linhas) < 2:
        return []
    
    print(f"\n✅ {len(linhas)} linhas extraídas")
    print()
    
    # Primeira linha são os cabeçalhos
    cabecalhos = linhas[0]
    print(f"📋 Cabeçalhos: {cabecalhos}")
    print()
    
    produtos = []
    
    for linha in linhas[1:]:  # Pula cabeçalho
        try:
            if len(linha) < 4:
                continue
            
            codigo = str(linha[0]).strip()
            if not codigo or codigo == '':
                continue
            
            descricao = str(linha[1]).strip()
            if not descricao or len(descricao) < 2:
                continue
            
            # Valor - aceita vírgula ou ponto
            valor_str = str(linha[2]).strip()
            valor_str = valor_str.replace(',', '.')
            valor = float(valor_str)
            
            if valor <= 0:
                continue
            
            # Estoque
            estoque_str = str(linha[3]).strip()
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
        
        except:
            continue
    
    return produtos

def main():
    print("="*70)
    print("🔬 EXTRATOR DIRETO XML")
    print("="*70)
    print()
    
    arquivo = "TABELACOMP.xlsx"
    
    if not os.path.exists(arquivo):
        print(f"❌ Arquivo não encontrado: {arquivo}")
        return False
    
    # Extrai
    linhas = extrair_do_xml(arquivo)
    
    if not linhas:
        print("\n❌ Falhou")
        return False
    
    # Processa
    produtos = processar_linhas(linhas)
    
    if not produtos:
        print("\n❌ Nenhum produto válido")
        return False
    
    print(f"\n✅ {len(produtos)} produtos processados")
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
    
    print()
    print("🎉 SUCESSO!")
    
    return True

if __name__ == "__main__":
    import sys
    sucesso = main()
    sys.exit(0 if sucesso else 1)

