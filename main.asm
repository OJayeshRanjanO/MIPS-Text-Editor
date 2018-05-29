
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
##  DATA SECTION
##
############################################################################
.data
buffer: .space 400
test: .asciiz "abcd"
.align 2

#for arguments read in
arg1: .word 0
arg2: .word 0

#prompts to display asking for user input
prompt: .asciiz "\nSpace or Enter to continue\n'q' to Quit\n'/' to search for text\n: "
search_prompt: .asciiz "\nEnter search string: "

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
	#Opens file for writing to get the file descriptor
	li $v0, 13		#Opens file
	lw $a0, arg1		#File Name
	li $a1, 0		#Opens for reading
	li $a2, 0		#Ignore numb characters to read
	syscall			#opens the file and saves file descriptor in $v0
	move $a0, $v0		#saves the file descriptor into $a0
	#lw $t0 argument2 #Loading "java" keyword
	lb $t1, arg2
	li $t0, 'j'
	bne $t1 -33 default #Java  (j label)
		li $a1, 0		# BG for start function (
		li $a2, 15		# FG for start function
		jal load_code_chunk
		jal apply_java_syntax
		jal apply_java_line_comments
		j A
	default:
	li $a1, 15		# BG for start function (
	li $a2, 0		# FG for start function
	jal load_code_chunk
	A:
tryToPrompt:
	addi $sp, $sp, -4
	sw $s0, ($sp)
	move $s0, $a0
	
doPrompt:
	la $a0, prompt
	li $v0, 4
	syscall
	
	li $v0, 12
	syscall
	
	move $t0, $v0
	beq $t0, 'q', exit_prompting
	beq $t0, ' ', clear_and_load
	beq $t0, '\n', clear_and_load
	beq $t0, '/', request_to_search
	beq $t0, 'c', clear_screen_request
	beq $t0, 's', str_cmp_request
	beq $t0, 'S', search_screen_request
	beq $t0, 'a', apply_cell_color_request
	beq $t0, 'b', clear_background_request
		j doPrompt
	
	clear_background_request:
		li $a0, 0x0 # BG to search for
		li $a1,	0xd # New BG
		jal clear_background
		
	clear_and_load:
		jal clear_screen	# Clear screen then load the rest
		move $a0, $s0		# saves the file descriptor into $a0
		bne $t1 -33 default4 #Java  (j label)
			li $a1, 0		# BG for start function (
			li $a2, 15		# FG for start function
			jal load_code_chunk
			j default_jump1
		default4:
		li $a1, 15		# BG color (color of text)
		li $a2, 0		# FG color 
		default_jump1:
		jal load_code_chunk
		j doPrompt
		
	request_to_search:
		la $a0, search_prompt
		li $v0, 4
		syscall
		
		la $a0, buffer
		li $a1, 100
		li $v0, 8
		syscall
		
		la $a0, buffer
		li $a1, 0xb
		li $a2, 0x0
		li $a3, 0x0
		jal search_screen

		j doPrompt
		
	clear_screen_request:
		jal clear_screen
		
		j doPrompt
		
	str_cmp_request:
		la $a0, test
		li $a1, 0
		li $a2, 0
		jal string_compare
		move $t0, $v0	# Store hw3 v0 into main t0
		move $t1, $v1	# Store hw3 v0 into main t1
		
		# Print out statements
		move $a0, $t0
		li $v0, 1
		syscall	# Num char match
		move $a0, $t1
		li $v0, 1	
		syscall	# Boolean perfect match
		
		j doPrompt
		
	search_screen_request:
		li $a0, 0x4
		li $a1, 0x2
		li $a2, 0x5
		li $a3, 0xd
		jal clear_background
		
		j doPrompt
		
	apply_cell_color_request:
		li $a0, 0
		li $a1, 0
		li $a2, 0xa
		li $a3, 0xa
		jal apply_cell_color
		
		j doPrompt
		
	exit_prompting:
	lw $s0, ($sp)
	addi $sp, $sp, 4
	jal clear_screen
	j exit_program
	
exit_program:
	li $v0, 10
	syscall

#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw3.asm"
