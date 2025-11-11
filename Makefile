.PHONY: all clean run

all: minicloud.img

boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin

kernel.o: kernel.c
	gcc -m32 -ffreestanding -c kernel.c -o kernel.o -fno-pie -fno-stack-protector -O2

kernel.bin: kernel.o
	ld -m elf_i386 -o kernel.tmp -Ttext 0x10000 kernel.o --oformat binary
	mv kernel.tmp kernel.bin

minicloud.img: boot.bin kernel.bin
	cat boot.bin kernel.bin > minicloud.img
	truncate -s 1440K minicloud.img

run: minicloud.img
	qemu-system-i386 -fda minicloud.img -boot a

clean:
	rm -f *.bin *.o *.img kernel.tmp

info:
	@echo "=== MiniCloud OS Build Info ==="
	@ls -lh boot.bin kernel.bin minicloud.img 2>/dev/null | awk '{print $$9, $$5}'
	@echo ""
	@echo "Memory layout:"
	@echo "  0x7C00  - Bootloader (enters PM)"
	@echo "  0x10000 - Kernel"
