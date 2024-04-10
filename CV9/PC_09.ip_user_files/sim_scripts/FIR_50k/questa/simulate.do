onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib FIR_50k_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {FIR_50k.udo}

run -all

quit -force
