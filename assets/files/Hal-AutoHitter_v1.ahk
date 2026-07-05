; ==============================================
; Hal-AutoHitter - AutoHotkey v1
; Auto key/Mouse presser with INI preset support
; ==============================================
#SingleInstance Force
#Persistent
#NoEnv
FileEncoding UTF-8
SetBatchLines, -1
SendMode Input
CoordMode, Mouse, Screen

; ---------- Globals ----------
global PresetsDir := A_ScriptDir . "\Presets"
global IsRunning  := false
global CurrentHotkey := ""

IfNotExist, %PresetsDir%
    FileCreateDir, %PresetsDir%

; ---------- Build GUI ----------
Gui, +AlwaysOnTop
Gui, -Theme
Gui, Font, s11 Norm, Consolas

; --- Left panel ---
Gui Font, s30 Bold
Gui, Add, Button, x5 y10 w130 h70 vBtnOnOff gToggleOnOff, OFF
Gui, Font, s11 Norm, Consolas

Gui, Add, GroupBox, x5 y85 w130 h186, Control
Gui, Add, Text, x10 y108 w120, Mode:
Gui, Add, Radio, x10 y128 w90 h20 vRadioMouse gModeChanged Checked, Mouse
Gui, Add, Radio, x10 y148 w90 h20 vRadioKey gModeChanged, Key

Gui, Add, Text, x10 y170 w120, HIT!:
Gui, Add, Button, x93 y170 w35 h18 gOpenDoc, ?🌐
Gui, Add, Edit, x10 y190 w120 vEditHit, Right

Gui, Add, Text, x10 y220 w120, Interval(ms):
Gui, Add, Edit, x10 y240 w120 vEditInterval Number, 500

; --- Right panel: Presets ---

Gui, Add, GroupBox, x140 y0 w145 h175, Preset
Gui, Add, ListBox, x145 y22 w110 h148 vListPresets
Gui, Add, Button, x257 y22 w22 h22 gOpenFolder, 📂
Gui, Add, Button, x257 y46 w22 h22 gReloadPresets, 🔃
Gui, Add, Button, x257 y70 w22 h22 gSavePreset, 💾
Gui, Add, Button, x257 y147 w22 h22 gLoadPreset, ✔


; --- Right panel: Settings ---
; Gui Add, Text, x140 y170 w142 h2 +0x10

Gui, Add, GroupBox, x140 y175 w145 h96, Setting
Gui, Add, Text, x145 y198 w135, ON/OFF key:
Gui, Add, Hotkey, x145 y218 w135 vHotkeyControl gHotkeyChanged, F8
Gui, Add, Checkbox, x145 y248 w135 vCheckAlwaysOnTop gAlwaysOnTopChanged Checked, Always on top

; --- Bottom bar: native Windows status bar ---
Gui, Add, StatusBar
SB_SetParts(110)
SB_SetText("v1", 1)
SB_SetText("[Tip]: Get Lucky", 2)

Gui, Show, w290 h300, Hal-AutoHitter

; ---------- Init ----------
GoSub, ReloadPresets
GoSub, RegisterHotkey_Init
return


; ==============================================
; Open Doc
; ==============================================
OpenDoc:
    Run, https://www.autohotkey.com/docs/v1/KeyList.htm
return

; ==============================================
; ON/OFF toggle
; ==============================================
ToggleOnOff:
    IsRunning := !IsRunning
    if (IsRunning)
    {
        Gui, Submit, NoHide
        GuiControl,, BtnOnOff, ON
        interval := EditInterval + 0
        if (interval < 1)
            interval := 50
        SetTimer, DoHit, %interval%
    }
    else
    {
        GuiControl,, BtnOnOff, OFF
        SetTimer, DoHit, Off
    }
return

; ==============================================
; The repeated action
; ==============================================
DoHit:
    Gui, Submit, NoHide
    if (RadioMouse)
    {
        btn := EditHit
        if (btn = "")
            btn := "Left"
        Click, %btn%
    }
    else
    {
        Key := EditHit
        if (Key = "")
            return
        Send, %Key%
    }
