import React from 'react';

/**
 * Componente: CryptoCard
 * TODO [Issue #1]:
 * - Recibe la prop desestructurada: { asset }.
 * - Renderiza el contenedor principal con className='crypto-card'.
 * - Renderiza una etiqueta <img /> con src={asset.logo}, alt={`${asset.name} logo`} y className='crypto-logo'.
 * - Renderiza el contenedor div.crypto-info con:
 *   - span.crypto-symbol mostrando asset.symbol
 *   - h2.crypto-name mostrando asset.name
 * - Renderiza el porcentaje de cambio (asset.change24h) en un span con className='crypto-change'
 *   y clase condicional 'positive' o 'negative' según el signo.
 */
export default function CryptoCard({ asset = {} }) {
  // TODO [Issue #1]: Calcular si el cambio de 24h es positivo o negativo

  return (
    <div className='crypto-card'>
      {/* TODO [Issue #1]: Renderizar logo, info (símbolo, nombre) y variación porcentual */}
    </div>
  );
}
