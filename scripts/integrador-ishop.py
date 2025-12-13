#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Sistema de Integração Automática iShop/Shop
Monitora e processa arquivos das pastas Y:\IN e Y:\OUT
"""

import os
import zipfile
import xml.etree.ElementTree as ET
import json
import csv
from datetime import datetime
from pathlib import Path
import glob

class IntegradorIShop:
    def __init__(self, base_path="Y:\\"):
        self.base_path = base_path
        self.path_in = os.path.join(base_path, "IN")
        self.path_out = os.path.join(base_path, "OUT")
        self.dados_dir = "data"
        self.temp_dir = "temp_integracao"
        
        # Criar diretórios se não existirem
        os.makedirs(self.dados_dir, exist_ok=True)
        os.makedirs(self.temp_dir, exist_ok=True)
    
    def log(self, mensagem, tipo="INFO"):
        """Log com timestamp"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        simbolo = {"INFO": "ℹ️", "SUCCESS": "✅", "ERROR": "❌", "WARNING": "⚠️"}.get(tipo, "•")
        print(f"[{timestamp}] {simbolo} {mensagem}")
    
    def obter_pasta_mais_recente(self, base_path):
        """Identifica a pasta com a data mais recente"""
        try:
            pastas = [d for d in os.listdir(base_path) if os.path.isdir(os.path.join(base_path, d))]
            
            # Filtrar pastas no formato YY-MM-DD
            pastas_validas = []
            for pasta in pastas:
                try:
                    # Converter YY-MM-DD para objeto datetime
                    data = datetime.strptime(pasta, "%y-%m-%d")
                    pastas_validas.append((pasta, data))
                except:
                    continue
            
            if not pastas_validas:
                return None
            
            # Ordenar por data e pegar a mais recente
            pasta_mais_recente = sorted(pastas_validas, key=lambda x: x[1], reverse=True)[0][0]
            return pasta_mais_recente
            
        except Exception as e:
            self.log(f"Erro ao buscar pasta mais recente: {e}", "ERROR")
            return None
    
    def extrair_zip_shp(self, arquivo_shp, destino):
        """Extrai conteúdo do arquivo .shp (que é um ZIP)"""
        try:
            with zipfile.ZipFile(arquivo_shp, 'r') as zip_ref:
                zip_ref.extractall(destino)
                return zip_ref.namelist()
        except Exception as e:
            self.log(f"Erro ao extrair {arquivo_shp}: {e}", "ERROR")
            return []
    
    def processar_xml_estoque(self, xml_path):
        """Processa arquivo XML de estoque"""
        try:
            tree = ET.parse(xml_path)
            root = tree.getroot()
            rows = root.findall('.//ROW')
            
            estoque = {}
            for row in rows:
                id_produto = row.get('IdDetalhe', '')
                qtd = row.get('QtEstoque', '0')
                data = row.get('DtReferencia', '')
                
                # Manter apenas o registro mais recente de cada produto
                if id_produto not in estoque or data >= estoque[id_produto]['data']:
                    estoque[id_produto] = {
                        'quantidade': float(qtd),
                        'data': data,
                        'empresa': row.get('CdEmpresa', '')
                    }
            
            return estoque
            
        except Exception as e:
            self.log(f"Erro ao processar XML de estoque: {e}", "ERROR")
            return {}
    
    def processar_xml_produtos(self, xml_path):
        """Processa arquivo XML de produtos/preços do iShop"""
        try:
            tree = ET.parse(xml_path)
            root = tree.getroot()
            rows = root.findall('.//ROW')
            
            produtos = {}
            for row in rows:
                # Extrair todos os atributos do produto
                produto = {}
                for attr_name, attr_value in row.attrib.items():
                    if attr_name != 'RowState':
                        produto[attr_name] = attr_value
                
                # Usar IdDetalhe como chave principal
                id_produto = row.get('IdDetalhe', '')
                if id_produto:
                    produtos[id_produto] = produto
            
            return produtos
            
        except Exception as e:
            self.log(f"Erro ao processar XML de produtos: {e}", "ERROR")
            return {}
    
    def processar_pasta_in(self):
        """Processa arquivos da pasta IN (produtos e preços do iShop)"""
        self.log("=" * 70)
        self.log("PROCESSANDO PASTA IN (iShop → Shop)")
        self.log("=" * 70)
        
        pasta_recente = self.obter_pasta_mais_recente(self.path_in)
        if not pasta_recente:
            self.log("Nenhuma pasta encontrada em IN", "WARNING")
            return {}
        
        self.log(f"Pasta mais recente: {pasta_recente}")
        pasta_completa = os.path.join(self.path_in, pasta_recente)
        
        # Listar todos os arquivos .shp
        arquivos = glob.glob(os.path.join(pasta_completa, "*.shp"))
        self.log(f"Encontrados {len(arquivos)} arquivos para processar")
        
        todos_produtos = {}
        
        for i, arquivo in enumerate(arquivos, 1):
            nome_arquivo = os.path.basename(arquivo)
            self.log(f"[{i}/{len(arquivos)}] Processando {nome_arquivo}...")
            
            # Extrair ZIP
            temp_extract = os.path.join(self.temp_dir, f"in_{i}")
            os.makedirs(temp_extract, exist_ok=True)
            
            arquivos_extraidos = self.extrair_zip_shp(arquivo, temp_extract)
            
            # Procurar arquivos XML
            for arq_extraido in arquivos_extraidos:
                if arq_extraido.lower().endswith('.xml'):
                    xml_path = os.path.join(temp_extract, arq_extraido)
                    produtos = self.processar_xml_produtos(xml_path)
                    todos_produtos.update(produtos)
                    self.log(f"  → {len(produtos)} produtos extraídos")
        
        self.log(f"Total de produtos únicos: {len(todos_produtos)}", "SUCCESS")
        return todos_produtos
    
    def processar_pasta_out(self):
        """Processa arquivos da pasta OUT (estoque do Shop)"""
        self.log("=" * 70)
        self.log("PROCESSANDO PASTA OUT (Shop → iShop)")
        self.log("=" * 70)
        
        pasta_recente = self.obter_pasta_mais_recente(self.path_out)
        if not pasta_recente:
            self.log("Nenhuma pasta encontrada em OUT", "WARNING")
            return {}
        
        self.log(f"Pasta mais recente: {pasta_recente}")
        pasta_completa = os.path.join(self.path_out, pasta_recente)
        
        # Listar todos os arquivos .shp
        arquivos = glob.glob(os.path.join(pasta_completa, "*.shp"))
        self.log(f"Encontrados {len(arquivos)} arquivos para processar")
        
        estoque_consolidado = {}
        
        for i, arquivo in enumerate(arquivos, 1):
            nome_arquivo = os.path.basename(arquivo)
            self.log(f"[{i}/{len(arquivos)}] Processando {nome_arquivo}...")
            
            # Extrair ZIP
            temp_extract = os.path.join(self.temp_dir, f"out_{i}")
            os.makedirs(temp_extract, exist_ok=True)
            
            arquivos_extraidos = self.extrair_zip_shp(arquivo, temp_extract)
            
            # Procurar arquivos XML de estoque
            for arq_extraido in arquivos_extraidos:
                if 'estoque' in arq_extraido.lower() and arq_extraido.lower().endswith('.xml'):
                    xml_path = os.path.join(temp_extract, arq_extraido)
                    estoque = self.processar_xml_estoque(xml_path)
                    estoque_consolidado.update(estoque)
                    self.log(f"  → {len(estoque)} itens de estoque extraídos")
        
        self.log(f"Total de itens em estoque: {len(estoque_consolidado)}", "SUCCESS")
        return estoque_consolidado
    
    def mesclar_dados(self, produtos, estoque):
        """Mescla dados de produtos com estoque"""
        self.log("=" * 70)
        self.log("MESCLANDO DADOS DE PRODUTOS E ESTOQUE")
        self.log("=" * 70)
        
        produtos_completos = []
        
        for id_produto, dados_produto in produtos.items():
            produto_completo = dados_produto.copy()
            
            # Adicionar informações de estoque se disponível
            if id_produto in estoque:
                produto_completo['estoque'] = estoque[id_produto]['quantidade']
                produto_completo['data_estoque'] = estoque[id_produto]['data']
            else:
                produto_completo['estoque'] = 0
                produto_completo['data_estoque'] = None
            
            produtos_completos.append(produto_completo)
        
        self.log(f"Total de produtos mesclados: {len(produtos_completos)}", "SUCCESS")
        return produtos_completos
    
    def salvar_dados(self, produtos):
        """Salva dados processados em múltiplos formatos"""
        self.log("=" * 70)
        self.log("SALVANDO DADOS PROCESSADOS")
        self.log("=" * 70)
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # 1. JSON principal (para o sistema web)
        json_path = os.path.join(self.dados_dir, "produtos.json")
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump(produtos, f, indent=2, ensure_ascii=False)
        self.log(f"✓ {json_path} ({len(produtos)} produtos)")
        
        # 2. Backup com timestamp
        backup_path = os.path.join(self.dados_dir, f"produtos_backup_{timestamp}.json")
        with open(backup_path, 'w', encoding='utf-8') as f:
            json.dump(produtos, f, indent=2, ensure_ascii=False)
        self.log(f"✓ {backup_path}")
        
        # 3. CSV para análise
        if produtos:
            csv_path = os.path.join(self.dados_dir, "produtos_completo.csv")
            with open(csv_path, 'w', newline='', encoding='utf-8-sig') as f:
                writer = csv.DictWriter(f, fieldnames=produtos[0].keys())
                writer.writeheader()
                writer.writerows(produtos)
            self.log(f"✓ {csv_path}")
        
        # 4. Relatório de integração
        relatorio_path = f"relatorio_integracao_{timestamp}.txt"
        with open(relatorio_path, 'w', encoding='utf-8') as f:
            f.write("="*70 + "\n")
            f.write("RELATÓRIO DE INTEGRAÇÃO iShop/Shop\n")
            f.write("="*70 + "\n")
            f.write(f"Data/Hora: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}\n")
            f.write(f"Total de Produtos: {len(produtos)}\n")
            
            # Estatísticas
            produtos_com_estoque = sum(1 for p in produtos if p.get('estoque', 0) > 0)
            produtos_sem_estoque = len(produtos) - produtos_com_estoque
            
            f.write(f"Produtos com Estoque: {produtos_com_estoque}\n")
            f.write(f"Produtos sem Estoque: {produtos_sem_estoque}\n")
            
            # Estoque total
            estoque_total = sum(float(p.get('estoque', 0)) for p in produtos)
            f.write(f"Estoque Total: {estoque_total:,.2f} unidades\n")
            
        self.log(f"✓ {relatorio_path}")
    
    def limpar_temp(self):
        """Limpa arquivos temporários"""
        try:
            import shutil
            if os.path.exists(self.temp_dir):
                shutil.rmtree(self.temp_dir)
            self.log("Arquivos temporários removidos", "SUCCESS")
        except Exception as e:
            self.log(f"Erro ao limpar temporários: {e}", "WARNING")
    
    def executar_integracao_completa(self):
        """Executa o processo completo de integração"""
        self.log("")
        self.log("="*70)
        self.log("🔄 INICIANDO INTEGRAÇÃO iShop/Shop")
        self.log("="*70)
        self.log("")
        
        try:
            # 1. Processar produtos da pasta IN
            produtos = self.processar_pasta_in()
            
            # 2. Processar estoque da pasta OUT
            estoque = self.processar_pasta_out()
            
            # 3. Mesclar dados
            produtos_completos = self.mesclar_dados(produtos, estoque)
            
            # 4. Salvar dados
            self.salvar_dados(produtos_completos)
            
            # 5. Limpar temporários
            self.limpar_temp()
            
            self.log("")
            self.log("="*70)
            self.log("✅ INTEGRAÇÃO CONCLUÍDA COM SUCESSO!")
            self.log("="*70)
            
            return True
            
        except Exception as e:
            self.log(f"Erro durante integração: {e}", "ERROR")
            import traceback
            traceback.print_exc()
            return False

def main():
    """Função principal"""
    integrador = IntegradorIShop()
    integrador.executar_integracao_completa()

if __name__ == "__main__":
    main()

