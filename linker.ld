ENTRY(_start)
SECTIONS
{
    . = 0x11000;
    .text : { *(.text) }
    .rodata : { *(.rodata) }
    .data : { *(.data) }
    .bss : { *(COMMON) *(.bss) }
    /DISCARD/ : { *(.comment) *(.eh_frame) *(.note*) }
}
