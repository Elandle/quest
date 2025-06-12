FLAGS=$(FC_FLAGS) $(PRG_FLAGS) -I$(QUEST_DIR)/SRC

.SUFFIXES : .mod .o .f90

mpi:    $(QUEST_DIR)/$(DQMCLIB) verify.f90
	$(FC) $(FLAGS) -o verify verify.f90 $(QUEST_DIR)/$(DQMCLIB) $(LIB) 

clean:
	rm -f verify

