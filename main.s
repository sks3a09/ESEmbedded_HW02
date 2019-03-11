.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	nop
	mov r0,1
	mov r1,2
	mov r2,3
	push {r0,r1,r2}
	pop {r0,r1,r2}
	nop
	mov r0,4
	mov r1,5
	mov r2,6
	push {r2,r0,r1}
	pop {r1,r2,r0}
	nop
	mov r0,7
	mov r1,8
	mov r2,9
	push {r0}
	push {r1}
	push {r2}
	pop {r1}
	pop {r2}
	pop {r0}
	nop