PRO DISH_HOME, IP_ADDR, PORT, SOCK_UIT, SUCCESS=SUCCESS, VERBOSE=VERBOSE

NORMAL_VEL='50'
SLOW_VEL='10'
MAX_DIST='20000000'
REVERSE_DIST='100000'
BACK_OFF_DIST='80000'

AXIS_1_LIM_STAT=''
AXIS_2_LIMLSTAT=''
AXIS_1_CONTROL_STAT=''
AXIS_2_CONTROL_STAT=''
AXIS_1_RUN_STAT=''
AXIS_2_RUN_STAT=''



DRIVE_OFF, IP_ADDR, PORT, '1', VERBOSE=SET_VERBOSE
DRIVE_ON, IP_ADDR, PORT, '1', VERBOSE=SET_VERBOSE
CONTROL_STAT, IP_ADDR, PORT, '1',CONTROL_STATUS=AXIS_1_CONTROL_STAT, VERBOSE=SET_VERBOSE
SET_MPI, IP_ADDR, PORT, '1', VERBOSE=SET_VERBOSE
SET_MOVE, IP_ADDR, PORT, '1','-20000000','50','50',MV_MODE='mpi',VERBOSE=SET_VERBOSE
SET_MOVE, IP_ADDR, PORT, '1','100000','50','50',MV_MODE='mpi',VERBOSE=SET_VERBOSE
DRIVE_RESET, IP_ADDR, PORT, '1', VERBOSE=SET_VERBOSE
SET_MOVE, IP_ADDR, PORT, '1','100000','50','50',MV_MODE='mpi',VERBOSE=SET_VERBOSE






WHILE AXIS_1_LIM_STAT NE 'G' DO BEGIN


WHILE AXIS_1_LIM_STAT NE 'S' DO BEGIN



ENDWHILE
ENDWHILE









END
