#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

#Include HelldiversData.ahk

global stratagems := []
global bindings := Map()
global bindingsFile := A_ScriptDir "\bindings.ini"
global configFile := A_ScriptDir "\config.ini"
global stratagemsFile := A_ScriptDir "\stratagems.ini"
global MyGui := ""
global BindGui := ""
global selectedCategory := "Todas"
global searchText := ""
global waitingForKey := false
global selectedStrat := ""
global bindingsPaused := false
global darkMode := true

CheckCreateFiles() {
    global configFile, bindingsFile, stratagemsFile

    if !FileExist(configFile) {
        FileAppend(
            "[General]`n"
            . "DarkMode=1`n"
            . "MacroDelay=300`n"
            . "AutoActivateGame=1`n",
            configFile
        )
    }

    if !FileExist(bindingsFile) {
        FileAppend("[Bindings]`n[Keys]`n", bindingsFile)
    }

    if !FileExist(stratagemsFile) {
        CreateDefaultStratagemsFile()
    }
}

LoadConfig() {
    global configFile, darkMode
    darkMode := IniRead(configFile, "General", "DarkMode", "1") = "1"
}

SaveConfig() {
    global configFile, darkMode
    IniWrite(darkMode ? "1" : "0", configFile, "General", "DarkMode")
}

LoadStratagemsConfig() {
    global stratagemsFile, stratagems

    stratagems := []
    index := 1
    Loop {
        strat := IniRead(stratagemsFile, "Stratagems", index, "")
        if (strat = "")
            break
        if STRATAGEM_DATA.Has(strat)
            stratagems.Push(strat)
        index++
    }

    if (stratagems.Length = 0) {
        for name in STRATAGEM_DATA
            stratagems.Push(name)
        SaveStratagemsConfig()
    }
}

SaveStratagemsConfig() {
    global stratagemsFile, stratagems

    try FileDelete(stratagemsFile)
    FileAppend("[Stratagems]`n", stratagemsFile)
    for i, strat in stratagems
        IniWrite(strat, stratagemsFile, "Stratagems", i)
}

LoadBindings() {
    global bindingsFile, bindings

    bindings := Map()
    index := 1
    Loop {
        strat := IniRead(bindingsFile, "Bindings", index, "")
        if (strat = "")
            break

        key := IniRead(bindingsFile, "Keys", strat, "")
        if (key != "") {
            bindings[key] := strat
            RegisterHotkey(key, strat)
        }
        index++
    }
}

