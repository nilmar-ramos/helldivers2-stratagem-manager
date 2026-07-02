#Requires AutoHotkey v2.0

global lang := "pt"
global _i18n := ""

InitLanguage() {
    global lang, _i18n
    _i18n := BuildI18n(lang)
}

SetLanguage(newLang) {
    global lang, _i18n
    lang := (newLang = "en") ? "en" : "pt"
    _i18n := BuildI18n(lang)
}

T(key) {
    global _i18n
    if (!_i18n)
        InitLanguage()
    return _i18n.Has(key) ? _i18n[key] : key
}

CategoryLabel(cat) {
    global lang
    static en := Map(
        "Todas", "All",
        "Suprimentos", "Supplies",
        "Missão", "Mission",
        "Defensivas", "Defensive",
        "Ofensivas", "Offensive",
        "Hangar", "Hangar",
        "Ponte", "Bridge",
        "Engenharia", "Engineering",
        "Oficina", "Factory"
    )
    if (lang = "en" && en.Has(cat))
        return en[cat]
    return cat
}

StratName(key) {
    global lang, STRATAGEM_DATA
    if !STRATAGEM_DATA.Has(key)
        return key
    data := STRATAGEM_DATA[key]
    if (lang = "en" && data.Has("NameEn"))
        return data["NameEn"]
    return key
}

StratDesc(key) {
    global lang, STRATAGEM_DATA
    if !STRATAGEM_DATA.Has(key)
        return ""
    data := STRATAGEM_DATA[key]
    if (lang = "en" && data.Has("DescriptionEn"))
        return data["DescriptionEn"]
    return data["Description"]
}

