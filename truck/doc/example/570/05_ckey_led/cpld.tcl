##############################################
#      www.OurFPGA.com
##############################################


#------------------GLOBAL--------------------#
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

set_location_assignment	PIN_12 	-to	clock
set_location_assignment	PIN_41 	-to	rst_n


#--------------------LED----------------------#
set_location_assignment	PIN_67	-to	led[1]
set_location_assignment	PIN_66	-to	led[2]
set_location_assignment	PIN_61	-to	led[3]
set_location_assignment	PIN_58	-to	led[4]
set_location_assignment	PIN_57	-to	led[5]
set_location_assignment	PIN_56	-to	led[6]
set_location_assignment	PIN_55	-to	led[7]
set_location_assignment	PIN_54	-to	led[8]

#--------------------KEY----------------------#

set_location_assignment	PIN_49 	-to	key[1]
set_location_assignment	PIN_48        -to	key[2]
set_location_assignment	PIN_47 	-to	key[3]
set_location_assignment	PIN_44 	-to	key[4]
set_location_assignment	PIN_43 	-to	key[5]
set_location_assignment	PIN_42 	-to	key[6]


#--------------------CKEY----------------------#
set_location_assignment	PIN_53 	-to	ckey[1]
set_location_assignment	PIN_52 	-to	ckey[2]
set_location_assignment	PIN_51        -to	ckey[3]
set_location_assignment	PIN_50  	-to	ckey[4]
