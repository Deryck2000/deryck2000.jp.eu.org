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

MouseMove, 39, 503, 3 ; move to aura button
sleep 100
MouseClick, Left ; click aura button
sleep 100
MouseMove, 1272, 323, 3 ; move regular button
sleep 100
MouseClick, Left ; click regular button
sleep 100
MouseMove, 1083, 353, 3 ; move search button
sleep 100
MouseClick, Left ; click search button
sleep 50

;equip aura
Clipboard := "Merchant Teleporter" ; put aura name here
sleep 100
Send, ^v
sleep 100 ; search

MouseMove, 851, 469, 3
sleep 100
MouseClick, Left ;select aura

MouseMove, 682, 567, 3
sleep 100
MouseClick, Left
sleep 100
MouseClick, Left
sleep 100

; close aura storage
MouseMove, 1414, 285, 3 ; move close button
sleep 100
MouseClick, Left ; click close button
sleep 100

BlockInput, Off
ExitApp
