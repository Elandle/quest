FLAGS=$(FC_FLAGS) -I$(QUEST_DIR)/SRC

.SUFFIXES : .mod .o .f90

test:   $(QUEST_DIR)/$(DQMCLIB) ggeom.f90
	$(FC) $(FLAGS) -o ggeom ggeom.f90 $(QUEST_DIR)/$(DQMCLIB) $(LIB)

clean:
	rm -f ggeom
