#include <stdio.h>

#include "crc16.h"

#define BLOCKLEN 8192

int main(int argc, char** argv)
{
	const char* filename;
	FILE* f;
	unsigned char buf[BLOCKLEN];

	if (argc != 2) {
		printf("usage: romcrc filename\n");
		return 1;
	}
	filename = argv[1];

	f = fopen(filename, "rb");
	if (!f) {
		printf("cannot open %s\n", filename);
		return 1;
	}
	init_crctab();

	while (1) {
		int len = fread(buf, 1, BLOCKLEN, f);
		if (len == 0) {
			break;
		}
		if (len != BLOCKLEN) {
			printf("error reading %s\n", filename);
			fclose(f);
			return 1;
		}
		unsigned int crc = calc_crc16(buf, BLOCKLEN);
		printf("%04X\n", crc);
	}
	fclose(f);
	return 0;
}
