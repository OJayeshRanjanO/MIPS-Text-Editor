 # Homework #3
 # name: Jayesh Ranjan
 # sbuid: 109962199


##############################
#
# TEXT SECTION
#
##############################
 .text
 	#Macros are for the weak
##############################
# PART I FUNCTIONS
##############################

##############################
# This function reads a byte at a time from the file and puts it
# into the appropriate position into the MMIO with the correct
# FG and BG color.
# The function begins each time at position [0,0].
# If a newline character is encountered, the function must
# populate the rest of the row in the MMIO with the spaces and
# then continue placing the bytes at the start of the next row.
#
# @param fd file descriptor of the file.
# @param BG four-bit value indicating background color
# @param FG four-bit value indication foreground color
# @return int 1 means EOF has not been encountered yet, 0 means
# EOF reached, -1 means invalid file.
##############################
load_code_chunk: #No Edge cases
	#Stack implementation
	addi $sp, $sp, -100
	sw $s0 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	sw $s3 12($sp)
	sw $s4 16($sp)
	sw $s5 20($sp)
	sw $s6 24($sp)
	sw $s7 28($sp)
	sw $ra 32($sp)
	
	li $s4, 0 #Boolean counter
	li $s7 -1 #Initialzing fd to -1
	move $s0 $a0#fd as arguement
	
	move $s1 $a1#BG as arguement
	bltz $s1 invalidBG#If BG is less than 0
	bgt $s1 15 invalidBG#If BG is greater than 15
	j validBG # if valid BG color then branch to valid BG label
	invalidBG:
		li $s1 15 #Set background to white
	validBG:
	
	sll $s1, $s1, 4 #Offsetting by 4 to allow
	 
	move $s2 $a2#FG as argument
	bltz $s2 invalidFG#If FG is less than 0
	bgt $s2 15 invalidFG#If FG is greater than 15
	j validFG #if valid FG color then jump to validG label
	invalidFG:
		li $s2 0 #Set foreground to black
	validFG:
	
	add $s3, $s1, $s2 #Adding the fore to back in $s3
	
	#Taking in arguements for reading file
	li $t6, 0xffff0f9f
	li $t7, 160
	li $t8, ' ' #Space character
	li $t9, '\n' #New line character
	move $a0, $s0 # file descriptor
	li $a1, 0xffff0000 # address of input buffer
 	li $a2, 1 #MaxNumber of characters to read
 	li $t0, 0 #Loop counter
	load_code_chunk_while:
		bge $a1, $t6 exit #if end of the MMIO
		li $v0,14       # system call for read from file
		syscall          # read from file
		beq $v0,$s7 InvalidFile
		beqz $v0, fillUp # if v0 is less than 0 or equal
		bltz $v0, exit
		#add $s0, $0, $v0 # Saving the value to s0
		lb $t1,0($a1) #Loading value of a1 into t1 (For bne $t1,$t9 notNewLine )
		addi $a1, $a1, 1 #Incrementing the address of t1 by 1 to point towards the next byte to load color
		sb $s3 0($a1) #Saving the byte of s1 into a1
		addi $a1, $a1, 1 #Incrementing the address of t1 by 1 to towards the next byte to load the character (avoid overwrite) 
		addi $t0, $t0, 2 #Incrementing loop counter by 1
		bne $t1,$t9 notNewLine #If t1 is not equal to space
			#If newLine
			load_code_chunk_while1:
			bge $t0, $t7, while1End_nextLine #Once reached 160th byte, goto next line
			sb $t8 0($a1) #Saving the byte of space (t8) into a1
			addi $a1, $a1, 1 #Incrementing the address of a1 by 1 to point towards the next byte to load color
			sb $s1 0($a1) #Saving the byte of space (t8) into a1
			addi $a1, $a1, 1 #Incrementing the address of a1 by 1 to towards the next byte to load the character (avoid overwrite) 
			addi $t0, $t0, 2 #Incrementing the address of a0 by 1 to fill in space
			j load_code_chunk_while1
		notNewLine:
		while1End_nextLine:
		bne $t0, $t7, resetCounter
		li $t0, 0
		resetCounter:
	j load_code_chunk_while
	j exit
	fillUp:
		load_code_chunk_while2:
		bge $a1, $t6, exit
		sb $t8 0($a1) #Saving the byte of space (t8) into a1
		addi $a1, $a1, 1 #Incrementing the address of a1 by 1 to point towards the next byte to load color
		sb $s1 0($a1) #Saving the byte of space (t8) into a1
		addi $a1, $a1, 1 #Incrementing the address of a1 by 1 to towards the next byte to load the character (avoid overwrite) 
		j load_code_chunk_while2
	j exit
	InvalidFile:
		#li $v0, -1
	exit:
	lw $s0 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	lw $s3 12($sp)
	lw $s4 16($sp)
	lw $s5 20($sp)
	lw $s6 24($sp)
	lw $s7 28($sp)
	lw $ra 32($sp)
	addi $sp, $sp, 100 # Adding back space in stack
	jr $ra


