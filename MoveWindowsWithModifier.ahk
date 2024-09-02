#Requires AutoHotkey v2.0
; MoveWindowsWithModifier.ahk v0.2
; https://github.com/replete/productivity-ahk
; This is buggy and isn't usable yet

; Global variables
global initialMouseOffset := {x: 0, y: 0}
global activeWindow := 0

; Ctrl hotkey
~Ctrl::
{
    ; Capture initial state
    MouseGetPos(&mouseX, &mouseY, &windowUnderMouse)
    if (windowUnderMouse)
    {
        activeWindow := windowUnderMouse
        WinGetPos(&winX, &winY,,, "ahk_id " activeWindow)
        initialMouseOffset.x := mouseX - winX
        initialMouseOffset.y := mouseY - winY

        ; Set up the movement loop
        SetTimer(MoveWindow, 10)
    }
}

; Release Ctrl
~Ctrl Up::
{
    SetTimer(MoveWindow, 0)  ; Stop the timer
    activeWindow := 0
}

MoveWindow()
{
    if (activeWindow)
    {
        MouseGetPos(&currentMouseX, &currentMouseY)
        newWinX := currentMouseX - initialMouseOffset.x
        newWinY := currentMouseY - initialMouseOffset.y
        WinMove(newWinX, newWinY,,, "ahk_id " activeWindow)
    }
}