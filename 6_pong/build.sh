mkdir -p bin
nasm -g -f elf64 pong.asm   -o bin/pong.o
nasm -g -f elf64 x11.asm    -o bin/x11.o
ld -g bin/pong.o bin/x11.o -o bin/pong
