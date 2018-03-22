#include <windows.h>
#include <shellapi.h>
#include <ctype.h>
#include <string.h>
#include <stdio.h>

#ifndef LWA_ALPHA
#define LWA_ALPHA 2
#endif

#ifndef WS_EX_LAYERD
#define WS_EX_LAYERED 0x00080000
#endif

#undef MessageBox
#define MessageBox(message) MessageBoxA(NULL, message, "Vim Library", 0)

#define PATH_BUFFER_LEN (1024* 10)
static char s_pathBuffer[PATH_BUFFER_LEN];

__declspec(dllexport) LONG openUrl(const char* url) {
    ShellExecute(NULL, "open", url, NULL, NULL, SW_SHOWNORMAL);
    return GetLastError();
}

__declspec(dllexport) LONG openFileLocationInExplore(const char* path) {
    char* cmd = "/select, ";
    int len = strlen(path) + strlen(cmd);
    if(len > PATH_BUFFER_LEN - 1) {
        MessageBox("File path is too long");
    } else {
        sprintf(s_pathBuffer, "%s%s", cmd, path);
        ShellExecute(NULL, "open", "explorer.exe", s_pathBuffer, NULL, SW_SHOWNORMAL);
    }
    return GetLastError();
}

__declspec(dllexport) LONG openFolderInExplore(const char* path) {
    ShellExecute(NULL, "explore", path, NULL, NULL, SW_SHOWNORMAL);
    return GetLastError();
}

BOOL CALLBACK findWindowProc(HWND hwnd, LPARAM lParam) {
    HWND* pphWnd = (HWND*)lParam;
    if (GetParent(hwnd)) {
        *pphWnd = NULL;
        return TRUE;
    }
    *pphWnd = hwnd;
    return FALSE;
}

LONG _declspec(dllexport) setAlpha(LONG nTrans) {
    HMODULE hDllUser32;

    hDllUser32 = LoadLibrary("user32");
    if (hDllUser32) {
        BOOL (WINAPI *pfnSetLayeredWindowAttributes)(HWND,DWORD,BYTE,DWORD);

        pfnSetLayeredWindowAttributes
            = (BOOL (WINAPI *)(HWND,DWORD,BYTE,DWORD))
            GetProcAddress(hDllUser32, "SetLayeredWindowAttributes");

        if (pfnSetLayeredWindowAttributes) {
            HWND hTop = NULL;
            DWORD dwThreadID;

            dwThreadID = GetCurrentThreadId();
            EnumThreadWindows(dwThreadID, findWindowProc, (LPARAM)&hTop);

            if (hTop) {
                if (nTrans == 255) {
                    SetWindowLong(hTop, GWL_EXSTYLE,
                            GetWindowLong(hTop, GWL_EXSTYLE) & ~WS_EX_LAYERED); 
                } else {
                    SetWindowLong(hTop, GWL_EXSTYLE,
                            GetWindowLong(hTop, GWL_EXSTYLE) | WS_EX_LAYERED); 
                    pfnSetLayeredWindowAttributes(
                            hTop, 0, (BYTE)nTrans, LWA_ALPHA);
                }
            }
        }
        FreeLibrary(hDllUser32);
    }
    return GetLastError();
}

