#File Locations
LAPACKLIBS=  -L/opt/atlas/lib/ -lcblas -lf77blas -latlas -llapack
SPAMADIR=./sparseAMA

PARAMFILENAME=$(MODNAME)_AMA_SetAllParamsZero
LOBJS = $(MODNAME)_AMA_template.o $(MODNAME)_AMA_matrices.o $(PARAMFILENAME).o
FOBJS = $(patsubst %.f,%.o,$(wildcard $(SPAMADIR)/src/main/fortran/*.f))
COBJS = $(patsubst %.c,%.o,$(wildcard $(SPAMADIR)/src/main/c/*.c))



#Flags, Compilers, Linkers
LINK = ifort
#LINK = gfortran
FC = ifort
#FC = gfortran
FFLAGS = -c -g -I$(SPAMADIR)/src/main/include
CC = icc
#CC = gcc
CFLAGS = -c -g -I$(SPAMADIR)/src/main/include -I/msu/res1/Software/matio-1.5.1/src/

RUN$(MODNAME): $(LOBJS) $(FOBJS) $(COBJS) getmat.o
	$(LINK) -g $(LOBJS) $(FOBJS) $(COBJS)  -L/msu/res1/Software/matio-1.5.1/src/.libs -lmatio -lm $(LAPACKLIBS) -o RUN$(MODNAME)

$(PARAMFILENAME).o: $(PARAMFILENAME).f90
	$(FC)  $(FFLAGS) $(PARAMFILENAME).f90 -fPIC

$(MODNAME)_AMA_template.o: $(MODNAME)_AMA_template.f90
	$(FC)  $(FFLAGS) $(MODNAME)_AMA_template.f90 -fPIC

$(MODNAME)_AMA_matrices.o : $(MODNAME)_AMA_matrices.c
	$(CC)  $(CFLAGS) $(MODNAME)_AMA_matrices.c -I$(SPAMADIR)/src/main/include -shared -fPIC -o $(MODNAME)_AMA_matrices.o

getmat.o: $(SPAMADIR)/src/main/c/getmat.c	
	$(CC) $(CFLAGS) -fPIC  $(SPAMADIR)/src/main/c/getmat.c -o getmat.o

clean:
	rm -f $(LOBJS) 
	mv reasonableParams.f90 keepItNIXON
	rm -f *.f90
	rm -f *.c
	rm -f *.o
	rm -f RUN*
	mv keepItNIXON reasonableParams.f90

distclean:
	rm -f $(LOBJS) $(FOBJS) $(COBJS)
	mv reasonableParams.f90 keepItNIXON
	rm -f *.f90
	rm -f *.c
	rm -f *.o
	rm -f RUN*
	mv keepItNIXON reasonableParams.f90

echo:
	echo $(LOBJS)
	echo $(FOBJS)
	echo $(COBJS)
