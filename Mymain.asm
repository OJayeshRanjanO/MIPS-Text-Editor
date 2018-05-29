 
# Helper macro for grabbing two command line arguments
.macro load_two_args
	lw $t0, 0($a1)
	sw $t0, arg1
	lw $t0, 4($a1)
	sw $t0, arg2
.end_macro

# Helper macro for grabbing one command line argument
.macro load_one_arg
	lw $t0, 0($a1)
	sw $t0, arg1
.end_macro

############################################################################
##
##  TEXT SECTION
##
############################################################################
.text
.globl main

main:
#check if command line args are provided
#if zero command line arguments are provided exit
beqz $a0, exit_program
li $t0, 1
#check if only one command line argument is given and call marco to save them
beq $t0, $a0, one_arg
#else save the two command line arguments
load_two_args()
j done_saving_args

#if there is only one arg, call macro to save it
one_arg:
	load_one_arg()

#you are done saving args now, start writing your code.
done_saving_args:


# YOUR CODE SHOULD START HERE
	
	lw $a0, arg1 #Address of null terminated string
	li $a1, 0
	li $a2, 15
	li $v0, 13 # Contains fd
	syscall
	move $s7, $v0 # s7 contans v0 from syscall 13 (fd)
	blez $v0, exit_program
	move $a0 $v0 #fd
	li $a1, 0 #BG Color
	li $a2, 15 #FG Color
	jal load_code_chunk
	move $s3, $v0 #fd is moved from v0 to s3
j exit_program
loop:
	li $v0, 4#Prompting the user
	la, $a0, prompt
	syscall
	li $v0,12 #take in input
        syscall
        
       	move $t9, $v0 #Moving the input into t9
	bne $t9, 'q', notQuit #if t9 is not equal to q
		jal clear_screen #Jump to clear screen
		j exit_program
	notQuit:
	bne $t9 '\n' notEnter#Check if it's enter
		jal clear_screen
		bltz $s3, exit_program
		beqz $s3, loop #if s3 is equal to 0, jump to beginning of loop
		move $a0, $s7
		li $a1, 15 #BG Color
		li $a2, 0 #FG Color
		jal load_code_chunk
		move $s3, $v0 #fd is moved from v0 to s3
	notEnter:
	bne $t9 ' ' notSpace#Check if it's space
		jal clear_screen
		bltz $s3, exit_program
		beqz $s3, loop #if s3 is equal to 0, jump to beginning of loop
		move $a0, $s7
		li $a1, 15 #BG Color
		li $a2, 0 #FG Color
		jal load_code_chunk
		move $s3, $v0 #fd is moved from v0 to s3
	notSpace:
	
j loop

	#apply_cell_color
	li $a0, 1#i
	li $a1, 1#j 
	li $a2, 7#Foregroud color
	li $a3, 3#Background color
	jal apply_cell_color

	#clear_background
	li $a0 0 #Old Background color
	li $a1 7 #New Backgrund color
	jal clear_background
j quit
	#String compare
	la $a0, user_string
	li $a1,3 #Arguement for i
	li $a2,0 #Arguemet for j
	jal string_compare
	move $t0, $v0
	move $t1, $v1
	
	li $v0 1
	add $a0, $0, $t0
	syscall
	
	li $v0 1
	add $a0, $0, $t1
	syscall
	

	#search_screen
	addi $sp $sp -4
	la $a0, user_string #search string
	li $a1, 11 #bg color
	li $a2, 0 #fg color
	li $a3, 15 #default bg color
	li $s0, 10
	sw $s0 0($sp)
	jal search_screen
	lw $s0 0($sp)
	addi $sp $sp 4
#somewhere

	jal apply_java_syntax	
	jal apply_java_line_comments	
exit_program:
quit:	
li $v0, 16 # Close file
syscall 
li $v0, 10
syscall

############################################################################
##
##  DATA SECTION
##
############################################################################
.data
user_string: .asciiz "ABC"
.align 2

#for arguments read in
arg1: .word 0
arg2: .word 0

#prompts to display asking for user input
prompt: .asciiz "\nSpace or Enter to continue\n'q' to Quit\n'/' to search for text\n: "
search_prompt: .asciiz "\nEnter search string: "



#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw3.asm"
