prefix		= m68k-elf-
CC			= $(prefix)gcc
AS			= $(prefix)as
LD			= $(prefix)ld
OBJCOPY		= $(prefix)objcopy
OBJDUMP		= $(prefix)objdump
RM			= rm

PROJECT		= r68k_bootloader
PROGRAM 	= $(PROJECT).elf
TARGET_S	= $(PROJECT).s68
TARGET_B	= $(PROJECT).bin

CFLAGS		= -g -Os -m68000 -Wall -fomit-frame-pointer
LDFLAGS 	= -Map $(PROJECT).map -T ricochet.lds -nostdlib

MAKEFILE	= Makefile

OBJS		= main.o startup.o

LIBS		=

all:		$(TARGET_B) $(TARGET_S)

$(TARGET_B): $(PROGRAM)
	$(OBJCOPY) -O binary --remove-section=.data $(PROGRAM) $(TARGET_B)
	@echo '-------------------------------------------------------------------'
	@echo " $(TARGET_B) build succeeded. [`date`]"
	@echo ''

$(TARGET_S): $(PROGRAM)
	$(OBJCOPY) -O srec --remove-section=.data $(PROGRAM) $(TARGET_S)
	$(OBJDUMP) -D $(PROGRAM) >$(PROGRAM).dasm
	$(OBJDUMP) -h $(PROGRAM)
	@echo '-------------------------------------------------------------------'
	@echo " $(TARGET_S) build succeeded. [`date`]"
	@echo ''

$(PROGRAM): 	$(OBJS) $(LIBS)
		$(LD) $(LDFLAGS) -o $(PROGRAM) $(OBJS)

%.o:		%.c
		$(CC) $(CFLAGS) -c $<

clean:
	$(RM) -f $(PROGRAM)
	$(RM) -f $(TARGET_S)
	$(RM) -f $(TARGET_B)
	$(RM) -f *.o

tar:
	cd .. && tar czvf $(PROJECT)-`date '+%Y%m%d'`.tar.gz $(PROJECT)