# Compiling a GPU-enabled version of UniFrac

Note: The GPU-enabled version is currenlty only supported on Linux systems.
One can however run on Windows systems, too, using [CUDA-enabled WSL2](https://docs.nvidia.com/cuda/wsl-user-guide/index.html).


## Anaconda 

UniFrac has several dependencies, which we assume come via [Anaconda](https://www.anaconda.com/products/individual).

The instructions below has been tested with version [2020.07](https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh).

In case you have never used Anaconda below, here are the installation instruction:

```
wget https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh
chmod a+x Anaconda3-2020.07-Linux-x86_64.sh
./Anaconda3-2020.07-Linux-x86_64.sh
#log out and back in
```

## Create a dedicated environment

While it is possible to build a GPU-enabled UniFrac in any Anaconda environment, we assume a dedicated one in this document.
We call it **unifrac-gpu**.

Note: If you decide to change the used environment, you will have to make the appropriate changes to the scripts below. 

To create our **unifrac-gpu** with all the needed dependencies, run:

```
# create and activate unifrac-gpu Anaconda environment
conda create --name unifrac-gpu -c conda-forge -c bioconda unifrac
conda activate unifrac-gpu
conda install -c conda-forge -c bioconda gxx_linux-64=7.5.0 
conda install -c conda-forge -c bioconda hdf5-static mkl-include
```

## Installing the NVIDIA HPC SDK

Currently, the only supported GPU-enabled compiler is the freely available [NVIDIA HPC SDK](https://developer.nvidia.com/hpc-sdk).

Note that internally the NVIDIA HPC SDK relies on GCC, which makes it possible for the resulting objects to link with the libraries provided through Anaconda. 

You can install the NVIDIA HPC SDK using a helper script:
```
wget https://raw.githubusercontent.com/sfiligoi/unifrac/v0.20.2-docs/scripts/install_hpc_sdk.sh
chmod a+x install_hpc_sdk.sh
./install_hpc_sdk.sh
```

For convenience, it will also create a setup script that will be used to properly setup the environment anytime needed.


## Compiling the GPU-enabled UniFrac with the NVIDIA HPC SDK

In order to compile UniFrac, you will need both the Anaconda dependencies, the NVIDIA HPC SDK and the UniFrac source code.
The first two you setup above, and can enable with the helper script; the later can be imported (once) with git.

```
source setup_nv_h5.sh

# save CPU version of binaries
mv $CONDA_PREFIX/bin/ssu $CONDA_PREFIX/bin/ssu.cpu
mv $CONDA_PREFIX/bin/faithpd $CONDA_PREFIX/bin/faithpd.cpu
mv $CONDA_PREFIX/lib/libssu.so $CONDA_PREFIX/bin/libssu.so.cpu

git clone https://github.com/biocore/unifrac.git
(cd unifrac/sucpp/ && make && make main && make api)
```

And you are all done.
The UniFrac binary and libraries in the Anaconda environment are now the GPU-enabled ones.

Note: If you do not want to use git, you can get a tarball of the released versions, instead.
```
wget https://codeload.github.com/biocore/unifrac/tar.gz/0.20.2
tar -xvzf 0.20.2
(cd unifrac-0.20.2/sucpp/ && make && make main && make api)
```
