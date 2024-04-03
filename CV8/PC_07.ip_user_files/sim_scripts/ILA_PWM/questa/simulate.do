onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib ILA_PWM_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {ILA_PWM.udo}

run -all

quit -force
