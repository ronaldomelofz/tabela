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
        <div className="container mx-auto px-4 py-6">
          <div className="flex items-center gap-3">
            <div className="bg-primary rounded-lg p-2">
              <Package className="h-6 w-6 text-white" />
            </div>
            <div>
              <h1 className="text-2xl font-bold text-gray-900">
                Tabela de Preços e Estoque
              </h1>
              <p className="text-sm text-gray-600">
                Consulte preços e disponibilidade de produtos
              </p>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        {/* Search Section */}
        <Card className="mb-8 shadow-lg border-0 bg-white/80 backdrop-blur">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Search className="h-5 w-5" />
              Pesquisar Produtos
            </CardTitle>
            <CardDescription>
              Busque por código ou descrição do produto
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex gap-2">
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                <Input
                  type="text"
                  placeholder="Digite o código ou descrição..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10"
                />
              </div>
              <Button
                variant="outline"
                onClick={() => setSearchTerm("")}
                disabled={!searchTerm}
              >
                Limpar
              </Button>
            </div>
            {searchTerm && (
              <p className="mt-2 text-sm text-gray-600">
                {filteredProdutos.length} produto(s) encontrado(s)
              </p>
            )}
          </CardContent>
        </Card>

        {/* Products Table */}
        <Card className="shadow-lg border-0">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Barcode className="h-5 w-5" />
              Lista de Produtos
            </CardTitle>
            <CardDescription>
              Todos os produtos com preços à vista (-10%) e estoque disponível
            </CardDescription>
          </CardHeader>
          <CardContent>
            {filteredProdutos.length > 0 ? (
              <div className="rounded-md border overflow-hidden">
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
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>
            ) : (
              <div className="text-center py-12">
                <Package className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                <p className="text-gray-500 font-medium">
                  Nenhum produto encontrado
                </p>
                <p className="text-sm text-gray-400 mt-1">
                  Tente buscar por outro termo
                </p>
              </div>
            )}
          </CardContent>
        </Card>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t mt-16">
        <div className="container mx-auto px-4 py-6 text-center text-sm text-gray-600">
          <p>© 2025 Sistema de Tabela de Preços e Estoque</p>
          <p className="mt-1">Desenvolvido com Next.js e shadcn/ui</p>
        </div>
      </footer>
    </div>
  );
}