##############################
# PART II FUNCTIONS
##############################

##############################
# This function should go through the whole memory array and clear the contents of the screen.
##############################
clear_screen:#No Edge cases
	
	#Stack implementation
	addi $sp, $sp, -100
	sw $s0 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	sw $s3 12($sp)
	sw $s4 16($sp)
	sw $s5 20($sp)
	sw $s6 24($sp)
	sw $s7 28($sp)
	#sw $ra 32($sp)
	
	li $s0, 0 #Background color
	li $s1, 0 #Foreground color
	sll $s0, $s0, 4 #Offsetting by 4 to allow 
	move $s1 $s1#FG as argument
	add $s2, $s0, $s1 #Adding the fore to back in $s2
	li $s3 ' ' #Loading space character in s3
	li $t0, 0xffff0f9f#Maximum range 
	li $t1, 0xffff0000 #Starting point on MMIO
	clear_screen_while:
		sb $s3 0($t1) #Saving the byte of space (s3) into a1
		addi $t1, $t1, 1 #Incrementing the address of a1 by 1 to point towards the next byte to load color
		sb $s2 0($t1) #Saving the byte of space (t8) into a1
		addi $t1, $t1, 1 #Incrementing the address of a1 by 1 to towards the next byte to load the character (avoid overwrite) 	
		bge $t1,$t0 clear_screen_whileEnd 
	j clear_screen_while
	clear_screen_whileEnd:
	lw $s0 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	lw $s3 12($sp)
	lw $s4 16($sp)
	lw $s5 20($sp)
	lw $s6 24($sp)
	lw $s7 28($sp)
	#lw $ra 32($sp)
	addi $sp, $sp, 100 # Adding back space in stack
	jr $ra
##############################
# PART III FUNCTIONS
##############################

