#!/bin/bash
# Build script for Cangjie Debian packages
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${WORK_DIR:-/tmp/cangjie-build}"

echo "=== Cangjie Debian Package Build Script ==="
echo ""

# Check if running on Ubuntu/Debian
if ! command -v dpkg-buildpackage &> /dev/null; then
    echo "Error: This script requires Debian/Ubuntu"
    echo "dpkg-buildpackage not found"
    exit 1
fi

# Create work directory
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "Working directory: $WORK_DIR"
echo ""

# Check if cangjie_compiler exists, if not clone it
if [ ! -d "cangjie_compiler" ]; then
    echo "=== Cloning Cangjie Compiler Repository ==="
    git clone --recursive https://github.com/cangjielanguage/cangjie_compiler.git
    echo ""
else
    echo "=== Using existing cangjie_compiler directory ==="
    echo "To force a fresh clone, delete: $WORK_DIR/cangjie_compiler"
    echo ""
fi

# Copy debian packaging
echo "=== Copying Debian packaging files ==="
cp -rv "$SCRIPT_DIR/debian" cangjie_compiler/
echo ""

# Install dependencies
echo "=== Installing build dependencies ==="
echo "This may require sudo password..."
sudo apt-get update
sudo apt-get install -y \
    debhelper \
    cmake \
    clang-14 \
    llvm-14-dev \
    libclang-14-dev \
    ninja-build \
    python3 \
    git \
    build-essential \
    devscripts \
    lintian
echo ""

# Build packages
echo "=== Building Debian packages ==="
cd cangjie_compiler
dpkg-buildpackage -us -uc -b

echo ""
echo "=== Build Complete ==="
echo ""
echo "Generated packages:"
ls -lh ../*.deb 2>/dev/null || echo "No .deb files found"
echo ""
echo "Packages are located in: $WORK_DIR"
echo ""
echo "To install:"
echo "  cd $WORK_DIR"
echo "  sudo dpkg -i *.deb"
echo "  sudo apt-get install -f  # Install missing dependencies"
