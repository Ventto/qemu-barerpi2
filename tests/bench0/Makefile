include ../crosscompile_defs.mk

APP  = kernel7
ELF  = $(APP).elf
BIN  = $(APP).bin
LDSCRIPT = kernel.ld

SRCS = main.c syscall.c
OBJS = $(SRCS:.c=.o)

all: $(BIN)

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(ELF): startup.o $(OBJS)
	$(CC) -lc -Wl,-Map=$(APP).map -T $(LDSCRIPT) $(CFLAGS) $^ -o $@

main.o: main.c
	$(CC) -c $(CFLAGS) $< -o $@

syscall.o: syscall.c
	$(CC) -c $(CFLAGS) $< -o $@

startup.o: startup.S
	$(AS) $(DFLAG) $< -o $@

debug: CFLAGS+=-g
debug: all

clean:
	$(RM) startup.o $(OBJS) $(APP).map $(ELF) $(BIN)

.PHONY: all debug clean