SaveBinding(strat, key) {
    global bindings, bindingsFile

    if bindings.Has(key) {
        IniDelete(bindingsFile, "Keys", bindings[key])
        UnregisterHotkey(key)
    }

    for k, s in bindings.Clone() {
        if (s = strat) {
            bindings.Delete(k)
            UnregisterHotkey(k)
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
    RegisterHotkey(key, strat)

    ShowTrayTip("Binding salvo", strat " -> " key)
    RefreshMainGui()
}

UnregisterHotkey(key) {
    if KeyIsValid(key) {
        try Hotkey(key, "Off")
    }
}

RegisterHotkey(key, strat) {
    if KeyIsValid(key) {
        try Hotkey(key, (*) => ExecuteStratagem(strat), "On")
    }
}

KeyIsValid(key) {
    static validKeys := [
        "Numpad0", "Numpad1", "Numpad2", "Numpad3", "Numpad4",
        "Numpad5", "Numpad6", "Numpad7", "Numpad8", "Numpad9",
        "NumpadDot", "NumpadDiv", "NumpadMult", "NumpadAdd", "NumpadSub", "NumpadEnter"
    ]
    for _, valid in validKeys {
        if (valid = key)
            return true
    }
    return false
}

WaitForKey() {
    ih := InputHook("L1")
    ih.KeyOpt("{All}", "E")
    ih.Start()
    ih.Wait()
    return ih.EndKey
}

ExecuteStratagem(stratagem) {
    global configFile

    delay := Integer(IniRead(configFile, "General", "MacroDelay", "300"))
    autoActivate := IniRead(configFile, "General", "AutoActivateGame", "1") = "1"

    if (autoActivate) {
        hwndList := WinGetList("ahk_exe helldivers2.exe")
        if (hwndList.Length > 0) {
            WinActivate("ahk_id " hwndList[1])
            Sleep(delay)
        } else if !ProcessExist("helldivers2.exe") {
            ShowTrayTip("Aviso", "HELLDIVERS 2 não está ativo.", 1500)
            return
        }
    }

    if STRATAGEM_DATA.Has(stratagem) {
        SendStratagemCode(STRATAGEM_DATA[stratagem]["Code"], delay)
    } else {
        try {
            Run('"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" "Helldivers 2 Macros.ahk" "' stratagem '"')
        } catch {
            ShowTrayTip("Erro", "Não foi possível executar o script de macros.", 1500)
        }
    }
}

SendStratagemCode(codeStr, delay) {
    for _, key in StrSplit(codeStr, ", ") {
        vk := GetVK(Trim(key))
        if (vk) {
            Send("{Blind}{" vk " Down}")
            Sleep(50)
            Send("{Blind}{" vk " Up}")
            Sleep(50)
        }
    }
    Sleep(delay)
    Send("{Enter}")
}

GetVK(dir) {
    static map := Map(
        "Cima", "Up", "Baixo", "Down", "Esquerda", "Left", "Direita", "Right",
        "Up", "Up", "Down", "Down", "Left", "Left", "Right", "Right"
    )
    return map.Has(dir) ? map[dir] : ""
}

ShowTrayTip(title, text, timeout := 1500) {
    TrayTip(title, text, timeout)
}

ClearAllBindings(*) {
    global bindings, bindingsFile

    for key in bindings
        UnregisterHotkey(key)

    bindings := Map()
    try FileDelete(bindingsFile)
    FileAppend("[Bindings]`n[Keys]`n", bindingsFile)

    ShowTrayTip("Bindings limpos", "Todos os bindings foram removidos.", 1500)
    ShowMainGui()
}

PauseAllBinds(pause := true) {
    global bindings
    for key in bindings {
        try Hotkey(key, , pause ? "Off" : "On")
    }
}

GetSelectedStrat(ctrl := "") {
    global MyGui
    if (!ctrl)
        ctrl := MyGui["StratList"]
    text := ctrl.Text
    if (text = "")
        return ""
    return RegExReplace(text, "\s+\[[^\]]+\]$", "")
}

ListBoxItemAtPoint(ctrl, x, y) {
    pt := Buffer(8, 0)
    NumPut("Int", x, pt, 0)
    NumPut("Int", y, pt, 4)
    DllCall("ScreenToClient", "Ptr", ctrl.Hwnd, "Ptr", pt)
    clientX := NumGet(pt, 0, "Int")
    clientY := NumGet(pt, 4, "Int")
    result := DllCall("SendMessage", "Ptr", ctrl.Hwnd, "UInt", 0x1A9, "UInt", 0, "UInt", (clientY << 16) | (clientX & 0xFFFF), "UInt")
    index := result & 0xFFFF
    return (index != 0xFFFF) ? index + 1 : 0
}

ShowMainGui() {
    global MyGui, stratagems, darkMode

    if (stratagems.Length = 0) {
        MsgBox("Nenhuma estratégia encontrada! Verifique o arquivo " stratagemsFile)
        return
    }

    if IsSet(MyGui) && MyGui {
        try MyGui.Destroy()
    }

    MyGui := Gui()
    MyGui.Title := "Helldivers 2 - Gerenciador de Estratégias"
    MyGui.SetFont("s10", "Segoe UI")
    MyGui.BackColor := darkMode ? 0x1E1E1E : 0xFFFFFF
    MyGui.OnEvent("Close", (*) => ExitApp())

    CreateToolbar()
    CreateCategoryTabs()
    CreateSearchBox()
    CreateStratagemList()
    CreateStatusBar()

    MyGui.Show("w900 h650")
    RefreshStratagemList()
}

CreateToolbar() {
    global MyGui, darkMode, bindingsPaused

    MyGui.AddGroupBox("x10 y10 w880 h45", "Ações")
    y := 25

    MyGui.AddButton("x20 y" y " w140 h30", "Bindings Atuais")
        .OnEvent("Click", (*) => ShowBindingsWindow())

    MyGui.AddButton("x170 y" y " w140 h30 vPauseBtn",
        bindingsPaused ? "Retomar Binds" : "Pausar Binds")
        .OnEvent("Click", (*) => TogglePauseBinds())

    MyGui.AddButton("x320 y" y " w120 h30", darkMode ? "Modo Claro" : "Modo Escuro")
        .OnEvent("Click", (*) => ToggleDarkMode())

    MyGui.AddButton("x450 y" y " w120 h30", "Importar")
        .OnEvent("Click", (*) => ImportBindings())

    MyGui.AddButton("x580 y" y " w120 h30", "Exportar")
        .OnEvent("Click", (*) => ExportBindings())

    MyGui.AddButton("x710 y" y " w80 h30", "Limpar")
        .OnEvent("Click", (*) => ClearAllBindings())

    MyGui.AddButton("x800 y" y " w80 h30", "Recarregar")
        .OnEvent("Click", (*) => ReloadAll())
}

CreateCategoryTabs() {
    global MyGui, selectedCategory

    categories := ["Todas", "Suprimentos", "Missão", "Defensivas", "Ofensivas", "Hangar", "Ponte", "Engenharia", "Oficina"]
    x := 20
    for cat in categories {
        btn := MyGui.AddButton("x" x " y65 w95 h30 vCat_" StrReplace(cat, "ã", "a"), cat)
        btn.OnEvent("Click", CategoryTabClick.Bind(cat))
        if (cat = selectedCategory)
            btn.Opt("+Default")
        x += 100
    }
}

CategoryTabClick(cat, btn, *) {
    global selectedCategory, MyGui

    selectedCategory := cat
    categories := ["Todas", "Suprimentos", "Missão", "Defensivas", "Ofensivas", "Hangar", "Ponte", "Engenharia", "Oficina"]
    for c in categories {
        if b := MyGui["Cat_" StrReplace(c, "ã", "a")]
            b.Opt(c = cat ? "+Default" : "-Default")
    }
    RefreshStratagemList()
}

CreateSearchBox() {
    global MyGui, searchText

    MyGui.AddText("x20 y105 w60 h25", "Buscar:")
    searchEdit := MyGui.AddEdit("x85 y103 w250 h25 vSearchEdit", searchText)
    searchEdit.OnEvent("Change", OnSearchChange)

    MyGui.AddButton("x340 y103 w80 h25", "Limpar")
        .OnEvent("Click", (*) => OnClearSearch())

    MyGui.AddText("x430 y105 w450 h25", "Duplo-clique = associar tecla | Botão direito = ver código")
}

OnSearchChange(ctrl, *) {
    global searchText
    searchText := ctrl.Value
    RefreshStratagemList()
}

OnClearSearch(*) {
    global searchText, MyGui
    searchText := ""
    MyGui["SearchEdit"].Value := ""
    RefreshStratagemList()
}

CreateStratagemList() {
    global MyGui, darkMode

    listBox := MyGui.AddListBox("x20 y140 w860 h430 vStratList", [])
    listBox.OnEvent("DoubleClick", (*) => OnStratagemDoubleClick())
    listBox.OnEvent("ContextMenu", OnStratagemContextMenu)

    if (darkMode) {
        listBox.BackColor := 0x2D2D2D
        listBox.TextColor := 0xFFFFFF
    }
}

CreateStatusBar() {
    global MyGui, bindings, stratagems, selectedCategory, searchText, darkMode

    statusText := "Estratégias: " stratagems.Length " | Bindings: " bindings.Count " | Categoria: " selectedCategory
    if (searchText != "")
        statusText .= " | Filtro: " searchText

    status := MyGui.AddText("x20 y580 w860 h25 vStatusBar", statusText)
    if (darkMode)
        status.TextColor := 0xAAAAAA
}

OnStratagemDoubleClick(*) {
    strat := GetSelectedStrat()
    if (strat)
        SelectStratagem(strat)
    else
        ShowTrayTip("Aviso", "Selecione uma estratégia primeiro!")
}

OnStratagemContextMenu(ctrl, item, isRightClick, x, y) {
    global STRATAGEM_DATA, bindings

    if (isRightClick) {
        clickedItem := ListBoxItemAtPoint(ctrl, x, y)
        if (clickedItem > 0)
            ctrl.Value := clickedItem
    } else if (item > 0) {
        ctrl.Value := item
    }

    strat := GetSelectedStrat(ctrl)
    if (!strat || !STRATAGEM_DATA.Has(strat))
        return

    data := STRATAGEM_DATA[strat]
    menu := Menu()
    menu.Add("Código: " data["CodeDisplay"], (*) => ShowTrayTip("Código", strat ":`n" data["CodeDisplay"], 3000))
    menu.Add("Categoria: " data["Category"], (*) => ShowTrayTip("Categoria", data["Category"], 1500))
    menu.Add("Descrição: " data["Description"], (*) => ShowTrayTip("Descrição", data["Description"], 3000))
    menu.Add("Copiar código", (*) => (Clipboard := data["CodeDisplay"], ShowTrayTip("Copiado", "Código copiado: " data["CodeDisplay"], 1500)))

    for key, s in bindings {
        if (s = strat) {
            menu.Add("Remover bind: " key, (*) => RemoveBinding(key))
            break
        }
    }
    menu.Show(x, y)
}

StratMatchesFilter(strat, data) {
    global selectedCategory, searchText

    if (selectedCategory != "Todas" && data["Category"] != selectedCategory)
        return false

    searchLower := StrLower(searchText)
    if (searchLower = "")
        return true

    return InStr(StrLower(strat), searchLower) || InStr(StrLower(data["Category"]), searchLower)
}

RefreshStratagemList() {
    global MyGui, stratagems, bindings, STRATAGEM_DATA

    listBox := MyGui["StratList"]
    listBox.Delete()

    for strat in stratagems {
        if !STRATAGEM_DATA.Has(strat)
            continue

        data := STRATAGEM_DATA[strat]
        if !StratMatchesFilter(strat, data)
            continue

        boundKey := ""
        for key, s in bindings {
            if (s = strat) {
                boundKey := " [" key "]"
                break
            }
        }
        listBox.Add([strat boundKey])
    }

    UpdateStatusBar()
}

UpdateStatusBar() {
    global MyGui, bindings, stratagems, selectedCategory, searchText, STRATAGEM_DATA

    visibleCount := 0
    for strat in stratagems {
        if !STRATAGEM_DATA.Has(strat)
            continue
        if StratMatchesFilter(strat, STRATAGEM_DATA[strat])
            visibleCount++
    }

    statusText := "Visíveis: " visibleCount " / " stratagems.Length " | Bindings: " bindings.Count " | Cat: " selectedCategory
    if (searchText != "")
        statusText .= " | Filtro: " searchText

    if (MyGui["StatusBar"])
        MyGui["StatusBar"].Text := statusText
}

SelectStratagem(strat) {
    global waitingForKey, selectedStrat, MyGui

    if (!strat)
        return

    waitingForKey := true
    selectedStrat := strat
    ShowTrayTip("Aguardando tecla", "Pressione uma tecla do Numpad para: " strat, 3000)

    if IsSet(MyGui) && MyGui
        MyGui.Hide()

    key := WaitForKey()

    if (key = "Escape") {
        ShowTrayTip("Cancelado", "Associação cancelada.", 1500)
    } else if !KeyIsValid(key) {
        ShowTrayTip("Tecla inválida", "Apenas teclas do Numpad são aceitas.", 1500)
    } else {
        SaveBinding(strat, key)
    }

    waitingForKey := false
    selectedStrat := ""

    if IsSet(MyGui) && MyGui
        MyGui.Show()
}

RemoveBinding(key) {
    global bindings, bindingsFile

    if !bindings.Has(key)
        return

    strat := bindings[key]
    bindings.Delete(key)
    UnregisterHotkey(key)

    index := 1
    Loop {
        s := IniRead(bindingsFile, "Bindings", index, "")
        if (s = "")
            break
        if (s = strat) {
            IniDelete(bindingsFile, "Bindings", index)
            IniDelete(bindingsFile, "Keys", strat)
            break
        }
        index++
    }

    ShowTrayTip("Removido", strat " removido de " key, 1500)
    RefreshMainGui()
}

TogglePauseBinds(*) {
    global bindingsPaused, MyGui, BindGui

    bindingsPaused := !bindingsPaused
    PauseAllBinds(bindingsPaused)

    pauseText := bindingsPaused ? "Retomar Binds" : "Pausar Binds"
    if (MyGui["PauseBtn"])
        MyGui["PauseBtn"].Text := pauseText
    if (BindGui && BindGui["PauseBtn"])
        BindGui["PauseBtn"].Text := pauseText

    ShowTrayTip("Binds", bindingsPaused ? "Todas as binds PAUSADAS." : "Todas as binds RETOMADAS.", 1500)
}

ShowBindingsWindow(*) {
    global bindings, bindingsPaused, BindGui, darkMode, STRATAGEM_DATA

    if IsSet(BindGui) && BindGui {
        try BindGui.Destroy()
    }

    if (bindings.Count = 0) {
        MsgBox("Nenhuma configuração atual para mostrar.")
        return
    }

    BindGui := Gui()
    BindGui.Title := "Bindings Atuais"
    BindGui.SetFont("s11", "Consolas")
    BindGui.BackColor := darkMode ? 0x1E1E1E : 0xF0F0F0

    y := 10
    BindGui.AddText("x20 y" y " w760 h30", "Estratégia".PadRight(40) "Tecla".PadRight(15) "Código")
    y += 30

    for key, strat in bindings {
        codeDisplay := STRATAGEM_DATA.Has(strat) ? STRATAGEM_DATA[strat]["CodeDisplay"] : "N/A"
        line := strat.PadRight(40) key.PadRight(15) codeDisplay
        txt := BindGui.AddText("x20 y" y " w760 h25", line)
        if (darkMode)
            txt.TextColor := 0xFFFFFF
        txt.OnEvent("ContextMenu", ShowBindingContextMenu.Bind(key, strat))
        y += 28
    }

    BindGui.AddButton("x20 y" (y + 10) " w180 h35 vPauseBtn",
        bindingsPaused ? "Retomar Binds" : "Pausar Binds")
        .OnEvent("Click", (*) => TogglePauseBinds())

    BindGui.AddButton("x220 y" (y + 10) " w120 h35", "Fechar")
        .OnEvent("Click", (*) => BindGui.Destroy())

    BindGui.Show("w800 h" (y + 80))
}

ShowBindingContextMenu(key, strat, ctrl, item, isRightClick, x, y) {
    menu := Menu()
    menu.Add("Remover bind", (*) => RemoveBinding(key))
    menu.Add("Editar tecla", (*) => SelectStratagem(strat))
    if STRATAGEM_DATA.Has(strat) {
        code := STRATAGEM_DATA[strat]["CodeDisplay"]
        menu.Add("Copiar código", (*) => (Clipboard := code, ShowTrayTip("Copiado", code, 1500)))
    }
    menu.Show(x, y)
}

ToggleDarkMode(*) {
    global darkMode, MyGui, BindGui

    darkMode := !darkMode
    SaveConfig()
    ShowMainGui()
    ShowTrayTip("Tema", darkMode ? "Modo Escuro ativado" : "Modo Claro ativado", 1000)
}

RefreshMainGui() {
    global MyGui
    if IsSet(MyGui) && MyGui {
        RefreshStratagemList()
        UpdateStatusBar()
    }
}

ReloadAll(*) {
    for key in bindings
        UnregisterHotkey(key)

    LoadStratagemsConfig()
    LoadBindings()
    ShowMainGui()
    ShowTrayTip("Recarregado", "Configurações recarregadas.", 1500)
}

ImportBindings(*) {
    global bindingsFile

    file := FileSelect(, , "Selecione arquivo de bindings", "INI (*.ini)")
    if (file = "")
        return

    try FileCopy(file, bindingsFile, 1)
    for key in bindings
        UnregisterHotkey(key)
    LoadBindings()
    RefreshMainGui()
    ShowTrayTip("Importado", "Bindings importados com sucesso.", 1500)
}

ExportBindings(*) {
    global bindingsFile

    file := FileSelect("S", , "Salvar bindings como", "INI (*.ini)")
    if (file = "")
        return

    try FileCopy(bindingsFile, file, 1)
    ShowTrayTip("Exportado", "Bindings exportados para:`n" file, 2000)
}

CreateDefaultStratagemsFile() {
    global stratagemsFile

    content := "[Stratagems]`n"
    for name in STRATAGEM_DATA
        content .= name "`n"
    FileAppend(content, stratagemsFile)
}

F6:: ShowMainGui()
F7:: ShowBindingsWindow()
F8:: TogglePauseBinds()
F12:: ExitApp()

CheckCreateFiles()
LoadConfig()
LoadStratagemsConfig()

if (stratagems.Length = 0) {
    MsgBox("Nenhuma estratégia encontrada! Verifique o arquivo " stratagemsFile)
    ExitApp()
}

LoadBindings()
ShowMainGui()
ShowTrayTip("Script iniciado", "F6 = janela principal | F7 = bindings | F8 = pausar", 2000)
