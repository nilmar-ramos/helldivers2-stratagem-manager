#Requires AutoHotkey >=2.0
SendMode "Event"
SetWorkingDir A_ScriptDir

macro(stratagem) {
	if (WinActive("HELLDIVERS™ 2")) {
		try {
			Run('"Helldivers 2 Macros.ahk" "' . stratagem . '"')
			/*
				You could add options to the end of the string.
				For example, you could set the delay between keys to 200 milliseconds:
				Run('"Helldivers 2 Macros.ahk" "' . stratagem . '" "delay=200"')
				Run "Helldivers 2 Macros.ahk" without any arguments to access the instruction manual.
			*/
		} catch {
			TrayTip("Could not run Helldivers 2 Macros script.")
		}
	}
}

Numpad0:: {
	macro("Reinforce")
}

Numpad1:: {
	macro("Resupply")
}

Numpad2:: {
	macro("Shield Generator Pack")
}

; Numpad4:: {
; 	macro("Commando")
; }

Numpad4:: {
	macro("Stalwart")
}

Numpad5:: {
	macro("Gatling Sentry")
}

Numpad6:: {
	macro("Rocket Sentry")
}

Numpad7:: {
	macro("Eagle 500kg Bomb")
}

Numpad8:: {
	macro("Eagle 110mm Rocket Pods")
}

