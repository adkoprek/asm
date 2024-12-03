mkdir -p bin
nasm -g -f elf64 numguess.asm -o bin/numguess.o
ld -g bin/numguess.o -o bin/numguess
