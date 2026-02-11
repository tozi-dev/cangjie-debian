# PPA Upload Guide

This guide explains how to upload the Cangjie compiler packages to a Personal Package Archive (PPA) on Launchpad.

## Prerequisites

1. **Launchpad Account**: Create an account at https://launchpad.net/
2. **GPG Key**: You need a GPG key for signing packages
3. **SSH Key**: Upload your SSH public key to Launchpad
4. **PPA Created**: Create a PPA on your Launchpad profile

## Setting Up GPG Key

If you don't have a GPG key:

```bash
# Generate a new GPG key
gpg --full-generate-key

# List your keys
gpg --list-secret-keys --keyid-format LONG

# Export your public key
gpg --armor --export YOUR_KEY_ID

# Upload to Ubuntu keyserver
gpg --send-keys --keyserver keyserver.ubuntu.com YOUR_KEY_ID
```

## Preparing the Source Package

1. Clone the compiler source with the debian packaging:

```bash
# Clone compiler
git clone --recursive https://github.com/cangjielanguage/cangjie_compiler.git
cd cangjie_compiler

# Clone packaging
git clone https://github.com/tozi-dev/cangjie-debian.git
cp -r cangjie-debian/debian ./

# Create orig tarball
cd ..
tar --exclude-vcs -czf cangjie-compiler_0.53.18.orig.tar.gz cangjie_compiler
cd cangjie_compiler
```

2. Update the changelog for the target Ubuntu version:

```bash
# Install devscripts if not already installed
sudo apt-get install devscripts

# Add a new changelog entry for specific Ubuntu version
dch -v 0.53.18-1ubuntu1~jammy1 "Build for Ubuntu 22.04 (Jammy)"
# or for focal: dch -v 0.53.18-1ubuntu1~focal1 "Build for Ubuntu 20.04 (Focal)"
```

3. Build the source package:

```bash
# Build source package
debuild -S -sa

# This creates:
# - cangjie-compiler_0.53.18-1ubuntu1~jammy1.dsc
# - cangjie-compiler_0.53.18-1ubuntu1~jammy1_source.changes
# - cangjie-compiler_0.53.18-1ubuntu1~jammy1.debian.tar.xz
# - cangjie-compiler_0.53.18.orig.tar.gz
```

## Uploading to PPA

1. Configure dput if needed:

Create or edit `~/.dput.cf`:

```ini
[ppa]
fqdn = ppa.launchpad.net
method = ftp
incoming = ~YOUR_LAUNCHPAD_ID/ubuntu/YOUR_PPA_NAME/
login = anonymous
allow_unsigned_uploads = 0
```

2. Upload to PPA:

```bash
# Navigate to directory with .changes file
cd ..

# Upload using dput
dput ppa:YOUR_LAUNCHPAD_ID/YOUR_PPA_NAME cangjie-compiler_*_source.changes
```

3. Monitor build status:

- Visit your PPA page: https://launchpad.net/~YOUR_LAUNCHPAD_ID/+archive/ubuntu/YOUR_PPA_NAME
- Check the build status for different Ubuntu versions and architectures
- Build logs will be available if there are errors

## Building for Multiple Ubuntu Versions

To support multiple Ubuntu versions, create separate uploads with version-specific suffixes:

```bash
# For Ubuntu 24.04 (Noble)
dch -v 0.53.18-1ubuntu1~noble1 "Build for Ubuntu 24.04 (Noble)"
debuild -S -sa
dput ppa:... cangjie-compiler_*noble*_source.changes

# For Ubuntu 22.04 (Jammy)
dch -v 0.53.18-1ubuntu1~jammy1 "Build for Ubuntu 22.04 (Jammy)"
debuild -S -sa
dput ppa:... cangjie-compiler_*jammy*_source.changes

# For Ubuntu 20.04 (Focal)
dch -v 0.53.18-1ubuntu1~focal1 "Build for Ubuntu 20.04 (Focal)"
debuild -S -sa
dput ppa:... cangjie-compiler_*focal*_source.changes
```

## Installing from PPA

Once uploaded and built, users can install:

```bash
# Add PPA
sudo add-apt-repository ppa:YOUR_LAUNCHPAD_ID/YOUR_PPA_NAME
sudo apt-get update

# Install packages
sudo apt-get install cangjie-compiler cangjie-compiler-headers
```

## Troubleshooting

### Build Failures

- Check the build logs on the PPA page
- Common issues:
  - Missing build dependencies in `debian/control`
  - CMake configuration errors
  - Compiler errors (may need to adjust for different LLVM versions)

### Upload Rejected

- Ensure your GPG key is registered with Launchpad
- Check that the version number is higher than existing versions
- Verify the `.changes` file is properly signed

### Dependency Issues

- Check that all `Build-Depends` in `debian/control` are available in the target Ubuntu version
- You may need to adjust version numbers for different Ubuntu releases

## Automating PPA Uploads

You can automate PPA uploads using GitHub Actions. See the workflow in `.github/workflows/` for an example of automated building. To add PPA upload:

1. Store your GPG private key as a GitHub secret
2. Add a workflow step to sign and upload packages
3. Use `dput` in the CI environment

Note: Storing private GPG keys in CI is sensitive. Consider using a dedicated signing key with limited permissions.
