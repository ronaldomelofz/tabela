#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Conversor para TABELABLOCO.txt - Formato estruturado
"""

import json
import re

def converter_tabelabloco():
    """
    Converte TABELABLOCO.txt para JSON
    
    Formato esperado (a cada 4 linhas):
    - Linha 1: Código
    - Linha 2: Descrição
    - Linha 3: Preço (com vírgula)
    - Linha 4: Estoque
    """
    
    print("="*70)
    print("🔄 CONVERTENDO TABELABLOCO.TXT")
    print("="*70)
    print()
    
    try:
        with open('TABELABLOCO.txt', 'r', encoding='utf-8') as f:
            linhas = f.readlines()
        
        print(f"✅ {len(linhas)} linhas lidas")
        print()
        
        produtos = []
        i = 0
        
        # Pula cabeçalhos
        while i < len(linhas):
            linha = linhas[i].strip()
            
            # Procura por código (6 dígitos)
            if re.match(r'^\d{6}$', linha):
                try:
                    codigo = linha
                    
                    # Próxima linha é a descrição
                    i += 1
                    if i >= len(linhas):
                        break
                    descricao = linhas[i].strip()
                    
                    # Próxima linha é o preço
                    i += 1
                    if i >= len(linhas):
                        break
                    preco_str = linhas[i].strip()
                    
                    # Próxima linha é o estoque
                    i += 1
                    if i >= len(linhas):
                        break
                    estoque_str = linhas[i].strip()
                    
                    # Processa preço (converte vírgula para ponto)
                    preco_str = preco_str.replace('.', '').replace(',', '.')
                    valor = float(preco_str)
                    
                    # Processa estoque (remove pontos de milhar)
                    estoque_str = estoque_str.replace('.', '').replace(',', '')
                    estoque = int(estoque_str)
                    
                    # Valida
                    if valor > 0 and estoque >= 0 and len(descricao) > 2:
                        produto = {
                            "codigo": codigo,
                            "descricao": descricao,
                            "valor": round(valor, 2),
                            "estoque": estoque
                        }
                        
                        produtos.append(produto)
                        
                        if len(produtos) % 100 == 0:
                            print(f"   ✅ {len(produtos)} produtos processados...")
                
                except Exception as e:
                    pass
            
            i += 1
        
        print()
        print(f"✅ {len(produtos)} produtos extraídos")
        print()
        
        if produtos:
            # Salva JSON
            with open('data/produtos.json', 'w', encoding='utf-8') as f:
                json.dump(produtos, f, indent=2, ensure_ascii=False)
            
            print("✅ Salvo em: data/produtos.json")
            print()
            
            # Mostra exemplos
            print("📋 Primeiros 15 produtos:")
            print()
            print(f"{'CÓDIGO':<10} {'DESCRIÇÃO':<50} {'VALOR':>10} {'ESTOQUE':>8}")
            print("-" * 85)
            
            for p in produtos[:15]:
                print(f"{p['codigo']:<10} {p['descricao'][:50]:<50} R$ {p['valor']:>6.2f} {p['estoque']:>8}")
            
            if len(produtos) > 15:
                print(f"\n... e mais {len(produtos)-15} produtos")
            
            print()
            print("🎉 CONVERSÃO CONCLUÍDA!")
            print()
            
            # Verifica alguns produtos específicos mencionados
            print("🔍 Verificando produtos mencionados:")
            print()
            
            for codigo in ['000544', '001948', '002544']:
                produto = next((p for p in produtos if p['codigo'] == codigo), None)
                if produto:
                    print(f"   {codigo} - {produto['descricao'][:40]:<40} R$ {produto['valor']:>8.2f}  Est: {produto['estoque']}")
            
            print()
            print("📱 Próximos passos:")
            print("   1. Execute: pnpm build")
            print("   2. Execute: pnpm dev")
            print("   3. Verifique os valores no site")
            print("   4. Se OK: git add . && git commit -m 'Corrige valores' && git push")
            
            return True
        else:
            print("❌ Nenhum produto encontrado")
            return False
    
    except Exception as e:
        print(f"❌ Erro: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    import sys
    sucesso = converter_tabelabloco()
    sys.exit(0 if sucesso else 1)

