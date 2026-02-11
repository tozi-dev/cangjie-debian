# Debian Packaging for Cangjie Compiler

This directory contains the Debian packaging files for creating Ubuntu/Debian packages for the Cangjie programming language compiler.

## Packages

This packaging creates two binary packages:

1. **cangjie-compiler**: Contains the Cangjie compiler binaries and runtime libraries
   - The `cjc` compiler executable
   - Shared libraries for the compiler infrastructure
   - Runtime support files

2. **cangjie-compiler-headers**: Contains development headers
   - C/C++ header files for compiler integration
   - Development files for building compiler extensions

## Building the Packages

### Prerequisites

Install the build dependencies:

```bash
sudo apt-get update
sudo apt-get install debhelper cmake clang llvm-dev libclang-dev ninja-build python3 git
```

### Building from Source

To build the packages:

```bash
# Get the Cangjie compiler source
git clone https://github.com/cangjielanguage/cangjie_compiler.git
cd cangjie_compiler

# Copy debian packaging files
cp -r /path/to/this/debian ./

# Build the packages
dpkg-buildpackage -us -uc -b
```

This will create the `.deb` packages in the parent directory.

### Building for PPA

To build source packages for uploading to a PPA:

```bash
# Build source package
dpkg-buildpackage -S -sa

# Sign and upload to PPA (requires GPG key setup)
dput ppa:your-ppa-name ../cangjie-compiler_*.changes
```

## Package Structure

- `debian/control`: Package metadata and dependencies
- `debian/rules`: Build rules (uses CMake)
- `debian/changelog`: Package version history
- `debian/copyright`: License information
- `debian/compat`: Debhelper compatibility level
- `debian/*.install`: File installation manifests

## Notes

- The packages are built using CMake with Ninja generator
- LLVM 14+ is required
- Currently supports amd64 and arm64 architectures
- The compiler headers package is architecture-independent

## References

- Upstream repository: https://github.com/cangjielanguage/cangjie_compiler
- Build instructions: https://github.com/cangjielanguage/cangjie_build
- Cangjie language homepage: https://cangjie-lang.cn/
