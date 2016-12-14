#include "sys/alt_stdio.h"

int main(void)
{ 
  alt_putstr("Hello from Nios II!\n");

  /* Event loop never exits. */
  while (1);

  return 0;
}
