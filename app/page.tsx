"use client";

import { useState, useMemo } from "react";
import { Search, Package, TrendingUp, Barcode } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Cart } from "@/components/cart";
import { AddToCartButton } from "@/components/add-to-cart-button";
import produtosData from "@/data/produtos.json";

interface Produto {
  codigo: string;
  descricao: string;
  valor: number;
  estoque: number;
}

export default function Home() {
  const [searchTerm, setSearchTerm] = useState("");
  const produtos: Produto[] = produtosData;

  const filteredProdutos = useMemo(() => {
    if (!searchTerm.trim()) {
      return produtos;
    }

    const searchLower = searchTerm.toLowerCase();
    return produtos.filter(
      (produto) =>
        produto.codigo.toLowerCase().includes(searchLower) ||
        produto.descricao.toLowerCase().includes(searchLower)
    );
  }, [searchTerm, produtos]);

  const formatCurrency = (value: number) => {
    return new Intl.NumberFormat("pt-BR", {
      style: "currency",
      currency: "BRL",
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(value);
  };

  const calcularValorAVista = (valor: number) => {
    return valor * 0.9; // 10% de desconto
  };

  const getEstoqueBadge = (estoque: number) => {
    if (estoque === 0) {
      return <Badge variant="destructive">Sem estoque</Badge>;
    } else if (estoque <= 10) {
      return <Badge variant="outline" className="bg-yellow-50 text-yellow-700 border-yellow-300">Baixo</Badge>;
    } else {
      return <Badge variant="secondary" className="bg-green-50 text-green-700 border-green-300">Disponível</Badge>;
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header */}
      <header className="bg-white border-b shadow-sm sticky top-0 z-10">
        <div className="container mx-auto px-3 sm:px-4 py-4 sm:py-6">
          <div className="flex items-center justify-between gap-2 sm:gap-3">
            <div className="flex items-center gap-2 sm:gap-3">
              <div className="bg-primary rounded-lg p-1.5 sm:p-2">
                <Package className="h-5 w-5 sm:h-6 sm:w-6 text-white" />
              </div>
              <div>
                <h1 className="text-lg sm:text-2xl font-bold text-gray-900">
                  Tabela de Preços e Estoque
                </h1>
                <p className="text-xs sm:text-sm text-gray-600 hidden sm:block">
                  Consulte preços e disponibilidade de produtos
                </p>
              </div>
            </div>
            <Cart />
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-3 sm:px-4 py-4 sm:py-8">
        {/* Search Section */}
        <Card className="mb-4 sm:mb-8 shadow-xl border-0 bg-gradient-to-br from-blue-500 to-blue-600 text-white">
          <CardHeader className="pb-3 sm:pb-6">
            <CardTitle className="flex items-center gap-2 text-base sm:text-lg text-white">
              <Search className="h-4 w-4 sm:h-5 sm:w-5" />
              Pesquisar Produtos
            </CardTitle>
            <CardDescription className="text-xs sm:text-sm text-blue-100">
              Busque por código ou descrição do produto
            </CardDescription>
          </CardHeader>
          <CardContent className="pt-0">
            <div className="flex flex-col sm:flex-row gap-2">
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                <Input
                  type="text"
                  placeholder="Digite o código ou descrição..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10 h-10 sm:h-10 text-sm sm:text-base bg-white text-gray-900"
                />
              </div>
              <Button
                variant="secondary"
                onClick={() => setSearchTerm("")}
                disabled={!searchTerm}
                className="h-10 sm:h-10 text-sm sm:text-base bg-white text-blue-600 hover:bg-blue-50"
              >
                Limpar
              </Button>
            </div>
            {searchTerm && (
              <p className="mt-2 text-xs sm:text-sm text-white font-medium">
                ✅ {filteredProdutos.length} produto(s) encontrado(s)
              </p>
            )}
          </CardContent>
        </Card>

        {/* Products Table */}
        <Card className="shadow-lg border-0">
          <CardHeader className="pb-3 sm:pb-6">
            <CardTitle className="flex items-center gap-2 text-base sm:text-lg">
              <Barcode className="h-4 w-4 sm:h-5 sm:w-5" />
              Lista de Produtos
            </CardTitle>
          </CardHeader>
          <CardContent className="p-0 sm:p-6">
            {filteredProdutos.length > 0 ? (
              <>
                {/* Mobile - Cards */}
                <div className="block sm:hidden space-y-3 p-3">
                  {filteredProdutos.map((produto) => (
                    <div
                      key={produto.codigo}
                      className="bg-white border rounded-lg p-4 shadow-sm hover:shadow-md transition-shadow"
                    >
                      {/* Cabeçalho do Card */}
                      <div className="flex justify-between items-start mb-3">
                        <div>
                          <span className="text-xs text-gray-500">Código</span>
                          <p className="font-mono font-bold text-sm text-gray-900">
                            {produto.codigo}
                          </p>
                        </div>
                        <div className="text-right">
                          {getEstoqueBadge(produto.estoque)}
                        </div>
                      </div>
                      
                      {/* Descrição */}
                      <h3 className="font-medium text-sm text-gray-900 mb-3">
                        {produto.descricao}
                      </h3>
                      
                      {/* Informações de Preço */}
                      <div className="grid grid-cols-2 gap-3 mb-3">
                        <div className="bg-gray-50 rounded-lg p-2">
                          <span className="text-xs text-gray-600 block">Valor Normal</span>
                          <p className="font-semibold text-sm text-gray-900">
                            {formatCurrency(produto.valor)}
                          </p>
                        </div>
                        <div className="bg-green-50 rounded-lg p-2">
                          <span className="text-xs text-green-700 block flex items-center gap-1">
                            <TrendingUp className="h-3 w-3" />
                            Valor à Vista
                          </span>
                          <p className="font-bold text-sm text-green-700">
                            {formatCurrency(calcularValorAVista(produto.valor))}
                          </p>
                        </div>
                      </div>
                      
                      {/* Estoque */}
                      <div className="flex justify-between items-center pt-2 border-t mb-3">
                        <span className="text-xs text-gray-600">Estoque Disponível</span>
                        <span className="font-bold text-sm text-gray-900">
                          {produto.estoque} unidades
                        </span>
                      </div>
                      
                      {/* Botão Adicionar */}
                      <div className="pt-2">
                        <AddToCartButton produto={produto} />
                      </div>
                    </div>
                  ))}
                </div>

                {/* Desktop - Table */}
                <div className="hidden sm:block overflow-hidden rounded-md border">
                  <Table>
                    <TableHeader>
                      <TableRow className="bg-gray-50">
                        <TableHead className="font-semibold">Código</TableHead>
                        <TableHead className="font-semibold">Descrição</TableHead>
                        <TableHead className="font-semibold text-right">
                          Valor Normal
                        </TableHead>
                        <TableHead className="font-semibold text-right">
                          <div className="flex items-center justify-end gap-1">
                            <TrendingUp className="h-4 w-4 text-green-600" />
                            Valor à Vista
                          </div>
                        </TableHead>
                        <TableHead className="font-semibold text-center">
                          Estoque
                        </TableHead>
                        <TableHead className="font-semibold text-center">
                          Status
                        </TableHead>
                        <TableHead className="font-semibold text-center">
                          Ação
                        </TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {filteredProdutos.map((produto) => (
                        <TableRow key={produto.codigo} className="hover:bg-gray-50">
                          <TableCell className="font-mono font-semibold">
                            {produto.codigo}
                          </TableCell>
                          <TableCell className="font-medium">
                            {produto.descricao}
                          </TableCell>
                          <TableCell className="text-right text-gray-600">
                            {formatCurrency(produto.valor)}
                          </TableCell>
                          <TableCell className="text-right">
                            <span className="font-semibold text-green-600">
                              {formatCurrency(calcularValorAVista(produto.valor))}
                            </span>
                          </TableCell>
                          <TableCell className="text-center font-semibold">
                            {produto.estoque} un.
                          </TableCell>
                          <TableCell className="text-center">
                            {getEstoqueBadge(produto.estoque)}
                          </TableCell>
                          <TableCell className="text-center">
                            <AddToCartButton produto={produto} />
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </div>
              </>
            ) : (
              <div className="text-center py-8 sm:py-12 px-4">
                <Package className="h-10 w-10 sm:h-12 sm:w-12 text-gray-300 mx-auto mb-3" />
                <p className="text-gray-500 font-medium text-sm sm:text-base">
                  Nenhum produto encontrado
                </p>
                <p className="text-xs sm:text-sm text-gray-400 mt-1">
                  Tente buscar por outro termo
                </p>
              </div>
            )}
          </CardContent>
        </Card>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t mt-8 sm:mt-16">
        <div className="container mx-auto px-3 sm:px-4 py-4 sm:py-6 text-center text-xs sm:text-sm text-gray-600">
          <p>© 2025 Sistema de Tabela de Preços e Estoque</p>
          <p className="mt-1 hidden sm:block">Desenvolvido com Next.js e shadcn/ui</p>
        </div>
      </footer>
    </div>
  );
}

