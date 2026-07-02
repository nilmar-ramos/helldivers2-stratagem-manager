#Requires AutoHotkey v2.0

; Mission stratagems that do not use loadout slots (always on the wheel).
global ALWAYS_AVAILABLE_STRATS := ["Reforçar", "Reabastecimento", "Farol SOS"]
global ALWAYS_AVAILABLE_KEYS := ["^1", "^2", "^3"]
global LOADOUT_KEY_SLOTS := ["Numpad1", "Numpad2", "Numpad3", "Numpad4"]
global LEGACY_ALWAYS_AVAILABLE_KEYS := ["Numpad1", "Numpad2", "Numpad3"]
global DEFAULT_PRESET_ID := "anti-bugs"

GetPresetsDir() {
    return A_ScriptDir "\presets"
}

ListPresetIds() {
    ids := []
    dir := GetPresetsDir()
    if !DirExist(dir)
        return ids
    Loop Files dir "\*.ini" {
        id := RegExReplace(A_LoopFileName, "\.ini$", "")
        ids.Push(id)
    }
    return ids
}

ReadPresetMeta(presetId) {
    global lang
    file := GetPresetsDir() "\" presetId ".ini"
    if !FileExist(file)
        return Map()

    langKey := (lang = "en") ? "NameEn" : "NamePt"
    descKey := (lang = "en") ? "DescriptionEn" : "DescriptionPt"
    return Map(
        "Id", IniRead(file, "Meta", "Id", presetId),
        "Name", IniRead(file, "Meta", langKey, presetId),
        "Description", IniRead(file, "Meta", descKey, "")
    )
}

ReadPresetLoadout(presetId) {
    file := GetPresetsDir() "\" presetId ".ini"
    loadout := []
    if !FileExist(file)
        return loadout

    Loop 4 {
        raw := IniRead(file, "Loadout", A_Index, "")
        if (raw = "")
            continue
        canon := ResolvePresetStrat(raw)
        if (canon != "")
            loadout.Push(canon)
    }
    return loadout
}

PresetLabel(presetId) {
    meta := ReadPresetMeta(presetId)
    return meta.Has("Name") ? meta["Name"] : presetId
}

ResolvePresetStrat(name) {
    name := Trim(name)
    if (name = "")
        return ""

    if STRATAGEM_DATA.Has(name) {
        canon := ResolveStrat(name)
        if IsCanonicalStrat(canon)
            return canon
    }

    canon := ResolveStrat(name)
    if STRATAGEM_DATA.Has(canon) && IsCanonicalStrat(canon)
        return canon

    nameLower := StrLower(name)
    for key, data in STRATAGEM_DATA {
        if !IsCanonicalStrat(key)
            continue
        if data.Has("NameEn") && StrLower(data["NameEn"]) = nameLower
            return key
    }
    return ""
}

IsAlwaysAvailableStrat(strat) {
    global ALWAYS_AVAILABLE_STRATS
    canon := ResolveStrat(strat)
    for name in ALWAYS_AVAILABLE_STRATS {
        if (ResolveStrat(name) = canon)
            return true
    }
    return false
}

EnsureAlwaysAvailablePinned() {
    global stratagems, ALWAYS_AVAILABLE_STRATS

    pinned := []
    rest := []
    seen := Map()

    for name in ALWAYS_AVAILABLE_STRATS {
        canon := ResolveStrat(name)
        if STRATAGEM_DATA.Has(canon) {
            pinned.Push(canon)
            seen[canon] := true
        }
    }

    for strat in stratagems {
        canon := ResolveStrat(strat)
        if seen.Has(canon)
            continue
        seen[canon] := true
        rest.Push(canon)
    }

    newList := []
    for strat in pinned
        newList.Push(strat)
    for strat in rest
        newList.Push(strat)

    changed := (newList.Length != stratagems.Length)
    if !changed {
        Loop newList.Length {
            if (newList[A_Index] != stratagems[A_Index]) {
                changed := true
                break
            }
        }
    }

    if (changed) {
        stratagems := newList
        SaveStratagemsConfig()
    }
    return changed
}

