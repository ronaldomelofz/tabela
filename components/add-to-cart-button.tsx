"use client";

import { useState } from "react";
import { Plus, ShoppingCart } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useCart } from "@/lib/cart-context";
import { Badge } from "@/components/ui/badge";

interface AddToCartButtonProps {
  produto: {
    codigo: string;
    descricao: string;
    valor: number;
    estoque: number;
  };
}

export function AddToCartButton({ produto }: AddToCartButtonProps) {
  const { addItem } = useCart();
  const [quantidade, setQuantidade] = useState(1);
  const [showQuantitySelector, setShowQuantitySelector] = useState(false);

  const handleAddToCart = () => {
    if (produto.estoque === 0) return;
    
    // Se estoque é 1, adiciona diretamente
    if (produto.estoque === 1) {
      addItem(produto, 1);
      return;
    }
    
    // Caso contrário, mostra seletor de quantidade
    setShowQuantitySelector(true);
  };

  const handleConfirm = () => {
    if (quantidade > 0 && quantidade <= produto.estoque) {
      addItem(produto, quantidade);
      setShowQuantitySelector(false);
      setQuantidade(1);
    }
  };

  const handleQuickAdd = () => {
    if (produto.estoque > 0) {
      addItem(produto, 1);
    }
  };

  if (produto.estoque === 0) {
    return (
      <Button
        variant="outline"
        size="sm"
        disabled
        className="w-full sm:w-auto"
      >
        <ShoppingCart className="h-4 w-4 mr-2" />
        Sem estoque
      </Button>
    );
  }

  if (showQuantitySelector) {
    return (
      <div className="flex items-center gap-2 w-full sm:w-auto">
        <div className="flex items-center gap-2 border rounded-md">
          <Button
            variant="outline"
            size="sm"
            className="h-8 w-8 p-0"
            onClick={() => setQuantidade(Math.max(1, quantidade - 1))}
          >
            -
          </Button>
          <input
            type="number"
            min="1"
            max={produto.estoque}
            value={quantidade}
            onChange={(e) => {
              const val = parseInt(e.target.value) || 1;
              setQuantidade(Math.min(Math.max(1, val), produto.estoque));
            }}
            className="w-16 text-center border-0 focus:outline-none focus:ring-0 text-sm font-semibold"
          />
          <Button
            variant="outline"
            size="sm"
            className="h-8 w-8 p-0"
            onClick={() => setQuantidade(Math.min(produto.estoque, quantidade + 1))}
          >
            +
          </Button>
        </div>
        <Button
          size="sm"
          onClick={handleConfirm}
          className="flex-1 sm:flex-initial"
        >
          <Plus className="h-4 w-4 mr-2" />
          Adicionar
        </Button>
        <Button
          variant="ghost"
          size="sm"
          onClick={() => {
            setShowQuantitySelector(false);
            setQuantidade(1);
          }}
        >
          Cancelar
        </Button>
      </div>
    );
  }

  return (
    <Button
      size="sm"
      onClick={handleAddToCart}
      className="w-full sm:w-auto"
    >
      <Plus className="h-4 w-4 mr-2" />
      Adicionar
    </Button>
  );
}
