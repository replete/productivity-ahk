#Requires AutoHotkey v2.0
; LeftBrowser.ahk v0.5
; https://github.com/replete/productivity-ahk

; Toggle with SUPER+\ or mouse-touch left screen edge

browser_exe := "vivaldi.exe" ; or any other browser dedicated to the side browser
is_visible := false
edge_timer := 0
edge_detection := false

; Function to toggle Side Browser visibility
ToggleLeftBrowser() {
    global is_visible, browser_exe
    
    browser_win := WinExist("ahk_exe " browser_exe)
    if not browser_win {
        Run browser_exe
        WinWait("ahk_exe " browser_exe)
        browser_win := WinExist("ahk_exe " browser_exe)
    }
    
    if (is_visible) {
        WinMinimize browser_win
        is_visible := false
    } else {
        if WinExist("ahk_id " browser_win " ahk_minimized") {
            WinRestore browser_win
        } else {
            WinShow browser_win
        }
        ResizeAndPositionLeftBrowser(browser_win)
        WinActivate browser_win
        is_visible := true
    }
}

; Function to resize and position Side Browser
ResizeAndPositionLeftBrowser(win_id) {
    MonitorGetWorkArea(, &left, &top, &right, &bottom)
    screen_height := bottom - top
    
    WinMove(0, 0, , screen_height, win_id)
}

; Hotkey to toggle Side Browser
#\::{  ; Windows key + \
    ToggleLeftBrowser()
}

; Timer to check if mouse is at the left edge
SetTimer(CheckMousePosition, 10)  ; Increased check frequency

CheckMousePosition() {
    global edge_timer, edge_detection
    
    CoordMode "Mouse", "Screen"  ; Ensure we're using screen coordinates
    MouseGetPos(&x, &y)
    
    if (x <= 1) {  ; Allow a small margin for error
        if not edge_detection {
            edge_timer := A_TickCount
            edge_detection := true
        } else if (A_TickCount - edge_timer >= 300) {
            ToggleLeftBrowser()
            edge_detection := false
            edge_timer := 0
            SetTimer(CheckMousePosition, 400)  ; Temporary slow down to prevent rapid toggling
            SetTimer(() => SetTimer(CheckMousePosition, 10), -500)  ; Reset to fast checks after 1.5 seconds
        }
    } else {
        edge_detection := false
        edge_timer := 0
    }
}