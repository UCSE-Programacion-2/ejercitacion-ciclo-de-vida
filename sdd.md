# SDD: Ejercitación — Ciclo de Vida en React: Control y Optimización (CryptoPulse Live Ticker)

Este documento define la especificación técnica, pedagógica y evaluativa bajo la metodología **Spec Driven Development (SDD)** para la ejercitación correspondiente a la **Clase 36** de la cátedra de **Programación II**.

---

## 1. 🎯 Ficha Técnica y Objetivos Pedagógicos

- **Cátedra:** Programación II — Ingeniería en Informática / Licenciatura en Sistemas.
- **Unidad temática:** Unidad 4 — Librería React.js (Creación y ciclo de vida de componentes funcionales).
- **Clase asociada:** Clase 36 (28/09) — _Ciclo de Vida en React: Control y Optimización_.
- **Sprint integrador:** Sprint 4 — _Modernización (React) & Deploy_.
- **Repositorio de referencia visto en clase:** `Worlds-2025-LoL` (Match Center de Esports).
- **Contenidos teóricos asociados:** `contenidos.html` (Ciclo de vida en componentes de clase vs. componentes funcionales con Hooks, fases de Montaje, Actualización y Desmontaje, hook `useEffect`, funciones de limpieza _cleanup_).
- **Estrategia pedagógica:** **Proyecto Isomórfico de Transferencia Cognitiva**. En lugar de replicar de forma mimética el código de la grabación de clase, los estudiantes aplican exactamente la misma arquitectura y patrones de ciclo de vida (sincronización de estado ante cambios de props, temporizadores con cleanup, listeners globales con desuscripción, y renderizado condicional de montaje/desmontaje) en un nuevo dominio profesional: **CryptoPulse**, un monitor financiero de cotizaciones de criptoactivos en tiempo real.

### Objetivos de Aprendizaje:

1. **Comprender las tres fases esenciales del ciclo de vida en React:** Montaje (_Mounting_), Actualización (_Updating_) y Desmontaje (_Unmounting_).
2. **Dominar el hook `useEffect` en componentes funcionales según el arreglo de dependencias:**
   - Efecto de única ejecución en montaje inicial con array vacío (`[]`), equivalente a `componentDidMount`.
   - Efecto controlado con dependencias específicas (`[prop, state]`), equivalente a `componentDidUpdate`.
3. **Implementar funciones de limpieza (_cleanups_) de forma estricta:** Retornar una función desde el callback de `useEffect` para cancelar temporizadores (`clearInterval`) y desuscribir eventos del navegador (`window.removeEventListener`), previniendo _memory leaks_ (fugas de memoria) y suscripciones huérfanas al desmontar el componente (`componentWillUnmount`).
4. **Interactuar con APIs del navegador como efectos secundarios:** Modificar dinámicamente `document.title` y capturar eventos globales de teclado (`keydown`).
5. **Sincronizar el estado interno ante cambios en las propiedades recibidas:** Reinicializar variables de estado local (`tickSegundos`) cuando cambia el activo seleccionado (`id`).
6. **Evidenciar el ciclo de vida completo mediante renderizado condicional:** Crear un control en `App.jsx` para montar y desmontar el ticker en vivo, confirmando la ejecución de los mecanismos de desmontaje y limpieza.
7. **Asegurar la calidad de código y build de producción:** Superar las pruebas estáticas de linters canónicos (**ESLint Airbnb**, **Stylelint 16**, **Prettier**) y la transpilación limpia de **Vite** (`npm run build`).

---

## 2. 📈 Dominio y Alcance Funcional

### Contexto Profesional:

Se desarrollará **CryptoPulse**, una aplicación de monitoreo financiero y telemetría de cotizaciones cripto en tiempo real. La interfaz simula la recepción continua de ticks de mercado, actualiza un temporizador de actualización, refleja la cotización del activo en el título de la pestaña del navegador y permite alternar rápidamente entre diferentes monedas mediante controles de pantalla y atajos globales de teclado.

### Colección de Datos (`src/data/cryptos.json`):

