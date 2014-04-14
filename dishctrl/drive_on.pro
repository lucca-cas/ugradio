PRO DRIVE_ON, IP_ADDR, PORT, VERBOSE=VERBOSE

ARG=STRING(13B)+STRING(13B)+'ON'+STRING(13B)
IF VERBOSE EQ 1 THEN PRINT, 'Energizing Drives'
OEM_REPLY='12345'

WAIT,1

SOCKET,SOCK_UNIT,IP_ADDR,PORT,/GET_LUN
WRITEU,SOCK_UNIT,ARG
READU,SOCK_UNIT,OEM_REPLY
CLOSE,SOCK_UNIT
FREE_LUN,SOCK_UNIT

WAIT,.5
END