BuildStratListForPreset(presetId) {
    global ALWAYS_AVAILABLE_STRATS

    list := []
    seen := Map()

    for name in ALWAYS_AVAILABLE_STRATS {
        canon := ResolveStrat(name)
        if STRATAGEM_DATA.Has(canon) && !seen.Has(canon) {
            list.Push(canon)
            seen[canon] := true
        }
    }

    for strat in ReadPresetLoadout(presetId) {
        if !seen.Has(strat) {
            list.Push(strat)
            seen[strat] := true
        }
    }

    return list
}

ApplyPresetBindings(loadout) {
    global bindings, ALWAYS_AVAILABLE_STRATS, ALWAYS_AVAILABLE_KEYS, LOADOUT_KEY_SLOTS

    for key in bindings.Clone()
        UnregisterHotkey(key)
    bindings := Map()

    Loop ALWAYS_AVAILABLE_STRATS.Length {
        idx := A_Index
        if (idx > ALWAYS_AVAILABLE_KEYS.Length)
            break
        strat := ResolveStrat(ALWAYS_AVAILABLE_STRATS[idx])
        key := ALWAYS_AVAILABLE_KEYS[idx]
        bindings[key] := strat
        RegisterHotkey(key, strat)
    }

    Loop loadout.Length {
        idx := A_Index
        if (idx > LOADOUT_KEY_SLOTS.Length)
            break
        strat := loadout[idx]
        key := LOADOUT_KEY_SLOTS[idx]
        bindings[key] := strat
        RegisterHotkey(key, strat)
    }

    SaveAllBindings()
}

EnsureAlwaysAvailableBindings() {
    global bindings, ALWAYS_AVAILABLE_STRATS, ALWAYS_AVAILABLE_KEYS, LEGACY_ALWAYS_AVAILABLE_KEYS

    changed := false
    Loop ALWAYS_AVAILABLE_STRATS.Length {
        idx := A_Index
        if (idx > ALWAYS_AVAILABLE_KEYS.Length)
            break
        strat := ResolveStrat(ALWAYS_AVAILABLE_STRATS[idx])
        key := ALWAYS_AVAILABLE_KEYS[idx]
        current := BoundKeyForStrat(strat)
        if (current = key)
            continue

        legacy := (idx <= LEGACY_ALWAYS_AVAILABLE_KEYS.Length) ? LEGACY_ALWAYS_AVAILABLE_KEYS[idx] : ""
        if (current != "" && current != legacy)
            continue

        if (current != "") {
            bindings.Delete(current)
            UnregisterHotkey(current)
        }
        if bindings.Has(key) {
            old := bindings[key]
            UnregisterHotkey(key)
            bindings.Delete(key)
        }
        bindings[key] := strat
        RegisterHotkey(key, strat)
        changed := true
    }
    if (changed)
        SaveAllBindings()
}

ApplyInitialBindingsIfEmpty() {
    global bindings, DEFAULT_PRESET_ID
    if (bindings.Count > 0)
        return
    loadout := ReadPresetLoadout(DEFAULT_PRESET_ID)
    if (loadout.Length = 0)
        return
    ApplyPresetBindings(loadout)
}

ApplyPreset(presetId) {
    global stratagems, configFile

    loadout := ReadPresetLoadout(presetId)
    if (loadout.Length = 0) {
        ShowTrayTip(T("error"), T("preset_invalid") presetId, 2500)
        return false
    }

    loadoutSet := Map()
    for strat in loadout
        loadoutSet[strat] := true

    EnsureAlwaysAvailablePinned()

    alwaysSet := Map()
    for name in ALWAYS_AVAILABLE_STRATS
        alwaysSet[ResolveStrat(name)] := true

    rest := []
    for strat in stratagems {
        if alwaysSet.Has(strat) || loadoutSet.Has(strat)
            continue
        rest.Push(strat)
    }

    stratagems := []
    for name in ALWAYS_AVAILABLE_STRATS {
        canon := ResolveStrat(name)
        if STRATAGEM_DATA.Has(canon)
            stratagems.Push(canon)
    }
    for strat in loadout
        stratagems.Push(strat)
    for strat in rest
        stratagems.Push(strat)

    SaveStratagemsConfig()
    ApplyPresetBindings(loadout)
    IniWrite(presetId, configFile, "General", "ActivePreset")
    return true
}

