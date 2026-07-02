#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

#Include HelldiversData.ahk
#Include HelldiversI18n.ahk
#Include HelldiversIcons.ahk
#Include HelldiversPresets.ahk

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
global listFontSize := 12
global UI_SIDEBAR_W := 208
global UI_TOP_BODY := 108
global CATEGORIES := ["Todas", "Suprimentos", "Missão", "Defensivas", "Ofensivas", "Hangar", "Ponte", "Engenharia", "Oficina"]

GetTheme() {
    return Map(
        "bg", 0xF5F5F5, "panel", 0xFFFFFF, "surface", 0xFFFFFF,
        "text", 0x1A1A1A, "muted", 0x5F6368, "accent", 0x8B6914,
        "input", 0xFFFFFF, "footer", 0xECECEC
    )
}

CatKey(cat) {
    return StrReplace(cat, "ã", "a")
}

ApplyGuiTheme(gui, theme) {
    gui.BackColor := theme["bg"]
    gui.SetFont("s10 c" Format("0x{:06X}", theme["text"]), "Segoe UI")
}

LoadConfig() {
    global configFile, listFontSize, lang
    listFontSize := Integer(IniRead(configFile, "General", "ListFontSize", "12"))
    listFontSize := Max(9, Min(16, listFontSize))
    SetLanguage(IniRead(configFile, "General", "Language", "pt"))
}

SaveConfig() {
    global configFile, listFontSize, lang
    IniWrite(listFontSize, configFile, "General", "ListFontSize")
    IniWrite(lang, configFile, "General", "Language")
}

ApplyListViewFont(lv) {
    ApplyListViewTheme(lv, GetTheme())
}

ApplyListFonts() {
    global MyGui, BindGui, listFontSize

    if IsSet(MyGui) && MyGui {
        if lv := MyGui["StratList"] {
            ApplyListViewFont(lv)
            FitListViewColumns(lv)
        }
        if lbl := MyGui["FontSizeLabel"]
            lbl.Text := listFontSize
    }
    if IsSet(BindGui) && BindGui {
        if lv := BindGui["BindList"]
            ApplyListViewFont(lv)
    }
}

AdjustListFont(delta) {
    global listFontSize
    listFontSize := Max(9, Min(16, listFontSize + delta))
    SaveConfig()
    ApplyListFonts()
}