Cinco activos principales con identificador, nombre, símbolo, logotipo, precio base en USD, variación porcentual 24h y red de liquidación:

1. **Bitcoin (BTC):** `$64,250.00 USD`, `+2.45%`, red _Bitcoin Network_.
2. **Ethereum (ETH):** `$3,480.00 USD`, `+1.80%`, red _Ethereum Mainnet_.
3. **Solana (SOL):** `$154.50 USD`, `+5.12%`, red _Solana Core_.
4. **Cardano (ADA):** `$0.48 USD`, `-0.65%`, red _Cardano Settlement_.
5. **Polkadot (DOT):** `$6.85 USD`, `+0.92%`, red _Polkadot Relay_.

### Requerimientos Funcionales:

1. **Visualización de Criptoactivo en Vivo (`CryptoTicker.jsx`):**
   - Mostrar el encabezado de la plataforma con badge indicador pulsante `● LIVE FEED` y nombre de la red del activo.
   - Mostrar el precio actual formateado en dólares estadounidenses y la variación porcentual de las últimas 24 horas (con clase temática positiva/verde o negativa/roja).
   - Mostrar un contador de segundos transcurridos desde el último tick de telemetría (`tickSegundos`).
2. **Componente Presentacional de Activo (`CryptoCard.jsx`):**
   - Renderizar el logo oficial del criptoactivo, su símbolo (`BTC`, `ETH`, etc.), el nombre completo y el badge de variación diaria recibido por props (`asset`).
3. **Sincronización por Activo:**
   - Al navegar a una nueva criptomoneda, el contador de tick de telemetría debe reinicializarse a `0` segundos automáticamente mediante un `useEffect` con dependencias `[id]`.
4. **Temporizador en Tiempo Real y Título de Pestaña:**
   - Un temporizador (`setInterval`) debe simular el avance de la sesión de mercado incrementando `tickSegundos` cada segundo.
   - La pestaña del navegador debe actualizar dinámicamente su título (`document.title`) reflejando la moneda y cotización actual: `[BTC] $64,250.00 USD ▲ | CryptoPulse`.
   - Al alternar de moneda o desmontar el componente, el temporizador debe cancelarse inmediatamente (`clearInterval`).
5. **Navegación Circular y Atajos de Teclado:**
   - Botones interactivos `← Anterior` y `Siguiente →` para navegar cíclicamente por el catálogo de criptomonedas.
   - Atajos globales de teclado: flecha izquierda (`ArrowLeft`) y flecha derecha (`ArrowRight`) en cualquier foco de la pantalla.
   - El event listener en `window` debe registrarse únicamente al montar (`[]`) y removerse obligatoriamente al desmontar (`removeEventListener`).
6. **Interruptor de Montaje/Desmontaje en `App.jsx`:**
   - Un botón en la barra superior ("Detener Feed" / "Reanudar Feed") que permita ocultar o mostrar el ticker en vivo, permitiendo verificar y auditar el ciclo de vida completo de montaje y desmontaje.

---

## 3. 🏗️ Arquitectura de Componentes y Estado

### Árbol Jerárquico de Componentes:

```text
App (Estado: feedActivo)
 │
 ├── header (Branding CryptoPulse y botón toggle para pausar/reanudar feed)
 │
 └── CryptoTicker (Estado: index, tickSegundos) [Se monta/desmonta condicionalmente]
      ├── header (Red del activo, badge LIVE FEED)
      ├── CryptoCard (Props: asset)
      ├── price-box (Cotización formateada USD, variación 24h, segundero de tick)
      └── footer (Botones de navegación ← Anterior y Siguiente →)
```

### Contratos de Componentes:

