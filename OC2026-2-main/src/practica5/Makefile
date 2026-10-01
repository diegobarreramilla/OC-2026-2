build:
	nasm -f elf p5.asm
	ld -m elf_i386 p5.o -o ../../bin/practica5.exe ../../lib/libpc_io.a

	nasm -f elf a_directo.asm
	ld -m elf_i386 a_directo.o -o ../../bin/a_directo.exe ../../lib/libpc_io.a

	nasm -f elf b_indirecto.asm
	ld -m elf_i386 b_indirecto.o -o ../../bin/b_indirecto.exe ../../lib/libpc_io.a

	nasm -f elf c_base_desplazamiento.asm
	ld -m elf_i386 c_base_desplazamiento.o -o ../../bin/c_base_desplazamiento.exe ../../lib/libpc_io.a

	nasm -f elf d_base_indice.asm
	ld -m elf_i386 d_base_indice.o -o ../../bin/d_base_indice.exe ../../lib/libpc_io.a

	nasm -f elf e_base_indice_desplazamiento.asm
	ld -m elf_i386 e_base_indice_desplazamiento.o -o ../../bin/e_base_indice_desplazamiento.exe ../../lib/libpc_io.a

	nasm -f elf f_base_indice_escalado.asm
	ld -m elf_i386 f_base_indice_escalado.o -o ../../bin/f_base_indice_escalado.exe ../../lib/libpc_io.a

run:
	./../../bin/a_directo.exe
	./../../bin/b_indirecto.exe
	./../../bin/c_base_desplazamiento.exe
	./../../bin/d_base_indice.exe
	./../../bin/e_base_indice_desplazamiento.exe
	./../../bin/f_base_indice_escalado.exe
	./../../bin/practica5.exe