CheckCreateFiles() {
    global configFile, bindingsFile, stratagemsFile

    if !FileExist(configFile) {
        FileAppend(
            "[General]`n"
            . "MacroDelay=300`n"
            . "AutoActivateGame=1`n"
            . "ListFontSize=12`n"
            . "Language=pt`n",
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

LoadStratagemsConfig() {
    global stratagemsFile, stratagems

    stratagems := []
    index := 1
    Loop {
        strat := IniRead(stratagemsFile, "Stratagems", index, "")
        if (strat = "")
            break
        if STRATAGEM_DATA.Has(strat)
            stratagems.Push(ResolveStrat(strat))
        index++
    }

    changed := CanonicalizeStratList()

    if (stratagems.Length = 0) {
        stratagems := BuildStratListForPreset(DEFAULT_PRESET_ID)
        SaveStratagemsConfig()
        return
    }

    for name in STRATAGEM_DATA {
        if !IsCanonicalStrat(name)
            continue
        found := false
        for existing in stratagems {
            if (existing = name) {
                found := true
                break
            }
        }
        if (!found) {
            stratagems.Push(name)
            changed := true
        }
    }
    if (changed)
        SaveStratagemsConfig()

    EnsureAlwaysAvailablePinned()
}

CanonicalizeStratList() {
    global stratagems
    seen := Map()
    cleaned := []
    changed := false

    for strat in stratagems {
        if !STRATAGEM_DATA.Has(strat)
            continue
        canon := ResolveStrat(strat)
        if (canon != strat)
            changed := true
        if seen.Has(canon)
            continue
        seen[canon] := true
        cleaned.Push(canon)
    }

    if (cleaned.Length != stratagems.Length)
        changed := true
    stratagems := cleaned
    return changed
}

BoundKeyForStrat(strat) {
    global bindings
    for key, s in bindings {
        if (ResolveStrat(s) = strat)
            return key
    }
    return ""
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
    migrated := false
    index := 1
    Loop {
        strat := IniRead(bindingsFile, "Bindings", index, "")
        if (strat = "")
            break

        key := IniRead(bindingsFile, "Keys", strat, "")
        if (key = "")
            key := IniRead(bindingsFile, "Keys", ResolveStrat(strat), "")

        if (key != "") {
            canon := ResolveStrat(strat)
            if (canon != strat)
                migrated := true
            bindings[key] := canon
            RegisterHotkey(key, canon)
        }
        index++
    }
    if (migrated)
        SaveAllBindings()

    EnsureAlwaysAvailableBindings()
    ApplyInitialBindingsIfEmpty()
}

SaveBinding(strat, key) {
    global bindings, bindingsFile

    strat := ResolveStrat(strat)
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

    ShowTrayTip(T("binding_saved"), StratName(strat) " -> " key)
    RefreshMainGui()
}

SaveAllBindings() {
    global bindings, bindingsFile

    try FileDelete(bindingsFile)
    FileAppend("[Bindings]`n[Keys]`n", bindingsFile)
    index := 1
    for key, strat in bindings {
        IniWrite(strat, bindingsFile, "Bindings", index)
        IniWrite(key, bindingsFile, "Keys", strat)
        index++
    }
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

    stratagem := ResolveStrat(stratagem)
    delay := Integer(IniRead(configFile, "General", "MacroDelay", "300"))
    autoActivate := IniRead(configFile, "General", "AutoActivateGame", "1") = "1"

    if (autoActivate) {
        hwndList := WinGetList("ahk_exe helldivers2.exe")
        if (hwndList.Length > 0) {
            WinActivate("ahk_id " hwndList[1])
            Sleep(delay)
        } else if !ProcessExist("helldivers2.exe") {
            ShowTrayTip(T("warning"), T("game_not_active"), 1500)
            return
        }
    }

    if STRATAGEM_DATA.Has(stratagem) {
        SendStratagemCode(STRATAGEM_DATA[stratagem]["Code"], delay)
    } else {
        ShowTrayTip(T("error"), T("strat_unknown") stratagem, 2000)
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

    ShowTrayTip(T("bindings_cleared"), T("bindings_cleared_msg"), 1500)
    ShowMainGui()
}

PauseAllBinds(pause := true) {
    global bindings
    for key in bindings {
        try Hotkey(key, , pause ? "Off" : "On")
    }
}

GetSelectedStratFromList(ctrl := "") {
    global MyGui
    if (!ctrl)
        ctrl := MyGui["StratList"]
    row := ctrl.GetNext(0, "F")
    if (!row)
        row := ctrl.GetNext()
    return row ? ctrl.GetText(row, 2) : ""
}

ShowMainGui() {
    global MyGui, stratagems, theme := GetTheme()

    if (stratagems.Length = 0) {
        MsgBox(T("no_strats") stratagemsFile)
        return
    }

    if IsSet(MyGui) && MyGui
        try MyGui.Destroy()

    MyGui := Gui("+Resize", T("window_title"))
    MyGui.MarginX := 16
    MyGui.MarginY := 12
    ApplyGuiTheme(MyGui, theme)
    MyGui.OnEvent("Close", (*) => ExitApp())
    MyGui.OnEvent("Size", OnMainGuiResize)

    MyGui.AddText("x16 y12 w500 h22", "HELLDIVERS 2")
        .SetFont("s13 bold c" Format("0x{:06X}", theme["accent"]), "Segoe UI")
    MyGui.AddText("x16 y34 w700 h18 vSubtitle", T("subtitle"))
        .SetFont("s9 c" Format("0x{:06X}", theme["muted"]), "Segoe UI")

    CreateToolbar(theme)
    CreateCategorySidebar(theme)
    CreateSearchBox(theme)
    InitStratIcons()
    CreateStratagemList(theme)
    CreateStatusBar(theme)

    MyGui.Show("w1100 h820")
    MyGui.GetPos(, , &gw, &gh)
    OnMainGuiResize(MyGui, 0, gw, gh)
    RefreshStratagemList()
}

LayoutToolbarRight(gui, width) {
    y := 58
    langW := 56
    plusW := 28
    sizeW := 32
    minusW := 28
    gap := 6
    right := width - 16
    if (c := gui["LangBtn"])
        c.Move(right - langW, y, langW, 32)
    if (c := gui["FontPlus"])
        c.Move(right - langW - gap - plusW, y - 1, plusW, 30)
    if (c := gui["FontSizeLabel"])
        c.Move(right - langW - gap - plusW - gap - sizeW, y + 4, sizeW, 24)
    if (c := gui["FontMinus"])
        c.Move(right - langW - gap - plusW - gap - sizeW - gap - minusW, y - 1, minusW, 30)
}

LayoutSearchRow(gui, width) {
    global UI_TOP_BODY
    listX := ListContentX()
    listW := ListContentWidth(width)
    searchY := UI_TOP_BODY
    editW := Max(120, listW - 54 - 8 - 72)

    if (c := gui["SearchEdit"])
        c.Move(listX + 54, searchY, editW)
    if (c := gui["SearchClear"])
        c.Move(listX + 54 + editW + 8, searchY - 1)
    if (c := gui["SearchHint"])
        c.Move(listX, searchY + 34, listW)
}
OnMainGuiResize(gui, minMax, width, height, *) {
    global UI_SIDEBAR_W, UI_TOP_BODY

    if (minMax = -1)
        return

    bodyH := height - UI_TOP_BODY - 48
    listX := ListContentX()
    listW := ListContentWidth(width)

    if (gui["SidebarPanel"])
        gui["SidebarPanel"].Move(12, UI_TOP_BODY - 4, UI_SIDEBAR_W + 8, bodyH + 4)
    if (gui["CatList"])
        gui["CatList"].Move(20, UI_TOP_BODY + 24, UI_SIDEBAR_W - 8, bodyH - 28)

    LayoutToolbarRight(gui, width)
    LayoutSearchRow(gui, width)

    listY := UI_TOP_BODY + 52
    listH := bodyH - 56
    if lv := gui["StratList"] {
        lv.Move(listX, listY, listW, listH)
        FitListViewColumns(lv)
    }
    if panel := gui["ListPanel"]
        panel.Move(listX - 4, listY - 4, listW + 8, listH + 8)
    if bar := gui["StatusBar"]
        bar.Move(16, height - 40, width - 32)
    if sub := gui["Subtitle"]
        sub.Move(16, 34, width - 32)
}

CreateToolbar(theme) {
    global MyGui, bindingsPaused, listFontSize

    y := 58
    MyGui.AddButton("x16 y" y " w130 h32", T("btn_bindings"))
        .OnEvent("Click", (*) => ShowBindingsWindow())
    MyGui.AddButton("x152 y" y " w130 h32 vPauseBtn",
        bindingsPaused ? T("btn_resume") : T("btn_pause"))
        .OnEvent("Click", (*) => TogglePauseBinds())
    MyGui.AddButton("x288 y" y " w100 h32", T("btn_import"))
        .OnEvent("Click", (*) => ImportBindings())
    MyGui.AddButton("x394 y" y " w100 h32", T("btn_export"))
        .OnEvent("Click", (*) => ExportBindings())
    MyGui.AddButton("x500 y" y " w90 h32", T("btn_clear"))
        .OnEvent("Click", (*) => ClearAllBindings())
    MyGui.AddButton("x596 y" y " w100 h32", T("btn_reload"))
        .OnEvent("Click", (*) => ReloadAll())
    MyGui.AddButton("x702 y" y " w100 h32", T("btn_presets"))
        .OnEvent("Click", ShowPresetMenu)
    MyGui.AddButton("x900 y" y " w28 h30 vFontMinus", "−")
        .OnEvent("Click", (*) => AdjustListFont(-1))
    MyGui.AddText("x932 y" (y + 4) " w32 h24 Center vFontSizeLabel", listFontSize)
        .SetFont("s9 c" Format("0x{:06X}", theme["text"]), "Segoe UI")
    MyGui.AddButton("x968 y" y " w28 h30 vFontPlus", "+")
        .OnEvent("Click", (*) => AdjustListFont(1))
    MyGui.AddButton("x1000 y" y " w56 h32 vLangBtn", T("btn_lang"))
        .OnEvent("Click", (*) => ToggleLanguage())
}

CreateCategorySidebar(theme) {
    global MyGui, selectedCategory, CATEGORIES, UI_SIDEBAR_W, UI_TOP_BODY

    panel := MyGui.AddText("x12 y" (UI_TOP_BODY - 4) " w" (UI_SIDEBAR_W + 8) " h500 vSidebarPanel Border", "")
    panel.BackColor := theme["panel"]

    MyGui.AddText("x20 y" UI_TOP_BODY " w" (UI_SIDEBAR_W - 8) " h20", T("label_category"))
        .SetFont("s9 bold c" Format("0x{:06X}", theme["muted"]), "Segoe UI")

    catList := MyGui.AddListBox("x20 y" (UI_TOP_BODY + 24) " w" (UI_SIDEBAR_W - 8) " h460 vCatList", [])
    catList.SetFont("s11", "Segoe UI")
    for cat in CATEGORIES
        catList.Add([CategoryLabel(cat)])
    DllCall("SendMessage", "Ptr", catList.Hwnd, "UInt", 0x01A0, "Ptr", 0, "Ptr", 36)

    idx := 1
    for i, cat in CATEGORIES {
        if (cat = selectedCategory)
            idx := i
    }
    catList.Value := idx
    catList.OnEvent("Change", OnCategorySidebarChange)
}

OnCategorySidebarChange(ctrl, *) {
    global selectedCategory, CATEGORIES

    idx := ctrl.Value
    i := 0
    for cat in CATEGORIES {
        i++
        if (i = idx) {
            selectedCategory := cat
            break
        }
    }
    RefreshStratagemList()
}

CreateSearchBox(theme) {
    global MyGui, searchText, UI_TOP_BODY

    x := ListContentX()
    y := UI_TOP_BODY

    MyGui.AddText("x" x " y" (y + 2) " w50 h24", T("label_search"))
        .SetFont("s9 c" Format("0x{:06X}", theme["muted"]), "Segoe UI")
    searchEdit := MyGui.AddEdit("x" (x + 54) " y" y " w400 h28 vSearchEdit", searchText)
    searchEdit.BackColor := theme["input"]
    searchEdit.OnEvent("Change", OnSearchChange)
    MyGui.AddButton("x" (x + 462) " y" (y - 1) " w72 h30 vSearchClear", T("btn_clear_search"))
        .OnEvent("Click", (*) => OnClearSearch())
    MyGui.AddText("x" x " y" (y + 34) " w600 h18 vSearchHint", T("hint_list"))
        .SetFont("s8 c" Format("0x{:06X}", theme["muted"]), "Segoe UI")
}

CreateStratagemList(theme) {
    global MyGui, UI_TOP_BODY

    x := ListContentX()
    y := UI_TOP_BODY + 52
    w := 860
    h := 608

    panel := MyGui.AddText("x" (x - 4) " y" (y - 4) " w" (w + 8) " h" (h + 8) " vListPanel Border", "")
    panel.BackColor := theme["panel"]

    lv := MyGui.AddListView("x" x " y" y " w" w " h" h " vStratList -HScroll", [T("col_strat"), "", T("col_key"), T("col_code")])
    lv.ModifyCol(2, 0)
    lv.OnEvent("DoubleClick", (*) => OnStratagemDoubleClick())
    lv.OnEvent("ContextMenu", OnStratagemContextMenu)
    AttachStratIcons(lv)
    ApplyListViewTheme(lv, theme)
}

CreateStatusBar(theme) {
    global MyGui

    bar := MyGui.AddText("x16 y776 w1068 h32 vStatusBar Border", "  ")
    bar.BackColor := theme["footer"]
    bar.SetFont("s9 c" Format("0x{:06X}", theme["muted"]), "Segoe UI")
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

OnStratagemDoubleClick(*) {
    strat := GetSelectedStratFromList()
    if (strat)
        SelectStratagem(strat)
    else
        ShowTrayTip(T("warning"), T("select_first"))
}

OnStratagemContextMenu(ctrl, item, isRightClick, x, y) {
    global STRATAGEM_DATA, bindings

    if (item > 0)
        ctrl.Modify(item, "Select Focus")

    strat := item > 0 ? ctrl.GetText(item, 2) : GetSelectedStratFromList(ctrl)
    if (!strat || !STRATAGEM_DATA.Has(strat))
        return

    data := STRATAGEM_DATA[strat]
    ctxMenu := Menu()
    ctxMenu.Add(T("code") ": " data["CodeDisplay"], (*) => ShowTrayTip(T("code"), StratName(strat) ":`n" data["CodeDisplay"], 3000))
    ctxMenu.Add(T("category") ": " CategoryLabel(data["Category"]), (*) => ShowTrayTip(T("category"), CategoryLabel(data["Category"]), 1500))
    ctxMenu.Add(T("description") ": " StratDesc(strat), (*) => ShowTrayTip(T("description"), StratDesc(strat), 3000))
    ctxMenu.Add(T("copy_code"), (*) => (Clipboard := data["CodeDisplay"], ShowTrayTip(T("copied"), T("code_copied") data["CodeDisplay"], 1500)))
    ctxMenu.Add(T("assign_key"), (*) => SelectStratagem(strat))

    boundKey := BoundKeyForStrat(strat)
    if (boundKey != "")
        ctxMenu.Add(T("remove_bind") boundKey, (*) => RemoveBinding(boundKey))
    ctxMenu.Show(x, y)
}

StratMatchesFilter(strat, data) {
    global selectedCategory, searchText

    if (selectedCategory != "Todas" && data["Category"] != selectedCategory)
        return false

    searchLower := StrLower(searchText)
    if (searchLower = "")
        return true

    return InStr(StrLower(strat), searchLower)
        || InStr(StrLower(data["Category"]), searchLower)
        || InStr(StrLower(CategoryLabel(data["Category"])), searchLower)
        || (data.Has("NameEn") && InStr(StrLower(data["NameEn"]), searchLower))
        || InStr(StrLower(data["Description"]), searchLower)
        || (data.Has("DescriptionEn") && InStr(StrLower(data["DescriptionEn"]), searchLower))
}

RefreshStratagemList() {
    global MyGui, stratagems, bindings, STRATAGEM_DATA

    lv := MyGui["StratList"]
    lv.Delete()

    for strat in stratagems {
        if !STRATAGEM_DATA.Has(strat) || !IsCanonicalStrat(strat)
            continue

        data := STRATAGEM_DATA[strat]
        if !StratMatchesFilter(strat, data)
            continue

        boundKey := BoundKeyForStrat(strat)
        if (boundKey = "")
            boundKey := "—"
        lv.Add(StratIconOption(strat), StratName(strat), strat, boundKey, data["CodeDisplay"])
    }

    UpdateStatusBar()
    FitListViewColumns(lv)
}

UpdateStatusBar() {
    global MyGui, bindings, stratagems, selectedCategory, searchText, STRATAGEM_DATA

    visibleCount := 0
    for strat in stratagems {
        if !STRATAGEM_DATA.Has(strat) || !IsCanonicalStrat(strat)
            continue
        if StratMatchesFilter(strat, STRATAGEM_DATA[strat])
            visibleCount++
    }

    statusText := "  " Format(T("status_fmt"), visibleCount, stratagems.Length, bindings.Count, CategoryLabel(selectedCategory))
    if (searchText != "")
        statusText .= " · " T("status_filter") ": " searchText

    if (MyGui["StatusBar"])
        MyGui["StatusBar"].Text := statusText
}

SelectStratagem(strat) {
    global waitingForKey, selectedStrat, MyGui

    if (!strat)
        return

    waitingForKey := true
    selectedStrat := strat
    ShowTrayTip(T("waiting_key"), T("waiting_key_msg") StratName(strat), 3000)

    if IsSet(MyGui) && MyGui
        MyGui.Hide()

    key := WaitForKey()

    if (key = "Escape") {
        ShowTrayTip(T("cancelled"), T("bind_cancelled"), 1500)
    } else if !KeyIsValid(key) {
        ShowTrayTip(T("invalid_key"), T("numpad_only"), 1500)
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

    ShowTrayTip(T("removed"), StratName(strat) T("removed_msg") key, 1500)
    RefreshMainGui()
    if IsSet(BindGui) && BindGui {
        if (bindings.Count = 0) {
            try BindGui.Destroy()
        } else {
            ShowBindingsWindow()
        }
    }
}

TogglePauseBinds(*) {
    global bindingsPaused, MyGui, BindGui

    bindingsPaused := !bindingsPaused
    PauseAllBinds(bindingsPaused)

    pauseText := bindingsPaused ? T("btn_resume") : T("btn_pause")
    if (MyGui["PauseBtn"])
        MyGui["PauseBtn"].Text := pauseText
    if (BindGui && BindGui["PauseBtn"])
        BindGui["PauseBtn"].Text := pauseText

    ShowTrayTip(T("binds"), bindingsPaused ? T("binds_paused") : T("binds_resumed"), 1500)
}

ShowBindingsWindow(*) {
    global bindings, bindingsPaused, BindGui, STRATAGEM_DATA, theme := GetTheme()

    if IsSet(BindGui) && BindGui
        try BindGui.Destroy()

    if (bindings.Count = 0) {
        MsgBox(T("no_bindings"))
        return
    }

    BindGui := Gui("+Resize", T("binds_window"))
    BindGui.MarginX := 16
    BindGui.MarginY := 12
    ApplyGuiTheme(BindGui, theme)
    BindGui.OnEvent("Size", OnBindGuiResize)

    BindGui.AddText("x16 y12 w400 h22", T("binds_header"))
        .SetFont("s12 bold c" Format("0x{:06X}", theme["accent"]), "Segoe UI")
    BindGui.AddText("x16 y36 w500 h18", bindings.Count T("binds_subtitle"))
        .SetFont("s9 c" Format("0x{:06X}", theme["muted"]), "Segoe UI")

    lv := BindGui.AddListView("x16 y64 w760 h400 vBindList -HScroll", [T("col_strat"), "", T("col_key"), T("col_code")])
    lv.ModifyCol(2, 0)
    lv.OnEvent("ContextMenu", OnBindListContextMenu)
    lv.OnEvent("DoubleClick", OnBindListDoubleClick)
    AttachStratIcons(lv)
    ApplyListViewFont(lv)

    for key, strat in bindings {
        codeDisplay := STRATAGEM_DATA.Has(strat) ? STRATAGEM_DATA[strat]["CodeDisplay"] : "N/A"
        lv.Add(StratIconOption(strat), StratName(strat), strat, key, codeDisplay)
    }

    btnY := 548
    BindGui.AddButton("x16 y" btnY " w140 h32 vPauseBtn",
        bindingsPaused ? T("btn_resume") : T("btn_pause"))
        .OnEvent("Click", (*) => TogglePauseBinds())
    BindGui.AddButton("x164 y" btnY " w100 h32 vBtnClose", T("btn_close"))
        .OnEvent("Click", (*) => BindGui.Destroy())

    BindGui.Show("w880 h600")
}

OnBindGuiResize(gui, minMax, width, height, *) {
    if (minMax = -1)
        return
    if lv := gui["BindList"] {
        lv.Move(16, 64, width - 32, height - 128)
        FitListViewColumns(lv)
    }
    if btn := gui["PauseBtn"]
        btn.Move(16, height - 52)
    if closeBtn := gui["BtnClose"]
        closeBtn.Move(164, height - 52)
}

OnBindListDoubleClick(*) {
    global BindGui

    lv := BindGui["BindList"]
    row := lv.GetNext(0, "F")
    if (!row)
        row := lv.GetNext()
    if (!row)
        return
    SelectStratagem(lv.GetText(row, 2))
}

OnBindListContextMenu(ctrl, item, isRightClick, x, y) {
    global STRATAGEM_DATA

    if (item > 0)
        ctrl.Modify(item, "Select Focus")
    if (!item)
        return

    strat := ctrl.GetText(item, 2)
    key := ctrl.GetText(item, 3)
    ctxMenu := Menu()
    ctxMenu.Add(T("remove_bind_menu"), (*) => RemoveBinding(key))
    ctxMenu.Add(T("edit_key"), (*) => SelectStratagem(strat))
    if STRATAGEM_DATA.Has(strat) {
        code := STRATAGEM_DATA[strat]["CodeDisplay"]
        ctxMenu.Add(T("copy_code"), (*) => (Clipboard := code, ShowTrayTip(T("copied"), code, 1500)))
    }
    ctxMenu.Show(x, y)
}

ToggleLanguage(*) {
    global lang, BindGui
    SetLanguage(lang = "pt" ? "en" : "pt")
    SaveConfig()
    if IsSet(BindGui) && BindGui
        try BindGui.Destroy()
    ShowMainGui()
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
    ShowTrayTip(T("reloaded"), T("reloaded_msg"), 1500)
}

ImportBindings(*) {
    global bindingsFile

    file := FileSelect(, , T("import_select"), "INI (*.ini)")
    if (file = "")
        return

    try FileCopy(file, bindingsFile, 1)
    for key in bindings
        UnregisterHotkey(key)
    LoadBindings()
    RefreshMainGui()
    ShowTrayTip(T("imported"), T("imported_msg"), 1500)
}

ExportBindings(*) {
    global bindingsFile

    file := FileSelect("S", , T("export_save"), "INI (*.ini)")
    if (file = "")
        return

    try FileCopy(bindingsFile, file, 1)
    ShowTrayTip(T("exported"), T("exported_msg") file, 2000)
}

CreateDefaultStratagemsFile() {
    global stratagems
    stratagems := BuildStratListForPreset(DEFAULT_PRESET_ID)
    SaveStratagemsConfig()
}

F6:: ShowMainGui()
F7:: ShowBindingsWindow()
F8:: TogglePauseBinds()
F12:: ExitApp()

CheckCreateFiles()
LoadConfig()
BuildStratCanonicalIndex()
LoadStratagemsConfig()
InitStratIcons()

if (stratagems.Length = 0) {
    MsgBox(T("no_strats") stratagemsFile)
    ExitApp()
}

LoadBindings()
ShowMainGui()
ShowTrayTip(T("script_started"), T("script_started_msg"), 2000)