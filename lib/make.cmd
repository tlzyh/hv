CALL SETENV /Release /x86 /xp
CL /nologo /Wall /LD /D_CRT_SECURE_NO_WARNINGS hv.c /link /out:hv-x86.dll shell32.lib user32.lib
DEL hv.exp hv.lib hv.obj

CALL SETENV /Release /x64 /xp
CL /nologo /Wall /LD /D_CRT_SECURE_NO_WARNINGS hv.c /link /out:hv-x64.dll shell32.lib user32.lib
DEL hv.exp hv.lib hv.obj
