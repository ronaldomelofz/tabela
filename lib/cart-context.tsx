"use client";

import React, { createContext, useContext, useState, useEffect } from "react";

export interface CartItem {
  codigo: string;
  descricao: string;
  valor: number;
  quantidade: number;
  valorAVista: number;
}

interface CartContextType {
  items: CartItem[];
  addItem: (produto: { codigo: string; descricao: string; valor: number }, quantidade: number) => void;
  removeItem: (codigo: string) => void;
  updateQuantity: (codigo: string, quantidade: number) => void;
  clearCart: () => void;
  getTotal: () => number;
  getTotalAVista: () => number;
  getItemCount: () => number;
}

const CartContext = createContext<CartContextType | undefined>(undefined);

export function CartProvider({ children }: { children: React.ReactNode }) {
  const [items, setItems] = useState<CartItem[]>([]);

  // Carregar carrinho do localStorage ao iniciar
  useEffect(() => {
    const savedCart = localStorage.getItem("cart");
    if (savedCart) {
      try {
        setItems(JSON.parse(savedCart));
      } catch (e) {
        console.error("Erro ao carregar carrinho:", e);
      }
    }
  }, []);

  // Salvar carrinho no localStorage sempre que mudar
  useEffect(() => {
    localStorage.setItem("cart", JSON.stringify(items));
  }, [items]);

  const addItem = (produto: { codigo: string; descricao: string; valor: number }, quantidade: number) => {
    setItems((prevItems) => {
      const existingItem = prevItems.find((item) => item.codigo === produto.codigo);
      
      if (existingItem) {
        return prevItems.map((item) =>
          item.codigo === produto.codigo
            ? { ...item, quantidade: item.quantidade + quantidade }
            : item
        );
      }
      
      return [
        ...prevItems,
        {
          ...produto,
          quantidade,
          valorAVista: produto.valor * 0.9, // 10% desconto
        },
      ];
    });
  };

  const removeItem = (codigo: string) => {
    setItems((prevItems) => prevItems.filter((item) => item.codigo !== codigo));
  };

  const updateQuantity = (codigo: string, quantidade: number) => {
    if (quantidade <= 0) {
      removeItem(codigo);
      return;
    }
    
    setItems((prevItems) =>
      prevItems.map((item) =>
        item.codigo === codigo ? { ...item, quantidade } : item
      )
    );
  };

  const clearCart = () => {
    setItems([]);
  };

  const getTotal = () => {
    return items.reduce((total, item) => total + item.valor * item.quantidade, 0);
  };

  const getTotalAVista = () => {
    return items.reduce((total, item) => total + item.valorAVista * item.quantidade, 0);
  };

  const getItemCount = () => {
    return items.reduce((count, item) => count + item.quantidade, 0);
  };

  return (
    <CartContext.Provider
      value={{
        items,
        addItem,
        removeItem,
        updateQuantity,
        clearCart,
        getTotal,
        getTotalAVista,
        getItemCount,
      }}
    >
      {children}
    </CartContext.Provider>
  );
}

export function useCart() {
  const context = useContext(CartContext);
  if (context === undefined) {
    throw new Error("useCart deve ser usado dentro de CartProvider");
  }
  return context;
}
