#Requires AutoHotkey v2
; =============================================================================
; Automatic Super Credit Farm - Version 2
;
; Modified by kian - Now supports Super Pickups on mod menu 2.10
;
; Instructions:
;   - Look at the ground and move around to normalize your camera angle.
;   - F1 toggles the script on/off.
;   - F12 closes the script.
;
;   - For virtual key and scan code details, see: https://www.autohotkey.com/docs/KeyList.htm
; =============================================================================

; ---------------------------
; Global Variables
; ---------------------------
global active := false
global menuKey := ""
global menuKeyMode := ""
global inputType := ""
global cycleRunning := false

; ---------------------------
; User-Editable Settings
; ---------------------------
inputSequence := ["Down", "Left", "Down", "Up", "Right"]   ; Default directional sequence (Regular Machine Gun)
targetPickupInterval := 50000                              ; 50 seconds
numGems := 1                                              ; Number of stratagems to call in before starting pickup loop
numPickupsBeforeCooldown := 13                            ; Self-explanatory, shouldnt need to change this
numCyclesPerGem := 3                                       ; Number of pickup cycles to perform per called stratagem; set to 3 because: 40 SC drops per strategem / 13 pickups per cooldown ~= 3

; ---------------------------
; Timing Variables (ms)
; ---------------------------
gemDelay := 200                    ; Wait after pressing menu key for stratagem menu to open
keystrokeDelay := 25                     ; Delay for each key press in the sequence
preClickDelay := 100                    ; Delay after the directional keys are sent and before clicking
postClickDelay := 1200                   ; Delay after clicking (configurable)
walkDuration := 515                    ; Duration to hold movement keys (for both forward and backward phases)
pickupTimer := 650                    ; Delay between each E press during pickup phase

; ---------------------------
; Low-Level Key Simulation Functions
; ---------------------------
simulateKeyDown(vk, sc) {
  DllCall("keybd_event", "Int", vk, "Int", sc, "Int", 0, "Int", 0)
}
simulateKeyUp(vk, sc) {
  DllCall("keybd_event", "Int", vk, "Int", sc, "Int", 2, "Int", 0)
}
simulateKey(vk, sc, delay := keystrokeDelay) {
  simulateKeyDown(vk, sc)
  Sleep delay
  simulateKeyUp(vk, sc)
}
simulateMenuKeyDown() {
  global menuKey
  if (menuKey = "Tab") {
    DllCall("keybd_event", "Int", 0x09, "Int", 0x0F, "Int", 0, "Int", 0)
  } else if (menuKey = "LControl") {
    DllCall("keybd_event", "Int", 0xA2, "Int", 0x1D, "Int", 0, "Int", 0)
  }
}
simulateMenuKeyUp() {
  global menuKey
  if (menuKey = "Tab") {
    DllCall("keybd_event", "Int", 0x09, "Int", 0x0F, "Int", 2, "Int", 0)
  } else if (menuKey = "LControl") {
    DllCall("keybd_event", "Int", 0xA2, "Int", 0x1D, "Int", 2, "Int", 0)
  }
}
simulateClick() {
  DllCall("mouse_event", "UInt", 0x02, "Int", 0, "Int", 0, "UInt", 0, "Ptr", 0)
  Sleep 50
  DllCall("mouse_event", "UInt", 0x04, "Int", 0, "Int", 0, "UInt", 0, "Ptr", 0)
}

; ---------------------------
; GUI Setup for On-Screen Status Display
; ---------------------------
global guiStatus := Gui("AlwaysOnTop -Caption +ToolWindow")
guiStatus.Font := "s24 Bold"
guiStatus.Transparency := 200
guiStatus.BackColor := "EEEEEE"
guiStatus.MarginX := 20
guiStatus.MarginY := 20
guiStatus.Add("Text", "vTopInstructions cBlue", "F1: Toggle Script On/Off   F12: Close Script")
guiStatus.Add("Text", "vStatusText Center xm ym+30 cBlack", "Script Disabled")
guiStatus.Add("Text", "vBottomNote Center xm ym+60 cGray", "Before activating, look straight down and strafe to reset camera angle.")
guiStatus.Title := "Stratagem Macro Status"
guiStatus.Show("w400 h150 Center y10")

; ---------------------------
; Process Check Timer: Exit if helldivers2.exe is not running
; ---------------------------
SetTimer(CheckGame, 1000)
CheckGame() {
  if (!ProcessExist("helldivers2.exe")) {
    guiStatus["StatusText"].Value := "Helldivers2 Closed – Exiting..."
    Sleep 500
    ExitApp()
  }
}

; ---------------------------
; Hotkeys
; ---------------------------
F1:: {
  global active, cycleRunning, guiStatus
  active := !active
  if (active) {
    guiStatus["StatusText"].Value := "Calling in Stratagem..."
    if (!cycleRunning) {
      cycleRunning := true
      SetTimer(cycle, -1)
    }
  } else {
    guiStatus["StatusText"].Value := "Script Disabled"
    cycleRunning := false
  }
}
F12:: ExitApp()

