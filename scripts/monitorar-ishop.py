#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Monitor de Integração iShop/Shop
Monitora continuamente as pastas e atualiza automaticamente quando detectar novos arquivos
"""

import os
import time
from datetime import datetime
import sys

# Importar o integrador
sys.path.append(os.path.dirname(__file__))
try:
    from integrador_ishop import IntegradorIShop
except ImportError:
    # Se não funcionar, tentar importar diretamente
    import importlib.util
    spec = importlib.util.spec_from_file_location("integrador_ishop", os.path.join(os.path.dirname(__file__), "integrador-ishop.py"))
    integrador_ishop = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(integrador_ishop)
    IntegradorIShop = integrador_ishop.IntegradorIShop

class MonitorIShop:
    def __init__(self, intervalo_minutos=30):
        self.integrador = IntegradorIShop()
        self.intervalo = intervalo_minutos * 60  # Converter para segundos
        self.ultima_pasta_in = None
        self.ultima_pasta_out = None
    
    def log(self, mensagem):
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{timestamp}] {mensagem}")
    
    def verificar_mudancas(self):
        """Verifica se há novas pastas/arquivos"""
        pasta_in_atual = self.integrador.obter_pasta_mais_recente(self.integrador.path_in)
        pasta_out_atual = self.integrador.obter_pasta_mais_recente(self.integrador.path_out)
        
        mudou = False
        
        if pasta_in_atual != self.ultima_pasta_in:
            self.log(f"📥 Nova pasta detectada em IN: {pasta_in_atual}")
            self.ultima_pasta_in = pasta_in_atual
            mudou = True
        
        if pasta_out_atual != self.ultima_pasta_out:
            self.log(f"📤 Nova pasta detectada em OUT: {pasta_out_atual}")
            self.ultima_pasta_out = pasta_out_atual
            mudou = True
        
        return mudou
    
    def executar_monitoramento(self):
        """Loop principal de monitoramento"""
        self.log("🔍 Iniciando monitoramento do iShop/Shop")
        self.log(f"⏱️  Intervalo de verificação: {self.intervalo // 60} minutos")
        self.log("")
        
        # Verificação inicial
        self.log("Executando integração inicial...")
        self.integrador.executar_integracao_completa()
        
        # Atualizar estado atual
        self.ultima_pasta_in = self.integrador.obter_pasta_mais_recente(self.integrador.path_in)
        self.ultima_pasta_out = self.integrador.obter_pasta_mais_recente(self.integrador.path_out)
        
        self.log("")
        self.log("✅ Monitoramento ativo. Aguardando mudanças...")
        self.log("   (Pressione Ctrl+C para parar)")
        self.log("")
        
        try:
            while True:
                time.sleep(self.intervalo)
                
                self.log("🔄 Verificando atualizações...")
                
                if self.verificar_mudancas():
                    self.log("📝 Mudanças detectadas! Executando integração...")
                    self.integrador.executar_integracao_completa()
                    self.log("✅ Integração concluída. Aguardando próxima verificação...")
                else:
                    self.log("✓ Nenhuma mudança detectada")
                
                self.log("")
                
        except KeyboardInterrupt:
            self.log("")
            self.log("⏹️  Monitoramento interrompido pelo usuário")
            self.log("Até logo!")

def main():
    """Função principal"""
    import argparse
    
    parser = argparse.ArgumentParser(description="Monitor de Integração iShop/Shop")
    parser.add_argument(
        "-i", "--intervalo",
        type=int,
        default=30,
        help="Intervalo de verificação em minutos (padrão: 30)"
    )
    
    args = parser.parse_args()
    
    monitor = MonitorIShop(intervalo_minutos=args.intervalo)
    monitor.executar_monitoramento()

if __name__ == "__main__":
    main()

