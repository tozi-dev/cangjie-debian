# Cangjie Debian Packaging

This repository contains Debian/Ubuntu packaging files for the [Cangjie programming language compiler](https://github.com/cangjielanguage/cangjie_compiler).

## Overview

Cangjie (仓颉) is a general-purpose programming language designed for full-scenario application development, balancing development efficiency and runtime performance. This repository provides the necessary packaging to create `.deb` packages that can be installed on Debian and Ubuntu systems or uploaded to a PPA (Personal Package Archive).

## Packages

Two packages are generated from this packaging:

1. **cangjie-compiler** - Contains the Cangjie compiler binaries and runtime libraries
2. **cangjie-compiler-headers** - Contains development header files for compiler integration

## Building Packages

### Build Method

This packaging uses the upstream's official `build.py` script from the [cangjie_build](https://github.com/cangjielanguage/cangjie_build) project. The build process is:

```bash
python3 build.py build -t Release --no-tests
python3 build.py install --prefix=/usr
```

This approach:
- Uses the official build method recommended by upstream
- Avoids CMake configuration complexities
- Ensures compatibility with future upstream changes

### Prerequisites

```bash
sudo apt-get update
sudo apt-get install -y debhelper cmake clang-14 llvm-14-dev libclang-14-dev ninja-build python3 git build-essential
```

### Manual Build

```bash
# Clone the compiler source
git clone --recursive https://github.com/cangjielanguage/cangjie_compiler.git
cd cangjie_compiler

# Clone this packaging repository
git clone https://github.com/tozi-dev/cangjie-debian.git

# Copy debian files
cp -r cangjie-debian/debian ./

# Build the packages
dpkg-buildpackage -us -uc -b
```

The `.deb` packages will be created in the parent directory.

### Automated Build

This repository includes a GitHub Actions workflow that automatically builds the packages when changes are pushed to the main branch. The workflow:

- Checks out both the compiler source and packaging files
- Sets up the build environment
- Builds the Debian packages
- Uploads the packages as artifacts

## Installation

After building, install the packages:

```bash
sudo dpkg -i cangjie-compiler_*.deb cangjie-compiler-headers_*.deb
sudo apt-get install -f  # Install any missing dependencies
```

## PPA Upload

To upload to a PPA, build a source package:

```bash
# Build source package (requires GPG key for signing)
dpkg-buildpackage -S -sa

# Upload to PPA
dput ppa:your-ppa-name ../cangjie-compiler_*.changes
```

## References

- [Cangjie Compiler Repository](https://github.com/cangjielanguage/cangjie_compiler)
- [Cangjie Build Guide](https://github.com/cangjielanguage/cangjie_build)
- [Cangjie Official Website](https://cangjie-lang.cn/)

## License

The packaging files in this repository are licensed under Apache-2.0, matching the upstream Cangjie compiler license.