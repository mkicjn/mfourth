#include <unistd.h>
static char cb;

void bye(void)
{
	_exit(0);
}

void tx(char c)
{
	cb=c;
	write(STDOUT_FILENO,&cb,1);
}

char rx(void)
{
	read(STDIN_FILENO,&cb,1);
	return cb;
}
