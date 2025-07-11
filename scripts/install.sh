#!/bin/bash

# OpenGFW Installation Script
# This script installs OpenGFW v0.4.1 with unattended execution support

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Configuration
OPENGFW_VERSION="v0.4.1"
INSTALL_DIR="/opt/opengfw"
SERVICE_FILE="/usr/lib/systemd/system/opengfw.service"
GITHUB_BASE_URL="https://github.com"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root or with sudo privileges"
        exit 1
    fi
}

# Check system requirements
check_requirements() {
    log "Checking system requirements..."
    
    # Check if systemd is available
    if ! command -v systemctl &> /dev/null; then
        error "systemd is required but not found"
        exit 1
    fi
    
    # Check architecture
    ARCH=$(uname -m)
    if [[ "$ARCH" != "x86_64" ]]; then
        error "This script is designed for x86_64 architecture, but found: $ARCH"
        exit 1
    fi
    
    info "System requirements check passed"
}

# Install required packages
install_dependencies() {
    log "Installing required packages..."
    
    # Update package list
    if ! apt update -qq; then
        error "Failed to update package list"
        exit 1
    fi
    
    # Install wget if not present
    if ! command -v wget &> /dev/null; then
        info "Installing wget..."
        if ! apt install -y wget; then
            error "Failed to install wget"
            exit 1
        fi
    else
        info "wget is already installed"
    fi
    
    log "Dependencies installed successfully"
}

# Create directories
create_directories() {
    log "Creating installation directories..."
    
    if ! mkdir -p "$INSTALL_DIR"; then
        error "Failed to create directory: $INSTALL_DIR"
        exit 1
    fi
    
    info "Directories created successfully"
}

# Download file with retry mechanism
download_with_retry() {
    local url="$1"
    local output="$2"
    local retries=3
    local wait_time=5
    
    for ((i=1; i<=retries; i++)); do
        info "Downloading $(basename "$output") (attempt $i/$retries)..."
        
        if wget --timeout=30 --tries=3 --quiet --show-progress "$url" -O "$output"; then
            log "Successfully downloaded $(basename "$output")"
            return 0
        else
            warning "Download attempt $i failed"
            if [[ $i -lt $retries ]]; then
                info "Waiting $wait_time seconds before retry..."
                sleep $wait_time
            fi
        fi
    done
    
    error "Failed to download $url after $retries attempts"
    return 1
}

# Download OpenGFW binary
download_opengfw() {
    log "Downloading OpenGFW binary..."
    
    local binary_url="${GITHUB_BASE_URL}/apernet/OpenGFW/releases/download/${OPENGFW_VERSION}/OpenGFW-linux-amd64"
    local binary_path="${INSTALL_DIR}/OpenGFW"
    
    if ! download_with_retry "$binary_url" "$binary_path"; then
        error "Failed to download OpenGFW binary"
        exit 1
    fi
    
    # Make executable
    if ! chmod +x "$binary_path"; then
        error "Failed to make OpenGFW binary executable"
        exit 1
    fi
    
    log "OpenGFW binary downloaded and configured"
}

# Download configuration files
download_configs() {
    log "Downloading configuration files..."
    
    local config_base_url="${GITHUB_BASE_URL}/liuzhen9320/OpenGFW-configuration/raw/main/config"
    
    # Download config.yaml
    if ! download_with_retry "${config_base_url}/config.yaml" "${INSTALL_DIR}/config.yaml"; then
        error "Failed to download config.yaml"
        exit 1
    fi
    
    # Download rules.yaml
    if ! download_with_retry "${config_base_url}/rules.yaml" "${INSTALL_DIR}/rules.yaml"; then
        error "Failed to download rules.yaml"
        exit 1
    fi
    
    log "Configuration files downloaded successfully"
}

# Download and install systemd service
install_service() {
    log "Installing systemd service..."
    
    local service_url="${GITHUB_BASE_URL}/liuzhen9320/OpenGFW-configuration/raw/main/daemon/opengfw.service"
    
    if ! download_with_retry "$service_url" "$SERVICE_FILE"; then
        error "Failed to download systemd service file"
        exit 1
    fi
    
    # Reload systemd daemon
    if ! systemctl daemon-reload; then
        error "Failed to reload systemd daemon"
        exit 1
    fi
    
    log "Systemd service installed successfully"
}

# Enable and start service
start_service() {
    log "Enabling and starting OpenGFW service..."
    
    # Enable service
    if ! systemctl enable opengfw.service; then
        error "Failed to enable OpenGFW service"
        exit 1
    fi
    
    # Start service
    if ! systemctl start opengfw.service; then
        error "Failed to start OpenGFW service"
        exit 1
    fi
    
    # Check service status
    if systemctl is-active --quiet opengfw.service; then
        log "OpenGFW service is running successfully"
    else
        warning "OpenGFW service was started but may not be running properly"
        info "Check service status with: systemctl status opengfw.service"
    fi
}

# Cleanup function
cleanup() {
    if [[ $? -ne 0 ]]; then
        error "Installation failed. Cleaning up..."
        systemctl stop opengfw.service 2>/dev/null || true
        systemctl disable opengfw.service 2>/dev/null || true
        rm -f "$SERVICE_FILE" 2>/dev/null || true
        rm -rf "$INSTALL_DIR" 2>/dev/null || true
        error "Cleanup completed. Please check the errors above."
    fi
}

# Set trap for cleanup
trap cleanup EXIT

# Main installation process
main() {
    log "Starting OpenGFW installation..."
    
    check_root
    check_requirements
    install_dependencies
    create_directories
    download_opengfw
    download_configs
    install_service
    start_service
    
    log "OpenGFW installation completed successfully!"
    info "Service status: $(systemctl is-active opengfw.service)"
    info "View logs with: journalctl -u opengfw.service -f"
    info "Configuration files are located in: $INSTALL_DIR"
}

# Run main function
main "$@"
