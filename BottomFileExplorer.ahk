#Requires AutoHotkey v2.0
; https://github.com/replete/productivity-ahk
; BottomFileExplorer.ahk v0.5

; Bind the hotkey ALT+\
!\::BottomFileExplorer()

BottomFileExplorer() {
    exeName := "explorer.exe"
    
    ; Check if File Explorer is running
    if !ProcessExist(exeName) {
        ; If not running, start it
        Run "explorer.exe"
        return
    }
    
    ; Get the window ID of File Explorer
    explorerWin := WinExist("ahk_class CabinetWClass")
    
    if !explorerWin {
        ; If no File Explorer window is found, open a new one
        Run "explorer.exe"
        WinWait("ahk_class CabinetWClass")
        explorerWin := WinExist("ahk_class CabinetWClass")
    }
    
    if WinGetMinMax("ahk_id " explorerWin) == -1 {
        ; If minimized, restore and resize
        WinRestore("ahk_id " explorerWin)
        ResizeAndDockWindow(explorerWin)
    } else if WinActive("ahk_id " explorerWin) {
        ; If it's the active window, minimize it
        WinMinimize("ahk_id " explorerWin)
    } else {
        ; If it's not the active window, activate and resize it
        WinActivate("ahk_id " explorerWin)
        ResizeAndDockWindow(explorerWin)
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