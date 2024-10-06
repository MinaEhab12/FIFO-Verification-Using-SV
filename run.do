vlib work
vlog interface.sv pkg_trans.sv pkg_coverage.sv pkg_scoreboard.sv shared_pkg.sv FIFO.sv monitor.sv FIFO_tb.sv top.sv +cover -covercells
vsim -voptargs=+acc work.top -cover
add wave *
coverage save top.ucdb -onexit
run -all