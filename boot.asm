
jmp short start
nop

; FAT12 BPB
OEMLabel            db "MINICLUD"
BytesPerSector      dw 512
SectorsPerCluster   db 1
ReservedSectors     dw 1
NumberOfFATs        db 2
RootEntries         dw 224
TotalSectors        dw 2880
MediaType           db 0xF0
SectorsPerFAT       dw 9
SectorsPerTrack     dw 18
NumberOfHeads       dw 2
HiddenSectors       dd 0
TotalSectorsBig     dd 0
DriveNumber         db 0
Reserved            db 0
Signature           db 0x29
VolumeID            dd 0xa0a1a2a3
VolumeLabel         db "MINICLOUD  "
FileSystem          db "FAT12   "

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti
    
    mov [DriveNumber], dl
    
    ; Clear screen
    mov ax, 0x0003
    int 0x10
    
    ; Print boot message
    mov si, msg_boot
    call print
    
    ; Load kernel (32 sectors)
    mov ah, 0x02
    mov al, 32
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [DriveNumber]
    mov bx, 0x1000
    mov es, bx
    xor bx, bx
    int 0x13
    jc disk_error
    
    mov si, msg_loaded
    call print
    
    ; Enter protected mode
    cli
    lgdt [gdt_pointer]
    
    in al, 0x92
    or al, 2
    out 0x92, al
    
    mov eax, cr0
    or al, 1
    mov cr0, eax
    
    jmp CODE_SEG:protected_mode

disk_error:
    mov si, msg_error
    call print
    cli
    hlt

print:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print
.done:
    ret

msg_boot:    db "MiniCloud OS - Booting...", 13, 10, 0
msg_loaded:  db "Kernel loaded!", 13, 10, 0
msg_error:   db "Disk error!", 13, 10, 0

; GDT
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
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

BITS 32
protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000
    
    ; Call kernel
    call 0x10000
    
    cli
    hlt

drive: db 0
times 510-($-$$) db 0
dw 0xAA55
EOF