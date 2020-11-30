#include "../../defs.h"
#include "../../stub.c"

/*
	PyFive Generic Test
*/

#include <stdint.h>

#include "ucode.h"

//static volatile uint32_t * const usb_regs  	= (void*)(0x30000000);
static volatile uint32_t * const midi_regs 	= (void*)(0x30100000);
static volatile uint32_t * const audio_regs	= (void*)(0x30200000);
static volatile uint32_t * const video_regs	= (void*)(0x30300000);
static volatile uint32_t * const ram       	= (void*)(0x30400000);


#define USB_CORE_BASE	0x30000000
#define USB_DATA_BASE	0x30008000

	struct usb_core {
		uint32_t csr;
		uint32_t ar;
		uint32_t evt;
	} __attribute__((packed,aligned(4)));

	struct usb_ep {
		uint32_t status;
		uint32_t _rsvd[3];
		struct {
			uint32_t csr;
			uint32_t ptr;
		} bd[2];
	} __attribute__((packed,aligned(4)));

	struct usb_ep_pair {
		struct usb_ep out;
		struct usb_ep in;
	} __attribute__((packed,aligned(4)));

	static volatile struct usb_core *    const usb_regs    = (void*) (USB_CORE_BASE);
	static volatile struct usb_ep_pair * const usb_ep_regs = (void*)((USB_CORE_BASE) + (1 << 13));
	static volatile uint32_t *           const usb_ucode   = (void*)((USB_CORE_BASE) + (1 << 13) + (1 << 10));

	static void
_usb_hw_reset_ep(volatile struct usb_ep *ep)
{
    ep->status = 0;
    ep->bd[0].csr = 0;
    ep->bd[0].ptr = 0;
    ep->bd[1].csr = 0;
    ep->bd[1].ptr = 0;
}

