bits 16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x9000
    
    mov ax, 0x2401
    int 0x15
    
    lgdt [gdt_pointer]
    
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    
    db 0xEA
    dd 0x10000 + (pm_start - start)
    dw CODE_SEG

gdt_start:
    dq 0x0
gdt_code:
    dw 0xFFFF, 0x0
    db 0x0, 10011010b, 11001111b, 0x0
gdt_data:
    dw 0xFFFF, 0x0
    db 0x0, 10010010b, 11001111b, 0x0
gdt_end:

gdt_pointer:
    dw gdt_end - gdt_start - 1
    dd gdt_start + 0x10000

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32
pm_start:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000
    
    ; Fill screen with exclamation marks - DON'T call kernel
    mov edi, 0xB8000
    mov ecx, 2000
    mov eax, 0x2F212F21
    rep stosd
    
    ; STOP HERE - don't call kernel
    cli
pm_halt:
    hlt
    jmp pm_halt

times 4096-($-$$) db 0
