#include "sys/alt_stdio.h"
#include "system.h"
#include "io.h"
#include "unistd.h"
int main(void)
{ 
  alt_putstr("Hello from Nios II!\n");
  volatile int count = 0x2142FF;
  IOWR_32DIRECT(DISPLAY_SEGMENT_0_BASE, 4, 41500);
  IOWR_32DIRECT(DISPLAY_SEGMENT_0_BASE, 8, 50000);
  IOWR_32DIRECT(DISPLAY_SEGMENT_0_BASE, 0, count);

  /* Event loop never exits. */
  while (1){

	  IOWR_32DIRECT(DISPLAY_SEGMENT_0_BASE, 0, count);
	  usleep(10);
	  count++;
  }

  return 0;
}
