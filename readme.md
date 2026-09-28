# Ejercitación: Ciclo de Vida en React: Control y Optimización (CryptoPulse)

Bienvenido a la cuarta ejercitación práctica del módulo de **React** en Programación II.

En esta actividad pondremos en práctica los conceptos esenciales del **ciclo de vida de los componentes funcionales** utilizando el hook **`useEffect`**. Construiremos **CryptoPulse**, una plataforma de monitoreo y telemetría de criptoactivos en tiempo real donde el usuario puede consultar cotizaciones en vivo, alternar entre activos mediante botones y atajos de teclado globales, y experimentar cómo React gestiona el **montaje**, la **actualización** y el **desmontaje** de componentes, previniendo fugas de memoria (_memory leaks_) mediante funciones de limpieza (_cleanup_).

---

## 🎯 Objetivos de la actividad

1. **Comprender las tres fases del ciclo de vida en React:** Identificar cuándo un componente entra al DOM (**Montaje**), cuándo reacciona a cambios en su estado o propiedades (**Actualización**) y cuándo es removido del DOM (**Desmontaje**).
2. **Dominar el hook `useEffect`:**
   - Configurar efectos que se ejecuten una única vez al montar el componente (dependencias vacías `[]`).
   - Configurar efectos controlados que se re-ejecuten únicamente ante el cambio de variables específicas (`[prop, state]`).
3. **Implementar funciones de limpieza (_cleanups_) de forma rigurosa:** Retornar una función desde el callback de `useEffect` para cancelar temporizadores (`clearInterval`) y remover escuchadores de eventos globales (`window.removeEventListener`).
4. **Interactuar con APIs externas del navegador:** Manipular el título de la pestaña del navegador (`document.title`) y escuchar eventos de teclado en `window`.
5. **Sincronizar el estado ante cambios de props:** Reinicializar contadores de telemetría cuando cambia el elemento activo seleccionado.
6. **Comprobar el ciclo de vida mediante renderizado condicional:** Alternar la visualización del feed en vivo desde el componente raíz (`App.jsx`) para constatar el desmontaje y la destrucción de recursos huérfanos.
7. **Garantizar la calidad de código y build:** Cumplir con los linters canónicos (**ESLint Airbnb**, **Stylelint 16**, **Prettier**) y compilar exitosamente para producción con **Vite**.

---

## 🧠 Fundamentos Teóricos de la Clase

### 1. ¿Qué es el ciclo de vida en React?

Todo componente en React pasa por una serie de etapas a lo largo de su existencia en una aplicación:

```text
       [ 1. MONTAJE ]
  (El componente nace y se
   inserta por primera vez
         en el DOM)
             │
             ▼
    [ 2. ACTUALIZACIÓN ]
(Cambian sus props o estado;
 se vuelve a ejecutar la función
       del componente)
             │
             ▼
     [ 3. DESMONTAJE ]
 (El componente es destruido
  y removido del DOM visual)
```

En las versiones clásicas de React (anteriores a la 16.8), estas fases se gestionaban con métodos de clases como `componentDidMount`, `componentDidUpdate` y `componentWillUnmount`. Con la llegada de los **Hooks**, toda esta lógica se unifica de manera concisa y declarativa en el hook **`useEffect`**.

---

### 2. Anatomía del Hook `useEffect`

El hook `useEffect` recibe dos argumentos:

```javascript
useEffect(callback, [dependencias]);
```

El comportamiento del efecto depende estrictamente del segundo parámetro (el **arreglo de dependencias**):

| Arreglo de dependencias                                 | Momento de ejecución                                          | Equivalencia en clases                     | Caso de uso típico                                                                    |
| :------------------------------------------------------ | :------------------------------------------------------------ | :----------------------------------------- | :------------------------------------------------------------------------------------ |
| **Sin arreglo** (`useEffect(fn)`)                       | Después de **cada** renderizado.                              | `componentDidMount` + `componentDidUpdate` | Registro de métricas generales o depuración.                                          |
| **Arreglo vacío `[]`** (`useEffect(fn, [])`)            | **Solo una vez**, inmediatamente después del montaje inicial. | `componentDidMount`                        | Suscripciones globales (`window.addEventListener`), peticiones HTTP iniciales.        |
| **Con dependencias `[a, b]`** (`useEffect(fn, [a, b])`) | En el montaje inicial y cada vez que cambie `a` o `b`.        | `componentDidUpdate` condicional           | Sincronizar un cronómetro, actualizar el título del documento ante un cambio de dato. |

---

### 3. Funciones de Limpieza (_Cleanup Functions_)

