onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+ILA_BTN_SW -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ILA_BTN_SW xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {ILA_BTN_SW.udo}

run -all

endsim

quit -force
