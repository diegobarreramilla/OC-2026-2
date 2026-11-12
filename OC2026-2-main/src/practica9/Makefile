# -fno-builtin: evita que gcc convierta printf("texto\n") en puts(),
# porque libpc_io.a tambien define puts (version ensamblador) y chocarian.
build:
	gcc -m32 -fno-builtin -c main.c
	nasm -f elf funciones.asm -o funciones.o
	gcc -m32 funciones.o main.o -L ../../lib -lpc_io -no-pie -z noexecstack -o ../../bin/practica9.exe

run:
	./../../bin/practica9.exe

clean:
	rm -f main.o funciones.o ../../bin/practica9.exe
