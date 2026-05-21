include ../../make_opts

all: mtt_bias

clean:
	$(RM) *.o $(BIASLIBDIR)$(BIASLIBRARY)

#
# Compilation of the module mtt_bias
#
mtt_bias.o: mtt_bias.f ../bias.inc
	$(FC) $(FFLAGS) $(LDFLAGS) -c -o mtt_bias.o mtt_bias.f

mtt_bias: mtt_bias.o
	$(call CREATELIB, $(BIASLIBDIR)$(BIASLIBRARY), $^)

#
# List of the requirements for this module.
# 'VALID' is the keyword that *must* be returned if everything is in order.
#
requirements:	
	@echo "VALID"

