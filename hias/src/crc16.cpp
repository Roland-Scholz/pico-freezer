typedef unsigned char UBYTE;

static UBYTE CRCTAB_LO[256];
static UBYTE CRCTAB_HI[256];

void init_crctab()
{
	unsigned int x,y;
	unsigned long crc;
	for (x=0;x<256;x++) {
		crc = x << 8;
		for (y=0;y<8;y++) {
			crc = crc *2;
			if (crc & 65536) {
				crc = (crc & 65535) ^ (0x1021);
			}
		}
		CRCTAB_LO[x] = crc & 0xff;
		CRCTAB_HI[x] = crc >> 8;
	}
}

static inline void update_crc(UBYTE data, UBYTE& crclo, UBYTE& crchi)
{
	UBYTE i;
	i = data ^ crchi;
	crchi = crclo ^ CRCTAB_HI[i];
	crclo = CRCTAB_LO[i];
}

unsigned int calc_crc16(unsigned char* buf, int len)
{
	int i;
	unsigned char crclo, crchi;
	crclo = crchi = 0xff;
	for (i=0;i<len;i++) {
		update_crc(buf[i], crclo, crchi);
	}
	return ((unsigned int) crclo) + ( ((unsigned int)crchi) << 8);
}
