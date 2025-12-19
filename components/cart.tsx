"use client";

import { useState } from "react";
import { ShoppingCart, X, Plus, Minus, Trash2, MessageCircle, User, Phone } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { useCart } from "@/lib/cart-context";

export function Cart() {
  const { items, removeItem, updateQuantity, clearCart, getTotal, getTotalAVista, getItemCount } = useCart();
  const [isOpen, setIsOpen] = useState(false);
  const [nomeCliente, setNomeCliente] = useState("");
  const [telefoneCliente, setTelefoneCliente] = useState("");

  const formatCurrency = (value: number) => {
    return new Intl.NumberFormat("pt-BR", {
      style: "currency",
      currency: "BRL",
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(value);
  };

  const formatarTelefoneParaWhatsApp = (telefone: string): string => {
    // Remove todos os caracteres não numéricos
    let numero = telefone.replace(/\D/g, "");
    
    // Se já começar com 55 (código do Brasil), retorna como está
    if (numero.startsWith("55") && numero.length >= 12) {
      return numero;
    }
    
    // Se começar com 0, remove o 0
    if (numero.startsWith("0")) {
      numero = numero.substring(1);
    }
    
    // Se tiver 10 ou 11 dígitos (DDD + número), adiciona código do país 55
    if (numero.length === 10 || numero.length === 11) {
      return `55${numero}`;
    }
    
    // Se já tiver formato correto, retorna
    return numero;
  };

  const enviarParaWhatsApp = () => {
    if (items.length === 0) return;

    // Validação dos campos obrigatórios
    if (!nomeCliente.trim()) {
      alert("Por favor, informe o nome do cliente.");
      return;
    }

    if (!telefoneCliente.trim()) {
      alert("Por favor, informe o telefone do cliente.");
      return;
    }

    // Formata o telefone do cliente para o formato do WhatsApp
    const numeroWhatsApp = formatarTelefoneParaWhatsApp(telefoneCliente);
    
    // Valida se o número está no formato correto
    if (numeroWhatsApp.length < 12) {
      alert("Por favor, informe um telefone válido com DDD.");
      return;
    }

    const mensagem = gerarMensagemPedido();
    const url = `https://wa.me/${numeroWhatsApp}?text=${encodeURIComponent(mensagem)}`;
    
    window.open(url, "_blank");
    
    // Limpar carrinho e campos após envio
    clearCart();
    setNomeCliente("");
    setTelefoneCliente("");
    setIsOpen(false);
  };

  const gerarMensagemPedido = () => {
    let mensagem = "*PEDIDO DE PRODUTOS*\n\n";
    
    // Informações do cliente
    mensagem += "*DADOS DO CLIENTE*\n";
    mensagem += `Nome: *${nomeCliente.trim()}*\n`;
    mensagem += `Telefone: ${telefoneCliente.trim()}\n\n`;
    
    mensagem += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n";
    
    // Itens do pedido
    mensagem += "*ITENS DO PEDIDO*\n\n";
    items.forEach((item, index) => {
      mensagem += `${index + 1}. *${item.descricao}*\n`;
      mensagem += `   Código: *${item.codigo}*\n`;
      mensagem += `   Quantidade: *${item.quantidade}* un.\n`;
      mensagem += `   Valor unit. (à vista): ${formatCurrency(item.valorAVista)}\n`;
      mensagem += `   Valor unit. (parcelado): ${formatCurrency(item.valor)}\n`;
      
      // Adiciona separador após cada item
      mensagem += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
    });

    mensagem += `*Total de itens:* ${getItemCount()} unidades\n`;
    mensagem += `*Total à vista:* ${formatCurrency(getTotalAVista())}\n`;
    mensagem += `*Total parcelado:* ${formatCurrency(getTotal())}\n`;
    mensagem += `*Desconto:* ${formatCurrency(getTotal() - getTotalAVista())}\n\n`;
    mensagem += "Obrigado pelo pedido!";

    return mensagem;
  };

  return (
    <>
      {/* Botão do Carrinho */}
      <Button
        variant="outline"
        size="icon"
        className="relative"
        onClick={() => setIsOpen(true)}
      >
        <ShoppingCart className="h-5 w-5" />
        {getItemCount() > 0 && (
          <Badge className="absolute -top-2 -right-2 h-5 w-5 flex items-center justify-center p-0 text-xs">
            {getItemCount()}
          </Badge>
        )}
      </Button>

      {/* Modal do Carrinho */}
      {isOpen && (
        <div 
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/50"
          onClick={(e) => {
            if (e.target === e.currentTarget) {
              setIsOpen(false);
            }
          }}
        >
          <Card 
            className="w-full max-w-2xl max-h-[90vh] overflow-hidden flex flex-col m-4"
            onClick={(e) => e.stopPropagation()}
          >
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3 border-b flex-shrink-0">
              <div>
                <CardTitle className="flex items-center gap-2">
                  <ShoppingCart className="h-5 w-5" />
                  Carrinho de Compras
                </CardTitle>
                <CardDescription>
                  {getItemCount()} {getItemCount() === 1 ? "item" : "itens"} no carrinho
                </CardDescription>
              </div>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => setIsOpen(false)}
              >
                <X className="h-4 w-4" />
              </Button>
            </CardHeader>

            <CardContent className="flex-1 overflow-y-auto p-4 min-h-0">
              {items.length === 0 ? (
                <div className="text-center py-12">
                  <ShoppingCart className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-500 font-medium">Carrinho vazio</p>
                  <p className="text-sm text-gray-400 mt-2">
                    Adicione produtos ao carrinho para começar
                  </p>
                </div>
              ) : (
                <div className="space-y-4">
                  {items.map((item) => (
                    <div
                      key={item.codigo}
                      className="flex items-start gap-4 p-4 border rounded-lg bg-gray-50"
                    >
                      <div className="flex-1">
                        <h3 className="font-semibold text-sm mb-1">{item.descricao}</h3>
                        <p className="text-xs text-gray-500 mb-2">Código: {item.codigo}</p>
                        <div className="flex items-center gap-4">
                          <div className="flex items-center gap-2">
                            <Button
                              variant="outline"
                              size="icon"
                              className="h-8 w-8"
                              onClick={() => updateQuantity(item.codigo, item.quantidade - 1)}
                            >
                              <Minus className="h-3 w-3" />
                            </Button>
                            <span className="w-8 text-center font-semibold">
                              {item.quantidade}
                            </span>
                            <Button
                              variant="outline"
                              size="icon"
                              className="h-8 w-8"
                              onClick={() => updateQuantity(item.codigo, item.quantidade + 1)}
                            >
                              <Plus className="h-3 w-3" />
                            </Button>
                          </div>
                          <div className="flex-1 text-right">
                            <p className="text-sm font-semibold">
                              {formatCurrency(item.valorAVista * item.quantidade)}
                            </p>
                            <p className="text-xs text-gray-500">
                              {formatCurrency(item.valorAVista)} cada
                            </p>
                          </div>
                          <Button
                            variant="ghost"
                            size="icon"
                            className="h-8 w-8 text-red-500 hover:text-red-700"
                            onClick={() => removeItem(item.codigo)}
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>

            {items.length > 0 && (
              <div className="border-t p-3 bg-gray-50 space-y-2 flex-shrink-0">
                {/* Campos de Cliente */}
                <div className="space-y-2 pb-2 border-b">
                  <h3 className="font-semibold text-xs flex items-center gap-1.5">
                    <User className="h-3.5 w-3.5" />
                    Dados do Cliente
                  </h3>
                  <div className="space-y-1.5">
                    <div>
                      <label className="text-xs text-gray-600 mb-0.5 block">
                        Nome do Cliente *
                      </label>
                      <Input
                        type="text"
                        placeholder="Digite o nome do cliente"
                        value={nomeCliente}
                        onChange={(e) => setNomeCliente(e.target.value)}
                        className="w-full h-9 text-sm"
                      />
                    </div>
                    <div>
                      <label className="text-xs text-gray-600 mb-0.5 block">
                        Telefone para Contato *
                      </label>
                      <div className="relative">
                        <Phone className="absolute left-2.5 top-1/2 -translate-y-1/2 h-3.5 w-3.5 text-gray-400" />
                        <Input
                          type="tel"
                          placeholder="(11) 98765-4321"
                          value={telefoneCliente}
                          onChange={(e) => setTelefoneCliente(e.target.value)}
                          className="w-full pl-9 h-9 text-sm"
                        />
                      </div>
                    </div>
                  </div>
                </div>

                {/* Resumo do Pedido */}
                <div className="space-y-1">
                  <div className="flex justify-between text-xs">
                    <span className="text-gray-600">Subtotal:</span>
                    <span className="font-semibold">{formatCurrency(getTotal())}</span>
                  </div>
                  <div className="flex justify-between text-xs">
                    <span className="text-gray-600">Desconto (10%):</span>
                    <span className="text-green-600 font-semibold">
                      -{formatCurrency(getTotal() - getTotalAVista())}
                    </span>
                  </div>
                  <div className="flex justify-between text-base font-bold pt-1 border-t">
                    <span>Total à Vista:</span>
                    <span className="text-green-600">{formatCurrency(getTotalAVista())}</span>
                  </div>
                </div>
                <div className="flex gap-2 pt-1">
                  <Button
                    variant="outline"
                    size="sm"
                    className="flex-1 h-9 text-xs"
                    onClick={clearCart}
                  >
                    <Trash2 className="h-3.5 w-3.5 mr-1.5" />
                    Limpar
                  </Button>
                  <Button
                    size="sm"
                    className="flex-1 bg-green-600 hover:bg-green-700 h-9 text-xs"
                    onClick={enviarParaWhatsApp}
                    disabled={!nomeCliente.trim() || !telefoneCliente.trim()}
                  >
                    <MessageCircle className="h-3.5 w-3.5 mr-1.5" />
                    Enviar para WhatsApp
                  </Button>
                </div>
              </div>
            )}
          </Card>
        </div>
      )}
    </>
  );
}
