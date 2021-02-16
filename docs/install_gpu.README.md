# How to install a GPU-enabled version of unifrac

Note: The GPU-enabled version is currenlty only supported on Linux systems.

One can however run on Windows systems, too, using [CUDA-enabled WSL2](https://docs.nvidia.com/cuda/wsl-user-guide/index.html).


## Regular unifrac installation

Install the production unifrac using [Anaconda](https://www.anaconda.com/products/individual).

The instructions below have been tested with version [2020.11](https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh).

In case you have never used Anaconda below, here are the installation instruction:

```
wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
chmod a+x Anaconda3-2020.11-Linux-x86_64.sh
./Anaconda3-2020.11-Linux-x86_64.sh
#log out and back in
```

While it is possible to install a GPU-enabled UniFrac in any Anaconda environment, we assume a dedicated one in this document.
We call it **unifrac-gpu**.

Note: If you decide to change the used environment, you will have to make the appropriate changes to the scripts below. 

To create our **unifrac-gpu** with all the needed dependencies, run:

```
# create and activate unifrac-gpu Anaconda environment
conda create --name unifrac-gpu -c conda-forge -c bioconda unifrac
conda activate unifrac-gpu
```

## Download pre-compiled GPU-enabled binaries


Let's first save the original binaries:
```
# save CPU version of binaries
mv $CONDA_PREFIX/bin/ssu $CONDA_PREFIX/bin/ssu.cpu
mv $CONDA_PREFIX/bin/faithpd $CONDA_PREFIX/bin/faithpd.cpu
mv $CONDA_PREFIX/lib/libssu.so $CONDA_PREFIX/bin/libssu.so.cpu
```

Now put the GPU-enabled ones in place, and make sure they are executable:
```
curl -o $CONDA_PREFIX/bin/ssu https://raw.githubusercontent.com/sfiligoi/unifrac/v0.20.2-docs/bins/linux-x86_64-cuda11.1/bin/ssu
curl -o $CONDA_PREFIX/bin/faithpd https://raw.githubusercontent.com/sfiligoi/unifrac/v0.20.2-docs/bins/linux-x86_64-cuda11.1/bin/faithpd
curl -o $CONDA_PREFIX/lib/libssu.so https://raw.githubusercontent.com/sfiligoi/unifrac/v0.20.2-docs/bins/linux-x86_64-cuda11.1/lib/libssu.so

chmod a+x $CONDA_PREFIX/bin/ssu
chmod a+x $CONDA_PREFIX/bin/faithpd
chmod a+x $CONDA_PREFIX/lib/libssu.so
```

And you are all done.
The UniFrac binary and libraries in the Anaconda environment are now the GPU-enabled ones.

