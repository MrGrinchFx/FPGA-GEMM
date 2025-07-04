
#Source code for the General Matrix Multiplier
#Built on to the DELITE-10 FPGA from Intel.

#Implemented in Verilog HDL is the MAC Unit as well as the control
#unit for the FSM.

![FPGA results](FPGA_results.jpg)
![FPGA Waveforms](FPGA_results2.jpg)
- lab1/
	- hdl/
		- dec_7seg_decoder.v

	- ip/
		- empty - later may include IPs generated by Quartus

	- simulation/
		- majority/
			- ModelSim-generated files (tb_majority.mpf, etc.)
		- partI/
			- ModelSim-generated files (tb_partI.mpf, etc.)
		- partII/
			- ModelSim-generated files (tb_partII.mpf, etc.)

	- synthesis/
		- majority/
			- SystemBuilder- & Quartus-generated files (.qsf, .qpf, .sdc, majority.v file, etc.)
		- partI/
			- SystemBuilder- & Quartus-generated files (.qsf, .qpf, .sdc, partI.v file, etc.)
		- partII/
			- SystemBuilder- & Quartus-generated files (.qsf, .qpf, .sdc, partII.v file, etc.)

	- test/
		- tb_majority.v
		- tb_partI.v
		- tb_partII.v