| Componente             | Responsabilidad                                                                                             | Props Recibidas                                                             | Estado Local (`useState`)                                                 | Hooks de Ciclo de Vida (`useEffect`)                                                                                                                                                                    |
| :--------------------- | :---------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------- | :------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **`App.jsx`**          | Contenedor raíz; gestiona el branding y el interruptor de montaje/desmontaje del feed en vivo.              | Ninguna                                                                     | `feedActivo` (`boolean`, default: `true`)                                 | Ninguno                                                                                                                                                                                                 |
| **`CryptoTicker.jsx`** | Administra el activo en pantalla, el temporizador de tick, el título de la pestaña y los atajos de teclado. | Ninguna (consume `cryptosData` desde `cryptos.json`)                        | `index` (`number`, default: `0`), `tickSegundos` (`number`, default: `0`) | **Efecto 1:** Sincronización de tick (`[id]`)<br>**Efecto 2:** Timer y `document.title` con cleanup (`[symbol, price, tickSegundos]`)<br>**Efecto 3:** Atajos de teclado en `window` con cleanup (`[]`) |
| **`CryptoCard.jsx`**   | Componente presentacional puro que renderiza los datos visuales de la criptomoneda.                         | `asset` (`object`: `{ id, name, symbol, logo, price, change24h, network }`) | Ninguno                                                                   | Ninguno                                                                                                                                                                                                 |

### Detalle de los Hooks de Ciclo de Vida (`useEffect`):

1. **Efecto 1: Sincronización de Estado Local (Fase de Actualización con Dependencias):**

   ```jsx
   useEffect(() => {
     setTickSegundos(0);
   }, [id]);
   ```

   _Propósito:_ Al cambiar el activo seleccionado, reinicializa el segundero de telemetría a 0.

2. **Efecto 2: Temporizador de Mercado y Título de Pestaña (Fase de Montaje/Actualización con Cleanup):**

   ```jsx
   useEffect(() => {
     const formattedPrice = price.toLocaleString('en-US', { minimumFractionDigits: 2 });
     const arrow = change24h >= 0 ? '▲' : '▼';
     document.title = `[${symbol}] $${formattedPrice} USD ${arrow} | CryptoPulse`;

     const interval = setInterval(() => {
       setTickSegundos(prev => prev + 1);
     }, 1000);

     return () => {
       clearInterval(interval);
     };
   }, [symbol, price, change24h, tickSegundos]);
   ```

   _Propósito:_ Actualiza `document.title` y configura un intervalo. Retorna la función de limpieza obligatoria con `clearInterval`.

3. **Efecto 3: Atajos Globales de Teclado (Fase de Montaje Único con Cleanup en Desmontaje):**
   ```jsx
   useEffect(() => {
     const onKey = e => {
       if (e.key === 'ArrowLeft') anterior();
       if (e.key === 'ArrowRight') siguiente();
     };

     window.addEventListener('keydown', onKey);

     return () => {
       window.removeEventListener('keydown', onKey);
     };
   }, []);
   ```
   _Propósito:_ Registra el listener global en `window` solo al montar (`[]`). Remueve el listener al desmontar para evitar llamadas huérfanas y fugas de memoria.

---

## 4. 📋 Matriz de Issues de GitHub Classroom

