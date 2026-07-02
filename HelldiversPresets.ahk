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
        canon := ResolveStrat(raw)
        if STRATAGEM_DATA.Has(canon) && IsCanonicalStrat(canon)
            loadout.Push(canon)
    }
    return loadout
}

PresetLabel(presetId) {
    meta := ReadPresetMeta(presetId)
    return meta.Has("Name") ? meta["Name"] : presetId
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

ShowPresetMenu(*) {
    ids := ListPresetIds()
    if (ids.Length = 0) {
        ShowTrayTip(T("warning"), T("preset_none"), 2000)
        return
    }

    presetMenu := Menu()
    for id in ids {
        meta := ReadPresetMeta(id)
        label := meta.Has("Name") ? meta["Name"] : id
        if (meta.Has("Description") && meta["Description"] != "")
            label .= " — " meta["Description"]
        presetMenu.Add(label, PresetMenuHandler.Bind(id))
    }
    presetMenu.Show()
}

PresetMenuHandler(presetId, *) {
    meta := ReadPresetMeta(presetId)
    name := meta.Has("Name") ? meta["Name"] : presetId
    if (MsgBox(Format(T("preset_confirm"), name), T("btn_presets"), "YesNo Icon?") = "Yes") {
        if ApplyPreset(presetId) {
            RefreshMainGui()
            ShowTrayTip(T("preset_applied"), name, 2000)
        }
    }
}
