#!/bin/bash
#
# Arduino CLI Installation Script for Linux and macOS
# Supports: x86_64, ARM64 architectures
# Version: 1.0.0
#
# Usage:
#   ./install-arduino-cli.sh [board_type]
#
# board_type: esp32|nrf52|nrf54|rp2040|mg24|samd|ra4m1|all
#             (default: all - installs all board packages)
#

set -e

ARDUINO_CLI_VERSION="1.4.1"
INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.arduino15"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        *)          echo "unknown";;
    esac
}

detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64)   echo "x86_64";;
        arm64|aarch64)  echo "arm64";;
        armv7l)         echo "armv7";;
        *)              echo "unknown";;
    esac
}

check_existing_installation() {
    if command -v arduino-cli &> /dev/null; then
        local version
        version=$(arduino-cli version 2>/dev/null | grep -oP 'version:\s*\K[^\s]+' || echo "unknown")
        log_info "Arduino CLI already installed: version $version"
        return 0
    fi
    return 1
}

download_arduino_cli() {
    local os="$1"
    local arch="$2"

    # Map OS and architecture for GitHub release naming convention
    # GitHub releases use: Linux_64bit, Linux_ARM64, macOS_64bit, macOS_ARM64
    local download_os
    local download_arch

    case "$os" in
        linux)  download_os="Linux" ;;
        macos)  download_os="macOS" ;;
        *)      log_error "Unsupported OS: $os"; exit 1 ;;
    esac

    case "$arch" in
        x86_64|amd64) download_arch="64bit" ;;
        arm64|aarch64) download_arch="ARM64" ;;
        armv7) download_arch="ARMv7" ;;
        *) log_error "Unsupported architecture: $arch"; exit 1 ;;
    esac

    local download_url="https://github.com/arduino/arduino-cli/releases/download/v${ARDUINO_CLI_VERSION}/arduino-cli_${ARDUINO_CLI_VERSION}_${download_os}_${download_arch}.tar.gz"
    local tmp_dir
    tmp_dir=$(mktemp -d)
    local tmp_file="${tmp_dir}/arduino-cli.tar.gz"

    log_info "Downloading Arduino CLI v${ARDUINO_CLI_VERSION} for ${download_os}/${download_arch}..."

    if ! curl -fsSL "$download_url" -o "$tmp_file"; then
        log_error "Failed to download Arduino CLI"
        rm -rf "$tmp_dir"
        exit 1
    fi

    log_info "Extracting..."
    tar -xzf "$tmp_file" -C "$tmp_dir"

    # Create install directory if not exists
    mkdir -p "$INSTALL_DIR"

    # Move binary
    mv "${tmp_dir}/arduino-cli" "${INSTALL_DIR}/arduino-cli"
    chmod +x "${INSTALL_DIR}/arduino-cli"

    # Cleanup
    rm -rf "$tmp_dir"

    log_success "Arduino CLI installed to ${INSTALL_DIR}/arduino-cli"
}

add_to_path() {
    local shell_rc=""

    if [[ -n "$ZSH_VERSION" ]]; then
        shell_rc="${HOME}/.zshrc"
    elif [[ -n "$BASH_VERSION" ]]; then
        shell_rc="${HOME}/.bashrc"
    fi

    # Check if already in PATH
    if [[ ":$PATH:" == *":${INSTALL_DIR}:"* ]]; then
        log_info "${INSTALL_DIR} is already in PATH"
        return 0
    fi

    # Add to shell config if available
    if [[ -n "$shell_rc" && -f "$shell_rc" ]]; then
        if ! grep -q "export PATH=\"\$PATH:${INSTALL_DIR}\"" "$shell_rc" 2>/dev/null; then
            echo "" >> "$shell_rc"
            echo "# Arduino CLI" >> "$shell_rc"
            echo "export PATH=\"\$PATH:${INSTALL_DIR}\"" >> "$shell_rc"
            log_info "Added ${INSTALL_DIR} to PATH in ${shell_rc}"
            log_info "Run 'source ${shell_rc}' or start a new terminal to update PATH"
        fi
    fi

    # Add to current session
    export PATH="$PATH:${INSTALL_DIR}"
}

configure_board_urls() {
    log_info "Configuring board manager URLs..."

    # Create config directory
    mkdir -p "$CONFIG_DIR"

    local urls=(
        "https://espressif.github.io/arduino-esp32/package_esp32_index.json"
        "https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json"
        "https://github.com/earlephilhower/arduino-pico/releases/download/global/package_rp2040_index.json"
        "https://siliconlabs.github.io/arduino/package_arduinosilabs_index.json"
    )

    # Initialize config if not exists
    if [[ ! -f "${CONFIG_DIR}/arduino-cli.yaml" ]]; then
        echo "board_manager:" > "${CONFIG_DIR}/arduino-cli.yaml"
        echo "  additional_urls:" >> "${CONFIG_DIR}/arduino-cli.yaml"
        for url in "${urls[@]}"; do
            echo "    - ${url}" >> "${CONFIG_DIR}/arduino-cli.yaml"
        done
        log_success "Created arduino-cli.yaml with board URLs"
    else
        # Add missing URLs to existing config
        for url in "${urls[@]}"; do
            if ! grep -q "$url" "${CONFIG_DIR}/arduino-cli.yaml" 2>/dev/null; then
                # This is a simple append - for complex config manipulation, use yq or similar
                log_warn "URL may need manual addition: $url"
            fi
        done
    fi

    # Update index
    log_info "Updating board index..."
    "${INSTALL_DIR}/arduino-cli" core update-index 2>/dev/null || true
}