| Issue # | Título de la Issue                                              | Requerimiento Técnico y Criterios de Aceptación                                                                                                                                                                                                                                                                                                                                                                                                                             | Commit sugerido                                                                    |
| :-----: | :-------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------- |
| **#1**  | **Componente presentacional `CryptoCard`**                      | - Crear `src/components/CryptoCard.jsx`.<br>- Recibir por props desestructuradas `{ asset }`.<br>- Renderizar contenedor `<div className="crypto-card">`.<br>- Renderizar `<img>` con `src={asset.logo}`, `alt={`${asset.name} logo`}` y clase `crypto-logo`.<br>- Renderizar contenedor `div.crypto-info` con `span.crypto-symbol` y `h2.crypto-name`.<br>- Renderizar badge de variación 24h con clase `crypto-change` y modificador condicional `positive` o `negative`. | `feat: implementar componente presentacional CryptoCard (Closes #1)`               |
| **#2**  | **Navegación circular y sincronización con `useEffect`**        | - En `src/components/CryptoTicker.jsx`, declarar estados `index` y `tickSegundos`.<br>- Implementar navegación circular para `anterior` (`(i - 1 + total) % total`) y `siguiente` (`(i + 1) % total`).<br>- Vincular botones de navegación del footer con los eventos `onClick`.<br>- Implementar `useEffect` con dependencias `[id]` para reiniciar `tickSegundos` a 0 al cambiar de activo.                                                                               | `feat: implementar navegacion circular y sincronizacion con useEffect (Closes #2)` |
| **#3**  | **Temporizador de tick en vivo y título con cleanup**           | - Implementar `useEffect` con dependencias `[symbol, price, change24h, tickSegundos]`.<br>- Actualizar `document.title` con la cotización en USD y flecha de tendencia.<br>- Iniciar `setInterval` que incremente `tickSegundos` usando actualización funcional `setTickSegundos(prev => prev + 1)`.<br>- **Retornar función de limpieza** que invoque `clearInterval(interval)`.                                                                                           | `feat: agregar timer de tick y document.title con cleanup (Closes #3)`             |
| **#4**  | **Atajos globales de teclado con limpieza de listener**         | - Implementar `useEffect` con array de dependencias vacío `[]`.<br>- Manejar evento de teclado para `ArrowLeft` y `ArrowRight`.<br>- Suscribir evento con `window.addEventListener('keydown', onKey)`.<br>- **Retornar función de limpieza** con `window.removeEventListener('keydown', onKey)`.                                                                                                                                                                            | `feat: registrar atajos de teclado con limpieza de event listener (Closes #4)`     |
| **#5**  | **Control de ciclo de vida en `App.jsx` y validación de build** | - En `src/App.jsx`, declarar estado `feedActivo` (`useState(true)`).<br>- Renderizar botón con clase `toggle-feed-btn` para alternar entre "Pausar Feed en Vivo" y "Reanudar Feed".<br>- Renderizar condicionalmente `{feedActivo && <CryptoTicker />}`.<br>- Validar compilación de producción con `npm run build` y reglas de linters (`npm run lint`).                                                                                                                   | `feat: integrar toggle de feed en App y validar build (Closes #5)`                 |

---

## 5. 🧪 Estrategia de Autoevaluación (`scripts/classroom-check.sh`)

### Subcomandos y Criterios de Evaluación POSIX:

| Subcomando                  | Propósito                        | Criterio de Verificación POSIX                                                                                                    | Salida Éxito        | Salida Fallo                                                    |
| :-------------------------- | :------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------- | :------------------ | :-------------------------------------------------------------- |
| `structure-check`           | Integridad de archivos           | Verifica existencia de `CryptoCard.jsx`, `CryptoTicker.jsx`, `cryptos.json`, `App.jsx`, `index.css`, configs canónicas y linters. | `CORRECTO` (exit 0) | Mensaje indicando archivo faltante (exit 1)                     |
| `crypto-card`               | Verificación de `CryptoCard.jsx` | Valida prop `asset`, renderizado de `asset.logo`, `asset.symbol`, `asset.name` y badge de variación condicional.                  | `CORRECTO` (exit 0) | Mensaje descriptivo de discrepancia (exit 1)                    |
| `asset-sync`                | Navegación y sincronización      | Valida `useState` de `index`, navegación circular en botones y `useEffect` dependiente de `id`.                                   | `CORRECTO` (exit 0) | Mensaje indicando error de sincronización o navegación (exit 1) |
| `live-timer-cleanup`        | Timer y función de limpieza      | Valida modificación de `document.title`, uso de `setInterval` y presencia obligatoria de `clearInterval` en el return del efecto. | `CORRECTO` (exit 0) | Mensaje acusando ausencia de timer o cleanup (exit 1)           |
| `keyboard-listener-cleanup` | Listener de ventana y cleanup    | Valida `useEffect` con `[]`, llamada a `addEventListener('keydown')` y desuscripción con `removeEventListener`.                   | `CORRECTO` (exit 0) | Mensaje señalando listener huérfano sin cleanup (exit 1)        |
| `app-lifecycle-toggle`      | Renderizado condicional en `App` | Valida estado `feedActivo`, botón toggle y renderizado condicional de `<CryptoTicker />`.                                         | `CORRECTO` (exit 0) | Mensaje señalando falta de toggle de ciclo de vida (exit 1)     |
| `build-check`               | Compilación Vite                 | Ejecuta `npm run build` verificando generación limpia en `dist/` sin errores de transpilación JSX.                                | `CORRECTO` (exit 0) | Mensaje con log de fallo de Vite (exit 1)                       |
| `all`                       | Suite integral                   | Ejecuta todos los subcomandos anteriores en orden secuencial.                                                                     | `CORRECTO` (exit 0) | Detiene en el primer fallo                                      |

