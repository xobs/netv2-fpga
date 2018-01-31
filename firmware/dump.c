#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include "stdio_wrap.h"

#include <generated/csr.h>
#include <generated/mem.h>

#include "dump.h"

void dump_mem(unsigned int addr, unsigned int len) {
	int i = 0, j = 0;
	unsigned int data;

	if( len > 0x40000 ) {
		wputs( "Warning: length over 0x10000, clipping to a reasonable length" );
		len = 0x40000;
	}

	if( addr < 0x80000000 ) {
		for( i = 0; i < len; i += 4 ) {
			if( (i % 32) == 0 ) {
				wprintf( "\n0x%08x: ", i + addr );
			}
			wprintf( "%08x ", *((unsigned int *) (addr + i) ) );
		}
		wprintf( "\n" );
	} else {
		// CSR space consists of bytes on word strides
		for( i = 0; i < len * 4; i+= 16 ) {
			if( (i % (32*4)) == 0 ) {
				wprintf( "\n0x%08x: ", i + addr );
			}
			data = 0;
			for( j = 0; j < 4; j++ ) {
				data |= MMPTR(addr + j * 4 + i);
				if( j < 3 )
					data <<= 8;
			}
			wprintf( "%08x ", data );
		}
		wprintf( "\n" );
	}
}

void poke_mem(unsigned int addr, unsigned int data) {
	int i = 0;

	addr &= 0xFFFFFFFC; // snap to the nearest word to avoid bus faults etc
	wprintf( "Poking %08x into %08x\n", data, addr );
	if( addr < 0x80000000 ) {
		*((unsigned int *) addr) = data;
	} else {
		for( i = 3; i >= 0; i-- ) {
			MMPTR(addr + i * 4) = data >> (i * 8);
		}
	}
}

void help_memread(void) {
	wputs("mr <address> [<len>]; memory read only does 32-bit words");
}

void help_memwrite(void) {
	wputs("mw <address> <value>; memory write only does 32-bit words");
}
