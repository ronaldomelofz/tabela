#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script corrigido para extrair produtos do PDF com valores corretos
"""

import json
import sys
import re

try:
    import pdfplumber
except ImportError:
    print("📦 Instalando pdfplumber...")
    import subprocess
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pdfplumber"])
    import pdfplumber

def corrigir_valor(valor_str):
    """Corrige o formato do valor para decimal brasileiro"""
    try:
        # Remove espaços e R$
        valor_limpo = valor_str.replace('R$', '').replace(' ', '').strip()
        
        # Se já tem vírgula, usa como decimal
        if ',' in valor_limpo:
            # Remove pontos de milhares e troca vírgula por ponto
            valor_limpo = valor_limpo.replace('.', '').replace(',', '.')
        else:
            # Se não tem vírgula, assume que são centavos
            # Ex: 860 = R$ 8,60
            if len(valor_limpo) >= 3 and '.' not in valor_limpo:
                # Adiciona ponto decimal nos últimos 2 dígitos
                valor_limpo = valor_limpo[:-2] + '.' + valor_limpo[-2:]
        
        return float(valor_limpo)
    except:
        return 0.0

def extrair_produtos(caminho_pdf):
    """Extrai produtos com correção de valores"""
    produtos = []
    produtos_dict = {}
    
    print(f"📖 Lendo: {caminho_pdf}")
    
    with pdfplumber.open(caminho_pdf) as pdf:
        print(f"📄 {len(pdf.pages)} páginas")
        
        for num_pag, pagina in enumerate(pdf.pages, 1):
            print(f"⏳ Página {num_pag}...", end=' ')
            
            # Extrai tabelas
            tabelas = pagina.extract_tables()
            count = 0
            
            if tabelas:
                for tabela in tabelas:
                    for linha in tabela:
                        if not linha or len(linha) < 4:
                            continue
                        
                        try:
                            codigo = str(linha[0]).strip() if linha[0] else ""
                            descricao = str(linha[1]).strip() if linha[1] else ""
                            valor_str = str(linha[2]).strip() if linha[2] else "0"
                            estoque_str = str(linha[3]).strip() if linha[3] else "0"
                            
                            # Pula cabeçalhos e linhas inválidas
                            if (not codigo or 
                                not codigo.isdigit() or 
                                len(codigo) < 3 or
                                "CÓDIGO" in descricao.upper() or
                                "DESCRI" in descricao.upper()):
                                continue
                            
                            # Corrige valor
                            valor = corrigir_valor(valor_str)
                            
                            # Limpa estoque
                            estoque_str = estoque_str.replace('.', '').replace(',', '').strip()
                            estoque = int(float(estoque_str))
                            
                            # Valida dados
                            if valor <= 0 or estoque < 0 or not descricao:
                                continue
                            
                            # Evita duplicatas
                            if codigo not in produtos_dict:
                                produto = {
                                    "codigo": codigo,
                                    "descricao": descricao,
                                    "valor": round(valor, 2),
                                    "estoque": estoque
                                }
                                produtos_dict[codigo] = produto
                                count += 1
                        
                        except (ValueError, TypeError, IndexError):
                            continue
            
            print(f"✅ {count} produtos")
    
    # Converte para lista e ordena
    produtos = list(produtos_dict.values())
    produtos.sort(key=lambda x: x['codigo'])
    
    return produtos

def salvar_json(produtos, caminho):
    """Salva produtos em JSON"""
    with open(caminho, 'w', encoding='utf-8') as f:
        json.dump(produtos, f, indent=2, ensure_ascii=False)
    print(f"\n✅ {len(produtos)} produtos salvos em {caminho}")

def main():
    print("="*60)
    print("🔄 EXTRAÇÃO CORRIGIDA DE PRODUTOS")
    print("="*60)
    print()
    
    produtos = extrair_produtos("tabela preço estoque.pdf")
    
    if not produtos:
        print("\n⚠️  Nenhum produto encontrado")
        return
    
    print(f"\n📊 Total: {len(produtos)} produtos")
    
    # Mostra exemplos
    print("\n📋 Exemplos:")
    for p in produtos[:5]:
        print(f"  {p['codigo']} - {p['descricao'][:40]:<40} R$ {p['valor']:>7.2f}  Est: {p['estoque']}")
    
    salvar_json(produtos, "data/produtos.json")
    print("\n🎉 Concluído!")

if __name__ == "__main__":
    main()

