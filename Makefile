# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

DESTDIR=${HOME}/.local
MANDESTDIR=${DESTDIR}/share/man
PREFIX=''

include config.mk

SRC = st.c x.c
OBJ = $(SRC:.c=.o)

all: options st

options:
	@echo st build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"

config.h:
	cp config.def.h config.h

.c.o:
	$(CC) $(STCFLAGS) -c $<

st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h

$(OBJ): config.h config.mk

st: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f st $(OBJ) st-$(VERSION).tar.gz

dist: clean
	mkdir -p st-$(VERSION)
	cp -R FAQ LEGACY TODO LICENSE Makefile README config.mk\
		config.def.h st.info st.1 arg.h st.h win.h $(SRC)\
		st-$(VERSION)
	tar -cf - st-$(VERSION) | gzip > st-$(VERSION).tar.gz
	rm -r st-$(VERSION)

install: st
	mkdir -p $(DESTDIR)/bin
	cp -f st $(DESTDIR)/bin
	chmod 755 $(DESTDIR)/bin/st
	mkdir -p $(MANDESTDIR)/man1
	sed "s/VERSION/$(VERSION)/g" < st.1 > $(MANDESTDIR)/man1/st.1
	chmod 644 $(MANDESTDIR)/man1/st.1
	tic -sx st.info
	@echo Please see the README file regarding the terminfo entry of st.

uninstall:
	rm -f $(DESTDIR)/bin/st
	rm -f $(MANDESTDIR)/man1/st.1

.PHONY: all options clean dist install uninstall