install_board_package() {
    local board_type="$1"

    case "$board_type" in
        esp32)
            log_info "Installing ESP32 board package..."
            "${INSTALL_DIR}/arduino-cli" core install esp32:esp32@3.1.1
            ;;
        nrf52|nrf54)
            log_info "Installing Seeed nRF52/nRF54 board package..."
            "${INSTALL_DIR}/arduino-cli" core install Seeeduino:nrf52
            "${INSTALL_DIR}/arduino-cli" core install Seeeduino:nrf54
            ;;
        rp2040)
            log_info "Installing RP2040 board package..."
            "${INSTALL_DIR}/arduino-cli" core install rp2040:rp2040
            ;;
        mg24|silabs)
            log_info "Installing Silicon Labs board package..."
            "${INSTALL_DIR}/arduino-cli" core install SiliconLabs:efr32mg24
            ;;
        samd)
            log_info "Installing Seeed SAMD board package..."
            "${INSTALL_DIR}/arduino-cli" core install Seeeduino:samd
            ;;
        ra4m1|renesas)
            log_info "Installing Seeed Renesas board package..."
            "${INSTALL_DIR}/arduino-cli" core install Seeeduino:renesas
            ;;
        all)
            log_info "Installing all board packages..."
            "${INSTALL_DIR}/arduino-cli" core install esp32:esp32@3.1.1
            "${INSTALL_DIR}/arduino-cli" core install Seeeduino:nrf52
            "${INSTALL_DIR}/arduino-cli" core install Seeeduino:nrf54
            "${INSTALL_DIR}/arduino-cli" core install rp2040:rp2040
            "${INSTALL_DIR}/arduino-cli" core install SiliconLabs:efr32mg24
            "${INSTALL_DIR}/arduino-cli" core install Seeeduino:samd
            "${INSTALL_DIR}/arduino-cli" core install Seeeduino:renesas
            ;;
        *)
            log_warn "Unknown board type: $board_type"
            log_info "Available: esp32, nrf52, nrf54, rp2040, mg24, samd, ra4m1, all"
            log_info "Skipping board package installation"
            ;;
    esac
}

print_usage() {
    echo "Usage: $0 [board_type]"
    echo ""
    echo "Board types:"
    echo "  esp32    - XIAO ESP32S3/C3/C5/C6"
    echo "  nrf52    - XIAO nRF52840"
    echo "  nrf54    - XIAO nRF54L15"
    echo "  rp2040   - XIAO RP2040/RP2350"
    echo "  mg24     - XIAO MG24"
    echo "  samd     - XIAO SAMD21"
    echo "  ra4m1    - XIAO RA4M1"
    echo "  all      - Install all board packages (default)"
    echo ""
    echo "Examples:"
    echo "  $0           # Install Arduino CLI with all board packages"
    echo "  $0 esp32     # Install Arduino CLI with ESP32 package only"
    echo "  $0 rp2040    # Install Arduino CLI with RP2040 package only"
}

main() {
    local board_type="${1:-all}"

    if [[ "$board_type" == "-h" || "$board_type" == "--help" ]]; then
        print_usage
        exit 0
    fi

    echo "========================================"
    echo " Arduino CLI Installer for XIAO Boards"
    echo "========================================"
    echo ""

    # Check existing installation
    if check_existing_installation; then
        log_info "Using existing Arduino CLI installation"
    else
        # Detect OS and architecture
        local os
        local arch
        os=$(detect_os)
        arch=$(detect_arch)

        log_info "Detected: ${os} ${arch}"

        if [[ "$os" == "unknown" ]]; then
            log_error "Unsupported operating system"
            exit 1
        fi

        # Download and install
        download_arduino_cli "$os" "$arch"
        add_to_path
    fi

    # Configure board URLs
    configure_board_urls

    # Install board package
    install_board_package "$board_type"

    echo ""
    log_success "Installation complete!"
    echo ""
    echo "To verify installation, run:"
    echo "  arduino-cli version"
    echo ""
    echo "To compile a sketch:"
    echo "  arduino-cli compile --fqbn <FQBN> <sketch_path>"
    echo ""
    echo "Example FQBNs for XIAO boards:"
    echo "  XIAO ESP32S3:    esp32:esp32:XIAO_ESP32S3"
    echo "  XIAO ESP32C3:    esp32:esp32:XIAO_ESP32C3"
    echo "  XIAO nRF52840:   Seeeduino:nrf52:xiaonRF52840"
    echo "  XIAO RP2040:     rp2040:rp2040:seeed_xiao_rp2040"
    echo "  XIAO SAMD21:     Seeeduino:samd:seeed_XIAO"
}

main "$@"