##############################
# This function updates the color specifications of the cell
# specified by the cell index. This function should not modify
# the text in any fashion.
#
# @param i row of MMIO to apply the cell color.
# @param j column of MMIO to apply the cell color.
# @param FG the four bit value specifying the foreground color
# @param BG the four bit value specifying the background color
##############################
apply_cell_color: #Edge cases fixed
	#Stack implementation
	addi $sp, $sp, -100
	sw $s0 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	sw $s3 12($sp)
	sw $s4 16($sp)
	sw $s5 20($sp)
	sw $s6 24($sp)
	sw $s7 28($sp)
	#sw $ra 32($sp)
	
	li $t0, 0xffff0000 #Loading the starting address of MMIO in t0
	li $t1, 0xffff0f9f #Last address
	li $t2, 0 #Counter
	
	li $t9, 160
	li $t8, 2
	li $t7, 0xF0 #Masking Foreground value 
	li $t6, 0x0F #Masking Background value
	lb $t3, 0($t1) #loading color byte of the last address into t3 
	add $t7, $t7, $t3 #t7 contains only the background color (after masking)
	add $t6, $t6, $t3 #t7 contains only the foreground color (after masking)

	
	move $s0, $a0 #Taking in arguement for i
	bltz $s0 InvalidArguement_acc#If I is less than  0
	bgt $s0 24 InvalidArguement_acc#If I is greater than 24
	#Else valid s0 is valid i
	
	move $s1, $a1 #Taking in arguement for j
	bltz $s1 InvalidArguement_acc#If I is less than  0
	bgt $s1 79 InvalidArguement_acc#If I is greater than 79
	
	move $s2, $a2 #Taking in arguement for FG
	bltz $s2 invalidFG1#If FG is less than 0
	bgt $s2 15 invalidFG1#If FG is greater thanv15
	j validFG1 #if valid FG color then jump to validFG label
	invalidFG1:
		add $s2 $t6 $0#Set foreground to origin
	validFG1:#FIXME
	
	move $s3, $a3 #Taking in arguement for BG
	bltz $s3 invalidBG1#If BG is less than 0
	bgt $s3 15 invalidBG1#If BG is greater than 15
	j validBG1 #if valid BG color then jump to validBG1 label
	invalidBG1:#FIXME
		add $s3 $t7 $0#Set foreground to black
	validBG1:
	
	sll $s3, $s3, 4 #Shifting by 4 bytes
	add $s3, $s3, $s2 #Adding the BG and FG in s3
	
	mul $s0 $s0 $t9 # Multiplying 160 with i
	mul $s1 $s1 $t8 #Multiplying 2 with j
	add $s0 $s0, $s1 # Saving the result of sum of s1 and s0 in s0
	add $s0, $s0, $t0 #Adding the base address to s0 and saving it in s0
	addi $s0, $s0, 1 #Adding 1 to the result calcualted and saving it in s0 (#Address)
	sb $s3 0($s0)	
	
	InvalidArguement_acc:
	lw $s0 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	lw $s3 12($sp)
	lw $s4 16($sp)
	lw $s5 20($sp)
	lw $s6 24($sp)
	lw $s7 28($sp)
	#lw $ra 32($sp)
	addi $sp, $sp, 100 # Adding back space in stack
	jr $ra


##############################
# This function goes through and clears any cell with oldBG color
# and sets it to the newBG color. It preserves the foreground
# color of the text that was present.
#
# @param oldBG old background color specs.
# @param newBG new background color defining the color specs
##############################
clear_background:#No Edge cases
	addi $sp, $sp, -100
	sw $s0 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	sw $s3 12($sp)
	sw $s4 16($sp)
	sw $s5 20($sp)
	sw $s6 24($sp)
	sw $s7 28($sp)
	sw $ra 32($sp)
	move $s0, $a0#Moving old BG to s0
	sll $s0, $s0 4 #Shifting it left by so 0x0F becomes 0xF0
	move $s1, $a1#moving new BG to s1
	sll $s1, $s1 4 #Shifting it left by so 0x0F becomes 0xF0
	li $s2, 0xffff0001#tarting address of the color byte
	li $t9, 0xffff0f9f#Maximum range 
	li $s3, 0xF0 #Masking the foreground color
	li $s4, 0x0F #Masking the background color
	
	clear_background_loop:
		lb $t0, 0($s2) #Loading the color byte in t0
		and $t1, $s3, $t0 #Masking s3 with the color byte to check with old BG (s0) and saving it in t1 (Preserving the background color) (0xFFFF0000)
		bne $s0, $t1, NoChange #If they are not same, then move to next 2nd byte
			#Else
			and $t2, $s4, $s1 #Preserving the FG color (0x0000FFFF)
			add $t3, $t2, $s1 #Adding the new background to preserved BG color in t3
			sb $t3,0($s2)#Saving the color to location s2
		NoChange: 
		bge $s2, $t9 clear_background_end#If maximum range has been reached
		addi $s2, $s2 2 #adding 2 bytes to go to the next character
	j clear_background_loop
	clear_background_end:
	lw $s0 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	lw $s3 12($sp)
	lw $s4 16($sp)
	lw $s5 20($sp)
	lw $s6 24($sp)
	lw $s7 28($sp)
	lw $ra 32($sp)
	addi $sp, $sp, 100 # Adding back space in stack
	jr $ra


