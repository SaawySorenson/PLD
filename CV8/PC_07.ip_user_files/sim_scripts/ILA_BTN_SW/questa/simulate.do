onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib ILA_BTN_SW_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {ILA_BTN_SW.udo}

run -all

quit -force
