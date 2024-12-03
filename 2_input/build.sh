mkdir -p bin
nasm -g -f elf64 input.asm -o bin/input.o
ld -g bin/input.o -o bin/input
