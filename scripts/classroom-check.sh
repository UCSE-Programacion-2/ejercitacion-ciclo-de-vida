#!/usr/bin/env bash
# Verificaciones automáticas — Ciclo de Vida en React: Control y Optimización (CryptoPulse)
# Cada subcomando valida un criterio puntual sobre el código fuente y build.
set -u

SRC_DIR="src"
COMPONENTS_DIR="src/components"
DATA_FILE="src/data/cryptos.json"
CRYPTO_CARD_JSX="src/components/CryptoCard.jsx"
CRYPTO_TICKER_JSX="src/components/CryptoTicker.jsx"
APP_JSX="src/App.jsx"
APP_CSS="src/App.css"
INDEX_CSS="src/index.css"
MAIN_JSX="src/main.jsx"
INDEX_HTML="index.html"
VITE_CONFIG="vite.config.js"

fail() {
  echo "$1" >&2
  exit 1
}

ok() {
  echo CORRECTO
}

# Limpia comentarios multilínea JSX y comentarios JS de una sola línea
clean_file() {
  local target="$1"
  local NODE_BIN=""
  if command -v node >/dev/null 2>&1; then
    NODE_BIN="node"
  elif command -v node.exe >/dev/null 2>&1; then
    NODE_BIN="node.exe"
  fi

  if [[ -n "$NODE_BIN" ]]; then
    "$NODE_BIN" -e "
      const fs = require('fs');
      if (!fs.existsSync('$target')) process.exit(0);
      let code = fs.readFileSync('$target', 'utf8');
      code = code.replace(/\{\/\*[\s\S]*?\*\/\}/g, ' ');
      code = code.replace(/\/\*[\s\S]*?\*\//g, ' ');
      code = code.replace(/(^|[^:])\/\/.*$/gm, '\$1 ');
      code = code.replace(/\s+/g, ' ');
      process.stdout.write(code);
    "
  else
    tr '\n' ' ' < "$target" | sed -e 's|{/\*.*\*/}| |g' -e 's|\([^:]\)//.*$|\1 |g'
  fi
}

case "${1:-}" in
  structure-check)
    [[ -d "$COMPONENTS_DIR" ]]    || fail "No se encontró la carpeta src/components/."
    [[ -f "$CRYPTO_CARD_JSX" ]]   || fail "No se encontró src/components/CryptoCard.jsx."
    [[ -f "$CRYPTO_TICKER_JSX" ]] || fail "No se encontró src/components/CryptoTicker.jsx."
    [[ -f "$DATA_FILE" ]]         || fail "No se encontró src/data/cryptos.json."
    [[ -f "$APP_JSX" ]]           || fail "No se encontró src/App.jsx."
    [[ -f "$APP_CSS" ]]           || fail "No se encontró src/App.css."
    [[ -f "$INDEX_CSS" ]]         || fail "No se encontró src/index.css."
    [[ -f "$MAIN_JSX" ]]          || fail "No se encontró src/main.jsx."
    [[ -f "$INDEX_HTML" ]]        || fail "No se encontró index.html en la raíz del proyecto."
    [[ -f "$VITE_CONFIG" ]]       || fail "No se encontró vite.config.js."
    ok
    ;;

  crypto-card)
    [[ -f "$CRYPTO_CARD_JSX" ]] || fail "No se encontró src/components/CryptoCard.jsx."

    clean_card=$(clean_file "$CRYPTO_CARD_JSX")

    # Debe recibir la prop asset desestructurada
    if ! echo "$clean_card" | grep -qE '\(\s*\{[^}]*asset'; then
      fail "CryptoCard.jsx debe recibir la prop 'asset' desestructurada."
    fi

    # Debe renderizar imagen del logo con src={asset.logo} y alt descriptivo
    if ! echo "$clean_card" | grep -qE '<img[^>]*asset\.logo'; then
      fail "CryptoCard debe renderizar una etiqueta <img ... /> vinculando asset.logo."
    fi

    # Debe renderizar el símbolo y nombre del criptoactivo
    if ! echo "$clean_card" | grep -qE 'asset\.symbol' || ! echo "$clean_card" | grep -qE 'asset\.name'; then
      fail "CryptoCard debe renderizar el símbolo (asset.symbol) y nombre (asset.name) del criptoactivo."
    fi

    # Debe renderizar el porcentaje de cambio o la clase crypto-change
    if ! echo "$clean_card" | grep -qE 'crypto-change|asset\.change24h'; then
      fail "CryptoCard debe renderizar el porcentaje de cambio (asset.change24h) con la clase 'crypto-change'."
    fi
    ok
    ;;

  asset-sync)
    [[ -f "$CRYPTO_TICKER_JSX" ]] || fail "No se encontró src/components/CryptoTicker.jsx."

    clean_ticker=$(clean_file "$CRYPTO_TICKER_JSX")

    # Debe usar useState para controlar el índice del activo
    if ! echo "$clean_ticker" | grep -qE 'useState\s*\(\s*0\s*\)'; then
      fail "CryptoTicker debe declarar un estado con useState(0) para gestionar el activo seleccionado."
    fi

    # Debe implementar navegación circular (operador módulo %)
    if ! echo "$clean_ticker" | grep -qE '%\s*[a-zA-Z0-9_]*\.?length'; then
      fail "CryptoTicker debe implementar navegación circular en sus funciones anterior/siguiente usando el operador módulo (%) con la longitud de los datos."
    fi

    # Debe tener un useEffect para sincronizar el estado ante cambios de activo (dependencia de id o asset)
    if ! echo "$clean_ticker" | grep -qE 'useEffect\s*\([^[]*,\s*\[[^]]*(id|asset)'; then
      fail "CryptoTicker debe incluir un useEffect con dependencia [id] o [asset] para reiniciar el segundero de tick ante cambios de activo."
    fi
    ok
    ;;

  live-timer-cleanup)
    [[ -f "$CRYPTO_TICKER_JSX" ]] || fail "No se encontró src/components/CryptoTicker.jsx."

    clean_ticker=$(clean_file "$CRYPTO_TICKER_JSX")

    # Debe actualizar document.title con la información del activo
    if ! echo "$clean_ticker" | grep -qE 'document\.title\s*='; then
      fail "CryptoTicker debe actualizar dinámicamente document.title con la cotización del activo en vivo."
    fi

    # Debe configurar un temporizador con setInterval
    if ! echo "$clean_ticker" | grep -qE 'setInterval\s*\('; then
      fail "CryptoTicker debe configurar un temporizador mediante setInterval() dentro de un useEffect."
    fi

    # Debe retornar una función de limpieza que invoque clearInterval
    if ! echo "$clean_ticker" | grep -qE 'return\s*(\(\s*\)\s*=>\s*\{?\s*clearInterval|function[^{]*\{[^}]*clearInterval)'; then
      fail "El efecto del temporizador en CryptoTicker debe retornar una función de limpieza (cleanup) que ejecute clearInterval()."
    fi
    ok
    ;;

  keyboard-listener-cleanup)
    [[ -f "$CRYPTO_TICKER_JSX" ]] || fail "No se encontró src/components/CryptoTicker.jsx."

    clean_ticker=$(clean_file "$CRYPTO_TICKER_JSX")

    # Debe registrar addEventListener para keydown en window
    if ! echo "$clean_ticker" | grep -qE "window\.addEventListener\s*\(\s*['\"]keydown['\"]"; then
      fail "CryptoTicker debe registrar un listener de eventos con window.addEventListener('keydown', ...) en un useEffect."
    fi

    # Debe escuchar las teclas ArrowLeft y ArrowRight
    if ! echo "$clean_ticker" | grep -qE 'ArrowLeft' || ! echo "$clean_ticker" | grep -qE 'ArrowRight'; then
      fail "El manejador de teclado en CryptoTicker debe evaluar las teclas 'ArrowLeft' y 'ArrowRight'."
    fi

    # Debe remover el listener en la función de limpieza
    if ! echo "$clean_ticker" | grep -qE "window\.removeEventListener\s*\(\s*['\"]keydown['\"]"; then
      fail "El efecto de atajos de teclado debe retornar una función de limpieza que invoque window.removeEventListener('keydown', ...)."
    fi

    # Debe tener array de dependencias vacío [] para registrarse solo al montar
    if ! echo "$clean_ticker" | grep -qE 'addEventListener[^{}]*;\s*return[^{}]*removeEventListener[^}]*\}\s*,\s*\[\s*\]\s*\)'; then
      # Verificación alternativa más flexible
      if ! echo "$clean_ticker" | grep -qE '\[\s*\]\s*\)'; then
        fail "El efecto de suscripción a teclas globales debe tener un arreglo de dependencias vacío [] para ejecutarse solo al montar."
      fi
    fi
    ok
    ;;

  app-lifecycle-toggle)
    [[ -f "$APP_JSX" ]] || fail "No se encontró src/App.jsx."

    clean_app=$(clean_file "$APP_JSX")

    # Debe tener un estado booleano para controlar el feed en vivo
    if ! echo "$clean_app" | grep -qE 'useState\s*\(\s*true\s*\)'; then
      fail "App.jsx debe declarar un estado booleano inicializado en true (useState(true)) para controlar el ciclo de vida del feed."
    fi

    # Debe renderizar condicionalmente el componente CryptoTicker
    if ! echo "$clean_app" | grep -qE '<CryptoTicker'; then
      fail "App.jsx debe renderizar el componente <CryptoTicker />."
    fi

    # Debe contar con un botón para alternar el estado
    if ! echo "$clean_app" | grep -qE '<button[^>]*onClick'; then
      fail "App.jsx debe contar con un botón interactivo que alterne el estado para montar y desmontar el ticker."
    fi
    ok
    ;;

  build-check|vite-build)
    npm run build >/dev/null 2>&1 || fail "El proyecto no compila correctamente con 'npm run build'. Revisa errores de sintaxis JSX o importaciones."
    ok
    ;;

  all)
    bash "$0" structure-check || exit 1
    bash "$0" crypto-card || exit 1
    bash "$0" asset-sync || exit 1
    bash "$0" live-timer-cleanup || exit 1
    bash "$0" keyboard-listener-cleanup || exit 1
    bash "$0" app-lifecycle-toggle || exit 1
    bash "$0" build-check || exit 1
    ok
    ;;

  *)
    fail "Subcomando no reconocido: ${1:-}. Opciones: structure-check, crypto-card, asset-sync, live-timer-cleanup, keyboard-listener-cleanup, app-lifecycle-toggle, build-check, all"
    ;;
esac
