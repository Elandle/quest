############################################################################
#  QUEST Makefile    
############################################################################

# Top-level directory of QUEST.
# By default, this is set to the directory of this current Makefile
QUEST_DIR = $(shell pwd)

# Fortran compiler.
# Two options:
#     gnu  : gfortran compiler
#     intel: intel compiler (ifort)
# The intel compiler has the best performance (because of its MKL), 
# but is only available on intel processors.
COMPILER  = intel

# LAPACK distribution to use.
# Four options (only default and intel have been recently tested):
#     default: OpenBLAS distribution provided with QUEST
#     mkl_seq: sequential MKL
#     mkl_par: parallel MKL
#     intel  : intel MKL
# Note: the last three options require the intel compiler to be used
# (since they are all part of intel's MKL library).
# Note: when using the default LAPACK distribution, OpenBLAS must be compiled manually
# before compiling QUEST (QUEST does not compile OpenBLAS when calling this Makefile).
# This can be done by calling the top level Makefile of the OpenBLAS directory.
LAPACK    = intel

# Path of the installed intel MKL library.
# Applicable only if using the intel compiler and its MKL.
# By default, this is set to the default installation location when installing intel's MKL
MKLPATH   = $(MKLROOT)/include/intel64/ilp64

# MAGMA library path.
# For use when using CUDA.
# This option is untested.
MAGMAPATH = 

# nVidia CUDA installation path.
# This option is untested.
CUDAPATH  = #/usr/lib/nvidia-cuda-toolkit

# Whether to use the checkerboard decomposition or not when computing the
# exponential of the kinetic energy matrix.
# Two options:
#     -DDQMC_CKB: use the checkerboard decomposition (FLAG_CKB  = -DDQMC_CKB)
#     (blank)   : do not use the checkerboard decomposition (FLAG_CKB = )
FLAG_CKB  = -DDQMC_CKB

# GPU version equal-time Green's function kernel.
# This option is untested.
#FLAG_ASQRD = -DDQMC_ASQRD

# GPU version time-dependent Green's function kernel
# This option is untested.
FLAG_BSOFI = #-DDQMC_BSOFI

# Enabling nVidia CUDA support in DQMC
# This option is untested.
FLAG_CUDA = #-DDQMC_CUDA


# --------------------------------------------------------------------------
#  Check ASQRD and CKB compatibility
# --------------------------------------------------------------------------
ifdef FLAG_ASQRD
  ifdef FLAG_CKB
    $(error ASQRD method does not support checkerboard decomposition at the moment. \
      Please turn off the flag FLAG_CKB or FLAG_ASQRD)
  endif
endif


# --------------------------------------------------------------------------
#  Compiler and flags
# --------------------------------------------------------------------------
ifndef COMPILER
  $(error "COMPILER" is not defined in the Makefile.)
endif

ifeq ($(COMPILER), intel)
  FC        = ifort
  CXX       = icpx
  # Performance flags (should be using when not debugging):
  FC_FLAGS  = -qopenmp -m64 -warn all -O3 -unroll -heap-arrays -heap-arrays
  CXX_FLAGS = -m64 -Wall -O3 -unroll $(CUDAINC) $(MAGMAINC)
  # Debugging flags:
  # FC_FLAGS  = -m64 -warn all -unroll -heap-arrays -g -debug all
  # CXX_FLAGS = -m64 -g -traceback -O0 -check-uninit -ftrapuv -debug all
endif
ifeq ($(COMPILER), gnu)
  FC        = gfortran
  CXX       = g++
  FC_FLAGS  = -fopenmp -m64 -O3 -funroll-loops -ffree-line-length-none -cpp
  CXX_FLAGS = -m64 -Wall -O3 -funroll-loops $(CUDAINC) $(MAGMAINC)
endif


# --------------------------------------------------------------------------
# C++ libraries
# --------------------------------------------------------------------------
CXXLIB = -lstdc++ #-lrt


# --------------------------------------------------------------------------
#  BLAS and LAPACK
# --------------------------------------------------------------------------
ifndef LAPACK
  $(error "LAPACK" is not defined in the Makefile.)
