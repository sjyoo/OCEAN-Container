# System-dependent makefile options for ONCVPSP
# This must be carefully edited before executing "make" in src
#
# Copyright (c) 1989-2015 by D. R. Hamann, Mat-Sim Research LLC and Rutgers
# University

##### Edit the following lines to correspond to your compilers ####

F77        = gfortran
F90        = gfortran
CC         = gcc
FCCPP      = cpp

FLINKER     = $(F90)

FCCPPFLAGS = -ansi -DLIBXC_VERSION=203  #This probably should not be changed

##### Edit the following optimization flags for your system ####

FFLAGS     = -O3 -ffast-math -funroll-loops
CFLAGS     = -O3

##### Edit the following LAPACK and BLAS library paths for your system ####
LIBS = -L/usr/local/lib -llapack -lblas

##### Edit the following for to use libxc if available #####
OBJS_LIBXC =    exc_libxc_stub.o

LIBS +=  -lxcf90 -lxc

FFLAGS += -I/usr/local/src/libxc-4.3.4/src
