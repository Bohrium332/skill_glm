<#
.SYNOPSIS
    Arduino CLI Installation Script for Windows
    Supports: x86_64, ARM64 architectures

.DESCRIPTION
    Downloads and installs Arduino CLI with board package configuration
    for Seeed XIAO series development boards.

.PARAMETER BoardType
    Board package to install: esp32, nrf52, nrf54, rp2040, mg24, samd, ra4m1, all
    Default: all

.PARAMETER InstallDir
    Installation directory. Default: $env:LOCALAPPDATA\Programs\arduino-cli

.EXAMPLE
    .\install-arduino-cli.ps1
    Installs Arduino CLI with all board packages

.EXAMPLE
    .\install-arduino-cli.ps1 -BoardType esp32
    Installs Arduino CLI with ESP32 board package only

.NOTES
    Version: 1.0.0
    Requires: PowerShell 5.1 or later
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet("esp32", "nrf52", "nrf54", "rp2040", "mg24", "samd", "ra4m1", "all")]
    [string]$BoardType = "all",

    [Parameter()]
    [string]$InstallDir = "$env:LOCALAPPDATA\Programs\arduino-cli"
)

$ErrorActionPreference = "Stop"
$ArduinoCliVersion = "1.4.1"
$ConfigDir = "$env:USERPROFILE\.arduino15"

function Write-LogInfo {
    param([string]$Message)
    Write-Host "[INFO] " -ForegroundColor Blue -NoNewline
    Write-Host $Message
}

function Write-LogSuccess {
    param([string]$Message)
    Write-Host "[SUCCESS] " -ForegroundColor Green -NoNewline
    Write-Host $Message
}

function Write-LogWarning {
    param([string]$Message)
    Write-Host "[WARNING] " -ForegroundColor Yellow -NoNewline
    Write-Host $Message
}

function Write-LogError {
    param([string]$Message)
    Write-Host "[ERROR] " -ForegroundColor Red -NoNewline
    Write-Host $Message
}

function Get-Architecture {
    $arch = $env:PROCESSOR_ARCHITECTURE
    if ($arch -eq "AMD64") {
        return "64bit"
    } elseif ($arch -eq "ARM64") {
        return "ARM64"
    } else {
        return "64bit"  # Default fallback
    }
}

function Test-ArduinoCli {
    $cliPath = Join-Path $InstallDir "arduino-cli.exe"
    if (Test-Path $cliPath) {
        return $true
    }

    # Check if in PATH
    $cmd = Get-Command arduino-cli -ErrorAction SilentlyContinue
    if ($cmd) {
        return $true
    }

    return $false
}

function Get-ArduinoCliVersion {
    try {
        $cliPath = Join-Path $InstallDir "arduino-cli.exe"
        if (Test-Path $cliPath) {
            $output = & $cliPath version 2>&1
            if ($output -match "version:\s*([0-9.]+)") {
                return $matches[1]
            }
        }
    } catch {}

    $cmd = Get-Command arduino-cli -ErrorAction SilentlyContinue
    if ($cmd) {
        $output = & arduino-cli version 2>&1
        if ($output -match "version:\s*([0-9.]+)") {
            return $matches[1]
        }
    }

    return "unknown"
}

function Download-ArduinoCli {
    $arch = Get-Architecture
    # GitHub release naming: Windows_64bit.zip or Windows_32bit.zip
    $downloadUrl = "https://github.com/arduino/arduino-cli/releases/download/v$ArduinoCliVersion/arduino-cli_${ArduinoCliVersion}_Windows_${arch}.zip"

    Write-LogInfo "Downloading Arduino CLI v$ArduinoCliVersion for Windows/${arch}..."

    # Create temp directory
    $tempDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP "arduino-cli-download") -Force
    $zipFile = Join-Path $tempDir "arduino-cli.zip"

    try {
        # Download
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing

        Write-LogInfo "Extracting..."

        # Create install directory
        if (-not (Test-Path $InstallDir)) {
            New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
        }

        # Extract
        Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force

        # Move executable
        $extractedExe = Join-Path $tempDir "arduino-cli.exe"
        if (Test-Path $extractedExe) {
            Move-Item -Path $extractedExe -Destination (Join-Path $InstallDir "arduino-cli.exe") -Force
        } else {
            # May be in subdirectory
            $exeFile = Get-ChildItem -Path $tempDir -Filter "arduino-cli.exe" -Recurse | Select-Object -First 1
            if ($exeFile) {
                Move-Item -Path $exeFile.FullName -Destination (Join-Path $InstallDir "arduino-cli.exe") -Force
            } else {
                throw "arduino-cli.exe not found in downloaded archive"
            }
        }

        Write-LogSuccess "Arduino CLI installed to $InstallDir\arduino-cli.exe"
    } finally {
        # Cleanup
        if (Test-Path $tempDir) {
            Remove-Item -Path $tempDir -Recurse -Force
        }
    }
}

function Add-ToPath {
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")

    if ($currentPath -like "*$InstallDir*") {
        Write-LogInfo "$InstallDir is already in user PATH"
        return
    }

    Write-LogInfo "Adding $InstallDir to user PATH..."
    $newPath = "$currentPath;$InstallDir"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")

    # Update current session
    $env:PATH = "$env:PATH;$InstallDir"

    Write-LogSuccess "Added to PATH. Restart your terminal for changes to take effect."
}

