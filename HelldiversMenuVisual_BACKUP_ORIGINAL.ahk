#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

; Arquivos de configuração
bindingsFile := A_ScriptDir "\bindings.ini"
configFile := A_ScriptDir "\stratagems.ini"

CheckCreateFiles()

global stratagems := ReadStratagems()
global bindings := Map()
global waitingForKey := false
global selectedStrat := ""
global MyGui := ""
global bindingsPaused := false

PauseAllBinds(pause := true) {
    global bindings
    for key, strat in bindings {
        try Hotkey(key, , pause ? "Off" : "On")
    }
}

; ======= FUNÇÃO PARA VERIFICAR E CRIAR ARQUIVOS =======
CheckCreateFiles() {
    global configFile, bindingsFile

    if !FileExist(configFile) {
        FileAppend("[Stratagems]`n", configFile)
        FileAppend("1=Reinforce`n", configFile)
        FileAppend("2=Resupply`n", configFile)
        FileAppend("3=Shield Generator Pack`n", configFile)
        FileAppend("4=Stalwart`n", configFile)
        FileAppend("5=Gatling Sentry`n", configFile)
        FileAppend("6=Rocket Sentry`n", configFile)
        FileAppend("7=Eagle 500kg Bomb`n", configFile)
        FileAppend("8=Eagle 110mm Rocket Pods`n", configFile)
        FileAppend("9=Orbital Precision Strike`n", configFile)
        FileAppend("10=Orbital Laser Strike`n", configFile)
        FileAppend("11=SOS Beacon`n", configFile)
        FileAppend("12=Anti-Tank Mines`n", configFile)
        MsgBox("Arquivo de estratégias criado: " configFile)
    }

    if !FileExist(bindingsFile) {
        FileAppend("[Bindings]`n", bindingsFile)
        FileAppend("[Keys]`n", bindingsFile)
        MsgBox("Arquivo de bindings criado: " bindingsFile)
    }
}

; ======= FUNÇÃO PARA LER ESTRATÉGIAS DO ARQUIVO =======
ReadStratagems() {
    global configFile
    list := []

    IniSection := "Stratagems"
    index := 1

    Loop {
        strat := IniRead(configFile, IniSection, index, "")
        if (strat = "")
            break
        list.Push(strat)
        index++
    }

    return list
}

; ======= FUNÇÃO PARA CARREGAR BINDINGS =======
LoadBindings() {
    global bindingsFile, bindings

    IniSection := "Bindings"
    index := 1

    Loop {
        strat := IniRead(bindingsFile, IniSection, index, "")
        if (strat = "")
            break

        key := IniRead(bindingsFile, "Keys", strat, "")

        if (key != "") {
            bindings[key] := strat
            HotKeyHandler(key, strat)
        }

        index++
    }
}

HotKeyHandler(key, strat) {
    if KeyIsValid(key) {
        try {
            Hotkey(key, (*) => ExecuteMacro(strat), "On")
        }
    }
}

WaitForKey() {
    ih := InputHook("L1")
    ih.KeyOpt("{All}", "E")
    ih.Start()
    ih.Wait()
    MsgBox("Tecla capturada: " ih.EndKey)
    return ih.EndKey
}

KeyIsValid(key) {
    validKeys := [
        "Numpad0", "Numpad1", "Numpad2", "Numpad3", "Numpad4",
        "Numpad5", "Numpad6", "Numpad7", "Numpad8", "Numpad9",
        "NumpadDot", "NumpadDiv", "NumpadMult", "NumpadAdd", "NumpadSub", "NumpadEnter"
    ]
    return HasValue(validKeys, key)
}

HasValue(haystack, needle) {
    for index, value in haystack {
        if (value = needle)
            return true
    }
    return false
}

SaveBinding(strat, key) {
    global bindings, bindingsFile

    if (bindings.Has(key)) {
        oldStrat := bindings[key]
        IniDelete(bindingsFile, "Keys", oldStrat)
        HotkeyRemove(key)
    }

    for k, s in bindings.Clone() {
        if (s = strat) {
            bindings.Delete(k)
            HotkeyRemove(k)
            break
        }
    }

    index := 1
    Loop {
        s := IniRead(bindingsFile, "Bindings", index, "")
        if (s = "" || s = strat)
            break
        index++
    }

    IniWrite(strat, bindingsFile, "Bindings", index)
    IniWrite(key, bindingsFile, "Keys", strat)

    bindings[key] := strat
    HotKeyHandler(key, strat)

    TrayTip("Binding salvo", strat " -> " key)
}

HotkeyRemove(key) {
    if KeyIsValid(key) {
        try {
            Hotkey(key, "Off")
        }
    }
}

ExecuteMacro(stratagem) {
    ProcessName := "helldivers2.exe"
    hwndList := WinGetList("ahk_exe " ProcessName)

    if (hwndList.Length > 0) {
        hwnd := hwndList[1]
        WinActivate("ahk_id " hwnd)
        Sleep(300)
    } else {
        ; Se o processo não está visível, verifica se existe mesmo assim
        if !ProcessExist(ProcessName) {
            TrayTip("Aviso", "HELLDIVERS 2 não está ativo.", 1500)
            return
        }
    }

    try {
        Run('"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" "Helldivers 2 Macros.ahk" "' stratagem '"')
    } catch {
        TrayTip("Erro", "Não foi possível executar o script de macros.", 1500)
    }
}

