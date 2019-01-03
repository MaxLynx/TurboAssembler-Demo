.model small
.stack 100h
.data
tmp db ?
tmp2 dw ?
rows db 3
cols db 5
mas db 5,2,4,3,1,7,7,7,7,7,13,12,14,15,11
q db 5
X db ?
mesg1 db "Average values for each row: ",0Dh,0Ah,'$'
mesg2 db "Array: $"

.code
start_ MACRO
    mov ax, @data
    mov ds, ax
Endm	

print MACRO X;
local pos, size_, print
    cmp al, 0
	jns pos
	mov dl, '-'
	mov ah, 02h
	int 21h
	mov al, X
	neg al
pos:	
    mov ah, 0
    mov tmp2, cx
    mov cx, 0
	mov tmp, bl
	mov bx, 10
size_:	
    xor dx, dx
	div bx
	push dx
	inc cx
	cmp al, 0
	jne size_
	mov ah, 02h
print: 
    pop dx
	add dl, 30h
	int 21h
	loop print
	mov dl, ' '
	mov ah, 02h
	int 21h
	mov bl, tmp
	mov cx, tmp2
Endm

print_array MACRO mas;
local label8, label9
    mov	AH, 09h		
	mov	DX, offset mesg2	
	int	21h	
	mov dl, 0dh
    mov ah, 02h
    int 21h
	mov dl, 0ah
	mov ah, 02h
    int 21h
   lea bx, mas
    mov cl, rows
	mov al, 0
	label8:
	    push cx
		mov cl, cols
		mov si, 0
	label9:
	    mov al, [bx][si]
		mov X, al
		print X  
		inc si
		loop label9
		mov dl, 0dh
	    mov ah, 02h
	    int 21h
		mov dl, 0ah
		mov ah, 02h
	    int 21h
		add bl, cols   
		pop cx
		loop label8
Endm

average MACRO mas;
local label1, label2
    mov	AH, 09h		
	mov	DX, offset mesg1	
	int	21h	
    lea bx, mas
    mov cl, rows
	mov al, 0
	label1:
		push cx
		mov cl, cols
		mov si, 0
	label2:
		add al, [bx][si]   
		inc si
		loop label2
		cbw
		div q
		mov X, al
		print X
		change X
		mov al, 0  
		add bl, cols   
		pop cx
		loop label1
	mov dl, 0dh
    mov ah, 02h
    int 21h
	mov dl, 0ah
	mov ah, 02h
	int 21h	
Endm

change MACRO X;
local label3, label4, label5
	mov si, 0
	mov cl, cols
  label3:
    mov al, X
    cmp al, [bx][si]
	je label4	
  labelReturn:
	inc si  	
	loop label3
	jmp label5
  label4:
    add [bx][si], al
	jmp labelReturn
  label5:	
Endm

end_ MACRO
	mov ax, 4C00h
	int 21h  
Endm

main:
   start_
   print_array mas
   average mas 
   print_array mas   
   end_ 
end main   
