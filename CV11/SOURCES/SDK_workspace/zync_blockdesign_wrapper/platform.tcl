# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Temp\xsvece00\PLD\CV11\SOURCES\SDK_workspace\zync_blockdesign_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Temp\xsvece00\PLD\CV11\SOURCES\SDK_workspace\zync_blockdesign_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {zync_blockdesign_wrapper}\
-hw {C:\Temp\xsvece00\PLD\CV11\SOURCES\HW\zync_blockdesign_wrapper.xsa}\
-out {C:/Temp/xsvece00/PLD/CV11/SOURCES/SDK_workspace}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {zync_blockdesign_wrapper}
domain active {zynq_fsbl}
domain active {standalone_ps7_cortexa9_0}
platform generate -quick
platform generate
