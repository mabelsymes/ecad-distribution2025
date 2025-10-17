.macro DEBUG_PRINT reg
csrw 0x800, \reg
.endm
	
.text
.global div              # Export the symbol 'div' so we can call it from other files
.type div, @function
div:
    addi sp, sp, -32     # Allocate stack space

    # store any callee-saved register you might overwrite
    sw   ra, 28(sp)      # Function calls would overwrite
    sw   s0, 24(sp)      # If t0-t6 is not enough, can use s0-s11 if I save and restore them
    # ...

    # do your work, we're using base 32
    bnez a1, divalg
    divbyzero:
        li a0, 0 
        li a1, 0
        j end

    divalg:
        li t0, 0    # Q := 0
        li t1, 0    # R := 0
        li t2, 31   # i := 31
        loop:
            sll t1, t1, 1       # R := R << 1
            srl t3, a0, t2      # ith bit of a0 is in LSB of t3
            and t3, t3, 1       # t3 is 0...0[ith bit of a0]
            or t1, t1, t3       # R(0) := N(i)
            
            blt t1, a1, check
            sub t1, t1, a1      # R := R-D
            li t3, 1            # t3 := 1
            sll t3, t3, t2      # t3 is 0...010...0 with 1 at ith bit
            or t0, t0, t3       # Q(i) := 1
            check:
                addi t2, t2, -1       # i := i - 1
                bgez t2, loop
        mv a0, t0   # putting Q in a0
        mv a1, t1   # putting R in a1

    end:


    # example of printing inputs a0 and a1
    DEBUG_PRINT a0
    DEBUG_PRINT a1

    # load every register you stored above
    lw   ra, 28(sp)
    lw   s0, 24(sp)
    # ...
    addi sp, sp, 32      # Free up stack space
    ret

