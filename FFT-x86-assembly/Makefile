all:
	nasm -f elf64 fft.asm
	gcc -o fft fft.c fft.o

clean:
	rm -f fft.o fft