### Configuración sugerida para Classmoji.io:

- **Método:** `Run command`.
- **Setup command:** `npm install`.
- **Timeout:** `2` minutos por test granular; `5` minutos para el test global (`all`).
- **Tests individuales:**
  1. `1. Estructura y Archivos Canónicos` ➔ `bash scripts/classroom-check.sh structure-check`
  2. `2. Componente Presentacional CryptoCard` ➔ `bash scripts/classroom-check.sh crypto-card`
  3. `3. Navegación Circular y Sincronización` ➔ `bash scripts/classroom-check.sh asset-sync`
  4. `4. Temporizador de Tick y Cleanup` ➔ `bash scripts/classroom-check.sh live-timer-cleanup`
  5. `5. Event Listener de Teclado y Desuscripción` ➔ `bash scripts/classroom-check.sh keyboard-listener-cleanup`
  6. `6. Interruptor de Ciclo de Vida en App` ➔ `bash scripts/classroom-check.sh app-lifecycle-toggle`
  7. `7. Compilación de Producción Vite` ➔ `bash scripts/classroom-check.sh build-check`

---

## 6. 📁 Estructura de Archivos Planificada para la Plantilla

```text
Ejercitacion-Ciclo-de-Vida/
├── .github/
│   └── workflows/
│       ├── classroom.yml          # Autograding oficial con io-grader por cada issue
│       └── setup-issues.yml       # Generación idempotente de las 5 issues
├── .vscode/
│   ├── extensions.json            # Extensiones recomendadas (ESLint, Prettier, Stylelint)
│   └── settings.json              # Configuración de auto-formateo al guardar
├── public/
│   └── vite.svg                   # Favicon oficial
├── scripts/
│   └── classroom-check.sh         # Script de autograding con subcomandos POSIX
├── src/
│   ├── components/
│   │   ├── CryptoCard.jsx         # Componente presentacional con stub guiado
│   │   └── CryptoTicker.jsx       # Componente principal con stubs guiados y TODOs
│   ├── data/
│   │   └── cryptos.json           # Colección de criptoactivos y cotizaciones
│   ├── App.css                    # Estilos de la barra de navegación y botón toggle
│   ├── App.jsx                    # Componente contenedor con toggle de ciclo de vida
│   ├── index.css                  # Estilos del ticker financiero, animación live y reset
│   └── main.jsx                   # Entrada estándar de React 18 con createRoot
├── .eslintrc.json                 # Configuración canónica Airbnb + React Vite
├── .gitignore                     # Exclusiones estándar (node_modules, dist, contenidos.html, Worlds-2025-LoL, etc.)
├── .prettierignore                # Exclusiones de formateo
├── .prettierrc.js                 # Reglas canónicas Prettier
├── .stylelintrc.json              # Configuración canónica Stylelint 16
├── index.html                     # Entrada HTML de Vite con <div id="root">
├── package.json                   # Dependencias estándar (React 18, Vite 5) y scripts
├── readme.md                      # Enunciado completo, conceptos teóricos y tabla de commits
├── sdd.md                         # Este documento de especificación formal SDD
└── vite.config.js                 # Configuración de Vite con @vitejs/plugin-react
```

---

## 🛑 Puerta de Control: Estado de Aprobación

- **Estado actual:** `PENDIENTE DE APROBACIÓN DOCENTE (REVISIÓN V2 - CRYPTOPULSE)`.
- **Acción requerida:** El docente debe revisar esta especificación y responder con su aprobación explícita o solicitudes de ajuste antes de iniciar la Fase 2 (creación de archivos, código JSX, scripts y workflows).
