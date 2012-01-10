CFLAGS=-Wall -Wextra -Wvla

all: resources

resources.o: tuple.h Makefile

tuple.o: tuple.h Makefile

resources: LDFLAGS+=-lm
resources: resources.o tuple.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $+ $(LOADLIBES) $(LDLIBS)

clean:
		-$(RM) resources.o tuple.o resources