; ---------------------------
; Main Cycle Function
; ---------------------------
cycle() {
  global active, gemDelay, keystrokeDelay, preClickDelay, postClickDelay, walkDuration
  global pickupTimer, numGems, numPickupsBeforeCooldown, inputSequence, guiStatus
  global menuKey, menuKeyMode, inputType, cycleRunning, targetPickupInterval
  global numCyclesPerGem

  if (!active) {
    cycleRunning := false
    return
  }

  guiStatus["StatusText"].Value := "Calling in Strategem..."
  Loop numGems {
    if (!active) {
      cycleRunning := false
      return
    }
    if (menuKeyMode = "Hold") {
      simulateMenuKeyDown()
    } else {
      simulateKey(menuKey = "Tab" ? 0x09 : 0xA2, menuKey = "Tab" ? 0x0F : 0x1D)
    }
    Sleep gemDelay
    for index, dir in inputSequence {
      if (inputType = "WASD") {
        if (dir = "Up") {
          vk := 0x57, sc := 0x11  ; W
        } else if (dir = "Down") {
          vk := 0x53, sc := 0x1F  ; S
        } else if (dir = "Left") {
          vk := 0x41, sc := 0x1E  ; A
        } else if (dir = "Right") {
          vk := 0x44, sc := 0x20  ; D
        }
      } else {
        if (dir = "Up") {
          vk := 0x26, sc := 0x48  ; Up Arrow
        } else if (dir = "Down") {
          vk := 0x28, sc := 0x50  ; Down Arrow
        } else if (dir = "Left") {
          vk := 0x25, sc := 0x4B  ; Left Arrow
        } else if (dir = "Right") {
          vk := 0x27, sc := 0x4D  ; Right Arrow
        }
      }
      simulateKey(vk, sc, keystrokeDelay)
      Sleep 50
    }
    if (menuKeyMode = "Hold") {
      simulateMenuKeyUp()
    }
    Sleep preClickDelay
    simulateClick()
    Sleep postClickDelay
  }

  guiStatus["StatusText"].Value := "Walking Forward..."
  simulateKeyDown(0x57, 0x11)  ; W down (walk forward)
  Sleep walkDuration
  simulateKeyUp(0x57, 0x11)    ; Release W

  Sleep 250

  ; ---- Repeated Pickup Cycles ----
  guiStatus["StatusText"].Value := "Picking Up..."
  Loop numGems {
    Loop numCyclesPerGem {
      cycleIndex := A_Index
      Loop numPickupsBeforeCooldown {
        if (!active) {
          cycleRunning := false
          return
        }
        simulateKey(0x45, 0x12, pickupTimer)  ; E key press
        Sleep pickupTimer
      }
      if (cycleIndex < numCyclesPerGem) {
        ; Wait between pickup cycles before repeating the pickup phase
        guiStatus["StatusText"].Value := "Waiting..."
        Sleep targetPickupInterval
      }
      else {
        simulateKey(0x45, 0x12, pickupTimer)	; One more E press to clear the pile
      }
    }
  }

  guiStatus["StatusText"].Value := "Walking Backward..."
  simulateKeyDown(0x53, 0x1F)  ; S down (walk backward)
  Sleep walkDuration
  simulateKeyUp(0x53, 0x1F)    ; Release S

  Sleep targetPickupInterval

  if (active) {
    SetTimer(cycle, -1)
  } else {
    cycleRunning := false
  }
}

; ---------------------------
; Configuration GUI
; ---------------------------
configGui := Gui()
configGui.Title := "Stratagem Macro Configuration"
configGui.Add("Text", , "Stratagem Menu Key:")
menuKeyRadio := configGui.Add("Radio", "vMenuKeyTab Group", "Tab")
configGui.Add("Radio", "vMenuKeyLControl", "Left Control")
configGui.Add("Text", , "Menu Key Mode:")
menuKeyModeRadio := configGui.Add("Radio", "vMenuKeyModeHold Group", "Hold")
configGui.Add("Radio", "vMenuKeyModeToggle", "Toggle")
configGui.Add("Text", , "Stratagem Directional Keys:")
inputTypeRadio := configGui.Add("Radio", "vInputTypeWASD Group", "WASD")
configGui.Add("Radio", "vInputTypeArrows", "Arrows")
configGui.Add("Button", "Default w80", "OK").OnEvent("Click", SaveConfig)
configGui.Show()

SaveConfig(*) {
  global menuKey, menuKeyMode, inputType
  menuKey := menuKeyRadio.Value ? "Tab" : "LControl"
  menuKeyMode := menuKeyModeRadio.Value ? "Hold" : "Toggle"
  inputType := inputTypeRadio.Value ? "WASD" : "Arrows"
  configGui.Destroy()  ; Close the configuration GUI after saving
}