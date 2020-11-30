FIRMWARE_PATH = ../..
VERILOG_PATH = ../../../..
RTL_PATH = $(VERILOG_PATH)/rtl
IP_PATH = ../../../../ip
BEHAVIOURAL_MODELS = ../../

GCC_PATH?=/ef/apps/bin
GCC_PREFIX?=riscv32-unknown-elf
PDK_PATH?=/ef/tech/SW/sky130A

SIM?=RTL

PYFIVE_PATH = ../../../../../openlane/pyfive_top

PYFIVE_SRC += $(addprefix -l${PYFIVE_PATH}/src/, \
	audio.v \
	delay.v \
	fifo_sync_256x32_sky130.v \
	fifo_sync_ram.v \
	fifo_sync_shift.v \
	glitch_filter.v \
	pdm.v \
	pyfive_top.v \
	ram_sdp.v \
	uart_rx.v \
	uart_tx.v \
	uart_wb.v \
	vid_palette.v \
	vid_ram_char.v \
	vid_ram_screen.v \
	vid_tgen.v \
	vid_top.v \
	wb_splitter.v \
)

PYFIVE_SRC += $(addprefix -l${PYFIVE_PATH}/no2usb/rtl/, \
	usb.v \
	usb_crc.v \
	usb_ep_buf.v \
	usb_ep_status.v \
	usb_phy.v \
	usb_rx_ll.v \
	usb_rx_pkt.v \
	usb_sky130.v \
	usb_trans.v \
	usb_tx_ll.v \
	usb_tx_pkt.v \
)

#PYFIVE_SRC=../../../../gl/pyfive_top.lvs.powered.v

PYFIVE_INC = -I${PYFIVE_PATH}/no2usb/rtl

.SUFFIXES:

PATTERN = pyfive_top

all:  ${PATTERN:=.vcd}

hex:  ${PATTERN:=.hex}

%.vvp: %_tb.v %.hex
ifeq ($(SIM),RTL)
	iverilog -DFUNCTIONAL -DSIM -DUSE_POWER_PINS -I $(BEHAVIOURAL_MODELS) \
	-I $(PDK_PATH) -I $(IP_PATH) -I $(RTL_PATH) \
	$(PYFIVE_INC) $(PYFIVE_SRC) \
	$< -o $@
else
	iverilog -DFUNCTIONAL -DSIM -DGL -DUSE_POWER_PINS -I $(BEHAVIOURAL_MODELS) \
	-I $(PDK_PATH) -I $(IP_PATH) -I $(VERILOG_PATH) -I $(RTL_PATH) \
	$(PYFIVE_INC) $(PYFIVE_SRC) \
	$< -o $@
endif

%.vcd: %.vvp
	vvp $< -fst

%.elf: %.c $(FIRMWARE_PATH)/sections.lds $(FIRMWARE_PATH)/start.s
	${GCC_PATH}/${GCC_PREFIX}-gcc -march=rv32imc -mabi=ilp32 -Os -Wl,-Bstatic,-T,$(FIRMWARE_PATH)/sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ $(FIRMWARE_PATH)/start.s $<

%.hex: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O verilog $< $@ 
	# to fix flash base address
	sed -i 's/@10000000/@00000000/g' $@

%.bin: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O binary $< /dev/stdout | tail -c +1048577 > $@

# ---- Clean ----

clean:
	rm -f *.elf *.hex *.bin *.vvp *.vcd *.log

.PHONY: clean hex all
