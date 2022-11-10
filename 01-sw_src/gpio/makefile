TARGET       = gpio_test
ARCH         = riscv
PLATFORM     = machine-fpga

EXTRA_CFLAGS+= -DCPU_KHZ=50000

SRC_DIR      = ./ 
SRC_DIR     += ./include


# Malloc support
# EXTRA_CFLAGS+= -DCONFIG_MALLOC
# EXTRA_CFLAGS+= -DCONFIG_MALLOC_SIZE=131072

# UART driver
EXTRA_CFLAGS += -DCONFIG_UARTLITE
EXTRA_CFLAGS += -DCONFIG_UARTLITE_BASE=0x92000000
SRC_DIR     += ./drivers/uart
SRC_DIR     += ./coremark

# IRQ driver
EXTRA_CFLAGS+= -DCONFIG_IRQCTRL
EXTRA_CFLAGS+= -DCONFIG_IRQCTRL_BASE=0x90000000
SRC_DIR     += ./drivers/irq

# MEM_SIZE     ?= 1048576
MEM_SIZE     ?= 65536 # 65536

OPT           = 2

TARGET_PORT ?= /dev/ttyUSB2
RUN_PREFIX  := ../run.py -d $(TARGET_PORT) -b 1000000 -f 

MAKE_DIR=./make
include $(MAKE_DIR)/makefile.exe
