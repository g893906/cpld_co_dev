##############################################
#      www.OurFPGA.com
##############################################


#------------------GLOBAL--------------------#
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

set_location_assignment	PIN_12 	-to	clk
set_location_assignment	PIN_41 	-to	rst_n



#--------------------LCD----------------------#
set_location_assignment	PIN_6	    -to	rs
set_location_assignment	PIN_5	    -to	rw
set_location_assignment	PIN_4	    -to       en
set_location_assignment	PIN_3	    -to	dat[0]
set_location_assignment	PIN_2	    -to	dat[1]
set_location_assignment	PIN_1	    -to	dat[2]
set_location_assignment	PIN_100    -to	dat[3]
set_location_assignment	PIN_99     -to       dat[4]

set_location_assignment	PIN_98     -to	dat[5]
set_location_assignment	PIN_97     -to       dat[6]
set_location_assignment	PIN_96	    -to	dat[7]