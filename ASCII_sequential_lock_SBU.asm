;
; ASCII_sequential_lock_SBU.asm
;
; Created: 10/13/2021 4:15:54 PM
; Author : vish7
; Target: AVR128DB48
; Replace with your application code

start:

ldi r16, $00 ;load r16 with all 0s
out VPORTC_DIR, r16 ;configure VPORTC as an input
sbi VPORTD_DIR, 7 ;PD7 output
cbi VPORTD_OUT, 7 ;initial value of lock is output 0
cbi VPORTE_DIR, 0 ;PE0 input
sbi VPORTE_DIR, 1 ;PE1 output

main_loop:
cbi VPORTE_OUT, 1 ;generate negative pulse to clear FF
sbi VPORTE_OUT, 1 ;stop clearing FF

char1:
sbis VPORTE_IN, 0
rjmp char1
in r16, VPORTC_IN ;input character
andi r16, $7F ;mask the bits, keeping only most significant one
cpi r16, 'S' ;Check to see if the input is S
brne main_loop ;If not S then go back to main loop, if S then skip instruction
cbi VPORTE_OUT, 1 ;generate negative pulse to clear FF
sbi VPORTE_OUT, 1 ;stop clearing FF

char2:
sbis VPORTE_IN, 0
rjmp char2
in r16, VPORTC_IN ;input character
andi r16, $7F ;mask the bits, keeping only most significant one
cpi r16, 'B' ;Check to see if the input is B
brne main_loop ;If not B then go back to main loop, if B then skip instruction
cbi VPORTE_OUT, 1 ;generate negative pulse to clear FF
sbi VPORTE_OUT, 1 ;stop clearing FF

char3:
sbis VPORTE_IN, 0 ;wait for pushbutton press
rjmp char3 ;if 0 back to char2
in r16, VPORTC_IN ;input character
andi r16, $7F ;mask the bits, keeping only most significant one
cpi r16, 'U' ;Check to see if the input is U
brne main_loop ;If not U then go back to main loop, if U then skip instruction

pulse:
ldi r16, 5 ;loop control variable for 15 clock delay
sbi VPORTD_OUT, 7 ;yes, generate 4 us pulse to open lock

pulse_delay:
dec r16 ;decrement loop control variable
brne pulse_delay ;branch if not equal
nop ;tune loop for 16 clocks inc. cbi
cbi VPORTD_OUT, 7 ;16th clock for 4 us
rjmp main_loop ;back to main_loop