GetLoadoutFromBindings() {
    global bindings, LOADOUT_KEY_SLOTS

    loadout := []
    for key in LOADOUT_KEY_SLOTS {
        if bindings.Has(key)
            loadout.Push(bindings[key])
    }
    return loadout
}

StratPresetName(strat) {
    if !STRATAGEM_DATA.Has(strat)
        return strat
    data := STRATAGEM_DATA[strat]
    return data.Has("NameEn") ? data["NameEn"] : strat
}

SlugifyPresetId(name) {
    slug := StrLower(Trim(name))
    slug := RegExReplace(slug, "[áàâãä]", "a")
    slug := RegExReplace(slug, "[éèêë]", "e")
    slug := RegExReplace(slug, "[íìîï]", "i")
    slug := RegExReplace(slug, "[óòôõö]", "o")
    slug := RegExReplace(slug, "[úùûü]", "u")
    slug := RegExReplace(slug, "[ç]", "c")
    slug := RegExReplace(slug, "[^\w-]", "-")
    slug := RegExReplace(slug, "-+", "-")
    slug := Trim(slug, "-")
    return slug != "" ? slug : "custom-" A_TickCount
}

SavePresetFile(presetId, namePt, nameEn, descriptionPt, descriptionEn, loadout) {
    dir := GetPresetsDir()
    if !DirExist(dir)
        DirCreate(dir)

    file := dir "\" presetId ".ini"
    content := "[Meta]`n"
        . "Id=" presetId "`n"
        . "NamePt=" namePt "`n"
        . "NameEn=" nameEn "`n"
        . "DescriptionPt=" descriptionPt "`n"
        . "DescriptionEn=" descriptionEn "`n"
        . "`n[Loadout]`n"

    Loop loadout.Length
        content .= A_Index "=" StratPresetName(loadout[A_Index]) "`n"

    try FileDelete(file)
    FileAppend(content, file, "UTF-8")
}

GetSortedCanonicalStrats() {
    choices := []
    for name in STRATAGEM_DATA {
        if IsCanonicalStrat(name) && !IsAlwaysAvailableStrat(name)
            choices.Push(name)
    }

    count := choices.Length
    if (count <= 1)
        return choices

    Loop count - 1 {
        outer := A_Index
        Loop count - outer {
            inner := A_Index
            if (StrCompare(StratName(choices[inner]), StratName(choices[inner + 1])) > 0) {
                temp := choices[inner]
                choices[inner] := choices[inner + 1]
                choices[inner + 1] := temp
            }
        }
    }
    return choices
}

SaveCurrentLoadoutAsPreset(*) {
    loadout := GetLoadoutFromBindings()
    if (loadout.Length = 0) {
        ShowTrayTip(T("warning"), T("preset_save_empty"), 2500)
        return
    }

    ib := InputBox(T("preset_save_prompt"), T("preset_save_title"))
    if (ib.Result != "OK" || Trim(ib.Value) = "")
        return

    name := Trim(ib.Value)
    presetId := SlugifyPresetId(name)
    if FileExist(GetPresetsDir() "\" presetId ".ini") {
        if (MsgBox(Format(T("preset_overwrite"), name), T("preset_save_title"), "YesNo Icon?") != "Yes")
            return
    }

    descPt := T("preset_custom_desc")
    SavePresetFile(presetId, name, name, descPt, descPt, loadout)
    ShowTrayTip(T("preset_saved"), name, 2000)
}