##############################
# This function will compare cmp_string to the string in the MMIO
# starting at position (i,j). If there is a match the function
# will return (1, length of the match).
#
# @param cmp_string start address of the string to look for in
# the MMIO
# @param i row of the MMIO to start string compare.
# @param j column of MMIO to start string compare.
# @return int length of match. 0 if no characters matched.
# @return int 1 for exact match, 0 otherwise
##############################
string_compare:#Edge cases fixed
	addi $sp, $sp, -100
	sw $s0 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	sw $s3 12($sp)
	sw $s4 16($sp)
	sw $s5 20($sp)
	sw $s6 24($sp)
	sw $s7 28($sp)
	sw $ra 32($sp)
	
	li $t9, 160 #Value of the row
	li $t8, 0xffff0000 #Starting address of MMIO
	li $t7, 2 #Loading 2 into t7
	li $s5, 0 #Counter
	li $v1, 1 #Boolean for 1 or 0 string match (Second integer)
	li $v0, 0 #Loading 0 to v0 to start counting from 0th character

	move $s0, $a0 #Moving a0 to s0 #String address is stored in s0
	move $s1, $a1 #Moving a1 to s1 #Stores the i'th column
	move $s2, $a2 #Moving a2 to s2 #Stores the j'th column
	
	bgt $s1, 24 invalidArguement_strcmp #If a1 in s1 is greater than 24, then invalidArguement_strcmp
	blt $s1, 0 invalidArguement_strcmp #If a1 in s1 is less than 0, then invalidArguement_strcmp
	bgt $s2, 79 invalidArguement_strcmp #If a2 in s2 is greater than 24, then invalidArguement_strcmp
	blt $s2, 0 invalidArguement_strcmp #If a2 in s2 is less than 0, then invalidArguement_strcmp
	j validArguement_strcmp #If both a2 and a1 is valid got to validArguement_strcmp
	invalidArguement_strcmp:
		li $v0, 0 #loading v0 with 0
		li $v1, 0 #loading v1 with 0
		j str_cmp_exit
	validArguement_strcmp:
	
	mul $s3 $s1 $t9 # Multiplying 160 with i
	mul $s4 $s2 $t7 #Multiplying 2 with j
	add $s3 $s3, $s4 # Saving the result of sum of s3 and s4 in s3
	add $t0, $t8, $s3 #Adding the base address to t8 and saving it in t0 #Calculating the address
	
	string_compare_loop:
		lb $t1 0($t0) #Loading the character from MMIO
		lb $t2 0($s0) #Loading the character from the string saved in s0 from a0
		beq $t2, 0, null_terminator
		beq $t2, '\n' null_terminator
		bne $t2 $t1 finish_comparing_mismatch #If mismatch found
		addi $t0, $t0, 2 #Moving to the next color byte in MMIO
		addi $s0, $s0, 1 #Moving to the next character byte in the string
		addi $v0, $v0, 1 #Adding 1 to check number of characters matched
	j string_compare_loop
	
	finish_comparing_mismatch:
	li $v1,0 #Load immediate Boolean to 0	
	null_terminator:
	str_cmp_exit:
	
	lw $s0 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	lw $s3 12($sp)
	lw $s4 16($sp)
	lw $s5 20($sp)
	lw $s6 24($sp)
	lw $s7 28($sp)
	lw $ra 32($sp)
	addi $sp, $sp, 100 # Adding back space in stack
	jr $ra


