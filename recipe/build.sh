#!/usr/bin/env bash
set -e

if [ "$(uname)" == "Darwin" ]; then
  skiprpath="-DCMAKE_SKIP_RPATH=TRUE"
else
  skiprpath=""
fi

# Install PyNE
export VERBOSE=1
${PYTHON} setup.py install \
  --build-type="Release" \
  --prefix="${PREFIX}" \
  --hdf5="${PREFIX}" \
  -DCMAKE_OSX_DEPLOYMENT_TARGET="${MACOSX_VERSION_MIN}" \
  ${skiprpath} \
  --clean \
  -j "${CPU_COUNT}"

# Create data library
cd build
if [ "$(uname)" == "Darwin" ]; then
  export DYLD_FALLBACK_LIBRARY_PATH="${DYLD_FALLBACK_LIBRARY_PATH}:${PREFIX}/lib"
else
  export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${PREFIX}/lib"
fi
${PYTHON} ${PREFIX}/bin/nuc_data_make
