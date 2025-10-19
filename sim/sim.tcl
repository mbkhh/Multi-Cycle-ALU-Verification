transcript file transcript_#.log

file delete -force *~  vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf

exec vlib work
vmap work work


set test_name           "random_test"
# set test_name           "test_mid"
# set test_name           "test_high"
# set test_name           "test_mix"


set sv_seed             "42"
# set sv_seed             "90"


    
#===============================================================================
	

    onbreak {
        # quit -sim
        # do merge_coverage.tcl
    }



#========== complile modules



vlog -vopt -sv	+acc -incr -source  ../hvl/parameter_packages/*.sv
vlog -vopt -sv	+acc -incr -source  ../hvl/interface_packages/alu_in_pkg/alu_in_if.sv
vlog -vopt -sv	+acc -incr -source  ../hvl/interface_packages/alu_out_pkg/alu_out_if.sv

vlog  -cover fsb -vopt -sv	+acc -incr -source  ../hdl/*.sv

vlog -vopt -sv	+acc -incr -source  ../hvl/class_pkg.sv

vlog -vopt -sv	+acc -incr -source  ../hvl/tests/*.sv

vlog -vopt -sv	+acc -incr -source  ../hvl/top.sv


#========== simulate design
vsim	-sv_seed $sv_seed	-wlf vsim.wlf  -wlfopt -wlfslim 10000 -wlftlim {500 ms}\
        -voptargs=+acc -debugDB \
        -classdebug  -coverage -assertdebug top 


coverage attribute -name TESTNAME -value  $test_name$sv_seed
coverage save -onexit last_run.ucdb

#========== adding signals to wave window
do wave.tcl


#========== run simulation
run -all





