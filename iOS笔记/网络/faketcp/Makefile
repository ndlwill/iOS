all: client server

client:
	gcc -std=gnu99 -g -pedantic -Wall -pthread queue.c client.c faketcp.c -o ftcp

server:
	gcc -std=gnu99 -g -pedantic -DFTCP_DEBUG=1 -Wall -pthread queue.c server.c faketcp.c -o fsvr

clean:
	rm -rf ftcp fsvr *.dSYM *~ *#

ctest:
	./ftcp 127.0.0.1 8888

stest:
	./fsvr 8888

check:
	splint -warnposix +charint -unrecog faketcp.c faketcp.h
