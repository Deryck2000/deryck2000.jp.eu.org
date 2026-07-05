;#Requires AutoHotkey v1.1
#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

; roblox window
SetTitleMatchMode,2
WinActivate, Roblox
WinMaximize, Roblox

BlockInput, On
sleep 100
MouseMove, 1232, 57, 3 ; active
sleep 100
MouseMove, 12, 375, 3 ; move to aura button
sleep 100
MouseClick, Left ; click aura button
sleep 100
MouseMove, 947, 327, 3 ; move regular button
sleep 100
MouseClick, Left ; click regular button
sleep 100
MouseMove, 1083, 353, 3 ; move search button
sleep 100
MouseClick, Left ; click search button
sleep 50

;equip aura
Clipboard := "Velocity" ; put aura name here
sleep 100
Send, ^v
sleep 100 ; search
MouseMove, 823, 421, 3
sleep 100

Loop, 200{
    MouseClick, WheelUp
}
sleep 250
MouseMove, 823, 422, 3
sleep 100

MouseClick, Left ;select aura
MouseMove, 659, 621, 3
sleep 100
MouseClick, Left ; click equip aura button
sleep 100

; close aura storage
MouseMove, 1414, 285, 3 ; move close button
sleep 100
MouseClick, Left ; click close button
sleep 100

BlockInput, Off
ExitApp