return

; ==============================================
; Mode radio changed (just cosmetic hook)
; ==============================================
ModeChanged:
return

; ==============================================
; Always on top toggle
; ==============================================
AlwaysOnTopChanged:
    Gui, Submit, NoHide
    if (CheckAlwaysOnTop)
        Gui, +AlwaysOnTop
    else
        Gui, -AlwaysOnTop
return

; ==============================================
; Hotkey (ON/OFF key) changed -> re-register
; ==============================================
HotkeyChanged:
    Gui, Submit, NoHide
    NewKey := HotkeyControl
    if (NewKey = "")
        return
    if (CurrentHotkey != "")
    {
        try
            Hotkey, %CurrentHotkey%, Off
    }
    CurrentHotkey := NewKey
    Hotkey, %CurrentHotkey%, ToggleOnOff, On
return

RegisterHotkey_Init:
    Gui, Submit, NoHide
    NewKey := HotkeyControl
    if (NewKey = "")
        NewKey := "F1"
    CurrentHotkey := NewKey
    Hotkey, %CurrentHotkey%, ToggleOnOff, On
return

; ==============================================
; Presets: Reload list from Presets folder (*.ini)
; ==============================================
ReloadPresets:
    presetList := ""
    Loop, Files, %PresetsDir%\*.ini
    {
        SplitPath, A_LoopFileName, , , , nameNoExt
        presetList .= nameNoExt . "|"
    }
    GuiControl,, ListPresets, |%presetList%
return

; ==============================================
; Presets: Open the Presets folder in Explorer
; ==============================================
OpenFolder:
    Run, %PresetsDir%
return

; ==============================================
; Presets: Load selected preset into the fields
; ==============================================
LoadPreset:
    Gui, Submit, NoHide
    Gui, -Theme
    if (ListPresets = "")
    {
        MsgBox, 48, Hal-AutoHitter, Select a preset from the list first.
        return
    }
    iniFile := PresetsDir . "\" . ListPresets . ".ini"
    IfNotExist, %iniFile%
    {
        MsgBox, 16, Hal-AutoHitter, Preset file not found:`n%iniFile%
        return
    }

    IniRead, pMode, %iniFile%, Preset, Mode, Key
    IniRead, pKey, %iniFile%, Preset, Key, a
    IniRead, pInterval, %iniFile%, Preset, Interval, 50
    IniRead, pHotkey, %iniFile%, Preset, Hotkey, %HotkeyControl%

    if (pMode = "Mouse")
        GuiControl,, RadioMouse, 1
    else
        GuiControl,, RadioKey, 1

    GuiControl,, EditHit, %pKey%
    GuiControl,, EditInterval, %pInterval%

    if (pHotkey != "" and pHotkey != CurrentHotkey)
    {
        GuiControl,, HotkeyControl, %pHotkey%
        if (CurrentHotkey != "")
        {
            try
                Hotkey, %CurrentHotkey%, Off
        }
        CurrentHotkey := pHotkey
        Hotkey, %CurrentHotkey%, ToggleOnOff, On
    }
return

; ==============================================
; Right-click a preset in the list -> Save current
; settings as a new/overwritten preset (.ini)
; ==============================================
SavePreset:
    Gui, Submit, NoHide
    Gui, -Theme
    Gui, +OwnDialogs
    InputBox, presetName, Save Preset, Enter a name for this preset:, , 200, 130
    if ErrorLevel
        return
    if (presetName = "")
        return

    mode := RadioMouse ? "Mouse" : "Key"
    iniFile := PresetsDir . "\" . presetName . ".ini"

    IniWrite, %mode%, %iniFile%, Preset, Mode
    IniWrite, %EditHit%, %iniFile%, Preset, Key
    IniWrite, %EditInterval%, %iniFile%, Preset, Interval
    IniWrite, %HotkeyControl%, %iniFile%, Preset, Hotkey

    GoSub, ReloadPresets
return

; ==============================================
; Close / Exit
; ==============================================
GuiClose:
GuiEscape:
ExitApp