void main()
{
	// GPIO configs
	reg_mprj_io_26 = GPIO_MODE_USER_STD_OUTPUT;			/* I */
	reg_mprj_io_25 = GPIO_MODE_USER_STD_OUTPUT;			/* B */
	reg_mprj_io_24 = GPIO_MODE_USER_STD_OUTPUT;			/* G */
	reg_mprj_io_23 = GPIO_MODE_USER_STD_OUTPUT;			/* R */
	reg_mprj_io_22 = GPIO_MODE_USER_STD_OUTPUT;			/* VSync */
	reg_mprj_io_21 = GPIO_MODE_USER_STD_OUTPUT;			/* HSync */
	reg_mprj_io_20 = GPIO_MODE_USER_STD_OUTPUT;			/* DE */
	reg_mprj_io_19 = GPIO_MODE_USER_STD_OUTPUT;			/* CLK */

	reg_mprj_io_18 = GPIO_MODE_USER_STD_OUTPUT;			/* PCM Out[1] */
	reg_mprj_io_17 = GPIO_MODE_USER_STD_OUTPUT;			/* PCM Out[0] */

	reg_mprj_io_16 = GPIO_MODE_USER_STD_INPUT_PULLUP;	/* MIDI RX */
	reg_mprj_io_15 = GPIO_MODE_USER_STD_OUTPUT;			/* MIDI TX */

	reg_mprj_io_14 = GPIO_MODE_USER_STD_OUTPUT;			/* SoF */
	reg_mprj_io_13 = GPIO_MODE_USER_STD_OUTPUT;			/* PU */
	reg_mprj_io_12 = 0x1800;							/* DP */
	reg_mprj_io_11 = 0x1800;							/* DN */

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

        /* TODO Add test code for each perhiperal */
	
	ram[0] = 0x600dbabe;
	ram[1] = ram[0] ^ 0xdaa00000;


	/* Video */
	/* ----- */

	// Timing generator
	video_regs[0x1000] = 0x40000003;   // Sync
	video_regs[0x1001] = 0x00000007;   // BP
	video_regs[0x1002] = 0x2000000b;   // Border
	video_regs[0x1003] = 0x3000001f;   // Active
	video_regs[0x1004] = 0x2000000b;   // Border
	video_regs[0x1005] = 0x80000007;   // FP

	video_regs[0x1008] = 0x40000003;   // Sync
	video_regs[0x1009] = 0x00000007;   // BP
	video_regs[0x100a] = 0x2000000b;   // Border
	video_regs[0x100b] = 0x3000001f;   // Active
	video_regs[0x100c] = 0x2000000b;   // Border
	video_regs[0x100d] = 0x80000007;   // FP

//	// Palette
//    video_regs[0x0000] = 0x01;			// Dark Red
//    video_regs[0x0001] = 0x0f;			// White
//    video_regs[0x0004] = 0x04;			// Dark Blue
//    video_regs[0x0005] = 0x0b;			// Yellow
//
//    // Char
//    vid_scr[14*72 + 22 + 0] = 'P';
//    vid_scr[14*72 + 22 + 1] = 'y';
//    vid_scr[14*72 + 22 + 2] = 'F';
//    vid_scr[14*72 + 22 + 3] = 'i';
//    vid_scr[14*72 + 22 + 4] = 'v';
//    vid_scr[14*72 + 22 + 5] = 'e';
//
//    vid_scr[14*72 + 48 + 22/2 + 0] = 0x11;
//    vid_scr[14*72 + 48 + 22/2 + 1] = 0x11;
//    vid_scr[14*72 + 48 + 22/2 + 2] = 0x11;



	video_regs[0x0000] = 0x8000a001;

	midi_regs[1] = 1536 - 2;
	midi_regs[0] = 'A';

	#define USB_CSR_PU_ENA      (1 << 15)
	#define USB_CSR_EVT_PENDING (1 << 14)
	#define USB_CSR_CEL_ACTIVE  (1 << 13)
	#define USB_CSR_CEL_ENA     (1 << 12)
	#define USB_CSR_BUS_SUSPEND (1 << 11)
	#define USB_CSR_BUS_RST     (1 << 10)
	#define USB_CSR_BUS_RST_PENDING (1 <<  9)
	#define USB_CSR_SOF_PENDING (1 <<  8)
	#define USB_CSR_ADDR_MATCH  (1 <<  7)
	#define USB_CSR_ADDR(x)     ((x) & 0x7f)

	#define USB_AR_CEL_RELEASE  (1 << 13)
	#define USB_AR_BUS_RST_CLEAR    (1 <<  9)
	#define USB_AR_SOF_CLEAR    (1 <<  8)

#define USB_EP_TYPE_NONE    0x0000
#define USB_EP_TYPE_ISOC    0x0001
#define USB_EP_TYPE_INT     0x0002
#define USB_EP_TYPE_BULK    0x0004
#define USB_EP_TYPE_CTRL    0x0006
#define USB_EP_TYPE_HALTED  0x0001
#define USB_EP_TYPE_IS_BCI(x)   (((x) & 6) != 0)
#define USB_EP_TYPE(x)      ((x) & 7)
#define USB_EP_TYPE_MSK     0x0007

#define USB_EP_DT_BIT       0x0080
#define USB_EP_BD_IDX       0x0040
#define USB_EP_BD_CTRL      0x0020
#define USB_EP_BD_DUAL      0x0010

#define USB_BD_STATE_MSK    0xe000
#define USB_BD_STATE_NONE   0x0000
#define USB_BD_STATE_RDY_DATA   0x4000
#define USB_BD_STATE_RDY_STALL  0x6000
#define USB_BD_STATE_DONE_OK    0x8000
#define USB_BD_STATE_DONE_ERR   0xa000
#define USB_BD_IS_SETUP     0x1000

#define USB_BD_LEN(l)       ((l) & 0x3ff)
#define USB_BD_LEN_MSK      0x03ff

#define EP0_PKT_LEN	64



	{
		usb_regs->csr = 0;

		/* Clear all descriptors */
		for (int i=0; i<16; i++) {
			_usb_hw_reset_ep(&usb_ep_regs[i].out);
			_usb_hw_reset_ep(&usb_ep_regs[i].in);
		}

		/* Load ucode */
		for (int i=0; i<sizeof(ucode)/sizeof(uint16_t); i++)
			usb_ucode[i] = ucode[i];

		/* Init EP0 */
		usb_ep_regs[0].out.status = USB_EP_TYPE_CTRL | USB_EP_BD_CTRL; /* Type=Control, control mode buffered */
		usb_ep_regs[0].in.status  = USB_EP_TYPE_CTRL | USB_EP_DT_BIT;  /* Type=Control, single buffered, DT=1 */

		usb_ep_regs[0].in.bd[0].ptr  = 0;
		usb_ep_regs[0].out.bd[0].ptr = 0;
		usb_ep_regs[0].out.bd[1].ptr = 64;

		usb_ep_regs[0].out.bd[1].csr = USB_BD_STATE_RDY_DATA | USB_BD_LEN(EP0_PKT_LEN);

		/* Boot */
		usb_regs->csr = USB_CSR_PU_ENA | USB_CSR_CEL_ENA | USB_CSR_ADDR_MATCH | USB_CSR_ADDR(0);
		usb_regs->ar  = USB_AR_BUS_RST_CLEAR | USB_AR_SOF_CLEAR | USB_AR_CEL_RELEASE;

		/* Put packet in */
		volatile uint32_t *p = (void*)0x30008000;

		p[0] = 0x01234567;
		p[1] = 0x89abcdef;
		usb_ep_regs[0].in.bd[0].csr = USB_BD_STATE_RDY_DATA | USB_BD_LEN(7);


		/* Wait packet */
		while ( (usb_ep_regs[0].out.bd[1].csr & USB_BD_STATE_MSK) != USB_BD_STATE_DONE_OK );

		usb_regs->ar  = USB_AR_BUS_RST_CLEAR | USB_AR_SOF_CLEAR | USB_AR_CEL_RELEASE;

		(void)p[16+0];
		(void)p[16+1];
		(void)p[16+2];
		(void)p[16+3];
		(void)p[16+4];
		(void)p[16+5];
		(void)p[16+6];
		(void)p[16+7];
	}
}
