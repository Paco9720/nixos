```bash
#!/usr/bin/env bash

set -euo pipefail

# =========================================================
# NixOS Desktop Installer
#
# Este script está pensado para ejecutarse DESPUÉS
# del instalador gráfico de NixOS.
#
# El instalador gráfico se encarga de:
#   - Particiones
#   - Bootloader
#   - Usuario
#   - Contraseña
#   - Idioma
#   - Teclado
#   - Zona horaria
#   - Red
#   - Hardware
#
# Este script solamente configura:
#   - Escritorio
#   - Perfil Minimal / Completa
# =========================================================

NIXOS_DIR="/etc/nixos"
CONFIG="$NIXOS_DIR/configuration.nix"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

DESKTOP_DIR="$SCRIPT_DIR/desktops"
PROFILE_DIR="$SCRIPT_DIR/profiles"

DESKTOP_OUTPUT="$NIXOS_DIR/desktop.nix"
PROFILE_OUTPUT="$NIXOS_DIR/profile.nix"

# =========================================================
# Colores
# =========================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

# =========================================================
# Funciones
# =========================================================

error() {
    echo -e "${RED}Error:${RESET} $1"
    exit 1
}

info() {
    echo -e "${BLUE}==>${RESET} $1"
}

success() {
    echo -e "${GREEN}✓${RESET} $1"
}

warning() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

# =========================================================
# Comprobar root
# =========================================================

if [[ $EUID -ne 0 ]]; then
    error "Ejecuta el instalador con sudo:

    sudo ./install.sh"
fi

# =========================================================
# Comprobar NixOS
# =========================================================

if [[ ! -d "$NIXOS_DIR" ]]; then
    error "No existe:

    $NIXOS_DIR

Este script debe ejecutarse después de instalar NixOS."
fi

if [[ ! -f "$CONFIG" ]]; then
    error "No existe:

    $CONFIG

Ejecuta primero el instalador gráfico de NixOS."
fi

if [[ ! -f "$NIXOS_DIR/hardware-configuration.nix" ]]; then
    error "No existe:

    $NIXOS_DIR/hardware-configuration.nix

Ejecuta primero el instalador gráfico de NixOS."
fi

# =========================================================
# Detectar versión de NixOS
# =========================================================

detect_nixos_version() {
    local VERSION

    if ! command -v nixos-version >/dev/null 2>&1; then
        return 1
    fi

    VERSION="$(nixos-version 2>/dev/null || true)"

    if [[ "$VERSION" =~ ([0-9]{2}\.[0-9]{2}) ]]; then
        echo "${BASH_REMATCH[1]}"
        return 0
    fi

    return 1
}

DETECTED_VERSION="$(detect_nixos_version || true)"

# =========================================================
# Seleccionar stateVersion
# =========================================================

clear

echo -e "${BOLD}"
echo "╭────────────────────────────────────╮"
echo "│       NixOS Desktop Installer      │"
echo "╰────────────────────────────────────╯"
echo -e "${RESET}"

echo
echo "Versión de NixOS:"
echo

if [[ -n "$DETECTED_VERSION" ]]; then
    echo "  1) Detectar automáticamente ($DETECTED_VERSION)"
else
    echo "  1) Detectar automáticamente"
    echo -e "     ${YELLOW}No se pudo detectar la versión${RESET}"
fi

echo "  2) Introducir manualmente"
echo

read -rp "Opción [1-2]: " VERSION_OPTION

case "$VERSION_OPTION" in
    1)
        if [[ -z "$DETECTED_VERSION" ]]; then
            error "No se pudo detectar la versión de NixOS."
        fi

        STATE_VERSION="$DETECTED_VERSION"
        ;;

    2)
        echo
        read -rp "system.stateVersion [ej. 26.05]: " STATE_VERSION

        if [[ ! "$STATE_VERSION" =~ ^[0-9]{2}\.[0-9]{2}$ ]]; then
            error "Versión inválida.

Ejemplo válido:

    26.05"
        fi
        ;;

    *)
        error "Opción inválida."
        ;;
esac

# =========================================================
# Seleccionar escritorio
# =========================================================

clear

echo -e "${BOLD}"
echo "╭────────────────────────────────────╮"
echo "│       NixOS Desktop Installer      │"
echo "╰────────────────────────────────────╯"
echo -e "${RESET}"

echo
echo "Selecciona el escritorio:"
echo
echo "  1) KDE Plasma"
echo "  2) GNOME"
echo "  3) Pantheon"
echo

read -rp "Escritorio [1-3]: " DESKTOP

case "$DESKTOP" in
    1)
        DESKTOP_NAME="KDE Plasma"
        DESKTOP_FILE="kde.nix"
        ;;

    2)
        DESKTOP_NAME="GNOME"
        DESKTOP_FILE="gnome.nix"
        ;;

    3)
        DESKTOP_NAME="Pantheon"
        DESKTOP_FILE="pantheon.nix"
        ;;

    *)
        error "Opción de escritorio inválida."
        ;;
esac

if [[ ! -f "$DESKTOP_DIR/$DESKTOP_FILE" ]]; then
    error "No existe:

    $DESKTOP_DIR/$DESKTOP_FILE"
fi

# =========================================================
# Seleccionar perfil
# =========================================================

clear

echo -e "${BOLD}"
echo "╭────────────────────────────────────╮"
echo "│       NixOS Desktop Installer      │"
echo "╰────────────────────────────────────╯"
echo -e "${RESET}"

echo
echo -e "Escritorio: ${GREEN}$DESKTOP_NAME${RESET}"
echo

echo "Selecciona el tipo de instalación:"
echo
echo "  1) Minimal"
echo "  2) Completa"
echo

read -rp "Perfil [1-2]: " PROFILE

case "$PROFILE" in
    1)
        PROFILE_NAME="Minimal"
        PROFILE_FILE="minimal.nix"
        ;;

    2)
        PROFILE_NAME="Completa"
        PROFILE_FILE="complete.nix"
        ;;

    *)
        error "Opción de perfil inválida."
        ;;
esac

if [[ ! -f "$PROFILE_DIR/$PROFILE_FILE" ]]; then
    error "No existe:

    $PROFILE_DIR/$PROFILE_FILE"
fi

# =========================================================
# Resumen
# =========================================================

clear

echo -e "${BOLD}"
echo "╭────────────────────────────────────╮"
echo "│        Configuración elegida       │"
echo "╰────────────────────────────────────╯"
echo -e "${RESET}"

echo
echo -e "  NixOS        : ${GREEN}$STATE_VERSION${RESET}"
echo -e "  Escritorio   : ${GREEN}$DESKTOP_NAME${RESET}"
echo -e "  Perfil       : ${GREEN}$PROFILE_NAME${RESET}"
echo

read -rp "¿Continuar? [Y/n]: " CONFIRM

CONFIRM="${CONFIRM:-Y}"

case "$CONFIRM" in
    Y|y|S|s)
        ;;
    *)
        echo
        echo "Instalación cancelada."
        exit 0
        ;;
esac

# =========================================================
# Copiar módulos
# =========================================================

info "Instalando configuración de $DESKTOP_NAME..."

cp "$DESKTOP_DIR/$DESKTOP_FILE" "$NIXOS_DIR/$DESKTOP_FILE"

success "$DESKTOP_FILE instalado."

info "Instalando perfil $PROFILE_NAME..."

cp "$PROFILE_DIR/$PROFILE_FILE" "$NIXOS_DIR/$PROFILE_FILE"

success "$PROFILE_FILE instalado."

# =========================================================
# Crear desktop.nix
# =========================================================

info "Creando desktop.nix..."

cat > "$DESKTOP_OUTPUT" <<EOF
{
  imports = [
    ./$DESKTOP_FILE
  ];
}
EOF

success "desktop.nix creado."

# =========================================================
# Crear profile.nix
# =========================================================

info "Creando profile.nix..."

cat > "$PROFILE_OUTPUT" <<EOF
{
  imports = [
    ./$PROFILE_FILE
  ];
}
EOF

success "profile.nix creado."

# =========================================================
# Añadir imports
# =========================================================

info "Configurando imports..."

python3 - "$CONFIG" <<'PY'
import sys
from pathlib import Path

config = Path(sys.argv[1])
text = config.read_text()

desktop_import = "    ./desktop.nix"
profile_import = "    ./profile.nix"

imports = []

if desktop_import not in text:
    imports.append(desktop_import)

if profile_import not in text:
    imports.append(profile_import)

if imports:
    marker = "imports = ["

    if marker not in text:
        raise SystemExit(
            "No se encontró el bloque 'imports = [' "
            "en configuration.nix."
        )

    insertion = "\n" + "\n".join(imports)

    text = text.replace(
        marker,
        marker + insertion,
        1
    )

    config.write_text(text)
PY

success "Imports configurados."

# =========================================================
# system.stateVersion
# =========================================================

if grep -q "system\.stateVersion" "$CONFIG"; then

    warning "configuration.nix ya contiene system.stateVersion."

    grep "system\.stateVersion" "$CONFIG"

else

    info "Añadiendo system.stateVersion..."

    cat >> "$CONFIG" <<EOF

  # Configurado por NixOS Desktop Installer
  system.stateVersion = "$STATE_VERSION";
EOF

    success "system.stateVersion añadido."
fi

# =========================================================
# Mostrar configuración
# =========================================================

echo
echo -e "${BOLD}Configuración actual:${RESET}"
echo
cat "$CONFIG"
echo

# =========================================================
# Validar
# =========================================================

info "Validando configuración..."

if ! nixos-rebuild dry-build; then
    echo
    error "La configuración no pudo ser evaluada."
fi

success "La configuración es válida."

# =========================================================
# Aplicar
# =========================================================

echo
echo "La configuración está lista."
echo
echo "Se ejecutará:"
echo
echo "    nixos-rebuild switch"
echo

read -rp "¿Continuar? [Y/n]: " SWITCH_CONFIRM

SWITCH_CONFIRM="${SWITCH_CONFIRM:-Y}"

case "$SWITCH_CONFIRM" in
    Y|y|S|s)
        ;;
    *)
        echo
        warning "No se aplicaron los cambios."
        echo
        echo "Puedes hacerlo posteriormente con:"
        echo
        echo "    sudo nixos-rebuild switch"
        exit 0
        ;;
esac

echo

nixos-rebuild switch

# =========================================================
# Final
# =========================================================

clear

echo -e "${GREEN}${BOLD}"
echo "╭────────────────────────────────────╮"
echo "│       Instalación completada       │"
echo "╰────────────────────────────────────╯"
echo -e "${RESET}"

echo
echo "NixOS        : $STATE_VERSION"
echo "Escritorio   : $DESKTOP_NAME"
echo "Perfil       : $PROFILE_NAME"
echo
echo "Configuración:"
echo "    /etc/nixos/configuration.nix"
echo
echo "Módulos:"
echo "    /etc/nixos/$DESKTOP_FILE"
echo "    /etc/nixos/$PROFILE_FILE"
echo
echo -e "${GREEN}NixOS está configurado correctamente.${RESET}"
echo
```

