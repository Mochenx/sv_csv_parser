
#!/bin/sh
./vlogana_uvm.sh
./vlogana_src.sh
ana_done=$?
echo "Vlogan done: $ana_done"
echo "=========================================="
if [ $ana_done -eq 0 ]
then
    vcs -sverilog TB ../../uvm_src/dpi/uvm_dpi.cc -CFLAGS -DVCS -debug_all -l cmp.log
fi

if [ $? -eq 0 ]
then
    ./simv -l sim.log
fi
