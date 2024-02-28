
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

### Assumptions:
  * Ubuntu (22.04) operating system (WSL with Ubuntu is known to work as well)
  * Intel Oneapi base and HPC toolkits installed (the Oneapi setvars command should be run in any terminal before any QUEST compilation)
  * Git installed
  * gnuMake installed

### Steps:
  1. Open a terminal and run the Oneapi setvars command: `source /opt/intel/oneapi/setvars.sh` (with a default installation).
  2. Clone this repository `git clone https://github.com/Meromorphics/quest.git` in a suitable folder (default name of cloned repository will be quest).
  3. Download sprng5 from http://www.sprng.org/ or by running `http://www.sprng.org/Version5.0/sprng5.tar.bz2`
  4. Untar the download `tar xjf sprng5.tar.bz2`.
  5. Change directories to sprng5 `cd sprng5`, prepare to compile it with Fortran enabled `./configure --with-fortran=yes`, then compile it `make`.
  6. Get out of the sprng5 directory `cd ..`, and move it to quest/SRC `mv sprng5 quest/SRC`.
  7. Go to the QUEST directory `cd quest` and make QUEST `make`.
  8. Verify that QUEST runs properly by running the verify program `cd EXAMPLE/verify` `./verify`. This should take around 30 seconds to run. This program prints information about how well QUEST simulates two small nalytically solved models. QUEST will print how well it performed. If the performance is not acceptable, do not continue to run QUEST for the purposes of obtaining data (the installation went wrong or QUEST is badly bugged).

If Oneapi is not installed in its default location, then the top level Makefile (the one in the quest directory) will have to be informed of this. MKLPATH should be set to the correct path to Oneapi's ilp64 folder (this should just be changing `$(MKLROOT)` to the installation directory of Oneapi). Due to complications in running make on an untarred file, an installation of sprng5 is not provided.

### Basic usage:

Details on using QUEST is provided in `quest/doc/manual.pdf`. The most basic usage is described as follows. Under `quest/EXAMPLE/geom` there is a program `ggeom` that has been preconfigured to take input files describing the geometry of a lattice and simulation parameters. To run it (while in the directory `quest/EXAMPLE/geom`), type either `./ggeom in` to run in a single thread or `./ggeom in -p n` where `n` is the number of processor threads to run QUEST in (modern household computers have a maximum of around 24 threads in them). `in` is an input file that communicates to QUEST how to run the simulation. An example input file `in` is provided. In addition to an input file, QUEST requires a geometry file. Example geometry files are provided in the folder `quest/geometries` and the name of the used geometry file must be provided in `in` (the variables `gfile`).
