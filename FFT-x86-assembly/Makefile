# For whatever reason, I won't be able to run fft if the executable
# is not build with the "static" flag. The error is in the asm file
# when calling a library function. I guess it has something to do
# with linking the object files and the so files.

all:
	nasm -f elf64 fft.asm
	gcc -o fft fft.c fft.o -static

clean:
	rm -f fft.o fft
