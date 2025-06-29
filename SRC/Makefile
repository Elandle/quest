.SUFFIXES : .mod .o .f90

FLAGS = $(FC_FLAGS) $(PRG_FLAGS)
SPRNG_INC = -I./sprng5/include

ifdef FLAG_CKB
InitB = dqmc_checkerboard.f90 
else
InitB = dqmc_matb.f90 
endif

ifdef NVCC
OBJ = 	$(SRC:.f90=.o) computeg.o blaslapack.o profile.o kernel_cpu.o kernel_gpu.o
else
OBJ = 	$(SRC:.f90=.o) computeg.o blaslapack.o profile.o kernel_cpu.o
endif

SRC =	dqmc_omp.f90 dqmc_mpi.f90 dqmc_util.f90 dqmc_cfg.f90 \
	dqmc_geom_param.f90 dqmc_latt.f90 dqmc_bonds.f90 dqmc_reclatt.f90 \
	dqmc_hamilt.f90 dqmc_symm.f90 \
	dqmc_wspace.f90 dqmc_struct.f90 dqmc_geom_wrap.f90 $(InitB) \
	dqmc_seqb.f90 dqmc_gfun.f90 dqmc_phy0.f90 \
	dqmc_phy2.f90 dqmc_hubbard.f90 dqmc_gtau.f90 \
	dqmc_tdm1.f90 dqmc_tdm2.f90 dqmc_kbonds.f90 dqmc_2dperl.f90

INC = 	$(SRC:.f90=.mod)

lib: 	$(OBJ)
	$(ARCH) $(ARFLAG) ../$(DQMCLIB) $(OBJ)
	$(RANLIB) ../$(DQMCLIB)

dqmc_wrap.o : dqmc_symm.o
dqmc_wspace.o : dqmc_util.o
dqmc_bonds.o : dqmc_latt.o
dqmc_latt.o : dqmc_util.o
dqmc_2dperl.o : dqmc_cfg.o dqmc_hubbard.o
dqmc_kbonds.o : dqmc_reclatt.o dqmc_symm.o
dqmc_tdm1.o : dqmc_struct.o dqmc_gtau.o
dqmc_tdm2.o : dqmc_struct.o dqmc_phy2.o dqmc_tdm1.o
dqmc_hubbard.o : dqmc_cfg.o dqmc_phy0.o dqmc_phy2.o
dqmc_phy2.o : dqmc_struct.o dqmc_symm.o
dqmc_phy0.o : dqmc_struct.o
ifdef FLAG_CKB
dqmc_gtau.o : dqmc_checkerboard.o dqmc_hubbard.o
dqmc_gfun.o : dqmc_checkerboard.o dqmc_seqb.o
dqmc_seqb.o : dqmc_checkerboard.o
else
dqmc_gtau.o : dqmc_matb.o dqmc_hubbard.o
dqmc_gfun.o : dqmc_matb.o dqmc_seqb.o
dqmc_seqb.o : dqmc_matb.o
endif
dqmc_checkerboard.o : dqmc_struct.o
dqmc_matb.o : dqmc_struct.o
dqmc_geom_wrap.o : dqmc_hamilt.o dqmc_symm.o
dqmc_symm.o : dqmc_hamilt.o
dqmc_hamilt.o : dqmc_reclatt.o
dqmc_struct.o : dqmc_cfg.o
dqmc_reclatt.o : dqmc_cfg.o
dqmc_cfg.o : dqmc_mpi.o dqmc_util.o

%.o: 	%.f90
	$(FC) $(FLAGS) $(SPRNG_INC) -c $<

%.o: 	%.c++ blaslapack.h profile.h kernel_cpu.h kernel_gpu.h
	$(CXX) $(PRG_FLAGS) $(CXX_FLAGS) -c $<

%.o:	%.cu blaslapack.h profile.h kernel_gpu.h
	$(NVCC) $(PRG_FLAGS) $(CU_FLAGS) -c $<

clean:
	rm -f *.o *.mod 
