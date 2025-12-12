"use client";

import { Search } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";

interface ProductSearchProps {
  searchTerm: string;
  onSearchChange: (value: string) => void;
  resultsCount: number;
}

export function ProductSearch({
  searchTerm,
  onSearchChange,
  resultsCount,
}: ProductSearchProps) {
  return (
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
              onChange={(e) => onSearchChange(e.target.value)}
              className="pl-10"
            />
          </div>
          <Button
            variant="outline"
            onClick={() => onSearchChange("")}
            disabled={!searchTerm}
          >
            Limpar
          </Button>
        </div>
        {searchTerm && (
          <p className="mt-2 text-sm text-gray-600">
            {resultsCount} produto(s) encontrado(s)
          </p>
        )}
      </CardContent>
    </Card>
  );
}

