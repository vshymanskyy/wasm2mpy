
// THIS FILE IS AUTO-GENERATED
// https://gist.github.com/agatti/2b486f925ec535ecf4d475cc96ac881d

	.file "rom.S"
	.section .text
.Ltext0:


	// __adddf3

	.section .text.__adddf3,"ax",@progbits
	.align 4
	.global __adddf3
	.type __adddf3, @function

__adddf3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000C538 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __adddf3, .-__adddf3


	// __addsf3

	.section .text.__addsf3,"ax",@progbits
	.align 4
	.global __addsf3
	.type __addsf3, @function

__addsf3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000C180 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __addsf3, .-__addsf3


	// __divdf3

	.section .text.__divdf3,"ax",@progbits
	.align 4
	.global __divdf3
	.type __divdf3, @function

__divdf3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000CB94 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __divdf3, .-__divdf3


	// __divdi3

	.section .text.__divdi3,"ax",@progbits
	.align 4
	.global __divdi3
	.type __divdi3, @function

__divdi3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000CE60 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __divdi3, .-__divdi3


	// __divsi3

	.section .text.__divsi3,"ax",@progbits
	.align 4
	.global __divsi3
	.type __divsi3, @function

__divsi3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000DC88 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __divsi3, .-__divsi3


	// __extendsfdf2

	.section .text.__extendsfdf2,"ax",@progbits
	.align 4
	.global __extendsfdf2
	.type __extendsfdf2, @function

__extendsfdf2:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000CDFC // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __extendsfdf2, .-__extendsfdf2


	// __fixdfsi

	.section .text.__fixdfsi,"ax",@progbits
	.align 4
	.global __fixdfsi
	.type __fixdfsi, @function

__fixdfsi:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000CCB8 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __fixdfsi, .-__fixdfsi


	// __fixunsdfsi

	.section .text.__fixunsdfsi,"ax",@progbits
	.align 4
	.global __fixunsdfsi
	.type __fixunsdfsi, @function

__fixunsdfsi:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000CD00 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __fixunsdfsi, .-__fixunsdfsi


	// __fixunssfsi

	.section .text.__fixunssfsi,"ax",@progbits
	.align 4
	.global __fixunssfsi
	.type __fixunssfsi, @function

__fixunssfsi:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000C4C4 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __fixunssfsi, .-__fixunssfsi


	// __floatsidf

	.section .text.__floatsidf,"ax",@progbits
	.align 4
	.global __floatsidf
	.type __floatsidf, @function

__floatsidf:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000E2F0 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __floatsidf, .-__floatsidf


	// __floatsisf

	.section .text.__floatsisf,"ax",@progbits
	.align 4
	.global __floatsisf
	.type __floatsisf, @function

__floatsisf:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000E2AC // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __floatsisf, .-__floatsisf


	// __floatunsidf

	.section .text.__floatunsidf,"ax",@progbits
	.align 4
	.global __floatunsidf
	.type __floatunsidf, @function

__floatunsidf:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000E2E8 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __floatunsidf, .-__floatunsidf


	// __floatunsisf

	.section .text.__floatunsisf,"ax",@progbits
	.align 4
	.global __floatunsisf
	.type __floatunsisf, @function

__floatunsisf:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000E2A4 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __floatunsisf, .-__floatunsisf


	// __muldf3

	.section .text.__muldf3,"ax",@progbits
	.align 4
	.global __muldf3
	.type __muldf3, @function

__muldf3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000C8F0 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __muldf3, .-__muldf3


	// __muldi3

	.section .text.__muldi3,"ax",@progbits
	.align 4
	.global __muldi3
	.type __muldi3, @function

__muldi3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x40000650 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __muldi3, .-__muldi3


	// __mulsf3

	.section .text.__mulsf3,"ax",@progbits
	.align 4
	.global __mulsf3
	.type __mulsf3, @function

__mulsf3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000C3DC // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __mulsf3, .-__mulsf3


	// __subdf3

	.section .text.__subdf3,"ax",@progbits
	.align 4
	.global __subdf3
	.type __subdf3, @function

__subdf3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000C688 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __subdf3, .-__subdf3


	// __subsf3

	.section .text.__subsf3,"ax",@progbits
	.align 4
	.global __subsf3
	.type __subsf3, @function

__subsf3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000C268 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __subsf3, .-__subsf3


	// __truncdfsf2

	.section .text.__truncdfsf2,"ax",@progbits
	.align 4
	.global __truncdfsf2
	.type __truncdfsf2, @function

__truncdfsf2:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000CD5C // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __truncdfsf2, .-__truncdfsf2


	// __udivdi3

	.section .text.__udivdi3,"ax",@progbits
	.align 4
	.global __udivdi3
	.type __udivdi3, @function

__udivdi3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000D310 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __udivdi3, .-__udivdi3


	// __udivsi3

	.section .text.__udivsi3,"ax",@progbits
	.align 4
	.global __udivsi3
	.type __udivsi3, @function

__udivsi3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000E21C // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __udivsi3, .-__udivsi3


	// __umoddi3

	.section .text.__umoddi3,"ax",@progbits
	.align 4
	.global __umoddi3
	.type __umoddi3, @function

__umoddi3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000D770 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __umoddi3, .-__umoddi3


	// __umodsi3

	.section .text.__umodsi3,"ax",@progbits
	.align 4
	.global __umodsi3
	.type __umodsi3, @function

__umodsi3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000E268 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __umodsi3, .-__umodsi3


	// __umulsidi3

	.section .text.__umulsidi3,"ax",@progbits
	.align 4
	.global __umulsidi3
	.type __umulsidi3, @function

__umulsidi3:
	addi   a1, a1, -16     // Allocate stack
	s32i   a12, a1, 0      // Save A12
	s32i   a13, a1, 4      // Save A13
	mov    a12, a0         // Save old return address
	movi   a13, 0x4000DCF0 // Load ROM address
	callx0 a13             // Call into ROM
	mov    a0, a12         // Restore old return address
	l32i   a13, a1, 4      // Restore A13
	l32i   a12, a1, 0      // Restore A12
	addi   a1, a1, 16      // Allocate stack
	ret.n                  // Done

	.size __umulsidi3, .-__umulsidi3

	// Done

