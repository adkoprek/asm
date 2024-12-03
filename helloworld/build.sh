mkdir -p bin
nasm -g -f elf64 helloworld.asm -o bin/helloworld.o
ld -g bin/helloworld.o -o bin/helloworld
