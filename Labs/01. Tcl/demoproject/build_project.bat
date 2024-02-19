call C:\Xilinx\Vivado\2016.4\settings64.bat
rd /s /q demo
vivado -mode=batch -nojournal -nolog -source build_project.tcl