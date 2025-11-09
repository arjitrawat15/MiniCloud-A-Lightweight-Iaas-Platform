BITS 16
ORG 0x7C00

jmp short boot_start
nop

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

boot_start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti
    mov [DriveNumber], dl
    mov ax, 0x0003
    int 0x10
    mov si, msg_boot
    call print_str
    mov ah, 0x00
    mov dl, [DriveNumber]
    int 0x13
    jc disk_err
    mov si, msg_loading
    call print_str
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
    jc disk_err
    mov si, msg_ok
    call print_str
    mov si, msg_jump
    call print_str
    jmp 0x1000:0x0000

disk_err:
    mov si, msg_error
    call print_str
    cli
    hlt

print_str:
    lodsb
    or al, al
    jz print_done
    mov ah, 0x0E
    int 0x10
    jmp print_str
print_done:
    ret

msg_boot:    db "MiniCloud Bootloader v0.1", 13, 10, 0
msg_loading: db "Loading kernel...", 13, 10, 0
msg_ok:      db "Kernel loaded!", 13, 10, 0
msg_jump:    db "Starting kernel...", 13, 10, 0
msg_error:   db "Disk error!", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
