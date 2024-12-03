mkdir -p bin
nasm -g -f elf64 fibonacci.asm -o bin/fibonacci.o
ld -g bin/fibonacci.o -o bin/fibonacci
