#!/bin/bash

#
# This is a helper script for installing the NVIDIA HPC SDK 
# needed to compile a GPU-enabled version of unifrac.
#

# Create GCC symbolic links
# since NVIDIA HPC SDK does not use the env variables
if [ "x${GCC}" == "x" ]; then
  echo "ERROR: GCC not defined"
  exit 1
fi

# usually $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-
EXE_PREFIX=${GCC%%*(gcc)}

echo "GCC pointing to ${EXE_PREFIX}gcc"
ls -l ${EXE_PREFIX}gcc

mkdir conda_nv_bins
(cd conda_nv_bins && for f in \
  ar as c++ cc cpp g++ gcc ld nm ranlib strip; \
  do \
    ln -s ${EXE_PREFIX}${f} ${f}; \
  done )

# create helper scripts
mkdir setup_scripts
echo "conda activate unifrac-gpu " \
  > setup_scripts/setup_conda_nv_bins.sh
echo "PATH=${PWD}/conda_nv_bins:\$PATH" \
  >> setup_scripts/setup_conda_nv_bins.sh

source setup_scripts/setup_conda_nv_bins.sh

# must patch the  install scripts to find the right gcc
sed -i -e "s#PATH=/#PATH=$PWD/conda_nv_bins:/#g" \
  nvhpc_*/install_components/install 
sed -i -e "s#PATH=/#PATH=$PWD/conda_nv_bins:/#g" \
  nvhpc_*/install_components/*/*/compilers/bin/makelocalrc
sed -i -e "s#PATH=/#PATH=$PWD/conda_nv_bins:/#g" \
  nvhpc_*/install_components/*/*/compilers/bin/addlocalrc
sed -i -e "s#PATH=/#PATH=$PWD/conda_nv_bins:/#g" \
  nvhpc_*/install_components/install_cuda

# Install the NVIDIA HPC SDK

# This link may need to be updated, as new compiler versions are released
wget https://developer.download.nvidia.com/hpc-sdk/20.11/nvhpc_2020_2011_Linux_x86_64_cuda_11.1.tar.gz
tar xpzf nvhpc_*.tar.gz
rm -f nvhpc_*.tar.gz

export NVHPC_INSTALL_DIR=$PWD/hpc_sdk
export NVHPC_SILENT=true

(cd nvhpc_*; ./install)

echo "PATH=\$PATH:`ls -d $PWD/hpc_sdk/*/202*/compilers/bin`" \
  > setup_scripts/setup_nv_hpc_bins.sh

# h5c++ patch
mkdir conda_h5
cp $CONDA_PREFIX/bin/h5c++ conda_h5/

# This works on linux with gcc ..
sed -i \
  "s#x86_64-conda.*-linux-gnu-c++#pgc++ -I`ls -d $PWD/hpc_sdk/*/202*/compilers/include`#g" \
  conda_h5/h5c++ 
sed -i \
  's#H5BLD_CXXFLAGS=".*"#H5BLD_CXXFLAGS=" -fvisibility-inlines-hidden -std=c++17 -fPIC -O2 -I${includedir}"#g'  \
  conda_h5/h5c++
sed -i \
  's#H5BLD_CPPFLAGS=".*"#H5BLD_CPPFLAGS=" -I${includedir} -DNDEBUG -D_FORTIFY_SOURCE=2 -O2"#g' \
  conda_h5/h5c++
sed -i \
  's#H5BLD_LDFLAGS=".*"#H5BLD_LDFLAGS=" -L${prefix}/x86_64-conda-linux-gnu/sysroot/usr/lib64/ -L${libdir} -Wl,-O2 -Wl,--sort-common -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,--disable-new-dtags -Wl,-rpath,\\\\\\$ORIGIN/../x86_64-conda-linux-gnu/sysroot/usr/lib64/ -Wl,-rpath,\\\\\\$ORIGIN/../lib -Wl,-rpath,${prefix}/x86_64-conda-linux-gnu/sysroot/usr/lib64/ -Wl,-rpath,${libdir}"#g' \
 conda_h5/h5c++

cat > setup_nv_h5.sh  << EOF
source $PWD/setup_scripts/setup_conda_nv_bins.sh
source $PWD/setup_scripts/setup_nv_hpc_bins.sh

PATH=${PWD}/conda_h5:\$PATH

# pgc++ does not define it, but gcc libraries expect it
export CPPFLAGS=-D__GCC_ATOMIC_TEST_AND_SET_TRUEVAL=0

EOF

