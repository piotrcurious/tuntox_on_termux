 I'll create the necessary autoconf files to properly handle Termux configuration.



<antArtifact identifier="tuntox-autoconf" type="application/vnd.ant.code" language="make" title="Tuntox Autoconf Files for Termux Support">
# configure.ac
AC_INIT([tuntox], [0.0.1], [https://github.com/gjedeer/tuntox/issues])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([foreign -Wall -Werror])

# Checks for programs
AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET

# Check for pkg-config
PKG_PROG_PKG_CONFIG

# Check for toxcore
PKG_CHECK_MODULES([TOXCORE], [toxcore])

# Check for libsodium
PKG_CHECK_MODULES([SODIUM], [libsodium])

# Check for pthread
AC_CHECK_LIB([pthread], [pthread_create])

# Check for math lib
AC_CHECK_LIB([m], [sqrt])

# Check for system-specific features
AC_CHECK_FUNC([clock_gettime], [], [AC_CHECK_LIB([rt], [clock_gettime])])

# Handle Termux-specific paths
AC_ARG_ENABLE([termux],
    AS_HELP_STRING([--enable-termux], [Enable Termux-specific paths and settings]))

AS_IF([test "x$enable_termux" = "xyes"], [
    prefix=/data/data/com.termux/files/usr
    AC_SUBST([TERMUX_CFLAGS], ["-I$prefix/include"])
    AC_SUBST([TERMUX_LDFLAGS], ["-L$prefix/lib"])
])

# Output files
AC_CONFIG_FILES([
    Makefile
    tuntox.pc
])

AC_OUTPUT

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

# tuntox.pc.in
prefix=@prefix@
exec_prefix=@exec_prefix@
libdir=@libdir@
includedir=@includedir@

Name: tuntox
Description: Tool for tunneling TCP connections over the Tox protocol
Version: @PACKAGE_VERSION@
Libs: -L${libdir}
Cflags: -I${includedir}
Requires: toxcore

# autogen.sh
#!/bin/sh
autoreconf --install --force --verbose
</antArtifact>

To use these files:

1. Place them in your tuntox source directory
2. Make `autogen.sh` executable:
```bash
chmod +x autogen.sh
```

3. Then build for Termux:
```bash
./autogen.sh
./configure --enable-termux
make
```

The autoconf setup provides several benefits:
- Automatic dependency detection
- Proper handling of Termux paths
- System-specific feature detection
- Generated pkg-config file for easier integration
- Proper handling of build flags

Would you like me to explain any part of the configuration in more detail or add any additional features to the build system?
