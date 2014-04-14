PRO CONTROL_STAT, IP_ADDR, PORT, MOVE_AXIS, CONTROL_STATUS = CONTROL_STATUS, VERBOSE=VERBOSE

ARG=STRING(13B)+STRING(13B)+MOVE_AXIS+'R'+STRING(13B)
IF VERBOSE EQ 1 THEN PRINT, 'Controller status requested from Drive ',MOVE_AXIS
OEM_REPLY='12345678'

;print, 'Before wait'
WAIT,1
;print, 'After wait'

SOCKET,SOCK_UNIT,IP_ADDR,PORT,/GET_LUN
WRITEU,SOCK_UNIT,ARG
READU,SOCK_UNIT,OEM_REPLY
CLOSE,SOCK_UNIT
FREE_LUN,SOCK_UNIT

OEM_REPLY=STRSPLIT(OEM_REPLY,'*',/EXTRACT)
OEM_REPLY=OEM_REPLY[1]
OEM_REPLY=STRSPLIT(OEM_REPLY,STRING(13B),/EXTRACT)
OEM_REPLY=OEM_REPLY[0]
IF VERBOSE EQ 1 THEN PRINT, 'Drive ',MOVE_AXIS,' controller reply is ',OEM_REPLY

IF VERBOSE EQ 1 THEN BEGIN
CASE OEM_REPLY OF
  'R': PRINT,'Drive ',MOVE_AXIS,' is ready.'
  'S': PRINT,'Drive ',MOVE_AXIS,' is ready, but attention is needed.'
  'B': PRINT,'Drive ',MOVE_AXIS,' is busy.'
  'C': PRINT,'Drive ',MOVE_AXIS,' is busy and attention is needed.'
ELSE: PRINT, 'No valid response received from Drive ',MOVE_AXIS,', please check communications.'
ENDCASE
ENDIF

CONTROL_STATUS=OEM_REPLY

END
