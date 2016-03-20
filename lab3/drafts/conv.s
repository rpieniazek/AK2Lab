# read line of space separated hex numbers and print it in base 2,8,10 and 16

SYSEXIT       = 1
SYSREAD       = 3
SYSWRITE      = 4
STDIN         = 0
STDOUT        = 1
EXIT_SUCCESS  = 0
SPACE         = 32

.align 32

.data
  .comm data,       100 # 100 x 1byte
  .comm data_len,   4
  .comm nums,       4   
  .comm tmp,        1   # temporary variable used for displaying 

.text
  msg_data:   .ascii  "Liczy hex oddzielone spacja: "
  msg_data_len  = . - msg_data
  
  msg_nl:     .ascii  "\n"

.global main

main:
  # IO stuff
  
  # show data prompt
  mov $msg_data,      %ecx
  mov $msg_data_len,  %edx
  call print
  
  # read input
  mov $data,          %ecx
  mov $100,           %edx # max length
  call read
  mov %eax,           data_len # save data length
  
  # strip data len
  mov data_len,       %eax
  sub $1,             %eax
  mov %eax,           data_len
  
  # init vars
  mov $1,   %ecx      # m = 1
  movl $0,  nums      # nums = 0
  
  # scan input data from the end
  # and store each number as 4 bytes at separate memory address
  mov data_len,   %esi
  sub $1,         %esi
  for1:
    cmp $0,       %esi
    jl end_for1

    # if current character is a space
    # reset exp and increment numbers counter
    xor %eax, %eax
    mov data(, %esi, 1),  %al     # val
    cmp $SPACE, %al
    je got_space
    
    # if & else
    got_char: # save char
      cmp $97, %al
      jge small_letter
      cmp $65, %al
      jge big_letter
      
        sub $48, %al              # got '0' .. '9', convert to 0 .. 9
        jmp store_it
        
      small_letter:               # got 'a' .. 'f', convert to 10 .. 15
        sub $87, %al
        jmp store_it
        
      big_letter:                 # got 'A' .. 'F', convert to 10 .. 15
        sub $55, %al
      
      store_it:
        mul %ecx                  # val*m
        add %eax, nums
        
        mov %ecx, %eax            # m *= 16
        mov $16,  %edx
        mul %edx
        mov %eax, %ecx
      
      jmp out

    got_space: # kind of reset
      mov $1, %ecx

    out:
      
    dec %esi
    jmp for1

  end_for1:

  # print representation base 2,8,10 and 16
  mov nums, %eax
  mov $2,   %ebx
  call print_base
  mov $8,   %ebx
  call print_base
  mov $10,  %ebx
  call print_base
  mov $16,  %ebx
  call print_base
  call nl

  # exit with 0
  mov $SYSEXIT,       %eax
  mov $EXIT_SUCCESS,  %ebx
  int $0x80
  ret

# io utils
print: # print data stored in %ecx with length stored in %edx to STDOUT
  mov $SYSWRITE,      %eax
  mov $STDOUT,        %ebx
  int $0x80
  ret

read: # read max %edx characters from STDIN into %ecx destination, store length in %eax
  mov $SYSREAD,       %eax
  mov $STDIN,         %ebx
  int $0x80
  ret
  
# prints number in specified base
# It does it using division and modulo (by base)
# and store each value on a stack until current value reaches 0
# Then it pops values from stack in reversed order and prints them
print_base: # x in %eax, base in %ebx
  push %rax
  xor %esi,     %esi    # k = 0
  for3:
    xor %edx,   %edx
    div %ebx
    push %rdx
    inc %esi
    
    cmp $0,     %eax
    jne for3
    
  for4:
    cmp $0,     %esi
    je end_for4
    
    pop %rcx
    cmp $10,    %ecx      # Check fo 10 .. 15 values (and show as letters, only base 16)
    jl less
      add $7,   %ecx
    less:
    
    add $48,    %ecx
    mov %ecx,   tmp
    mov $tmp,   %ecx
    mov $1,     %edx
    call print

    dec %esi
    jmp for4

  end_for4:
  call nl
  pop %rax
  ret

nl: # print new line
  mov $msg_nl,        %ecx
  mov $1,             %edx
  call print
  ret
