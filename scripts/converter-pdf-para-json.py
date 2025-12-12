#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para converter PDF de produtos para JSON
Instalação: pip install pdfplumber
"""

import json
import re
import sys

try:
    import pdfplumber
except ImportError:
    print("❌ Biblioteca pdfplumber não encontrada!")
    print("📦 Instalando automaticamente...")
    import subprocess
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pdfplumber"])
    import pdfplumber

def extrair_produtos_do_pdf(caminho_pdf):
    """Extrai produtos do PDF e retorna uma lista de dicionários"""
    produtos = []
    
    print(f"📖 Lendo arquivo: {caminho_pdf}")
    
    try:
        with pdfplumber.open(caminho_pdf) as pdf:
            print(f"📄 Total de páginas: {len(pdf.pages)}")
            
            for num_pagina, pagina in enumerate(pdf.pages, 1):
                print(f"⏳ Processando página {num_pagina}...")
                
                # Extrai texto da página
                texto = pagina.extract_text()
                
                if not texto:
                    continue
                
                # Divide em linhas
                linhas = texto.split('\n')
                
                for linha in linhas:
                    # Ignora linhas vazias ou cabeçalhos
                    if not linha.strip() or len(linha.strip()) < 10:
                        continue
                    
                    # Tenta extrair: código, descrição, valor e estoque
                    # Padrão flexível para detectar diferentes formatos
                    
                    # Exemplo de padrões comuns:
                    # "001 Produto XYZ 100.00 50"
                    # "001 | Produto XYZ | R$ 100,00 | 50"
                    
                    # Remove espaços múltiplos
                    linha_limpa = re.sub(r'\s+', ' ', linha.strip())
                    
                    # Tenta extrair usando regex
                    # Padrão: código (alfanumérico) + descrição + valor (número com vírgula/ponto) + estoque (número)
                    padrao = r'([A-Z0-9\-]+)\s+(.+?)\s+(?:R\$\s*)?(\d+[.,]\d{2})\s+(\d+)'
                    match = re.search(padrao, linha_limpa, re.IGNORECASE)
                    
                    if match:
                        codigo = match.group(1)
                        descricao = match.group(2).strip()
                        valor_str = match.group(3).replace(',', '.')
                        estoque = match.group(4)
                        
                        try:
                            valor = float(valor_str)
                            estoque_int = int(estoque)
                            
                            produto = {
                                "codigo": codigo,
                                "descricao": descricao,
                                "valor": valor,
                                "estoque": estoque_int
                            }
                            
                            produtos.append(produto)
                            print(f"  ✅ {codigo} - {descricao[:30]}...")
                            
                        except ValueError:
                            continue
    
    except Exception as e:
        print(f"❌ Erro ao processar PDF: {str(e)}")
        return []
    
    return produtos

def salvar_json(produtos, caminho_saida):
    """Salva a lista de produtos em um arquivo JSON"""
    try:
        with open(caminho_saida, 'w', encoding='utf-8') as f:
            json.dump(produtos, f, indent=2, ensure_ascii=False)
        print(f"\n✅ Arquivo salvo com sucesso: {caminho_saida}")
        return True
    except Exception as e:
        print(f"❌ Erro ao salvar JSON: {str(e)}")
        return False

def main():
    """Função principal"""
    print("=" * 60)
    print("🔄 CONVERSOR DE PDF PARA JSON")
    print("=" * 60)
    print()
    
    # Caminhos dos arquivos
    pdf_path = "tabela preço estoque.pdf"
    json_path = "data/produtos.json"
    
    # Extrai produtos do PDF
    produtos = extrair_produtos_do_pdf(pdf_path)
    
    if not produtos:
        print("\n⚠️  Nenhum produto foi encontrado no PDF.")
        print("📝 Por favor, verifique o formato do arquivo PDF.")
        print()
        print("💡 O PDF deve conter linhas no formato:")
        print("   CÓDIGO DESCRIÇÃO VALOR ESTOQUE")
        print("   Exemplo: 001 Mouse Gamer 150.00 25")
        return
    
    print(f"\n📊 Total de produtos encontrados: {len(produtos)}")
    
    # Salva no formato JSON
    if salvar_json(produtos, json_path):
        print(f"\n🎉 Conversão concluída com sucesso!")
        print(f"📦 {len(produtos)} produtos foram convertidos")
        print(f"📁 Arquivo: {json_path}")
        print()
        print("▶️  Próximo passo: Execute 'pnpm dev' para visualizar o site")
    else:
        print("\n❌ Falha ao salvar o arquivo JSON")

if __name__ == "__main__":
    main()

