#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script avançado para extrair tabela de produtos do PDF
"""

import json
import sys

try:
    import pdfplumber
except ImportError:
    print("❌ Instalando pdfplumber...")
    import subprocess
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pdfplumber"])
    import pdfplumber

def extrair_tabela_pdf(caminho_pdf):
    """Extrai produtos usando detecção de tabelas do pdfplumber"""
    produtos = []
    
    print(f"📖 Lendo arquivo: {caminho_pdf}")
    
    try:
        with pdfplumber.open(caminho_pdf) as pdf:
            print(f"📄 Total de páginas: {len(pdf.pages)}")
            
            for num_pagina, pagina in enumerate(pdf.pages, 1):
                print(f"⏳ Processando página {num_pagina}...")
                
                # Tenta extrair tabelas
                tabelas = pagina.extract_tables()
                
                if tabelas:
                    for tabela in tabelas:
                        for linha in tabela:
                            if not linha or len(linha) < 4:
                                continue
                            
                            try:
                                # Assume: [código, descrição, valor, estoque]
                                codigo = str(linha[0]).strip() if linha[0] else ""
                                descricao = str(linha[1]).strip() if linha[1] else ""
                                valor_str = str(linha[2]).strip() if linha[2] else "0"
                                estoque_str = str(linha[3]).strip() if linha[3] else "0"
                                
                                # Pula cabeçalhos
                                if not codigo or not codigo.isdigit() or len(codigo) < 3:
                                    continue
                                
                                if "CÓDIGO" in descricao.upper() or "DESCRI" in descricao.upper():
                                    continue
                                
                                # Limpa e converte valores
                                valor_str = valor_str.replace('R$', '').replace('.', '').replace(',', '.').strip()
                                estoque_str = estoque_str.replace('.', '').replace(',', '').strip()
                                
                                valor = float(valor_str)
                                estoque = int(float(estoque_str))
                                
                                produto = {
                                    "codigo": codigo,
                                    "descricao": descricao,
                                    "valor": valor,
                                    "estoque": estoque
                                }
                                
                                produtos.append(produto)
                                print(f"  ✅ {codigo} - {descricao[:40]}...")
                                
                            except (ValueError, TypeError, IndexError) as e:
                                continue
                
                # Se não encontrou tabelas, tenta por texto
                else:
                    texto = pagina.extract_text()
                    if texto:
                        linhas = texto.split('\n')
                        for linha in linhas:
                            # Padrão: 6 dígitos + texto + valor + estoque
                            partes = linha.split()
                            if len(partes) >= 4:
                                try:
                                    codigo = partes[0]
                                    if not codigo.isdigit() or len(codigo) != 6:
                                        continue
                                    
                                    # Encontra valor (número com vírgula) e estoque (último número)
                                    valor_idx = -1
                                    estoque_idx = -1
                                    
                                    for i, parte in enumerate(partes):
                                        if ',' in parte and any(c.isdigit() for c in parte):
                                            valor_idx = i
                                        elif parte.isdigit() and i > valor_idx and valor_idx != -1:
                                            estoque_idx = i
                                    
                                    if valor_idx == -1 or estoque_idx == -1:
                                        continue
                                    
                                    descricao = ' '.join(partes[1:valor_idx])
                                    valor_str = partes[valor_idx].replace('.', '').replace(',', '.')
                                    estoque_str = partes[estoque_idx]
                                    
                                    valor = float(valor_str)
                                    estoque = int(estoque_str)
                                    
                                    produto = {
                                        "codigo": codigo,
                                        "descricao": descricao,
                                        "valor": valor,
                                        "estoque": estoque
                                    }
                                    
                                    produtos.append(produto)
                                    print(f"  ✅ {codigo} - {descricao[:40]}...")
                                    
                                except (ValueError, IndexError):
                                    continue
    
    except Exception as e:
        print(f"❌ Erro ao processar PDF: {str(e)}")
        return []
    
    return produtos

def salvar_json(produtos, caminho_saida):
    """Salva produtos em JSON"""
    try:
        with open(caminho_saida, 'w', encoding='utf-8') as f:
            json.dump(produtos, f, indent=2, ensure_ascii=False)
        print(f"\n✅ Arquivo salvo: {caminho_saida}")
        return True
    except Exception as e:
        print(f"❌ Erro ao salvar: {str(e)}")
        return False

def main():
    print("=" * 60)
    print("🔄 CONVERSOR AVANÇADO DE PDF PARA JSON")
    print("=" * 60)
    print()
    
    pdf_path = "tabela preço estoque.pdf"
    json_path = "data/produtos.json"
    
    produtos = extrair_tabela_pdf(pdf_path)
    
    if not produtos:
        print("\n⚠️  Nenhum produto encontrado.")
        print("💡 Verifique se o PDF contém uma tabela estruturada.")
        return
    
    # Remove duplicatas por código
    produtos_unicos = {}
    for p in produtos:
        produtos_unicos[p['codigo']] = p
    
    produtos_final = list(produtos_unicos.values())
    produtos_final.sort(key=lambda x: x['codigo'])
    
    print(f"\n📊 Total: {len(produtos_final)} produtos únicos")
    
    if salvar_json(produtos_final, json_path):
        print(f"\n🎉 Conversão concluída!")
        print(f"📦 {len(produtos_final)} produtos convertidos")

if __name__ == "__main__":
    main()

