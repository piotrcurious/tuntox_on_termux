# Makefile.am
AUTOMAKE_OPTIONS = foreign

bin_PROGRAMS = tuntox
tuntox_SOURCES = \
    cJSON.c \
    client.c \
    log.c \
    main.c \
    tox_bootstrap_json.c \
    util.c

tuntox_CFLAGS = \
    -Wall -g \
    $(TOXCORE_CFLAGS) \
    $(SODIUM_CFLAGS) \
    @TERMUX_CFLAGS@

tuntox_LDADD = \
    $(TOXCORE_LIBS) \
    $(SODIUM_LIBS) \
    -lpthread -lm \
    @TERMUX_LDFLAGS@

EXTRA_DIST = \
    generate_tox_bootstrap.py \
    README.md \
    tuntox.pc.in

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = tuntox.pc

gitversion.h: FORCE
	@if [ -d .git ]; then \
		echo "  GEN   $@"; \
		echo "#define GITVERSION \"$(shell git rev-parse HEAD)\"" > $@; \
	fi

FORCE:

tox_bootstrap.h:
	$(PYTHON) generate_tox_bootstrap.py

BUILT_SOURCES = \
    gitversion.h \
    tox_bootstrap.h

CLEANFILES = \
    gitversion.h \
    tox_bootstrap.h
    
