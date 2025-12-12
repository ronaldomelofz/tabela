#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Validador completo - verifica TODOS os produtos do arquivo
"""

import json
import re

def validar_e_corrigir():
    """Lê TODO o arquivo e valida cada produto"""
    
    print("="*80)
    print("🔍 VALIDAÇÃO COMPLETA DE TODOS OS PRODUTOS")
    print("="*80)
    print()
    
    with open('TABELABLOCO.txt', 'r', encoding='utf-8') as f:
        linhas = f.readlines()
    
    print(f"📖 Total de linhas no arquivo: {len(linhas)}")
    print()
    
    produtos = []
    produtos_dict = {}  # Para evitar duplicatas
    erros = []
    i = 0
    
    print("⏳ Processando linha por linha...")
    print()
    
    while i < len(linhas):
        linha = linhas[i].strip()
        
        # Procura por código (6 dígitos)
        if re.match(r'^\d{6}$', linha):
            try:
                codigo = linha
                
                # Descrição (próxima linha)
                i += 1
                if i >= len(linhas):
                    break
                descricao = linhas[i].strip()
                
                # Preço (próxima linha)
                i += 1
                if i >= len(linhas):
                    break
                preco_str = linhas[i].strip()
                
                # Estoque (próxima linha)
                i += 1
                if i >= len(linhas):
                    break
                estoque_str = linhas[i].strip()
                
                # Validações
                if not descricao or len(descricao) < 2:
                    erros.append(f"Código {codigo}: Descrição inválida")
                    i += 1
                    continue
                
                # Converte preço
                preco_limpo = preco_str.replace('.', '').replace(',', '.')
                try:
                    valor = float(preco_limpo)
                except:
                    erros.append(f"Código {codigo}: Preço inválido ({preco_str})")
                    i += 1
                    continue
                
                if valor <= 0:
                    erros.append(f"Código {codigo}: Preço zero ou negativo")
                    i += 1
                    continue
                
                # Converte estoque
                estoque_limpo = estoque_str.replace('.', '').replace(',', '')
                try:
                    estoque = int(estoque_limpo)
                except:
                    erros.append(f"Código {codigo}: Estoque inválido ({estoque_str})")
                    i += 1
                    continue
                
                if estoque < 0:
                    erros.append(f"Código {codigo}: Estoque negativo")
                    i += 1
                    continue
                
                # Produto válido
                produto = {
                    "codigo": codigo,
                    "descricao": descricao,
                    "valor": round(valor, 2),
                    "estoque": estoque
                }
                
                # Evita duplicatas (usa o último encontrado)
                produtos_dict[codigo] = produto
                
                if len(produtos_dict) % 100 == 0:
                    print(f"   ✅ {len(produtos_dict)} produtos válidos processados...")
            
            except Exception as e:
                erros.append(f"Linha {i}: {str(e)}")
        
        i += 1
    
    # Converte dict para lista ordenada
    produtos = list(produtos_dict.values())
    produtos.sort(key=lambda x: x['codigo'])
    
    print()
    print("="*80)
    print("📊 RELATÓRIO FINAL")
    print("="*80)
    print()
    print(f"✅ Total de produtos válidos: {len(produtos)}")
    print(f"⚠️  Total de erros/linhas ignoradas: {len(erros)}")
    print()
    
    if erros and len(erros) <= 20:
        print("📋 Primeiros erros encontrados:")
        for erro in erros[:20]:
            print(f"   - {erro}")
        print()
    
    # Estatísticas
    print("📈 Estatísticas:")
    print(f"   - Menor preço: R$ {min(p['valor'] for p in produtos):.2f}")
    print(f"   - Maior preço: R$ {max(p['valor'] for p in produtos):.2f}")
    print(f"   - Total em estoque: {sum(p['estoque'] for p in produtos):,} unidades")
    print(f"   - Produtos sem estoque: {sum(1 for p in produtos if p['estoque'] == 0)}")
    print(f"   - Produtos com estoque: {sum(1 for p in produtos if p['estoque'] > 0)}")
    print()
    
    # Salva
    with open('data/produtos.json', 'w', encoding='utf-8') as f:
        json.dump(produtos, f, indent=2, ensure_ascii=False)
    
    print("✅ Salvo em: data/produtos.json")
    print()
    
    # Mostra amostra
    print("📋 Amostra de produtos (primeiros 20):")
    print()
    print(f"{'CÓDIGO':<10} {'DESCRIÇÃO':<50} {'VALOR':>10} {'ESTOQUE':>8}")
    print("-" * 85)
    
    for p in produtos[:20]:
        print(f"{p['codigo']:<10} {p['descricao'][:50]:<50} R$ {p['valor']:>6.2f} {p['estoque']:>8}")
    
    print()
    print(f"... e mais {len(produtos)-20} produtos")
    print()
    
    # Verifica produtos específicos mencionados
    print("🔍 Produtos mencionados anteriormente:")
    print()
    
    codigos_teste = ['000544', '001948', '002544', '000007', '000008']
    for codigo in codigos_teste:
        produto = produtos_dict.get(codigo)
        if produto:
            print(f"   {codigo} - {produto['descricao'][:45]:<45} R$ {produto['valor']:>8.2f}  Est: {produto['estoque']:>5}")
        else:
            print(f"   {codigo} - NÃO ENCONTRADO")
    
    print()
    print("🎉 VALIDAÇÃO E CORREÇÃO COMPLETA!")
    print()
    print(f"📦 {len(produtos)} produtos prontos para o site")
    
    return True

if __name__ == "__main__":
    import sys
    sucesso = validar_e_corrigir()
    sys.exit(0 if sucesso else 1)