endif

ifeq ($(LAPACK), default)
  libOpenBLAS   = $(QUEST_DIR)/OpenBLAS/libopenblas.a

  # Pass if the target is 'clean' or 'lapack'
  ifneq ($(MAKECMDGOALS), clean)
  ifneq ($(MAKECMDGOALS), lapack)
    ifeq ($(wildcard $(libOpenBLAS)),)
      $(error It appears that LAPACK is set to be "default", but libopenblas.a is missing. \
        Use "make lapack" to build the required library.)
    endif
  endif
  endif
  LAPACKLIB = $(libOpenBLAS)
endif

ifeq ($(LAPACK), mkl_seq)
  ifdef MKLPATH
    #LAPACKLIB = -L$(MKLPATH) -Wl,--no-as-needed -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread
    LAPACKLIB = -L$(MKLPATH) -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread
  else
    $(error "MKLPATH" is not defined in the Makefile.)
  endif
endif

ifeq ($(LAPACK), mkl_par)
  ifdef MKLPATH
    LAPACKLIB = -L$(MKLPATH) -mkl:parallel -lpthread
  else
    $(error "MKLPATH" is not defined in the Makefile.)
  endif
endif

ifeq ($(LAPACK), intel)
  LAPACKLIB = -qmkl=sequential -static-intel
endif


# --------------------------------------------------------------------------
# MAGMA library path
# --------------------------------------------------------------------------
ifdef MAGMAPATH
  MAGMALIB = -L$(MAGMAPATH)/lib -lmagma -lmagmablas -lmagma 
  MAGMAINC = -I$(MAGMAPATH)/include
endif


# --------------------------------------------------------------------------
# CUDA compiler and libraries
# --------------------------------------------------------------------------
ifdef CUDAPATH
  ifeq ($(MAGMAINC),)
    $(error In Makefile, variable MAGMATH is not defined in Makefile)
  endif
  NVCC = $(CUDAPATH)/bin/nvcc
  CU_FLAGS = -O3 -Xptxas -v -m 64 -arch sm_20 $(MAGMAINC)
  CUDALIB = -L$(CUDAPATH)/lib64 -lcublas -lcudart -lcuda
  CUDAINC = -I$(CUDAPATH)/include
endif


# --------------------------------------------------------------------------
# DQMC library
# --------------------------------------------------------------------------
DQMCLIB    = libdqmc.a


# --------------------------------------------------------------------------
# Libraries required by driver routines 
# --------------------------------------------------------------------------
LIB        = $(CXXLIB) $(LAPACKLIB) $(CUDALIB) $(MAGMALIB)

INC        = $(MPIINC)


# --------------------------------------------------------------------------
# Archiver and flags
# --------------------------------------------------------------------------
ifeq ($(COMPILER), intel) 
	ARCH       = xiar
else ifeq ($(COMPILER), gnu)
	ARCH = ar
endif
ARFLAG     = cr
RANLIB     = ranlib


# --------------------------------------------------------------------------
# Optional complication flags
# -D_SXX, -D_QMC_MPI
# --------------------------------------------------------------------------
PRG_FLAGS = $(FLAG_BSOFI) $(FLAG_ASQRD) $(FLAG_CKB) $(FLAG_CUDA) 

FLAGS = $(FC_FLAGS) $(PRG_FLAGS)


# --------------------------------------------------------------------------
export 

.PHONY: libdqmc example libopenblas clean

all : libdqmc example

libdqmc :
	(cd SRC; $(MAKE))
example : libdqmc
	(cd EXAMPLE; $(MAKE))

lapack : libopenblas

libopenblas : 
	(cd $(QUEST_DIR)/OpenBLAS; $(MAKE))

clean :
	(cd $(QUEST_DIR)/SRC; $(MAKE) clean)
	(cd $(QUEST_DIR)/EXAMPLE; $(MAKE) clean)
	(rm -f $(QUEST_DIR)/$(DQMCLIB))