ShowCreateLoadoutGui(*) {
    global LoadoutGui, stratChoices, MyGui, theme := GetTheme()

    if IsSet(LoadoutGui) && LoadoutGui
        try LoadoutGui.Destroy()

    stratChoices := GetSortedCanonicalStrats()
    labels := []
    for strat in stratChoices
        labels.Push(StratName(strat))

    opts := (IsSet(MyGui) && MyGui) ? "+Owner" MyGui.Hwnd : ""
    LoadoutGui := Gui(opts, T("preset_create_title"))
    LoadoutGui.MarginX := 16
    LoadoutGui.MarginY := 12
    ApplyGuiTheme(LoadoutGui, theme)

    LoadoutGui.AddText("x16 y12 w420 h20", T("preset_create_hint"))
        .SetFont("s9 c" Format("0x{:06X}", theme["muted"]), "Segoe UI")

    y := 40
    Loop 4 {
        slot := A_Index
        LoadoutGui.AddText("x16 y" y " w80 h24", Format(T("preset_slot"), slot))
        ddl := LoadoutGui.AddDropDownList("x96 y" (y - 2) " w340 h200 vLoadoutSlot" slot, labels.Clone())
        ddl.Value := Min(slot, labels.Length)
        y += 34
    }

    LoadoutGui.AddText("x16 y" y " w80 h24", T("preset_name_label"))
    LoadoutGui.AddEdit("x96 y" (y - 2) " w340 h28 vPresetName", T("preset_custom_default_name"))
    y += 40

    LoadoutGui.AddButton("x96 y" y " w120 h32", T("preset_save_apply"))
        .OnEvent("Click", SaveCreatedLoadout)
    LoadoutGui.AddButton("x224 y" y " w100 h32", T("btn_close"))
        .OnEvent("Click", (*) => LoadoutGui.Destroy())

    LoadoutGui.Show("w460 h" (y + 52))
}

SaveCreatedLoadout(*) {
    global LoadoutGui, stratChoices

    loadout := []
    seen := Map()
    Loop 4 {
        slot := A_Index
        ddl := LoadoutGui["LoadoutSlot" slot]
        idx := ddl.Value
        if (idx < 1 || idx > stratChoices.Length)
            continue
        strat := stratChoices[idx]
        if seen.Has(strat) {
            MsgBox(T("preset_duplicate_slot"), T("error"), "Icon!")
            return
        }
        seen[strat] := true
        loadout.Push(strat)
    }

    if (loadout.Length = 0) {
        MsgBox(T("preset_pick_one"), T("error"), "Icon!")
        return
    }

    name := Trim(LoadoutGui["PresetName"].Value)
    if (name = "") {
        MsgBox(T("preset_name_required"), T("error"), "Icon!")
        return
    }

    presetId := SlugifyPresetId(name)
    if FileExist(GetPresetsDir() "\" presetId ".ini") {
        if (MsgBox(Format(T("preset_overwrite"), name), T("preset_save_title"), "YesNo Icon?") != "Yes")
            return
    }

    descPt := T("preset_custom_desc")
    SavePresetFile(presetId, name, name, descPt, descPt, loadout)
    LoadoutGui.Destroy()

    if ApplyPreset(presetId) {
        RefreshMainGui()
        RefreshBindingsWindow()
        ShowTrayTip(T("preset_applied"), name, 2000)
    }
}

ShowPresetMenu(*) {
    ids := ListPresetIds()

    presetMenu := Menu()
    for id in ids {
        meta := ReadPresetMeta(id)
        label := meta.Has("Name") ? meta["Name"] : id
        if (meta.Has("Description") && meta["Description"] != "")
            label .= " — " meta["Description"]
        presetMenu.Add(label, PresetMenuHandler.Bind(id))
    }

    if (ids.Length > 0)
        presetMenu.Add()
    presetMenu.Add(T("preset_save_current"), SaveCurrentLoadoutAsPreset)
    presetMenu.Add(T("preset_create"), ShowCreateLoadoutGui)
    presetMenu.Show()
}

PresetMenuHandler(presetId, *) {
    meta := ReadPresetMeta(presetId)
    name := meta.Has("Name") ? meta["Name"] : presetId
    if (MsgBox(Format(T("preset_confirm"), name), T("btn_presets"), "YesNo Icon?") = "Yes") {
        if ApplyPreset(presetId) {
            RefreshMainGui()
            RefreshBindingsWindow()
            ShowTrayTip(T("preset_applied"), name, 2000)
        }
    }
}
