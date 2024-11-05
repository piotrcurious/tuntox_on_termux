cc -o tuntox *.c -I$PREFIX/include -L$PREFIX/lib -ltoxcore -ltoxencryptsave -lsodium -lm \
   -DGITVERSION=\"$(git describe --always --dirty 2>/dev/null || echo unknown)\"
