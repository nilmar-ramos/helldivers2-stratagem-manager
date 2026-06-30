#Requires AutoHotkey v2.0

global stratIconList := 0
global stratIconIndex := Map()
global ICON_SIZE := 36
global LIST_ICON_INDENT := 22

ToBgr(rgb) {
    return (rgb & 0xFF) << 16 | (rgb & 0xFF00) | (rgb >> 16) & 0xFF
}

InitStratIcons() {
    global stratIconList, stratIconIndex, STRATAGEM_DATA, ICON_SIZE

    stratIconIndex := Map()
    if (stratIconList)
        try IL_Destroy(stratIconList)

    ; Large images assigned to the small-icon slot => taller rows in Report view
    stratIconList := IL_Create(48, 16, true)
    iconsDir := A_ScriptDir "\icons"
    defaultPath := iconsDir "\default.png"
    defaultIdx := _AddIconPng(stratIconList, defaultPath)
    if (!defaultIdx)
        defaultIdx := 1

    fileIndex := Map("default.png", defaultIdx)
    for key, data in STRATAGEM_DATA {
        iconFile := data.Has("IconFile") ? data["IconFile"] : "default.png"
        if !fileIndex.Has(iconFile) {
            path := iconsDir "\" iconFile
            idx := _AddIconPng(stratIconList, path)
            fileIndex[iconFile] := idx ? idx : defaultIdx
        }
        stratIconIndex[key] := fileIndex[iconFile]
    }
}

_ResolveIconPath(path) {
    if !InStr(path, "Background")
        return path

    flatDir := A_ScriptDir "\icons\flat"
    name := SubStr(path, InStr(path, "\", , -1) + 1)
    flatPath := flatDir "\" name
    if FileExist(flatPath)
        return flatPath

    if !DirExist(flatDir)
        DirCreate(flatDir)

    pyScript := A_ScriptDir "\tools\flatten_icon.py"
    if FileExist(pyScript) {
        try RunWait('python "' pyScript '" "' path '" "' flatPath '"', , "Hide")
        if FileExist(flatPath)
            return flatPath
    }
    return path
}

_AddIconPng(il, path) {
    global ICON_SIZE
    if !FileExist(path)
        return 0
    path := _ResolveIconPath(path)
    size := "w" ICON_SIZE " h" ICON_SIZE
    try {
        hPic := LoadPicture(path, size, &handleType := 0)
        if (handleType = 1)
            return IL_Add(il, "HICON:" hPic)
        if (handleType = 2)
            return IL_Add(il, "HBITMAP:" hPic, 0xFFFFFF, true)
    }
    idx := IL_Add(il, path, 0xFFFFFF, true)
    return idx
}

GetListRowHeight() {
    global listFontSize, ICON_SIZE
    return Max(listFontSize + 20, ICON_SIZE + 14)
}

GetListViewClientWidth(hwnd) {
    rect := Buffer(16, 0)
    DllCall("GetClientRect", "Ptr", hwnd, "Ptr", rect)
    w := NumGet(rect, 8, "Int") - NumGet(rect, 0, "Int")
    h := NumGet(rect, 12, "Int") - NumGet(rect, 4, "Int")
    count := DllCall("SendMessage", "Ptr", hwnd, "UInt", 0x1004, "Ptr", 0, "Ptr", 0, "Ptr")
    rowH := DllCall("SendMessage", "Ptr", hwnd, "UInt", 0x1028, "Ptr", 0, "Ptr", 0, "Ptr")
    if (count > 0 && rowH > 0 && count * rowH > h)
        w -= DllCall("GetSystemMetrics", "Int", 2)
    return Max(200, w)
}

DisableListViewHScroll(lv) {
    hwnd := lv.Hwnd
    style := DllCall("GetWindowLongPtr", "Ptr", hwnd, "Int", -16, "Ptr")
    if (style & 0x100000) {
        DllCall("SetWindowLongPtr", "Ptr", hwnd, "Int", -16, "Ptr", style & ~0x100000, "Ptr")
        DllCall("SetWindowPos", "Ptr", hwnd, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Int", 0, "Int", 0, "UInt", 0x27)
    }
    DllCall("ShowScrollBar", "Ptr", hwnd, "UInt", 0, "Int", 0)
}

FitListViewColumns(lv) {
    global ICON_SIZE, LIST_ICON_INDENT
    clientW := GetListViewClientWidth(lv.Hwnd)
    keyW := 72
    gutter := 4 + LIST_ICON_INDENT
    usable := clientW - gutter
    minName := ICON_SIZE + LIST_ICON_INDENT + 36
    codeW := Max(100, Min(165, Floor(usable * 0.21)))
    nameW := usable - keyW - codeW
    if (nameW < minName) {
        nameW := minName
        codeW := usable - keyW - nameW
    }
    if (codeW < 96) {
        codeW := 96
        nameW := Max(minName, usable - keyW - codeW)
    }
    lv.ModifyCol(1, nameW)
    lv.ModifyCol(2, 0)
    lv.ModifyCol(3, keyW)
    lv.ModifyCol(4, usable - nameW - keyW)
    DisableListViewHScroll(lv)
}

ApplyListViewTheme(lv, theme := "") {
    global LIST_ICON_INDENT, listFontSize
    if (theme = "")
        theme := GetTheme()
    hwnd := lv.Hwnd

    try DllCall("uxtheme\SetWindowTheme", "Ptr", hwnd, "Str", "Explorer", "Str", 0)

    lv.SetFont("s" listFontSize " c" Format("0x{:06X}", theme["text"]), "Segoe UI")

    bk := ToBgr(theme["surface"])
    tx := ToBgr(theme["text"])
    DllCall("SendMessage", "Ptr", hwnd, "UInt", 0x1001, "Ptr", 0, "Ptr", bk)   ; LVM_SETBKCOLOR
    DllCall("SendMessage", "Ptr", hwnd, "UInt", 0x1024, "Ptr", 0, "Ptr", tx)   ; LVM_SETTEXTCOLOR
    DllCall("SendMessage", "Ptr", hwnd, "UInt", 0x1026, "Ptr", 0, "Ptr", 0xFFFFFFFF) ; LVM_SETTEXTBKCOLOR = transparent
    DllCall("SendMessage", "Ptr", hwnd, "UInt", 0x101E, "Ptr", GetListRowHeight(), "Ptr", 0) ; LVM_SETITEMHEIGHT
    DllCall("SendMessage", "Ptr", hwnd, "UInt", 0x1027, "Ptr", LIST_ICON_INDENT, "Ptr", 0)  ; LVM_SETINDENT

    ; LVS_EX_DOUBLEBUFFER | LVS_EX_FULLROWSELECT
    styles := 0x00010000 | 0x00000020
    DllCall("SendMessage", "Ptr", hwnd, "UInt", 0x1036, "Ptr", styles, "Ptr", styles)
    FitListViewColumns(lv)
}

GetStratIconIndex(strat) {
    global stratIconIndex
    return stratIconIndex.Has(strat) ? stratIconIndex[strat] : 1
}

AttachStratIcons(lv) {
    global stratIconList
    if (stratIconList)
        lv.SetImageList(stratIconList, 1)
}

StratIconOption(strat) {
    return "Icon" GetStratIconIndex(strat)
}

ListContentX() {
    global UI_SIDEBAR_W
    return UI_SIDEBAR_W + 32
}

ListContentWidth(guiWidth) {
    return guiWidth - ListContentX() - 16
}
