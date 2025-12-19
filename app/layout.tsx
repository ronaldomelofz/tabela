import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { CartProvider } from "@/lib/cart-context";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Tabela de Preços e Estoque",
  description: "Sistema de consulta de preços e estoque de produtos",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="pt-BR">
      <body className={inter.className}>
        <CartProvider>
          {children}
        </CartProvider>
      </body>
    </html>
  );
}

