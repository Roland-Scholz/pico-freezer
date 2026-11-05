#include <stdio.h>
#include <getopt.h>

#define BLOCKLEN (1024*1024)
static const char* filename;
static unsigned char buf[BLOCKLEN];
static int len;

static bool first_match;

void print_match(const char* text, int pos, int preceding = 5, int match = 3, int trailing = 5)
{
	if (first_match) {
		printf("matches for %s\n", filename);
	}
	first_match = false;

	printf("%06X ", pos);
	if (preceding) {
		printf(" [ ");
	} else {
		printf(" ");
	}
	int i;
	for (i=pos - preceding; i<pos+match+trailing; i++) {
		if (preceding && (i == pos) ) {
			printf("]   ");
		}
		if (trailing && (i == pos+match) ) {
			printf("  [ ");
		}
		if ((i>=0) && (i<len)) {
			printf("%02X ", buf[i]);
		} else {
			printf("   ");
		}
	}
	if (trailing) {
		printf("]");
	}
	printf("   %s\n", text);
}

inline bool is_sta(unsigned char c)
{
	return     (c == 0x8d) // STA adr
		|| (c == 0x99) // STA adr,Y
		|| (c == 0x9d) // STA adr,X
		|| (c == 0x8e) // STX adr
		|| (c == 0x8c) // STY adr
	;
}

inline bool is_lda(unsigned char c)
{
	return     (c == 0xad) // LDA adr
		|| (c == 0xb9) // LDA adr,Y
		|| (c == 0xbd) // LDA adr,X
		|| (c == 0xae) // LDX adr
		|| (c == 0xac) // LDY adr
	;
}

bool search_03fa()
{
	int i, end;
	end = len - 2;

	bool found = false;
	for (i=0;i<end;i++) {
		if ( is_sta(buf[i]) && (buf[i+1] == 0xfa) && (buf[i+2] == 0x03) ) {
			found = true;
			print_match("write $03FA", i);
		}
	}
	return found;
}

bool search_d5xx()
{
	int i, end;
	end = len - 2;

	bool found = false;
	for (i=0;i<end;i++) {
		if ( buf[i+2] == 0xd5 ) {
			if ( is_sta(buf[i]) ) {
				found = true;
				print_match("write $D5xx", i);
			}
			if ( is_lda(buf[i]) ) {
				found = true;
				print_match(" read $D5xx", i);
			}
		}
	}
	return found;
}

int main(int argc, char** argv)
{
	FILE* f;
	bool chk_03fa = true;
	bool chk_d5xx = true;

	bool found_03fa = false;
	bool found_d5xx = false;

	int opt;
	while ((opt = getopt(argc, argv, "3d")) != -1) {
		switch(opt) {
		case '3': chk_d5xx = false; break;
		case 'd': chk_03fa = false; break;
		default:
			  break;
		}
	}
	if ((!chk_03fa) && (!chk_d5xx)) {
		goto usage;
	}
	if (optind >= argc) {
		goto usage;
	}

	while (optind < argc) {
		filename = argv[optind++];

		f = fopen(filename, "rb");
		if (!f) {
			printf("cannot open %s\n", filename);
			continue;
		}
		len = fread(buf, 1, BLOCKLEN, f);
		fclose(f);
		if (len < 8192) {
			printf("error reading %s\n", filename);
			continue;
		}

		first_match = true;

		if (chk_03fa) {
			if (search_03fa()) {
				found_03fa = true;
			}
		}
		if (chk_d5xx) {
			if (search_d5xx()) {
				found_d5xx = true;
			}
		}
	}

	if (found_03fa || found_d5xx) {
		return 1;
	}
       	else {
		return 0;
	}
usage:
	printf("usage: chkrom [-3|-d] filename\n");
	printf("   -3: search only for $03FA\n");
	printf("   -d: search only for $D5xx\n");
	return 1;
}
