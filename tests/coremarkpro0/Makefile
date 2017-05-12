#include ../crosscompile_defs.mk

TARGET		:= raspi2

TOPDIR		= $(shell pwd)
COREDIR 	= $(TOPDIR)/eembc/coremarkpro/benchmarks/core
MITHDIR 	= $(TOPDIR)/eembc/coremarkpro/mith
BSPDIR		= $(TOPDIR)/safran/bsps/$(TARGET)
WORKDIR		= $(TOPDIR)/safran/workloads/coremarkpro-core

SRCS		= $(shell find . -type f -iname '*.c')
OBJS		= $(SRCS:.c=.o)

ELF			= coremark.elf

CFLAGS		= -Wall

.PHONY: all
all : $(ELF)

$(ELF): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ -lm

$(OBJS):
	$(MAKE) -C $(COREDIR) BSPDIR=$(BSPDIR)
	$(MAKE) -C $(MITHDIR) BSPDIR=$(BSPDIR)
	$(MAKE) -C $(WORKDIR) BSPDIR=$(BSPDIR)

.PHONY: clean
clean:
	$(MAKE) -C $(COREDIR) BSPDIR=$(BSPDIR) clean
	$(MAKE) -C $(MITHDIR) BSPDIR=$(BSPDIR) clean
	$(MAKE) -C $(WORKDIR) BSPDIR=$(BSPDIR) clean
	$(RM) $(OBJS) $(ELF)