##############################
# This function goes through the whole MMIO screen and searches
# for any string matches to the search_string provided by the
# user. This function should clear the old highlights first.
# Then it will call string_compare on each cell in the MMIO
# looking for a match. If there is a match it will apply the
# background color using the apply_cell_color function.
#
# @param search_string Start address of the string to search for
# in the MMIO.
# @param BG background color specs defining.
##############################
search_screen:
	lw $t3 0($sp) #The 5th arguement
	addi $sp, $sp, -100
	sw $s0 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	sw $s3 12($sp)
	sw $s4 16($sp)
	sw $s5 20($sp)
	sw $s6 24($sp)
	sw $s7 28($sp)
	sw $ra 32($sp)
	
	#Arguements	
	move $s0, $a0 #Moving the string (a0) 
	move $s1, $a1 #BG (a1) arguement
	move $s2, $a2 #FG (a2) arguement
	move $s3, $a3 #default BG (a3) arguement
	
	#Calling clearbackground
	move $a0 $s3 #Moving the "old background" to a0 (Highlight background)
	move $a1 $s1 #Moving the "new background" to a1
	jal clear_background
	
	li $s7, 0 #Starting position of i
	li $s6, 0 #Starting position of j
	li $s5, 79 #End position of j
	li $s4, 24 #End position of i
	
	#Finding strings that match
	test_loop_row:
	bgt $s7 $s4 done #If s4 is more than 24
		test_loop_column:#Filling up a single row with colors
		bgt $s6 $s5 NextRow #If s6 is more than 79
			move $a0 $s0 #Loading string address of a0 from s0 to a0 
			move $a1 $s7 #Loading j to a1
			move $a2 $s6 #Loading i to a2
			sw $t0 40($sp)
			sw $t1 44($sp)
			sw $t2 60($sp)
			jal string_compare#Calling String comparasion
			lw $t0 40($sp)
			lw $t1 44($sp)
			lw $t2 60($sp)
			move $t4, $v0 #String length that matched
			move $t5, $v1 #Boolean 
	
			#Calling apply_cell_color
			bne $t5 1 MisMatch #If string not matched 
			li $t6,0 #Loading 0 to t6 for loop counter to count number of characters to highlight
			move $t7, $s6 #Loading the current value of j in t7
				
				test_loop:
				bge $t6, $t4 MisMatch #If t6 is equal to v0 then break loop
				move $a0, $s7 #Loading i to a1
				move $a1, $t7 #Loading j to a2
				move $a2, $s2 #FG (s2) arguement
				move $a3, $s1 #BG (s1) arguement
		
				sw $t6 36($sp)
				sw $t0 48($sp)
				sw $t1 52($sp)
				sw $t7 56($sp)
				sw $t2 64($sp)
				jal apply_cell_color
				lw $t6 36($sp)
				lw $t0 48($sp)
				lw $t1 52($sp)
				lw $t7 56($sp)
				lw $t2 64($sp)
		
				addi $t6, $t6 1 #Loop incrementer
				addi $t7 $t7 1 #Incrementing until the 
				j test_loop
			MisMatch:
			addi $s6, $s6 1 #Incrementing j by 1
		j test_loop_column
		NextRow:
		li $s6 0 #Resetting s6 to 0
	addi $s7, $s7 1 #Incrementing i
	j test_loop_row	
	done:
	lw $s0 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	lw $s3 12($sp)
	lw $s4 16($sp)
	lw $s5 20($sp)
	lw $s6 24($sp)
	lw $s7 28($sp)
	lw $ra 32($sp)
	addi $sp, $sp, 100 # Adding back space in stack
	jr $ra


##############################
# PART IV FUNCTIONS
##############################

