# Contributing to Cangjie Debian Packaging

Thank you for your interest in contributing to the Cangjie Debian packaging project!

## How to Contribute

### Reporting Issues

If you encounter problems with the packaging:

1. Check existing issues at https://github.com/tozi-dev/cangjie-debian/issues
2. Create a new issue with:
   - Description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - System information (Ubuntu version, architecture)

### Updating Package Versions

When a new version of Cangjie compiler is released:

1. Update `debian/changelog`:
   ```bash
   dch -v NEW_VERSION-1 "New upstream release"
   ```

2. Update dependencies in `debian/control` if needed

3. Test the build locally:
   ```bash
   ./build.sh
   ```

4. Submit a pull request

### Modifying Build Process

If you need to modify the build process:

1. Edit `debian/rules` for build configuration
2. Update `debian/control` if adding/removing dependencies
3. Test thoroughly on Ubuntu 22.04 (or the target version)
4. Document changes in the PR description

### Adding Support for New Ubuntu Versions

To add support for a new Ubuntu release:

1. Update `.github/workflows/build-packages.yml`:
   ```yaml
   matrix:
     ubuntu-version: ['22.04', '24.04']  # Add new version
   ```

2. Test compatibility with the new Ubuntu version
3. Update documentation with any version-specific notes

## Testing Your Changes

### Local Testing

1. Install build dependencies:
   ```bash
   sudo apt-get install debhelper cmake clang-14 llvm-14-dev libclang-14-dev ninja-build python3 git build-essential
   ```

2. Run the build script:
   ```bash
   ./build.sh
   ```

3. Test installation:
   ```bash
   cd /tmp/cangjie-build
   sudo dpkg -i *.deb
   ```

4. Test the compiler:
   ```bash
   cjc --version
   ```

### CI Testing

All pull requests automatically trigger the GitHub Actions workflow, which:
- Builds packages for specified Ubuntu versions
- Runs lintian checks
- Uploads build artifacts

Review the workflow results before merging.

## Code Review Process

1. Submit a pull request with clear description
2. Wait for automated checks to pass
3. Address reviewer feedback
4. Once approved, a maintainer will merge

## Packaging Standards

Follow these standards when contributing:

1. **Debian Policy**: Follow https://www.debian.org/doc/debian-policy/
2. **Version Naming**: Use format `UPSTREAM_VERSION-DEBIAN_REVISION`
3. **Dependencies**: Be conservative - only add necessary dependencies
4. **Documentation**: Update README.md and debian/README.md as needed

## File Structure

Key files and their purposes:

- `debian/control`: Package metadata and dependencies
- `debian/rules`: Build process definition
- `debian/changelog`: Version history
- `debian/*.install`: File installation manifests
- `.github/workflows/`: CI/CD configuration

## Questions?

- Open a discussion: https://github.com/tozi-dev/cangjie-debian/discussions
- Check documentation: README.md, PPA_UPLOAD.md
- Review existing issues and PRs

## License

By contributing, you agree that your contributions will be licensed under the Apache-2.0 license.
