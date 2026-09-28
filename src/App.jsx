import { useState } from 'react';
import CryptoTicker from './components/CryptoTicker';
import './App.css';

/**
 * Componente: App
 * TODO [Issue #5]:
 * - Declarar el estado booleano feedActivo inicializado en true con useState(true).
 * - Renderizar el botón con clase toggle-feed-btn que alterne el valor de feedActivo entre true y false.
 * - Renderizar condicionalmente <CryptoTicker /> únicamente cuando feedActivo sea true.
 */
export default function App() {
  // TODO [Issue #5]: Declarar estado feedActivo con useState(true)

  return (
    <div className='app-container'>
      <header className='app-header'>
        <div className='brand'>
          <h1 className='brand-title'>
            <span className='brand-gradient'>CryptoPulse</span>
          </h1>
          <p className='brand-subtitle'>Monitor de Cotizaciones y Telemetría en Tiempo Real</p>
        </div>
        {/* TODO [Issue #5]: Botón toggle para pausar o reanudar el feed */}
      </header>

      <main className='app-main'>
        {/* TODO [Issue #5]: Renderizado condicional de CryptoTicker */}
      </main>
    </div>
  );
}
