#include <sys/ioctl.h>
#include <termios.h>

#include "term_utils.h"

int term_sz(int fd, unsigned short *rows, unsigned short *cols)
{
	int res;
	struct winsize ws;

	res = ioctl(fd, TIOCGWINSZ, &ws);

	if (res == -1)
		return (-1);

	*rows = ws.ws_row;
	*cols = ws.ws_col;

	return (0);
}

