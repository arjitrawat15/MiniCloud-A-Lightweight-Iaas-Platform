// kernel.c - Main kernel for MiniCloud OS
#define VGA_ADDRESS 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

typedef unsigned short uint16_t;
typedef unsigned char uint8_t;

static uint16_t* vga_buffer = (uint16_t*)VGA_ADDRESS;
static int cursor_x = 0;
static int cursor_y = 0;
static uint8_t current_color = 0x07;

static inline uint16_t vga_entry(char c, uint8_t color) {
    return (uint16_t)c | ((uint16_t)color << 8);
}

void terminal_clear(void) {
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga_buffer[i] = vga_entry(' ', 0x00); // BLACK background
    }
    cursor_x = 0;
    cursor_y = 0;
}

void terminal_putchar(char c) {
    if (c == '\n') {
        cursor_x = 0;
        cursor_y++;
        if (cursor_y >= VGA_HEIGHT) {
            // Scroll
            for (int y = 0; y < VGA_HEIGHT - 1; y++) {
                for (int x = 0; x < VGA_WIDTH; x++) {
                    vga_buffer[y * VGA_WIDTH + x] = vga_buffer[(y + 1) * VGA_WIDTH + x];
                }
            }
            cursor_y = VGA_HEIGHT - 1;
            for (int x = 0; x < VGA_WIDTH; x++) {
                vga_buffer[cursor_y * VGA_WIDTH + x] = vga_entry(' ', current_color);
            }
        }
        return;
    }
    
    vga_buffer[cursor_y * VGA_WIDTH + cursor_x] = vga_entry(c, current_color);
    cursor_x++;
    
    if (cursor_x >= VGA_WIDTH) {
        cursor_x = 0;
        cursor_y++;
        if (cursor_y >= VGA_HEIGHT) {
            cursor_y = 0; // Simple wrap for now
        }
    }
}

void terminal_write(const char* str) {
    while (*str) {
        terminal_putchar(*str++);
    }
}

void terminal_setcolor(uint8_t color) {
    current_color = color;
}

void kernel_main(void) {
    terminal_clear();
    
    // Print banner
    terminal_setcolor(0x0A); // Light green
    terminal_write("==========================================\n");
    terminal_write("   MiniCloud OS v0.1 - Successfully Booted!\n");
    terminal_write("==========================================\n\n");
    
    terminal_setcolor(0x07); // Light grey
    terminal_write("Kernel loaded at 0x10000\n");
    terminal_write("Protected mode: Active\n");
    terminal_write("VGA text mode: 80x25\n\n");
    
    terminal_setcolor(0x0F); // White
    terminal_write("Welcome to MiniCloud OS!\n");
    terminal_write("A lightweight operating system kernel.\n\n");
    
    terminal_setcolor(0x0B); // Cyan
    terminal_write("System Information:\n");
    terminal_setcolor(0x07);
    terminal_write("  Architecture: x86 32-bit\n");
    terminal_write("  Bootloader: Custom bootloader\n");
    terminal_write("  Kernel: C kernel\n\n");
    
    terminal_setcolor(0x0E); // Yellow
    terminal_write("Memory Layout:\n");
    terminal_setcolor(0x07);
    terminal_write("  0x00007C00 - Bootloader\n");
    terminal_write("  0x00010000 - Kernel\n");
    terminal_write("  0x000B8000 - VGA Buffer\n\n");
    
    terminal_setcolor(0x0A); // Green
    terminal_write("System is running!\n");
    terminal_setcolor(0x08); // Dark grey
    terminal_write("(Keyboard input requires interrupt setup)\n");
    
    // Infinite loop
    while (1) {
        __asm__ __volatile__("hlt");
    }
}

void _start(void) {
    kernel_main();
}