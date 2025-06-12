
# QUEST

QUantum Electron Simulation Toolbox (QUEST) is a Fortran 90/95 package that implements the Determinant Quantum Monte Carlo (DQMC) method for quantum electron simulations. The original versions of DQMC programs, developed by the condensed matter theory group at UCSB including R. L Sugar, D. J. Scalapino, S. R. White, and E. Y. Loh, and maintained by R. Scalettar, have been extensively used to study magnetism, metal-insulator transitions, and superconductivity by the Hubbard model.


### Folders:

* EXAMPLE - contains subfolders with examples running QUEST.
* OpenBLAS - source code of the OpenBLAS library (for use with QUEST-provided BLAS and LAPACK).
* SRC - QUEST source code.
* doc - documentation.
* geometries - examples of the geometry input files (gfiles).
* makefiles - old makefiles (may be of use porting to other platforms).

### Installation:

Currently, QUEST is being developed on an Ubuntu (22.04) machine running an Intel processor, so the installation instructions reflect how it would be installed from scratch on such a machine.
As QUEST is installed on more platforms, installation instructions for other machines and compilers will be added. The main differences should primaily be slight alterations of the top-level Makefile, so older Makefiles are included in the makefiles folder to hopefully aid in
other machine installations.

### Assumptions for installation:
  * Unix based operating system (eg, Ubuntu, Mac, WSL)
  * Either the Intel Oneapi base and HPC toolkits **or** gfortran and an mpi installation (tested with openmpi, potentially usable without mpi with minor modifications)
  * Git installed
  * gnuMake installed

### Steps:
  1. (if using Intel Oneapi) Open a terminal and run the Oneapi setvars command: `source /opt/intel/oneapi/setvars.sh` (with a default installation).
  2. Clone this repository `git clone https://github.com/Meromorphics/quest.git` in a suitable folder (default name of cloned repository will be quest).
  3. Download sprng5 from http://www.sprng.org/ or by running `wget http://www.sprng.org/Version5.0/sprng5.tar.bz2`
  4. Untar the download `tar xjf sprng5.tar.bz2`.
  5. Change directories to sprng5 `cd sprng5`, prepare to compile it with Fortran and mpi enabled `./configure --with-fortran=yes --with-mpi=yes`, then compile it `make`.
  6. Get out of the sprng5 directory `cd ..`, and move it to quest/SRC `mv sprng5 quest/SRC`.
  7. Go to the QUEST directory `cd quest` and make QUEST `make` (this step will require more information, see below).
  8. Verify that QUEST runs properly by running the verify program `cd EXAMPLE/verify` `./verify`. This should take around 30 seconds to run. This program prints information about how well QUEST simulates two small nalytically solved models. QUEST will print how well it performed. If the performance is not acceptable, do not continue to run QUEST for the purposes of obtaining data (the installation went wrong or QUEST is badly bugged).

### Step 7 continued:
Step 7 requires the main Makefile (topmost one, and less likely the lesser Makefiles) to be configured for your machine and usage. The main Makefile has tons of information and compilation methodologies, but here we will go over the basic ones needed to get things up and running.

If you are using Oneapi and it is not installed in its default location, then the top level Makefile (the one in the quest directory) will have to be informed of this. MKLPATH should be set to the correct path to Oneapi's ilp64 folder (this should just be changing `$(MKLROOT)` to the installation directory of Oneapi).

Near the top of the Makefile you will see an option of choosing a compiler. Set `COMPILER = intel` if you are using Intel, and `COMPILER = gnu` if you are using gfortran.
Below your compiler choice you will see an option of choosing a LAPACK installation. If you are using Intel, just set `LAPACK = intel`. If you are using gfortran, first set `LAPACK = default`, then compile this default LAPACK by typing `make lapack` in a terminal in the top-level quest directory.

A little bit below this is a line setting the variable `FLAG_CKB` equal to something (in a fresh installation this is either set equal to nothing or commented out using `#`). This determines whether to use the checkerboard decomposition or not. To use the checkerboard decomposition, set `FLAG_CKB = ` (yes it looks like it is equal to something blank, setting it equal to something will give an error). To not use the checkerboard decomposition, either delete the line or comment it out.

Lastly are the compiler flags. These are set a bit below where `FLAG_CKB` is set. There are two sections labeled by `ifeq ($(COMPILER), intel)` and `ifeq ($(COMPILER), gnu)`, which correspond to whether you are using an Intel compiler or gfortran. The most important thing here to change is `FC_FLAGS`, which determines what compiler flags you want to compile with. This is up to personal preference and use, but it is worth mentioning that `-g` adds in extra debugger information and `-Ox` for `x = 0,1,2,3,fast` adds extra compiler optimizations (faster code).

### Basic usage:

Details on using QUEST is provided in `quest/doc/manual.pdf`. The most basic usage is described as follows. Under `quest/EXAMPLE/geom` there is a program `ggeom` that has been preconfigured to take input files describing the geometry of a lattice and simulation parameters. To run it (while in the directory `quest/EXAMPLE/geom`), type either `./ggeom in` to run in a single thread or `./ggeom in -p n` where `n` is the number of processor threads to run QUEST in (modern household computers have a maximum of around 24 threads in them). `in` is an input file that communicates to QUEST how to run the simulation. An example input file `in` is provided. In addition to an input file, QUEST requires a geometry file. Example geometry files are provided in the folder `quest/geometries` and the name of the used geometry file must be provided in `in` (the variables `gfile`).
