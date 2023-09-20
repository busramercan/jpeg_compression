

#include <stdio.h>
//#include "platform.h"
#include "xparameters.h"
#include "sleep.h"
#include "xuartps.h"
#include <stdlib.h>
#include "xtime_l.h"
#include "image_data.h"

#define LENGTH 50
#define HEIGHT 50
#define FILE_SIZE LENGTH*HEIGHT
#define TOTAL_BLOCK_NO 64

int maskForLeds = 0;

#define UART_DEVICE_ID              XPAR_PS7_UART_1_DEVICE_ID

#define WRITE_FROM_ZYNQ_COMPLETED 10
#define FILTER_COMPLETED 12

int main()
{

//	XGpio_Initialize(&input, XPAR_AXI_GPIO_BTN_DEVICE_ID); //initialize input XGpio variable
//	XGpio_SetDataDirection(&input, 1, 0xF); //set first channel tristate buffer to input

//	XGpio_Initialize(&output, XPAR_AXI_GPIO_LED_DEVICE_ID); //initialize output XGpio variable
//	XGpio_SetDataDirection(&output, 1, 0x0); //set first channel tristate buffer to output

	u32 * bramBase = (u32*)XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR;
	u8 image_block[8][8];
	u32 coded_data[8][32];
	u32 status;


	u32 totalReceived = 0;
	u32 totalSent = 0;
	int imageWaiting = 1;

	int for_x = 0;
	int for_y = 0;

	/*
	 * block yazdıktan sonra A koy
	 * B bekle, B varsa blok okunmuştur, yeni blok yaz
	 * C bekle, c varsa oku ve sonuca at
	 * */
	int counter = 2;
	int block_no = 0;
	int write_block = 1;

	while(counter < 18){

		bramBase[counter] = counter;
		counter = counter + 1;
	}




	while(block_no < TOTAL_BLOCK_NO){
		if(write_block == 1){
			//write blok to bram
			counter = 0;
			for( for_y = 0 ; for_y < 8 ; for_y ++){
				for( for_x = 0 ; for_x < 8 ; for_x ++){
					image_block[for_y][for_x] = image_data[block_no*8 +for_y][block_no*8 + for_x];
					bramBase[counter + 2] = image_block[for_y][for_x];
				}
			}
			bramBase[0] = 10;

		}
	}




	return 0;
}

