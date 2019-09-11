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


#--------------------DIG----------------------#
set_location_assignment	PIN_87 	-to	dig[0]
set_location_assignment	PIN_86 	-to	dig[1]
set_location_assignment	PIN_85 	-to    dig[2]
set_location_assignment	PIN_84 	-to	dig[3]
set_location_assignment	PIN_95 	-to	dig[4]
set_location_assignment	PIN_92 	-to	dig[5]
set_location_assignment	PIN_91 	-to	dig[6]
set_location_assignment	PIN_89 	-to    dig[7]

set_location_assignment	PIN_76        -to	seg[0]
set_location_assignment	PIN_83 	-to    seg[1]
set_location_assignment	PIN_81 	-to	seg[2]
set_location_assignment	PIN_75 	-to	seg[3]
set_location_assignment	PIN_74 	-to	seg[4]
set_location_assignment	PIN_78 	-to    seg[5]
set_location_assignment	PIN_82 	-to    seg[6]
set_location_assignment	PIN_77 	-to    seg[7]


#--------------------BEEP----------------------#
set_location_assignment	PIN_73	-to	beep



#--------------------PS2----------------------#
set_location_assignment	PIN_71	     -to	ps2_clk
set_location_assignment	PIN_72	     -to	ps2_dat

#--------------------UART----------------------#
set_location_assignment	PIN_68 	-to	rxd
set_location_assignment	PIN_69	       -to	txd


#--------------------LCD----------------------#
set_location_assignment	PIN_6	    -to	lcd[1]
set_location_assignment	PIN_5	    -to	lcd[2]
set_location_assignment	PIN_4	    -to       lcd[3]
set_location_assignment	PIN_3	    -to	lcd[4]
set_location_assignment	PIN_2	    -to	lcd[5]
set_location_assignment	PIN_1	    -to	lcd[6]
set_location_assignment	PIN_100    -to	lcd[7]
set_location_assignment	PIN_99     -to       lcd[8]

set_location_assignment	PIN_98     -to	lcd[9]
set_location_assignment	PIN_97     -to       lcd[10]
set_location_assignment	PIN_96	    -to	lcd[11]

#--------------------AD----------------------#
set_location_assignment	PIN_18 	-to	adc_clk
set_location_assignment	PIN_20 	-to	cs_n
set_location_assignment	PIN_19 	-to     sdat_in