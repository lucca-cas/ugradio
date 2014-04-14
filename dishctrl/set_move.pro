PRO SET_MOVE, IP_ADDR, PORT, MOVE_AXIS, MV_DIST, MV_VEL, MV_ACCL, MV_MODE=MV_MODE, VERBOSE=VERBOSE

SET_VERBOSE=0
IF VERBOSE EQ 1 THEN SET_VERBOSE=1

ASET_OK=0
VSET_OK=0
DSET_OK=0
MAX_ERROR=1000

PRINT, 'Initializing . . .'

RDY_CHK=''
RUN_STAT, IP_ADDR, PORT, MOVE_AXIS, RUN_STATUS=RDY_CHK, VERBOSE=SET_VERBOSE

LIM_CHK=''
LIM_STAT, IP_ADDR, PORT, MOVE_AXIS, LIM_STATUS=LIM_CHK, VERBOSE=SET_VERBOSE

CTRL_CHECK=''
CONTROL_STAT, IP_ADDR, PORT, MOVE_AXIS, CONTROL_STATUS=CTRL_CHK, VERBOSE=SET_VERBOSE

ENC_CHK=0
ENC_POS, IP_ADDR, PORT, MOVE_AXIS, ENC_POSITION=ENC_CHK, VERBOSE=SET_VERBOSE
INIT_POS=ENC_CHK
PRINT,'Starting at',STRCOMPRESS(STRING(INIT_POS))
MV_CHK=0
MV_DONE=0

SET_ACCEL, IP_ADDR, PORT, MOVE_AXIS, ACCEL=MV_ACCL, SUCCESS=ASET_OK, VERBOSE=SET_VERBOSE
SET_VEL, IP_ADDR, PORT, MOVE_AXIS, VELOCITY=MV_VEL, SUCCESS=VSET_OK, VERBOSE=SET_VERBOSE
SET_DIST, IP_ADDR, PORT, MOVE_AXIS, DISTANCE=MV_DIST, SUCCESS=DSET_OK, VERBOSE=SET_VERBOSE

IF (((ASET_OK EQ 1) && (VSET_OK EQ 1)) && (DSET_OK EQ 1)) THEN BEGIN
;PRINT, 'GO WOULD INITIATE HERE'
SET_GO, IP_ADDR, PORT, MOVE_AXIS, VERBOSE=SET_VERBOSE
ENDIF
IF MV_MODE EQ 'mpa' THEN PRINT, 'Moving to',STRCOMPRESS(STRING(MV_DIST)),', Please Wait!'
IF MV_MODE EQ 'mpi' THEN PRINT, 'Moving to',STRCOMPRESS(STRING(INIT_POS+MV_DIST)),', Please Wait!'

WHILE (((((LIM_CHK EQ '@') || (LIM_CHK EQ 'A')) || (LIM_CHK EQ 'B')) || ((CTRL_CHK NE 'S')||(CTRL_CHK NE 'C'))) && ((MV_CHK LT 3) && (MV_DONE EQ 0))) DO BEGIN
ENC_CHK_LAST = ENC_CHK
PRINT, 'Drive ', MOVE_AXIS, ' is at position',STRCOMPRESS(STRING(ENC_CHK))
LIM_STAT, IP_ADDR, PORT, MOVE_AXIS, LIM_STATUS=LIM_CHK, VERBOSE=SET_VERBOSE
CONTROL_STAT, IP_ADDR, PORT, MOVE_AXIS, CONTROL_STATUS=CTRL_CHK, VERBOSE=SET_VERBOSE
ENC_POS, IP_ADDR, PORT, MOVE_AXIS, ENC_POSITION=ENC_CHK, VERBOSE=SET_VERBOSE

IF MV_MODE EQ 'mpa' THEN BEGIN
MV_ERROR=ABS(MV_DIST-ENC_CHK)
IF SET_VERBOSE EQ 1 THEN PRINT,'Move error is',STRCOMPRESS(STRING(MV_ERROR))
ENDIF

IF MV_MODE EQ 'mpi' THEN BEGIN
TARGET_POS=INIT_POS+MV_DIST
MV_ERROR=ABS(TARGET_POS-ENC_CHK)
IF SET_VERBOSE EQ 1 THEN PRINT,'Move error is',STRCOMPRESS(STRING(MV_ERROR))
ENDIF

IF ((MV_ERROR LE MAX_ERROR) && (CTRL_CHK EQ 'R')) THEN MV_DONE = 1
IF ENC_CHK EQ ENC_CHK_LAST THEN (MV_CHK = MV_CHK + 1)
IF MV_CHK GE 3 THEN PRINT, 'Axis for Drive ',MOVE_AXIS,' is not moving. Exiting!'
ENDWHILE

END
