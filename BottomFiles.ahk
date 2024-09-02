#Requires AutoHotkey v2.0
; BottomFiles.ahk v0.5
; https://github.com/replete/productivity-ahk
; Show files.exe (https://files.community) on ALT+\

; Bind the hotkey ALT+\
!\::ToggleBottomFileBrowser()

ToggleBottomFileBrowser() {
    exeName := "files.exe"
    
    ; Check if files.exe is running
    if !ProcessExist(exeName) {
        ; If not running, start it
        Run exeName
        return
    }
    
    ; Get the window ID of files.exe
    filesWin := WinExist("ahk_exe " exeName)
    
    if !filesWin {
        ; Window not found, exit the function
        return
    }
    
    if WinGetMinMax("ahk_id " filesWin) == -1 {
        ; If minimized, restore and resize
        WinRestore("ahk_id " filesWin)
        ResizeAndDockWindow(filesWin)
    } else {
        ; If not minimized, minimize
        WinMinimize("ahk_id " filesWin)
    }
}

ResizeAndDockWindow(winId) {
    ; Get screen dimensions
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight
    
    ; Check if taskbar is auto-hidden
    taskbarHeight := GetTaskbarHeight()
    
    ; Get current window position and size
    WinGetPos(&x, &y, &width, &height, "ahk_id " winId)
    
    ; Set new dimensions
    newWidth := screenWidth
    newHeight := height  ; Preserve the current height
    newX := 0
    newY := screenHeight - newHeight - taskbarHeight
    
    ; Move and resize the window
    WinMove(newX, newY, newWidth, newHeight, "ahk_id " winId)
}

GetTaskbarHeight() {
    taskbarHwnd := WinExist("ahk_class Shell_TrayWnd")
    if taskbarHwnd {
        WinGetPos(&x, &y, &w, &h, "ahk_id " taskbarHwnd)
        if WinGetStyle("ahk_id " taskbarHwnd) & 0x80000000 {  ; Check if taskbar is auto-hidden
            return 0
        } else {
            return h
        }
    }
    return 0  ; Return 0 if taskbar not found
}