Cuando un efecto crea un recurso persistente en el navegador (como un temporizador `setInterval`, una conexión WebSocket o un listener en `window`), **es imperativo destruirlo** cuando el componente se actualice o se desmonte. De lo contrario, se generan **fugas de memoria** (_memory leaks_): procesos huérfanos que siguen consumiendo CPU y memoria en segundo plano.

Para limpiar un efecto, simplemente **retornamos una función** desde el callback:

```jsx
useEffect(() => {
  // 1. Fase de configuración / suscripción
  const intervalId = setInterval(() => {
    console.log('Tick cada 1 segundo');
  }, 1000);

  // 2. Función de limpieza (Cleanup)
  return () => {
    clearInterval(intervalId); // Se ejecuta antes de volver a correr el efecto y al desmontar
  };
}, [dependencias]);
```

---

## 📁 Arquitectura del Proyecto

```text
src/
├── components/
│   ├── CryptoCard.jsx       # Componente presentacional puro (logo, símbolo, nombre, variación)
│   └── CryptoTicker.jsx     # Componente principal con hooks useEffect, estado y timer
├── data/
│   └── cryptos.json         # Colección de criptoactivos en formato JSON
├── App.css                  # Estilos del contenedor y botón toggle
├── App.jsx                  # Componente contenedor con interruptor de ciclo de vida
├── index.css                # Estilos globales, ticker de mercado y animación live
└── main.jsx                 # Punto de entrada de React 18
```

---

## 📋 Matriz de Entregas e Issues

| Issue # | Título                                                          | Requerimiento Técnico                                                                                                                                                                           | Commit sugerido                                                                    |
| :-----: | :-------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------- |
| **#1**  | **Componente presentacional `CryptoCard`**                      | Recibir `{ asset }`, renderizar logo (`img.crypto-logo`), símbolo, nombre y badge de variación diaria con clase condicional `positive` o `negative`.                                            | `feat: implementar componente presentacional CryptoCard (Closes #1)`               |
| **#2**  | **Navegación circular y sincronización con `useEffect`**        | Declarar estados `index` y `tickSegundos`. Funciones `anterior()` y `siguiente()` con rotación circular (`%`). Efecto dependiente de `[id]` para reiniciar el segundero ante cambios de activo. | `feat: implementar navegacion circular y sincronizacion con useEffect (Closes #2)` |
| **#3**  | **Temporizador de tick en vivo y título con cleanup**           | Efecto dependiente de `[symbol, price, change24h, tickSegundos]` que actualice `document.title`, inicie `setInterval` funcional y retorne obligatoriamente `clearInterval`.                     | `feat: agregar timer de tick y document.title con cleanup (Closes #3)`             |
| **#4**  | **Atajos globales de teclado con limpieza de listener**         | Efecto con dependencias `[]` que registre listener en `window` para `ArrowLeft` y `ArrowRight`, retornando `window.removeEventListener`.                                                        | `feat: registrar atajos de teclado con limpieza de event listener (Closes #4)`     |
| **#5**  | **Control de ciclo de vida en `App.jsx` y validación de build** | Declarar `feedActivo` en `App.jsx`, botón toggle para montar/desmontar `<CryptoTicker />`, validar linters (`npm run lint`) y compilación Vite (`npm run build`).                               | `feat: integrar toggle de feed en App y validar build (Closes #5)`                 |

---

## 🧪 Estrategia de Pruebas y Autoevaluación

Podés validar cada entrega localmente antes de hacer commit utilizando el script de autograding:

```bash
# Validar un criterio específico:
bash scripts/classroom-check.sh structure-check
bash scripts/classroom-check.sh crypto-card
bash scripts/classroom-check.sh asset-sync
bash scripts/classroom-check.sh live-timer-cleanup
bash scripts/classroom-check.sh keyboard-listener-cleanup
bash scripts/classroom-check.sh app-lifecycle-toggle
bash scripts/classroom-check.sh build-check

# Ejecutar la suite completa:
npm test
# (equivale a: bash scripts/classroom-check.sh all)
```

### Calidad de Código (Linters)

Antes de realizar tus entregas, comprobá que tu código cumpla con las reglas canónicas de la cátedra:

```bash
# Verificar ESLint y Stylelint
npm run lint

# Auto-corregir problemas de formato y reglas automáticas
npm run lint:fix

# Verificar formato con Prettier
npm run format:check
```

---

## 🚀 Puesta en Marcha en Local

1. Instalar las dependencias del proyecto:
   ```bash
   npm install
   ```
2. Iniciar el servidor de desarrollo con Hot Module Replacement (HMR):
   ```bash
   npm run dev
   ```
3. Abrir en el navegador: [http://localhost:5173](http://localhost:5173).
