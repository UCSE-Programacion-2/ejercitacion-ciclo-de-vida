import { useState, useEffect } from 'react';
import cryptosData from '../data/cryptos.json';
import CryptoCard from './CryptoCard';

/**
 * Componente: CryptoTicker
 * TODO [Issues #2, #3, #4]:
 * - [Issue #2]: Gestionar el estado index (default: 0) y tickSegundos (default: 0).
 *               Implementar funciones anterior() y siguiente() con rotación circular (%).
 *               Implementar useEffect dependiente de [id] para reiniciar tickSegundos a 0.
 * - [Issue #3]: Implementar useEffect para el temporizador de mercado con setInterval
 *               y actualización de document.title, retornando su función de limpieza con clearInterval.
 * - [Issue #4]: Implementar useEffect con dependencias [] para escuchar atajos de teclado (ArrowLeft, ArrowRight)
 *               en window, retornando su función de limpieza con window.removeEventListener.
 */
export default function CryptoTicker() {
  // TODO [Issue #2]: Declarar estado index y tickSegundos con useState

  // TODO [Issue #2]: Obtener activo seleccionado a partir de cryptosData e index

  // TODO [Issue #2]: Implementar funciones anterior() y siguiente() con operador módulo (%)

  // TODO [Issue #2]: useEffect con dependencias [id] para reiniciar tickSegundos a 0

  // TODO [Issue #3]: useEffect con setInterval y document.title (con retorno de cleanup clearInterval)

  // TODO [Issue #4]: useEffect con [] para escuchar keydown en window (con retorno de cleanup removeEventListener)

  return (
    <section className='crypto-ticker'>
      {/* TODO [Issue #2]: Renderizar ticker-header, CryptoCard, price-box y ticker-footer con botones de navegación */}
    </section>
  );
}