function Configure-BoardUrls {
    Write-LogInfo "Configuring board manager URLs..."

    # Create config directory
    if (-not (Test-Path $ConfigDir)) {
        New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
    }

    $configFile = Join-Path $ConfigDir "arduino-cli.yaml"
    $urls = @(
        "https://espressif.github.io/arduino-esp32/package_esp32_index.json",
        "https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json",
        "https://github.com/earlephilhower/arduino-pico/releases/download/global/package_rp2040_index.json",
        "https://siliconlabs.github.io/arduino/package_arduinosilabs_index.json"
    )

    if (-not (Test-Path $configFile)) {
        $yamlContent = "board_manager:`n  additional_urls:`n"
        foreach ($url in $urls) {
            $yamlContent += "    - $url`n"
        }
        Set-Content -Path $configFile -Value $yamlContent -NoNewline
        Write-LogSuccess "Created arduino-cli.yaml with board URLs"
    } else {
        Write-LogInfo "arduino-cli.yaml already exists, verifying URLs..."
        $configContent = Get-Content $configFile -Raw
        foreach ($url in $urls) {
            if ($configContent -notmatch [regex]::Escape($url)) {
                Write-LogWarning "URL may need manual addition: $url"
            }
        }
    }

    # Update index
    Write-LogInfo "Updating board index..."
    $cliPath = Join-Path $InstallDir "arduino-cli.exe"
    & $cliPath core update-index 2>&1 | Out-Null
}

function Install-BoardPackage {
    param([string]$Type)

    $cliPath = Join-Path $InstallDir "arduino-cli.exe"

    switch ($Type) {
        "esp32" {
            Write-LogInfo "Installing ESP32 board package..."
            & $cliPath core install esp32:esp32@3.1.1
        }
        {$_ -in "nrf52", "nrf54"} {
            Write-LogInfo "Installing Seeed nRF52/nRF54 board packages..."
            & $cliPath core install Seeeduino:nrf52
            & $cliPath core install Seeeduino:nrf54
        }
        "rp2040" {
            Write-LogInfo "Installing RP2040 board package..."
            & $cliPath core install rp2040:rp2040
        }
        {$_ -in "mg24", "silabs"} {
            Write-LogInfo "Installing Silicon Labs board package..."
            & $cliPath core install SiliconLabs:efr32mg24
        }
        "samd" {
            Write-LogInfo "Installing Seeed SAMD board package..."
            & $cliPath core install Seeeduino:samd
        }
        {$_ -in "ra4m1", "renesas"} {
            Write-LogInfo "Installing Seeed Renesas board package..."
            & $cliPath core install Seeeduino:renesas
        }
        "all" {
            Write-LogInfo "Installing all board packages..."
            & $cliPath core install esp32:esp32@3.1.1
            & $cliPath core install Seeeduino:nrf52
            & $cliPath core install Seeeduino:nrf54
            & $cliPath core install rp2040:rp2040
            & $cliPath core install SiliconLabs:efr32mg24
            & $cliPath core install Seeeduino:samd
            & $cliPath core install Seeeduino:renesas
        }
    }
}

function Show-Usage {
    Write-Host ""
    Write-Host "Usage: .\install-arduino-cli.ps1 [-BoardType <type>]"
    Write-Host ""
    Write-Host "Board types:"
    Write-Host "  esp32    - XIAO ESP32S3/C3/C5/C6"
    Write-Host "  nrf52    - XIAO nRF52840"
    Write-Host "  nrf54    - XIAO nRF54L15"
    Write-Host "  rp2040   - XIAO RP2040/RP2350"
    Write-Host "  mg24     - XIAO MG24"
    Write-Host "  samd     - XIAO SAMD21"
    Write-Host "  ra4m1    - XIAO RA4M1"
    Write-Host "  all      - Install all board packages (default)"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\install-arduino-cli.ps1              # Install with all packages"
    Write-Host "  .\install-arduino-cli.ps1 -BoardType esp32  # ESP32 only"
}

# Main execution
Write-Host "========================================"
Write-Host " Arduino CLI Installer for XIAO Boards"
Write-Host "========================================"
Write-Host ""

# Check existing installation
if (Test-ArduinoCli) {
    $version = Get-ArduinoCliVersion
    Write-LogInfo "Arduino CLI already installed: version $version"
} else {
    Download-ArduinoCli
    Add-ToPath
}

# Configure board URLs
Configure-BoardUrls

# Install board package
Install-BoardPackage -Type $BoardType

Write-Host ""
Write-LogSuccess "Installation complete!"
Write-Host ""
Write-Host "To verify installation, run:"
Write-Host "  arduino-cli version"
Write-Host ""
Write-Host "To compile a sketch:"
Write-Host "  arduino-cli compile --fqbn <FQBN> <sketch_path>"
Write-Host ""
Write-Host "Example FQBNs for XIAO boards:"
Write-Host "  XIAO ESP32S3:    esp32:esp32:XIAO_ESP32S3"
Write-Host "  XIAO ESP32C3:    esp32:esp32:XIAO_ESP32C3"
Write-Host "  XIAO nRF52840:   Seeeduino:nrf52:xiaonRF52840"
Write-Host "  XIAO RP2040:     rp2040:rp2040:seeed_xiao_rp2040"
Write-Host "  XIAO SAMD21:     Seeeduino:samd:seeed_XIAO"
