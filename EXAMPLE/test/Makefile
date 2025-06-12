.SUFFIXES : .mod .o .f90

test:    $(QUEST_DIR)/$(DQMCLIB) test.f90
	$(FC) $(FLAGS) -I$(QUEST_DIR)/SRC -o test  test.f90 $(QUEST_DIR)/$(DQMCLIB) $(LIB) 

clean:
	rm -f test

