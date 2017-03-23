package: AMPT
version: "alice/v1.26t7-v2.26t7"
source: https://github.com/alisw/ampt
requires:
 - "GCC-Toolchain:(?!osx)"
 - HepMC
---
#!/bin/bash -e

rsync -a --exclude='**/.git' --delete --delete-excluded $SOURCEDIR/ ./
make -j${JOBS}
install -d $INSTALLROOT/bin
install -t $INSTALLROOT/bin ampt
install -t $INSTALLROOT/bin parser

# Modulefile
MODULEDIR="$INSTALLROOT/etc/modulefiles"
MODULEFILE="$MODULEDIR/$PKGNAME"
mkdir -p "$MODULEDIR"
cat > "$MODULEFILE" <<EoF
#%Module1.0
proc ModulesHelp { } {
  global version
  puts stderr "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
}
set version $PKGVERSION-@@PKGREVISION@$PKGHASH@@
module-whatis "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
# Dependencies
module load BASE/1.0 ${HEPMC_VERSION:+HepMC/$HEPMC_VERSION-$HEPMC_REVISION}
# Our environment
setenv AMPT_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
prepend-path PATH \$::env(AMPT_ROOT)/bin
#prepend-path LD_LIBRARY_PATH \$::env(AMPT_ROOT)/lib
#$([[ ${ARCHITECTURE:0:3} == osx ]] && echo "prepend-path DYLD_LIBRARY_PATH \$::env(AMPT_ROOT)/lib")
EoF
