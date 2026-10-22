build:
	nasm -f elf p8.asm -o p8.o
	ld -m elf_i386 p8.o -o ../../bin/p8.exe

run:
	./../../bin/p8.exe

clean:
	rm -f p8.o ../../bin/p8.exe