BuildI18n(l) {
    if (l = "en") {
        return Map(
            "window_title", "Helldivers 2 — Stratagem Manager",
            "subtitle", "Stratagem manager · F6 menu · F7 bindings · F8 pause",
            "btn_bindings", "Bindings",
            "btn_pause", "⏸ Pause",
            "btn_resume", "▶ Resume",
            "btn_import", "Import",
            "btn_export", "Export",
            "btn_clear", "Clear",
            "btn_reload", "Reload",
            "btn_presets", "Presets",
            "preset_applied", "Preset applied",
            "preset_confirm", "Apply preset '{1}'?`n`nAlways-available stratagems use Ctrl+1 to Ctrl+3. Loadout slots use Numpad 1-4.",
            "preset_invalid", "Invalid preset: ",
            "preset_none", "No presets found in presets/",
            "preset_save_current", "Save current loadout...",
            "preset_create", "Create loadout...",
            "preset_save_title", "Save loadout",
            "preset_save_prompt", "Name for this loadout preset:",
            "preset_save_empty", "Bind stratagems to Numpad 1-4 first, or use Create loadout.",
            "preset_saved", "Loadout saved",
            "preset_overwrite", "Overwrite preset '{1}'?",
            "preset_create_title", "Create loadout",
            "preset_create_hint", "Pick 4 stratagems for your loadout (Numpad 1-4).",
            "preset_slot", "Slot {1}",
            "preset_name_label", "Name",
            "preset_custom_default_name", "My loadout",
            "preset_custom_desc", "Custom loadout",
            "preset_save_apply", "Save and apply",
            "preset_duplicate_slot", "Each slot must be a different stratagem.",
            "preset_pick_one", "Pick at least one stratagem.",
            "preset_name_required", "Enter a name for the loadout.",
            "btn_lang", "PT",
            "label_category", "Category",
            "label_search", "Search",
            "btn_clear_search", "Clear",
            "hint_list", "Double-click = bind · right-click = details",
            "label_font", "Font",
            "col_strat", "Stratagem",
            "col_key", "Key",
            "col_code", "Code",
            "status_fmt", "{1} visible · {2} total · {3} bindings · {4}",
            "status_filter", "filter",
            "no_strats", "No stratagems found! Check file ",
            "binding_saved", "Binding saved",
            "bindings_cleared", "Bindings cleared",
            "bindings_cleared_msg", "All bindings were removed.",
            "warning", "Warning",
            "game_not_active", "HELLDIVERS 2 is not running.",
            "error", "Error",
            "strat_unknown", "Stratagem not registered: ",
            "strat_exec_error", "Could not execute stratagem.",
            "select_first", "Select a stratagem first!",
            "code", "Code",
            "category", "Category",
            "description", "Description",
            "copied", "Copied",
            "code_copied", "Code copied: ",
            "assign_key", "Assign key",
            "remove_bind", "Remove bind: ",
            "waiting_key", "Waiting for key",
            "waiting_key_msg", "Press a Numpad key for: ",
            "cancelled", "Cancelled",
            "bind_cancelled", "Binding cancelled.",
            "invalid_key", "Invalid key",
            "numpad_only", "Only Numpad keys are accepted.",
            "removed", "Removed",
            "removed_msg", " removed from ",
            "binds", "Binds",
            "binds_paused", "All binds PAUSED.",
            "binds_resumed", "All binds RESUMED.",
            "no_bindings", "No bindings to show.",
            "binds_window", "Bindings — Helldivers 2",
            "binds_header", "ACTIVE BINDINGS",
            "binds_subtitle", " keys assigned · right-click for options",
            "btn_close", "Close",
            "remove_bind_menu", "Remove bind",
            "edit_key", "Edit key",
            "copy_code", "Copy code",
            "reloaded", "Reloaded",
            "reloaded_msg", "Settings reloaded.",
            "import_select", "Select bindings file",
            "imported", "Imported",
            "imported_msg", "Bindings imported successfully.",
            "export_save", "Save bindings as",
            "exported", "Exported",
            "exported_msg", "Bindings exported to:`n",
            "script_started", "Script started",
            "script_started_msg", "F6 = main window | F7 = bindings | F8 = pause"
        )
    }
    return Map(
        "window_title", "Helldivers 2 — Gerenciador de Estratégias",
        "subtitle", "Gerenciador de estratagemas · F6 menu · F7 bindings · F8 pausar",
        "btn_bindings", "Bindings",
        "btn_pause", "⏸ Pausar",
        "btn_resume", "▶ Retomar",
        "btn_import", "Importar",
        "btn_export", "Exportar",
        "btn_clear", "Limpar",
        "btn_reload", "Recarregar",
        "btn_presets", "Presets",
        "preset_applied", "Preset aplicado",
        "preset_confirm", "Aplicar preset '{1}'?`n`nEstratégias fixas usam Ctrl+1 a Ctrl+3. Loadout usa Numpad 1-4.",
        "preset_invalid", "Preset inválido: ",
        "preset_none", "Nenhum preset em presets/",
        "preset_save_current", "Salvar loadout atual...",
        "preset_create", "Criar loadout...",
        "preset_save_title", "Salvar loadout",
        "preset_save_prompt", "Nome deste preset de loadout:",
        "preset_save_empty", "Associe estratégias ao Numpad 1-4 ou use Criar loadout.",
        "preset_saved", "Loadout salvo",
        "preset_overwrite", "Substituir preset '{1}'?",
        "preset_create_title", "Criar loadout",
        "preset_create_hint", "Escolha 4 estratégias para o loadout (Numpad 1-4).",
        "preset_slot", "Slot {1}",
        "preset_name_label", "Nome",
        "preset_custom_default_name", "Meu loadout",
        "preset_custom_desc", "Loadout personalizado",
        "preset_save_apply", "Salvar e aplicar",
        "preset_duplicate_slot", "Cada slot precisa ser uma estratégia diferente.",
        "preset_pick_one", "Escolha pelo menos uma estratégia.",
        "preset_name_required", "Informe um nome para o loadout.",
        "btn_lang", "EN",
        "label_category", "Categoria",
        "label_search", "Buscar",
        "btn_clear_search", "Limpar",
        "hint_list", "Duplo-clique = bind · direito = detalhes",
        "label_font", "Fonte",
        "col_strat", "Estratégia",
        "col_key", "Tecla",
        "col_code", "Código",
        "status_fmt", "{1} visíveis · {2} total · {3} bindings · {4}",
        "status_filter", "filtro",
        "no_strats", "Nenhuma estratégia encontrada! Verifique o arquivo ",
        "binding_saved", "Binding salvo",
        "bindings_cleared", "Bindings limpos",
        "bindings_cleared_msg", "Todos os bindings foram removidos.",
        "warning", "Aviso",
        "game_not_active", "HELLDIVERS 2 não está ativo.",
        "error", "Erro",
        "strat_unknown", "Estratégia não cadastrada: ",
        "strat_exec_error", "Não foi possível executar a estratégia.",
        "select_first", "Selecione uma estratégia primeiro!",
        "code", "Código",
        "category", "Categoria",
        "description", "Descrição",
        "copied", "Copiado",
        "code_copied", "Código copiado: ",
        "assign_key", "Associar tecla",
        "remove_bind", "Remover bind: ",
        "waiting_key", "Aguardando tecla",
        "waiting_key_msg", "Pressione uma tecla do Numpad para: ",
        "cancelled", "Cancelado",
        "bind_cancelled", "Associação cancelada.",
        "invalid_key", "Tecla inválida",
        "numpad_only", "Apenas teclas do Numpad são aceitas.",
        "removed", "Removido",
        "removed_msg", " removido de ",
        "binds", "Binds",
        "binds_paused", "Todas as binds PAUSADAS.",
        "binds_resumed", "Todas as binds RETOMADAS.",
        "no_bindings", "Nenhuma configuração atual para mostrar.",
        "binds_window", "Bindings — Helldivers 2",
        "binds_header", "BINDINGS ATIVOS",
        "binds_subtitle", " teclas associadas · botão direito para opções",
        "btn_close", "Fechar",
        "remove_bind_menu", "Remover bind",
        "edit_key", "Editar tecla",
        "copy_code", "Copiar código",
        "reloaded", "Recarregado",
        "reloaded_msg", "Configurações recarregadas.",
        "import_select", "Selecione arquivo de bindings",
        "imported", "Importado",
        "imported_msg", "Bindings importados com sucesso.",
        "export_save", "Salvar bindings como",
        "exported", "Exportado",
        "exported_msg", "Bindings exportados para:`n",
        "script_started", "Script iniciado",
        "script_started_msg", "F6 = janela principal | F7 = bindings | F8 = pausar"
    )
}