##############################
# This function goes through the whole MMIO screen and searches
# for Java syntax keywords, operators, data types, etc and
# applies the appropriate color specifications for to that match.
##############################
apply_java_syntax:
	addi $sp, $sp, -100 # Adding back space in stack
	sw $s0 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	sw $s3 12($sp)
	sw $s4 16($sp)
	sw $s5 20($sp)
	sw $s6 24($sp)
	sw $s7 28($sp)
	sw $ra 32($sp)
	
	la $s0 java_keywords #Saves the address for java keywords
	la $s1 java_datatypes #Saves the address for java datatypes
	la $s2 java_operators #Saves the address for java operators
	la $s3 java_brackets #Saves the address for java brackets
	loop_keywords:
		lw $t0 0($s0) #Loading the address of s0 to address t0
		lb $t1, ($s0)
		beq $t1, 105, nextArrayOps
		move $a0 $t0 #Moving value of t0 to a0
		li $a1 0 #Black BG
		li $a2 9 #Bright Red FG
		li $a3 15 #default BG to white 
		jal search_screen
	
		addi $s0, $s0 4 #Incrementing s0 by 1
	j loop_keywords
	nextArrayOps:
	loop_datatypes:
		lw $t0 0($s1) #Loading the address of s0 to address t0
		lb $t1, ($s1)
		beq $t1, 43, nextArrayOps1
		move $a0 $t0 #Moving value of t0 to a0
		li $a1 0 #Black BG
		li $a2 14 #Bright Cyan FG
		li $a3 15 #default BG to white 
		jal search_screen
	
		addi $s1, $s1 4 #Incrementing s0 by 1
	j loop_datatypes
	nextArrayOps1:
	loop_operators:
		lw $t0 0($s2) #Loading the address of s0 to address t0
		lb $t1, ($s2)
		beq $t1, 40, nextArrayOps2
		move $a0 $t0 #Moving value of t0 to a0
		li $a1 0 #Black BG
		li $a2 10 #Bright Green FG
		li $a3 15 #default BG to white 
		jal search_screen
	
		addi $s2, $s2 4 #Incrementing s0 by 1
	j loop_operators
	nextArrayOps2:
	loop_brackets:
		lw $t0 0($s3) #Loading the address of s0 to address t0
		lb $t1, ($s3)
		beq $t1, 47, nextArrayOps3
		move $a0 $t0 #Moving value of t0 to a0
		li $a1 0 #Black BG
		li $a2 13 #Bright Magenta FG
		li $a3 15 #default BG to white 
		jal search_screen
	
		addi $s3, $s3 4 #Incrementing s0 by 1
	j loop_brackets
	nextArrayOps3:
	jal apply_java_line_comments
	
	lw $s0 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	lw $s3 12($sp)
	lw $s4 16($sp)
	lw $s5 20($sp)
	lw $s6 24($sp)
	lw $s7 28($sp)
	lw $ra 32($sp)
	addi $sp, $sp, 100 # Adding back space in stack
	jr $ra


##############################
# This function goes through the whole MMIO screen finds any java
# comments and applies a blue foreground color to all of the text
# in that line.
##############################
apply_java_line_comments:
	addi $sp, $sp, -100 # Adding back space in stack
	sw $s0 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	sw $s3 12($sp)
	sw $s4 16($sp)
	sw $s5 20($sp)
	sw $s6 24($sp)
	sw $s7 28($sp)
	sw $ra 32($sp)
	la $s0 java_line_comment
	li $s7, 0 #Starting position of i
	li $s6, 0 #Starting position of j
	li $s5, 79 #End position of j
	li $s4, 24 #End position of i
	
	#Finding strings that match
	test_loop_row1:
	bgt $s7 $s4 done #If s4 is more than 24
		test_loop_column1:#Filling up a single row with colors
		bgt $s6 $s5 NextRow1 #If s6 is more than 79
			move $a0 $s0 #Loading string address of a0 from s0 to a0 
			move $a1 $s7 #Loading j to a1
			move $a2 $s6 #Loading i to a2
			sw $t0 40($sp)
			sw $t1 44($sp)
			sw $t2 60($sp)
			jal string_compare#Calling String comparasion
			lw $t0 40($sp)
			lw $t1 44($sp)
			lw $t2 60($sp)
			move $t4, $v0 #String length that matched
			move $t5, $v1 #Boolean 
	
			#Calling apply_cell_color
			bne $t5 1 MisMatch1 #If string not matched 
			li $t6,0 #Loading 0 to t6 for loop counter to count number of characters to highlight
			move $t7, $s6 #Loading the current value of j in t7
				
				test_loop1:
				bge $t6, $s5 MisMatch1 #If t6 is equal to 79 then break loop
				move $a0, $s7 #Loading i to a1
				move $a1, $t7 #Loading j to a2
				li $a2, 12 #CUSTOM VALUE
				move $a3, $s1 #BG (s1) arguement
		
				sw $t6 36($sp)
				sw $t0 48($sp)
				sw $t1 52($sp)
				sw $t7 56($sp)
				sw $t2 64($sp)
				jal apply_cell_color
				lw $t6 36($sp)
				lw $t0 48($sp)
				lw $t1 52($sp)
				lw $t7 56($sp)
				lw $t2 64($sp)
		
				addi $t6, $t6 1 #Loop incrementer
				addi $t7 $t7 1 #Incrementing until the 
				j test_loop1
			MisMatch1:
			addi $s6, $s6 1 #Incrementing j by 1
		j test_loop_column1
		NextRow1:
		li $s6 0 #Resetting s6 to 0
	addi $s7, $s7 1 #Incrementing i
	j test_loop_row1
	
	lw $s0 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	lw $s3 12($sp)
	lw $s4 16($sp)
	lw $s5 20($sp)
	lw $s6 24($sp)
	lw $s7 28($sp)
	lw $ra 32($sp)
	addi $sp, $sp, 100 # Adding back space in stack
	jr $ra



