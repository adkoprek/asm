mkdir -p bin
nasm -g -f elf64 args.asm -o bin/args.o
ld -g bin/args.o -o bin/args
