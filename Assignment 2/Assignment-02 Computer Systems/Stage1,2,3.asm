//------------------------STAGE_1----------------------------------
//codebreaker
      mov R0, #codebreaker_question
      STR R0, .WriteString
      mov R0, #codebreaker
      BL readstrings
//codemaker
      mov R0, #codemaker_question
      STR R0, .WriteString
      mov R0, #codemaker
      BL readstrings
//maximum guess
maxguess:
      MOV R0, #maxguess_question
      STR R0, .WriteString
      LDR R4, .InputNum 
      STR R4, .WriteUnsignedNum 
      CMP R4, #0 
      BGT checkmaxguess
      BLT maxguesserror
      BEQ maxguesserror
checkmaxguess: 
      CMP R4, #20 
      BLT Stage23 
      BL maxguesserror
      B maxguess
//-------------------Stage 2,3-------------------------------------
Stage23:
      BL movenextline
      mov R4, #codemaker
      STR R4, .WriteString
      mov R4, #inputcode_question
      STR R4, .WriteString
      BL getcode
      BL getcode2
      HALT
//-----------------------Input Code Functions--------------------------
getcode:
      MOV R4, #inputcode 
      STR R4, .ReadString
      RET
getcode2:
      PUSH {R4, R1, R4,SP}
      MOV R4, #inputcode 
      MOV R4, #0
      BL check_fourletters
      POP {R4, R1, R4, SP} // return R4, R1, SP to previous value
      PUSH {R1, R4, R5}
      MOV R4, #0
      LDR R4, [R2]
      MOV R1, #secretcode
      STR R4, [R3]
      BL check_required_alphabets
      POP {R1, R4, R5}
      HALT
//-----------------------Check Input Functions (4 Letters)---------------------
check_fourletters:
      LDRB R1, [R2 + R4] // take single byte of the code ( from least significant to most significant byte)
      CMP R1, #0        // if it is equal to 0, the byte is empty
      BNE check_fourletters2 // if not equal to 0 for this index, check the next index
check_fourletters2:     //while loop to check all letters in the array
      ADD R4, R4, #1
      CMP R4, #4
      BLT check_fourletters
      LDRB R1, [R2 + #4] 
      CMP R1, #0        //Will check the 5th byte, if the 5th byte is not equal to 0, there is an input in the 5th byte
      BNE fourlettererror 
      B checkfourletters3
checkfourletters3:
      RET
//-----------------------Check Input Functions (Required Alphabets)------------
check_required_alphabets:
      LDRB R6, [R3 + R4] // take the least to most significant byte of the code
      cmp R6, #114      // compare with r
      beq check_required_alphabets2
      cmp R6, #103      // compare with g
      beq check_required_alphabets2
      cmp R6, #98       // compare with b
      beq check_required_alphabets2
      cmp R6, #121      // compare with y
      beq check_required_alphabets2
      cmp R6, #112      // compare with p
      beq check_required_alphabets2
      cmp R6, #99       // compare with c
      beq check_required_alphabets2
      B Alphabeterror
check_required_alphabets2:
      ADD R4, R4, #1 
      cmp R4, #4
      beq check_required_alphabets3 
      BLT check_required_alphabets
check_required_alphabets3:
      RET
//-------------------Other Functions----------------------------------
readstrings:
      STR R0, .ReadString
      STR R0, .WriteString
      RET
maxguesserror:
      PUSH {R2}
      mov R4, #WRONG    //maxguess exceeds 10
      STR R4, .WriteString
      POP {R2}
      RET
movenextline:
      PUSH {R2}
      MOV R4, #nextline
      STR R4,.WriteString
      POP {R2}
      RET
fourlettererror:
      PUSH {R2}
      MOV R4, #WRONG2   //if input exceeds 4 letters
      STR R4, .WriteString
      POP {R2}
      B Stage23
Alphabeterror:
      PUSH {R2}
      mov R4, #WRONG3   //if the input alphabets is wrong
      STR R4, .WriteString
      POP {R2}
      B Stage23
//-------------------------Variables-------------------------------------
codebreaker: .WORD 16 
codemaker: .WORD 16     //memory addressess
inputcode: .WORD 0 
secretcode: .WORD 0
//-------------------------Sentences---------------------------------
codebreaker_question: .ASCIZ "Codebreaker is "
codemaker_question: .ASCIZ "\nCodemaker is "
maxguess_question: .ASCIZ "\nMaximum number of guesses is: "
inputcode_question: .ASCIZ ", Please enter a 4-letter code: "
WRONG: .ASCIZ "\nPlease choose a number from 1 to 10"
WRONG2: .ASCIZ "\nPlease enter 4 letters only"
WRONG3: .ASCIZ "\nThe input must be the following letters: 'r' 'g' 'b' 'y' 'p' 'c' "
nextline: .ASCIZ "\n"