##############################
#
# DATA SECTION
#
##############################
.data
emptySpace: .asciiz " "
#put the users search string in this buffer

.align 2
negative: .space 4000

#java keywords red
java_keywords_public: .asciiz "public"
java_keywords_private: .asciiz "private"
java_keywords_import: .asciiz "import"
java_keywords_class: .asciiz "class"
java_keywords_if: .asciiz "if"
java_keywords_else: .asciiz "else"
java_keywords_for: .asciiz "for"
java_keywords_return: .asciiz "return"
java_keywords_while: .asciiz "while"
java_keywords_sop: .asciiz "System.out.println"
java_keywords_sop2: .asciiz "System.out.print"

.align 2
#java_keywords: .word java_keywords_public, java_keywords_private, java_keywords_import, java_keywords_class, java_keywords_if, java_keywords_else, java_keywords_for, java_keywords_return, java_keywords_while, java_keywords_sop, java_keywords_sop2, negative
java_keywords: .word java_keywords_public, java_keywords_import, java_keywords_class, java_keywords_if, java_keywords_else, java_keywords_for, java_keywords_sop, java_keywords_sop2, negative
#java datatypes
java_datatype_int: .asciiz "int "
java_datatype_byte: .asciiz "byte "
java_datatype_short: .asciiz "short "
java_datatype_long: .asciiz "long "
java_datatype_char: .asciiz "char "
java_datatype_boolean: .asciiz "boolean "
java_datatype_double: .asciiz "double "
java_datatype_float: .asciiz "float "
java_datatype_string: .asciiz "String "

.align 2
#java_datatypes: .word java_datatype_int, java_datatype_byte, java_datatype_short, java_datatype_long, java_datatype_char, java_datatype_boolean, java_datatype_double, java_datatype_float, java_datatype_string, negative
java_datatypes: .word java_datatype_int, negative
#java operators
java_operator_plus: .asciiz "+"
java_operator_minus: .asciiz "-"
java_operator_division: .asciiz "/"
java_operator_multiply: .asciiz "*"
java_operator_less: .asciiz "<"
java_operator_greater: .asciiz ">"
java_operator_and_op: .asciiz "&&"
java_operator_or_op: .asciiz "||"
java_operator_not_op: .asciiz "!="
java_operator_equal: .asciiz "="
java_operator_colon: .asciiz ":"
java_operator_semicolon: .asciiz ";"

.align 2
java_operators: .word java_operator_plus, java_operator_minus, java_operator_division, java_operator_multiply, java_operator_less, java_operator_greater, java_operator_and_op, java_operator_or_op, java_operator_not_op, java_operator_equal, java_operator_colon, java_operator_semicolon, negative

#java brackets
java_bracket_paren_open: .asciiz "("
java_bracket_paren_close: .asciiz ")"
java_bracket_square_open: .asciiz "["
java_bracket_square_close: .asciiz "]"
java_bracket_curly_open: .asciiz "{"
java_bracket_curly_close: .asciiz "}"

.align 2
java_brackets: .word java_bracket_paren_open, java_bracket_paren_close, java_bracket_square_open, java_bracket_square_close, java_bracket_curly_open, java_bracket_curly_close, negative

java_line_comment: .asciiz "//"

.align 2
user_search_buffer: .space 101
