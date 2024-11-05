extract :

# Installing Tuntox on Termux

This guide walks through building and installing tuntox from source on Termux.

## Prerequisites
```bash
pkg update && pkg upgrade
pkg install git make clang pkg-config autoconf automake libtool binutils libsodium
```

## Build and Install Dependencies

### 1. Build Opus
```bash
git clone https://github.com/xiph/opus.git
cd opus
./autogen.sh
./configure --prefix=/data/data/com.termux/files/usr
make
make install
cd ..
```

### 2. Build Toxcore
```bash
# Set up environment
export PREFIX=/data/data/com.termux/files/usr
echo "lt_cv_sys_lib_dlsearch_path_spec='/data/data/com.termux/files/usr/lib'" > ~/config.site

# Clone and build toxcore
git clone https://github.com/TokTok/c-toxcore.git
cd c-toxcore
git submodule init
git submodule update

CONFIG_SITE=~/config.site ./autogen.sh
CONFIG_SITE=~/config.site ./configure --prefix=$PREFIX \
    --with-libdir=$PREFIX/lib \
    AR=ar \
    PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig \
    lt_cv_sys_lib_search_path_spec=$PREFIX/lib \
    lt_cv_sys_lib_dlsearch_path_spec=$PREFIX/lib
make
make install
cd ..
```

### 3. Build Tuntox
```bash
# Set environment
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
export LD_LIBRARY_PATH=$PREFIX/lib

# Clone and create custom Makefile
git clone https://github.com/gjedeer/tuntox.git
cd tuntox

cat > Makefile << 'EOF'
CFLAGS += -g -Wall -I$(PREFIX)/include
LDFLAGS += -L$(PREFIX)/lib -ltoxcore -ltoxencryptsave -lsodium -lm
OBJECTS = cJSON.o client.o gitversion.o log.o main.o tox_bootstrap_json.o util.o

all: tuntox

gitversion.h:
	echo "#define GITVERSION \"$(shell git describe --always --dirty 2>/dev/null || echo unknown)\"" > $@

%.o: %.c gitversion.h
	$(CC) $(CFLAGS) -c -o $@ $<

tuntox: $(OBJECTS)
	$(CC) -o $@ $(OBJECTS) $(LDFLAGS)

clean:
	rm -f tuntox *.o gitversion.h
EOF

# Build tuntox
make clean
make
```

**Note**: Tuntox requires root access or proper capabilities to create TUN interfaces.
