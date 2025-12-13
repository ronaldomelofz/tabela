#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script Simples para Atualizar o Site com Dados do iShop
Lê arquivos de Y:\IN e Y:\OUT e atualiza data/produtos.json
"""

import os
import zipfile
import xml.etree.ElementTree as ET
import json
import glob
from datetime import datetime

class AtualizadorSite:
    def __init__(self):
        self.path_in = "Y:\\IN"
        self.path_out = "Y:\\OUT"
        self.arquivo_site = "data/produtos.json"
        
    def log(self, msg):
        print(f"[{datetime.now().strftime('%H:%M:%S')}] {msg}")
    
    def pasta_mais_recente(self, base_path):
        """Encontra a pasta com data mais recente"""
        try:
            pastas = [d for d in os.listdir(base_path) 
                     if os.path.isdir(os.path.join(base_path, d))]
            
            datas = []
            for pasta in pastas:
                try:
                    data = datetime.strptime(pasta, "%y-%m-%d")
                    datas.append((pasta, data))
                except:
                    continue
            
            if datas:
                return sorted(datas, key=lambda x: x[1], reverse=True)[0][0]
            return None
        except:
            return None
    
    def extrair_xml_de_shp(self, arquivo_shp):
        """Extrai XMLs de um arquivo .shp (ZIP)"""
        xmls = {}
        try:
            with zipfile.ZipFile(arquivo_shp, 'r') as zip_ref:
                for nome in zip_ref.namelist():
                    if nome.lower().endswith('.xml'):
                        with zip_ref.open(nome) as f:
                            xmls[nome] = ET.parse(f).getroot()
        except:
            pass
        return xmls
    
    def processar_produtos_in(self):
        """Processa produtos da pasta IN"""
        self.log("📥 Processando produtos da pasta IN...")
        
        pasta = self.pasta_mais_recente(self.path_in)
        if not pasta:
            self.log("⚠️  Nenhuma pasta encontrada em IN")
            return {}
        
        self.log(f"   Pasta: {pasta}")
        caminho = os.path.join(self.path_in, pasta)
        
        produtos = {}
        arquivos = glob.glob(os.path.join(caminho, "*.shp"))
        
        for arquivo in arquivos:
            xmls = self.extrair_xml_de_shp(arquivo)
            
            # Processar produto.xml
            if 'produto.xml' in xmls:
                for row in xmls['produto.xml'].findall('.//ROW'):
                    id_produto = row.get('idproduto', '')
                    if id_produto:
                        produtos[id_produto] = {
                            'id': id_produto,
                            'codigo': row.get('cdchamada', ''),
                            'nome': row.get('nmproduto', ''),
                            'ativo': row.get('stativo', '1'),
                        }
            
            # Processar detalhe.xml (preços e detalhes)
            if 'detalhe.xml' in xmls:
                for row in xmls['detalhe.xml'].findall('.//ROW'):
                    id_detalhe = row.get('iddetalhe', '')
                    id_produto = row.get('idproduto', '')
                    
                    if id_produto in produtos:
                        produtos[id_produto].update({
                            'idDetalhe': id_detalhe,
                            'descricao': row.get('dsdetalhe', ''),
                            'precoCusto': row.get('vlprecocusto', '0'),
                            'precoVenda': row.get('vlprecovenda', '0'),
                            'desconto1': row.get('vldesc1', '0'),
                            'desconto2': row.get('vldesc2', '0'),
                            'desconto3': row.get('vldesc3', '0'),
                        })
            
            # Processar empdet.xml (dados por empresa)
            if 'empdet.xml' in xmls:
                for row in xmls['empdet.xml'].findall('.//ROW'):
                    id_produto = row.get('idproduto', '')
                    if id_produto in produtos:
                        produtos[id_produto].update({
                            'empresa': row.get('idempresa', ''),
                            'ranking': row.get('nrrankloja', '0'),
                            'percentVenda': row.get('percentvendaloja', '0'),
                        })
        
        self.log(f"   ✓ {len(produtos)} produtos carregados")
        return produtos
    
    def processar_estoque_out(self):
        """Processa estoque da pasta OUT"""
        self.log("📤 Processando estoque da pasta OUT...")
        
        pasta = self.pasta_mais_recente(self.path_out)
        if not pasta:
            self.log("⚠️  Nenhuma pasta encontrada em OUT")
            return {}
        
        self.log(f"   Pasta: {pasta}")
        caminho = os.path.join(self.path_out, pasta)
        
        estoque = {}
        arquivos = glob.glob(os.path.join(caminho, "*.shp"))
        
        for arquivo in arquivos:
            xmls = self.extrair_xml_de_shp(arquivo)
            
            # Procurar XML de estoque (geralmente contém "estoque" no nome)
            for nome_xml, root in xmls.items():
                if 'estoque' in nome_xml.lower() or 'W2I' in nome_xml:
                    for row in root.findall('.//ROW'):
                        id_detalhe = row.get('IdDetalhe', '')
                        qtd = row.get('QtEstoque', '0')
                        data = row.get('DtReferencia', '')
                        
                        # Manter apenas o mais recente
                        if id_detalhe not in estoque or data >= estoque[id_detalhe].get('data', ''):
                            estoque[id_detalhe] = {
                                'quantidade': float(qtd),
                                'data': data
                            }
        
        self.log(f"   ✓ {len(estoque)} itens de estoque carregados")
        return estoque
    
    def mesclar_e_salvar(self, produtos, estoque):
        """Mescla produtos com estoque e salva no formato do site"""
        self.log("🔄 Mesclando dados...")
        
        # Criar índice por idDetalhe para cruzar com estoque
        produtos_por_detalhe = {}
        for prod in produtos.values():
            if 'idDetalhe' in prod:
                produtos_por_detalhe[prod['idDetalhe']] = prod
        
        # Adicionar estoque
        for id_detalhe, info_estoque in estoque.items():
            if id_detalhe in produtos_por_detalhe:
                produtos_por_detalhe[id_detalhe]['estoque'] = info_estoque['quantidade']
                produtos_por_detalhe[id_detalhe]['dataEstoque'] = info_estoque['data']
        
        # Converter para formato do site (lista)
        produtos_lista = []
        for prod in produtos.values():
            # Adicionar estoque 0 se não tiver
            if 'estoque' not in prod:
                prod['estoque'] = 0
            
            # Formatar para o site (formato esperado pelo Next.js)
            preco_venda = float(prod.get('precoVenda', 0))
            
            produto_site = {
                'codigo': prod.get('codigo', ''),
                'descricao': prod.get('nome', '') or prod.get('descricao', ''),
                'valor': preco_venda,
                'estoque': int(float(prod.get('estoque', 0))),
            }
            
            # Só adiciona produtos com código válido
            if produto_site['codigo']:
                produtos_lista.append(produto_site)
        
        # Salvar JSON
        os.makedirs('data', exist_ok=True)
        
        # Backup do arquivo atual
        if os.path.exists(self.arquivo_site):
            backup = f"data/produtos_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
            try:
                with open(self.arquivo_site, 'r', encoding='utf-8') as f:
                    with open(backup, 'w', encoding='utf-8') as fb:
                        fb.write(f.read())
                self.log(f"   ✓ Backup criado: {backup}")
            except:
                pass
        
        # Salvar novo arquivo
        with open(self.arquivo_site, 'w', encoding='utf-8') as f:
            json.dump(produtos_lista, f, indent=2, ensure_ascii=False)
        
        self.log(f"   ✓ Arquivo atualizado: {self.arquivo_site}")
        self.log(f"   ✓ Total: {len(produtos_lista)} produtos")
        
        # Estatísticas
        com_estoque = sum(1 for p in produtos_lista if p['estoque'] > 0)
        self.log(f"   ✓ Com estoque: {com_estoque}")
        self.log(f"   ✓ Sem estoque: {len(produtos_lista) - com_estoque}")
        
        return produtos_lista
    
    def enviar_para_github(self):
        """Envia alterações para o GitHub"""
        self.log("📤 Enviando para GitHub...")
        
        try:
            import subprocess
            
            # Resetar quaisquer mudanças não desejadas
            self.log("   🔄 Resetando mudanças não relacionadas...")
            subprocess.run(['git', 'reset', 'HEAD', '.'], capture_output=True)
            subprocess.run(['git', 'checkout', '.'], capture_output=True)
            
            # Add APENAS o arquivo de produtos
            self.log("   📁 Adicionando apenas data/produtos.json...")
            subprocess.run(['git', 'add', 'data/produtos.json'], check=True)
            
            # Verificar se há mudanças no arquivo
            result = subprocess.run(['git', 'diff', '--cached', '--quiet'], capture_output=True)
            if result.returncode == 0:
                self.log("   ℹ️  Nenhuma mudança nos dados")
                return True
            
            # Commit
            mensagem = f"Atualização automática iShop - {datetime.now().strftime('%d/%m/%Y %H:%M')}"
            subprocess.run(['git', 'commit', '-m', mensagem], check=True)
            
            # Push
            self.log("   📤 Enviando para GitHub...")
            subprocess.run(['git', 'push'], check=True)
            
            self.log("   ✅ Enviado para GitHub com sucesso!")
            self.log("   🌐 Netlify fará deploy automático em instantes")
            
            return True
            
        except subprocess.CalledProcessError as e:
            self.log(f"   ⚠️  Erro ao enviar para GitHub: {e}")
            return False
        except Exception as e:
            self.log(f"   ⚠️  Erro: {e}")
            return False
    
    def executar(self):
        """Executa atualização completa"""
        print("\n" + "="*60)
        print("🔄 ATUALIZANDO SITE COM DADOS DO iShop")
        print("="*60 + "\n")
        
        try:
            # 1. Carregar produtos
            produtos = self.processar_produtos_in()
            
            # 2. Carregar estoque
            estoque = self.processar_estoque_out()
            
            # 3. Mesclar e salvar
            self.mesclar_e_salvar(produtos, estoque)
            
            # 4. Enviar para GitHub (Netlify fará deploy automático)
            self.enviar_para_github()
            
            print("\n" + "="*60)
            print("✅ SITE ATUALIZADO E ENVIADO PARA GITHUB!")
            print("🌐 Netlify fará o deploy automático")
            print("="*60 + "\n")
            
            return True
            
        except Exception as e:
            print(f"\n❌ ERRO: {e}\n")
            import traceback
            traceback.print_exc()
            return False

if __name__ == "__main__":
    atualizador = AtualizadorSite()
    atualizador.executar()