ClearAllBindings() {
    global bindings, bindingsFile

    for key, strat in bindings {
        HotkeyRemove(key)
    }

    bindings := Map()

    try {
        FileDelete(bindingsFile)
    }
    FileAppend("[Bindings]`n", bindingsFile)
    FileAppend("[Keys]`n", bindingsFile)

    TrayTip("Bindings limpos", "Todos os bindings foram removidos.", 1500)
    ShowGui()
}

ShowGui() {
    global MyGui, stratagems, bindings

    if IsSet(MyGui) && MyGui {
        try {
            MyGui.Destroy()
        }
    }

    if (stratagems.Length = 0) {
        MsgBox("Nenhuma estratégia encontrada! Verifique o arquivo " configFile)
        return
    }

    MyGui := Gui()
    MyGui.Title := "Helldivers 2 - Mapeador de Estratégias"
    MyGui.SetFont("s10", "Segoe UI")

    MyGui.AddText("w400", "Selecione uma estratégia e pressione a tecla que deseja associar:")

    ; Botão para abrir a janela das configurações atuais
    btnShowBindings := MyGui.AddButton("y+10 w200", "Mostrar Configurações Atuais")
    btnShowBindings.OnEvent("Click", (*) => ShowBindingsWindow())

    stratList := MyGui.AddListBox("y+10 w400 r15 vStratList", stratagems)
    btnBind := MyGui.AddButton("y+10 w410", "Associar Tecla")
    btnBind.OnEvent("Click", HandleClick)

    HandleClick(*) {
        strat := stratList.Text
        if (strat) {
            SelectStratagem(strat)
        } else {
            MsgBox("Selecione uma estratégia primeiro!")
        }
    }

    btnClear := MyGui.AddButton("y+10 w200", "Limpar Todos Bindings")
    btnClear.OnEvent("Click", (*) => ClearAllBindings())
    btnReload := MyGui.AddButton("x+10 w200", "Recarregar Configurações")
    btnReload.OnEvent("Click", (*) => ReloadConfig())
    MyGui.Show("w435 h460")
}

ShowBindingsWindow() {
    global bindings, bindingsPaused, BindGui

    if (bindings.Count = 0) {
        MsgBox("Nenhuma configuração atual para mostrar.")
        return
    }

    BindGui := Gui()
    BindGui.Title := "Configurações Atuais"
    BindGui.SetFont("s14", "Consolas") ; Fonte maior e monoespaçada

    bindText := "Configurações Atuais:`n`n"
    for key, strat in bindings {
        bindText .= strat ": " key "`n"
    }

    BindGui.AddText("w450 h450 vBindText", bindText)

    ; Botão de Pausar/Retomar
    pauseBtnText := bindingsPaused ? "Retomar Binds" : "Pausar Binds"
    pauseBtn := BindGui.AddButton("y+10 w215 vPauseBtn", pauseBtnText)
    pauseBtn.OnEvent("Click", (*) => TogglePauseBinds(BindGui))

    ; Botão de Fechar
    BindGui.AddButton("x+10 yp w210", "Fechar").OnEvent("Click", (*) => BindGui.Destroy())
    BindGui.Show("w470 h520")
}

TogglePauseBinds(guiRef) {
    global bindingsPaused
    bindingsPaused := !bindingsPaused
    PauseAllBinds(bindingsPaused)
    btn := guiRef["PauseBtn"]
    btn.Text := bindingsPaused ? "Retomar Binds" : "Pausar Binds"
    TrayTip("Binds", bindingsPaused ? "Todas as binds foram PAUSADAS." : "Todas as binds foram RETOMADAS.", 1500)
}

SelectStratagem(strat) {
    global waitingForKey, selectedStrat, MyGui

    if (!strat)
        return

    waitingForKey := true
    selectedStrat := strat

    TrayTip("Aguardando tecla", "Pressione uma tecla para: " strat, 150)

    if IsSet(MyGui) && MyGui
        MyGui.Hide()

    key := WaitForKey()
    if (key = "Escape") {
        waitingForKey := false
        selectedStrat := ""
        TrayTip("Cancelado", "Associação cancelada.", 1500)
        if IsSet(MyGui) && MyGui
            MyGui.Show()
        return
    }
    if !KeyIsValid(key) {
        TrayTip("Tecla inválida", "Apenas teclas do Numpad são aceitas.", 1500)
        waitingForKey := false
        selectedStrat := ""
        if IsSet(MyGui) && MyGui
            MyGui.Show()
        return
    }
    SaveBinding(selectedStrat, key)
    waitingForKey := false
    selectedStrat := ""
    ShowGui()
}

ReloadConfig() {
    global stratagems, bindings

    for key, strat in bindings {
        HotkeyRemove(key)
    }

    stratagems := ReadStratagems()
    bindings := Map()
    LoadBindings()

    ShowGui()

    TrayTip("Configurações recarregadas", "Estratégias e bindings foram atualizados.", 1500)
}

; ======= HOTKEYS =======

F6:: ShowGui()
F7:: ShowBindingsWindow()
F8:: TogglePauseBinds(BindGui)
F12:: ExitApp

if (stratagems.Length = 0) {
    MsgBox("Nenhuma estratégia encontrada! Verifique o arquivo " configFile)
    ExitApp
}

LoadBindings()
ShowGui()

TrayTip("Script iniciado", "Pressione F1 para abrir o mapeador de estratégias.", 1500)