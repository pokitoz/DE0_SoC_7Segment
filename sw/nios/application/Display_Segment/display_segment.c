#include "sys/alt_stdio.h"
#include "system.h"
#include "io.h"
#include "unistd.h"

#define NUMBER_DISPLAY 6
#define MAX_DIGIT 9

int main(void) {
	alt_putstr("Display Segment Program!\n");
	volatile int count = 0x2142FF;
	IOWR_32DIRECT(DISPLAY_SEGMENT_0_BASE, 4, 41500);
	IOWR_32DIRECT(DISPLAY_SEGMENT_0_BASE, 8, 50000);
	IOWR_32DIRECT(DISPLAY_SEGMENT_0_BASE, 0, count);

	char v[NUMBER_DISPLAY] = { 0 };
	count = 0;
	/* Event loop never exits. */
	while (1) {
		count = v[0] | (v[1] << 4) | (v[2] << 8) | (v[3] << 12) | (v[4] << 16)
				| (v[5] << 20);

		IOWR_32DIRECT(DISPLAY_SEGMENT_0_BASE, 0, count);
		usleep(1000);

		v[0]++;
		int i = 0;
		for (i = 0; i < NUMBER_DISPLAY; i++) {
			if (v[i] == MAX_DIGIT + 1) {
				v[i + 1]++;
				v[i] = 0;
			}
		}

	}

	return 0;
}
