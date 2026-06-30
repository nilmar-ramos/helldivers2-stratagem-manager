#Requires AutoHotkey v2.0

global STRATAGEM_DATA := Map(
; Synced with helldivers.wiki.gg — icons in /icons
"Metralhadora MG-43", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Right",
    "CodeDisplay", "↓ ← ↓ ↑ →",
    "Description", "Alto RPM, baixa velocidade de recarga.",
    "NameEn", "MG-43 Machine Gun",
    "DescriptionEn", "High fire rate machine gun with slow reload.",
    "IconFile", "Machine_Gun_Stratagem_Icon.png"
),
"EAST-17 Anti-Tanque Expendedível", Map(
    "Category", "Suprimentos",
    "Code", "Down, Down, Left, Up, Right",
    "CodeDisplay", "↓ ↓ ← ↑ →",
    "Description", "Dois RPGs descartáveis.",
    "NameEn", "EAT-17 Expendable Anti-Tank",
    "DescriptionEn", "Two disposable anti-tank rockets.",
    "IconFile", "Expendable_Anti-Tank_Stratagem_Icon.png"
),
"M-105 Stalwart", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Up, Left",
    "CodeDisplay", "↓ ← ↓ ↑ ↑ ←",
    "Description", "Alto RPM e cadência rápida.",
    "NameEn", "M-105 Stalwart",
    "DescriptionEn", "High fire rate support weapon with fast reload.",
    "IconFile", "Stalwart_Stratagem_Icon.png"
),
"Canhão laser LAS-98", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Left",
    "CodeDisplay", "↓ ← ↓ ↑ ←",
    "Description", "Laser de longo alcance; aquece com uso prolongado.",
    "NameEn", "LAS-98 Laser Cannon",
    "DescriptionEn", "Long-range laser; overheats with sustained fire.",
    "IconFile", "Laser_Cannon_Stratagem_Icon.png"
),
"Espingarda anti-material APW-1", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Right, Up, Down",
    "CodeDisplay", "↓ ← → ↑ ↓",
    "Description", "Sniper contra armadura leve.",
    "NameEn", "APW-1 Anti-Materiel Rifle",
    "DescriptionEn", "Sniper rifle effective against light armor.",
    "IconFile", "Anti-Materiel_Rifle_Stratagem_Icon.png"
),
"Lançador de granadas GL-21", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Up, Left, Down",
    "CodeDisplay", "↓ ← ↑ ← ↓",
    "Description", "Granada de alta potência.",
    "NameEn", "GL-21 Grenade Launcher",
    "DescriptionEn", "High-explosive grenade launcher.",
    "IconFile", "Grenade_Launcher_Stratagem_Icon.png"
),
"Carabina sem recuo GR-8", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Right, Right, Left",
    "CodeDisplay", "↓ ← → → ←",
    "Description", "RPG de altíssimo dano.",
    "NameEn", "GR-8 Recoilless Rifle",
    "DescriptionEn", "Shoulder-fired recoilless rifle with massive damage.",
    "IconFile", "Recoilless_Rifle_Stratagem_Icon.png"
),
"FLAM-40 Lança-chamas", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Up, Down, Up",
    "CodeDisplay", "↓ ← ↑ ↓ ↑",
    "Description", "Destrutivo contra insetos.",
    "NameEn", "FLAM-40 Flamethrower",
    "DescriptionEn", "Devastating against bug-type enemies.",
    "IconFile", "Flamethrower_Stratagem_Icon.png"
),
"Metralhadora pesada MG-206", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Up, Down, Down",
    "CodeDisplay", "↓ ← ↑ ↓ ↓",
    "Description", "MG pesada de alto RPM.",
    "NameEn", "MG-206 Heavy Machine Gun",
    "DescriptionEn", "Heavy machine gun with high fire rate.",
    "IconFile", "Heavy_Machine_Gun_Stratagem_Icon.png"
),
"Canhão automático AC-8", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Up, Right",
    "CodeDisplay", "↓ ← ↓ ↑ ↑ →",
    "Description", "Canhão de ombro anti-veículo.",
    "NameEn", "AC-8 Autocannon",
    "DescriptionEn", "Shoulder-mounted autocannon for anti-vehicle use.",
    "IconFile", "Autocannon_Stratagem_Icon.png"
),
"ARC-3 Lançador de arco", Map(
    "Category", "Suprimentos",
    "Code", "Down, Right, Down, Up, Left, Left",
    "CodeDisplay", "↓ → ↓ ↑ ← ←",
    "Description", "Arco elétrico médio-longo alcance.",
    "NameEn", "ARC-3 Arc Thrower",
    "DescriptionEn", "Medium-to-long range electrical arc weapon.",
    "IconFile", "Arc_Thrower_Stratagem_Icon.png"
),
"Canhão Quasar LAS-99", Map(
    "Category", "Suprimentos",
    "Code", "Down, Down, Up, Left, Right",
    "CodeDisplay", "↓ ↓ ↑ ← →",
    "Description", "Laser de altíssimo dano.",
    "NameEn", "LAS-99 Quasar Cannon",
    "DescriptionEn", "Extremely high damage laser cannon.",
    "IconFile", "Quasar_Cannon_Stratagem_Icon.png"
),
"Lançador RL-77 Airburst", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Up, Left, Right",
    "CodeDisplay", "↓ ↑ ↑ ← →",
    "Description", "Foguete com detonação aérea.",
    "NameEn", "RL-77 Airburst Rocket Launcher",
    "DescriptionEn", "Rocket launcher with airburst detonation.",
    "IconFile", "Airburst_Rocket_Launcher_Stratagem_Icon.png"
),
"MLS-4X Commando", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Up, Down, Right",
    "CodeDisplay", "↓ ← ↑ ↓ →",
    "Description", "Lançador anti-tanque guiado laser, 4 foguetes.",
    "NameEn", "MLS-4X Commando",
    "DescriptionEn", "Laser-guided anti-tank launcher; four rockets.",
    "IconFile", "Commando_Stratagem_Icon.png"
),
"Lança FAF-14 Spear", Map(
    "Category", "Suprimentos",
    "Code", "Down, Down, Up, Down, Down",
    "CodeDisplay", "↓ ↓ ↑ ↓ ↓",
    "Description", "ATGM homing de altíssimo dano.",
    "NameEn", "FAF-14 Spear",
    "DescriptionEn", "Homing anti-tank missile with extreme damage.",
    "IconFile", "Spear_Stratagem_Icon.png"
),
"Canhão Railgun RS-422", Map(
    "Category", "Suprimentos",
    "Code", "Down, Right, Down, Up, Left, Right",
    "CodeDisplay", "↓ → ↓ ↑ ← →",
    "Description", "Railgun experimental; modo seguro/inseguro.",
    "NameEn", "RS-422 Railgun",
    "DescriptionEn", "Experimental railgun; safe and unsafe firing modes.",
    "IconFile", "Railgun_Stratagem_Icon.png"
),
"TX-41 Sterilizer", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Up, Down, Left",
    "CodeDisplay", "↓ ← ↑ ↓ ←",
    "Description", "Gás cáustico que cega e desacelera inimigos.",
    "NameEn", "TX-41 Sterilizer",
    "DescriptionEn", "Caustic gas that blinds and slows enemies.",
    "IconFile", "Sterilizer_Stratagem_Icon.png"
),
"StA-X3 W.A.S.P. Launcher", Map(
    "Category", "Suprimentos",
    "Code", "Down, Down, Up, Down, Right",
    "CodeDisplay", "↓ ↓ ↑ ↓ →",
    "Description", "Lançador de enxame.",
    "NameEn", "StA-X3 W.A.S.P. Launcher",
    "DescriptionEn", "Swarm launcher.",
    "IconFile", "W.A.S.P._Launcher_Stratagem_Icon_Background.png"
),
"CQC-20 Breaching Hammer", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Right, Left, Up",
    "CodeDisplay", "↓ ← → ← ↑",
    "Description", "Martelo de breaching.",
    "NameEn", "CQC-20 Breaching Hammer",
    "DescriptionEn", "Breaching hammer for close combat.",
    "IconFile", "Breaching_Hammer_Stratagem_Icon.png"
),
"PLAS-45 Epoch", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Up, Left, Right",
    "CodeDisplay", "↓ ← ↑ ← →",
    "Description", "Arma de plasma.",
    "NameEn", "PLAS-45 Epoch",
    "DescriptionEn", "Plasma weapon.",
    "IconFile", "Epoch_Stratagem_Icon.png"
),
"MGX-42 Bullet Storm", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Right, Up, Left",
    "CodeDisplay", "↓ ← ↓ → ↑ ←",
    "Description", "Metralhadora descartável.",
    "NameEn", "MGX-42 Bullet Storm",
    "DescriptionEn", "Disposable machine gun.",
    "IconFile", "Bullet_Storm_Stratagem_Icon.png"
),
"S-11 Speargun", Map(
    "Category", "Suprimentos",
    "Code", "Down, Right, Down, Left, Up, Right",
    "CodeDisplay", "↓ → ↓ ← ↑ →",
    "Description", "Arpão.",
    "NameEn", "S-11 Speargun",
    "DescriptionEn", "Underwater-capable speargun.",
    "IconFile", "Speargun_Stratagem_Icon.png"
),
"CQC-9 Defoliation Tool", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Right, Right, Down",
    "CodeDisplay", "↓ ← → → ↓",
    "Description", "Ferramenta de desfolha.",
    "NameEn", "CQC-9 Defoliation Tool",
    "DescriptionEn", "Heavy defoliation tool.",
    "IconFile", "Defoliation_Tool_Stratagem_Icon.png"
),
"EAT-700 Expendable Napalm", Map(
    "Category", "Suprimentos",
    "Code", "Down, Down, Left, Up, Left",
    "CodeDisplay", "↓ ↓ ← ↑ ←",
    "Description", "Napalm descartável.",
    "NameEn", "EAT-700 Expendable Napalm",
    "DescriptionEn", "Disposable napalm launcher.",
    "IconFile", "Expendable_Napalm_Stratagem_Icon.png"
),
"EAT-411 Leveller", Map(
    "Category", "Suprimentos",
    "Code", "Down, Down, Left, Up, Down",
    "CodeDisplay", "↓ ↓ ← ↑ ↓",
    "Description", "Explosivo nivelador descartável.",
    "NameEn", "EAT-411 Leveller",
    "DescriptionEn", "Disposable levelling explosive.",
    "IconFile", "Leveller_Stratagem_Icon.png"
),
"GL-52 De-Escalator", Map(
    "Category", "Suprimentos",
    "Code", "Down, Right, Up, Left, Right",
    "CodeDisplay", "↓ → ↑ ← →",
    "Description", "Lançador de granadas.",
    "NameEn", "GL-52 De-Escalator",
    "DescriptionEn", "Grenade launcher.",
    "IconFile", "De-Escalator_Stratagem_Icon.png"
),
"GL-28 Belt-Fed Grenade Launcher", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Up, Left, Up, Up",
    "CodeDisplay", "↓ ← ↑ ← ↑ ↑",
    "Description", "Lançador de granadas com cinta.",
    "NameEn", "GL-28 Belt-Fed Grenade Launcher",
    "DescriptionEn", "Belt-fed grenade launcher.",
    "IconFile", "Belt-Fed_Grenade_Launcher_Stratagem_Icon.png"
),
"B/MD C4 Pack", Map(
    "Category", "Suprimentos",
    "Code", "Down, Right, Up, Up, Right, Up",
    "CodeDisplay", "↓ → ↑ ↑ → ↑",
    "Description", "Pacote de C4.",
    "NameEn", "B/MD C4 Pack",
    "DescriptionEn", "Remote-detonated C4 pack.",
    "IconFile", "C4_Pack_Stratagem_Icon_Background.png"
),
"MS-11 Solo Silo", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Right, Down, Down",
    "CodeDisplay", "↓ ↑ → ↓ ↓",
    "Description", "Silo solo de mísseis.",
    "NameEn", "MS-11 Solo Silo",
    "DescriptionEn", "Single-use missile silo.",
    "IconFile", "Solo_Silo_Stratagem_Icon.png"
),
"B/FLAM-80 Cremator", Map(
    "Category", "Suprimentos",
    "Code", "Down, Down, Right, Down, Up, Up",
    "CodeDisplay", "↓ ↓ → ↓ ↑ ↑",
    "Description", "Lança-chamas pesado.",
    "NameEn", "B/FLAM-80 Cremator",
    "DescriptionEn", "Heavy flamethrower.",
    "IconFile", "Cremator_Stratagem_Icon_Background.png"
),
"M-1000 Maxigun", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Right, Down, Up, Up",
    "CodeDisplay", "↓ ← → ↓ ↑ ↑",
    "Description", "Maxigun de alto dano.",
    "NameEn", "M-1000 Maxigun",
    "DescriptionEn", "High-damage minigun.",
    "IconFile", "Maxigun_Stratagem_Icon.png"
),
"CQC-1 One True Flag", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Right, Right, Up",
    "CodeDisplay", "↓ ← → → ↑",
    "Description", "Bandeira de combate.",
    "NameEn", "CQC-1 One True Flag",
    "DescriptionEn", "Combat flag.",
    "IconFile", "One_True_Flag_Stratagem_Icon_Background.png"
),
"B-1 Conjunto de fornecimento", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Up, Down",
    "CodeDisplay", "↓ ← ↓ ↑ ↑ ↓",
    "Description", "Mochila com bolsas de munição.",
    "NameEn", "B-1 Supply Pack",
    "DescriptionEn", "Backpack with ammo resupply bags.",
    "IconFile", "Supply_Pack_Stratagem_Icon_Background.png"
),
"Mochila de proteção balística SH-20", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Down, Up, Left",
    "CodeDisplay", "↓ ← ↓ ↓ ↑ ←",
    "Description", "Escudo balístico de uma mão.",
    "NameEn", "SH-20 Ballistic Shield Backpack",
    "DescriptionEn", "One-handed ballistic shield.",
    "IconFile", "Ballistic_Shield_Backpack_Stratagem_Icon.png"
),
"AX/AR-23 Cão de guarda", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Up, Right, Down",
    "CodeDisplay", "↓ ↑ ← ↑ → ↓",
    "Description", "Drone com rifle Liberator.",
    "NameEn", "AX/AR-23 Guard Dog",
    "DescriptionEn", "Automaton drone with Liberator rifle.",
    "IconFile", "Guard_Dog_Stratagem_Icon_Background.png"
),
"AX/LAS-5 Cão de guarda Rover", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Up, Right, Right",
    "CodeDisplay", "↓ ↑ ← ↑ → →",
    "Description", "Drone com laser.",
    "NameEn", "AX/LAS-5 Rover",
    "DescriptionEn", "Automaton drone with laser.",
    "IconFile", "Rover_Stratagem_Icon_Background.png"
),
"Mochila Gerador de Escudo SH-32", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Right, Left, Right",
    "CodeDisplay", "↓ ↑ ← → ← →",
    "Description", "Bolha de escudo sobre o mergulhador.",
    "NameEn", "SH-32 Shield Generator Pack",
    "DescriptionEn", "Bubble shield over the Helldiver.",
    "IconFile", "Shield_Generator_Pack_Stratagem_Icon.png"
),
"SH-51 Escudo Direcional", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Right, Up, Up",
    "CodeDisplay", "↓ ↑ ← → ↑ ↑",
    "Description", "Escudo direcional.",
    "NameEn", "SH-51 Directional Shield",
    "DescriptionEn", "Directional shield backpack.",
    "IconFile", "Directional_Shield_Stratagem_Icon.png"
),
"AX/FLAM-75 Hot Dog", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Up, Left, Left",
    "CodeDisplay", "↓ ↑ ← ↑ ← ←",
    "Description", "Cão de guarda lança-chamas.",
    "NameEn", "AX/FLAM-75 Hot Dog",
    "DescriptionEn", "Guard Dog with flamethrower.",
    "IconFile", "Hot_Dog_Stratagem_Icon_Background.png"
),
"B-100 Hellbomb Portátil", Map(
    "Category", "Suprimentos",
    "Code", "Down, Right, Up, Up, Up",
    "CodeDisplay", "↓ → ↑ ↑ ↑",
    "Description", "Hellbomb portátil.",
    "NameEn", "B-100 Portable Hellbomb",
    "DescriptionEn", "Portable hellbomb.",
    "IconFile", "Portable_Hellbomb_Stratagem_Icon_Background.png"
),
"AX/ARC-3 K-9", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Up, Right, Left",
    "CodeDisplay", "↓ ↑ ← ↑ → ←",
    "Description", "Cão de guarda arco elétrico.",
    "NameEn", "AX/ARC-3 K-9",
    "DescriptionEn", "Guard Dog with arc thrower.",
    "IconFile", "K-9_Stratagem_Icon_Background.png"
),
"AX/TX-13 Dog Breath", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Up, Right, Up",
    "CodeDisplay", "↓ ↑ ← ↑ → ↑",
    "Description", "Cão de guarda com gás cáustico.",
    "NameEn", "AX/TX-13 Dog Breath",
    "DescriptionEn", "Guard Dog with caustic gas.",
    "IconFile", "Dog_Breath_Stratagem_Icon_Background.png"
),
"Pacote de salto LIFT-850", Map(
    "Category", "Hangar",
    "Code", "Down, Up, Up, Down, Up",
    "CodeDisplay", "↓ ↑ ↑ ↓ ↑",
    "Description", "Salto sem dano de queda.",
    "NameEn", "LIFT-850 Jump Pack",
    "DescriptionEn", "Jump pack; no fall damage.",
    "IconFile", "Jump_Pack_Stratagem_Icon.png"
),
"LIFT-860 Hover Pack", Map(
    "Category", "Hangar",
    "Code", "Down, Up, Up, Down, Left, Right",
    "CodeDisplay", "↓ ↑ ↑ ↓ ← →",
    "Description", "Pacote de hover.",
    "NameEn", "LIFT-860 Hover Pack",
    "DescriptionEn", "Hover mobility pack.",
    "IconFile", "Hover_Pack_Stratagem_Icon.png"
),
"LIFT-182 Warp Pack", Map(
    "Category", "Hangar",
    "Code", "Down, Left, Right, Down, Left, Right",
    "CodeDisplay", "↓ ← → ↓ ← →",
    "Description", "Pacote de distorção.",
    "NameEn", "LIFT-182 Warp Pack",
    "DescriptionEn", "Warp teleport pack.",
    "IconFile", "Warp_Pack_Stratagem_Icon.png"
),
"EXO-45 Patriot Exosuit", Map(
    "Category", "Oficina",
    "Code", "Left, Down, Right, Up, Left, Down, Down",
    "CodeDisplay", "← ↓ → ↑ ← ↓ ↓",
    "Description", "Exoesqueleto com metralhadora e foguetes.",
    "NameEn", "EXO-45 Patriot Exosuit",
    "DescriptionEn", "Exosuit with machine gun and rockets.",
    "IconFile", "Patriot_Exosuit_Stratagem_Icon.png"
),
"EXO-49 Emancipator Exosuit", Map(
    "Category", "Oficina",
    "Code", "Left, Down, Right, Up, Left, Down, Up",
    "CodeDisplay", "← ↓ → ↑ ← ↓ ↑",
    "Description", "Exoesqueleto com canhões automáticos duplos.",
    "NameEn", "EXO-49 Emancipator Exosuit",
    "DescriptionEn", "Exosuit with dual autocannons.",
    "IconFile", "Emancipator_Exosuit_Stratagem_Icon.png"
),
"EXO-55 Breakthrough Exosuit", Map(
    "Category", "Oficina",
    "Code", "Left, Down, Right, Left, Right, Down, Up",
    "CodeDisplay", "← ↓ → ← → ↓ ↑",
    "Description", "Exoesqueleto Breakthrough.",
    "NameEn", "EXO-55 Breakthrough Exosuit",
    "DescriptionEn", "Breakthrough exosuit.",
    "IconFile", "Breakthrough_Exosuit_Stratagem_Icon.png"
),
"EXO-51 Lumberer Exosuit", Map(
    "Category", "Oficina",
    "Code", "Left, Down, Right, Up, Right, Left, Up",
    "CodeDisplay", "← ↓ → ↑ → ← ↑",
    "Description", "Exoesqueleto Lumberer.",
    "NameEn", "EXO-51 Lumberer Exosuit",
    "DescriptionEn", "Lumberer exosuit.",
    "IconFile", "Lumberer_Exosuit_Stratagem_Icon.png"
),
"M-102 Fast Recon Vehicle", Map(
    "Category", "Hangar",
    "Code", "Left, Down, Right, Down, Right, Down, Up",
    "CodeDisplay", "← ↓ → ↓ → ↓ ↑",
    "Description", "Veículo de reconhecimento rápido.",
    "NameEn", "M-102 Fast Recon Vehicle",
    "DescriptionEn", "Fast recon vehicle.",
    "IconFile", "Fast_Recon_Vehicle_Stratagem_Icon_Background.png"
),
"M-103 Supply FRV", Map(
    "Category", "Hangar",
    "Code", "Left, Down, Left, Left, Down, Up, Right",
    "CodeDisplay", "← ↓ ← ← ↓ ↑ →",
    "Description", "FRV de suprimentos.",
    "NameEn", "M-103 Supply FRV",
    "DescriptionEn", "Supply fast recon vehicle.",
    "IconFile", "Supply_FRV_Stratagem_Icon_Background.png"
),
"M-104 Incinerator FRV", Map(
    "Category", "Hangar",
    "Code", "Left, Down, Right, Left, Down, Up, Up",
    "CodeDisplay", "← ↓ → ← ↓ ↑ ↑",
    "Description", "FRV incinerador.",
    "NameEn", "M-104 Incinerator FRV",
    "DescriptionEn", "Incinerator fast recon vehicle.",
    "IconFile", "Incinerator_FRV_Stratagem_Icon_Background.png"
),
"TD-220 Bastion MK XVI", Map(
    "Category", "Hangar",
    "Code", "Left, Down, Right, Down, Left, Down, Up, Down, Up",
    "CodeDisplay", "← ↓ → ↓ ← ↓ ↑ ↓ ↑",
    "Description", "Veículo blindado pesado.",
    "NameEn", "TD-220 Bastion MK XVI",
    "DescriptionEn", "Heavy armored vehicle.",
    "IconFile", "Bastion_MK_XVI_Stratagem_Icon_Background.png"
),
"Reforçar", Map(
    "Category", "Missão",
    "Code", "Up, Down, Right, Left, Up",
    "CodeDisplay", "↑ ↓ → ← ↑",
    "Description", "Traz companheiros de volta.",
    "NameEn", "Reinforce",
    "DescriptionEn", "Brings fallen Helldivers back.",
    "IconFile", "Reinforce_Stratagem_Icon.png"
),
"Farol SOS", Map(
    "Category", "Missão",
    "Code", "Up, Down, Right, Up",
    "CodeDisplay", "↑ ↓ → ↑",
    "Description", "Preenche elenco do esquadrão.",
    "NameEn", "SOS Beacon",
    "DescriptionEn", "Fills empty squad slots.",
    "IconFile", "SOS_Beacon_Stratagem_Icon.png"
),
"Reabastecimento", Map(
    "Category", "Missão",
    "Code", "Down, Down, Up, Right",
    "CodeDisplay", "↓ ↓ ↑ →",
    "Description", "Cápsula de munição.",
    "NameEn", "Resupply",
    "DescriptionEn", "Ammo resupply pod.",
    "IconFile", "Resupply_Stratagem_Icon.png"
),
"Rearme da águia", Map(
    "Category", "Missão",
    "Code", "Up, Up, Left, Up, Right",
    "CodeDisplay", "↑ ↑ ← ↑ →",
    "Description", "Reabastece munição Eagle.",
    "NameEn", "Eagle Rearm",
    "DescriptionEn", "Rearms Eagle stratagem payloads.",
    "IconFile", "Eagle_Rearm_Stratagem_Icon.png"
),
"Bomba Infernal NUX-223", Map(
    "Category", "Missão",
    "Code", "Down, Up, Left, Down, Up, Right, Down, Up",
    "CodeDisplay", "↓ ↑ ← ↓ ↑ → ↓ ↑",
    "Description", "Hellbomb para objetivos.",
    "NameEn", "NUX-223 Hellbomb",
    "DescriptionEn", "Hellbomb for mission objectives.",
    "IconFile", "Hellbomb_Stratagem_Icon_Background.png"
),
"Entrega SSSD", Map(
    "Category", "Missão",
    "Code", "Down, Down, Down, Up, Up",
    "CodeDisplay", "↓ ↓ ↓ ↑ ↑",
    "Description", "Entrega especial de suprimentos.",
    "NameEn", "SSSD Delivery",
    "DescriptionEn", "Special supply delivery.",
    "IconFile", "Reinforce_Stratagem_Icon_Background.png"
),
"Sonda sísmica", Map(
    "Category", "Missão",
    "Code", "Up, Up, Left, Right, Down, Down",
    "CodeDisplay", "↑ ↑ ← → ↓ ↓",
    "Description", "Detecta atividade sísmica.",
    "NameEn", "Seismic Probe",
    "DescriptionEn", "Detects seismic activity.",
    "IconFile", "Seismic_Probe_Stratagem_Icon.png"
),
"Carregar dados", Map(
    "Category", "Missão",
    "Code", "Left, Right, Up, Up, Up",
    "CodeDisplay", "← → ↑ ↑ ↑",
    "Description", "Upload de dados da missão.",
    "NameEn", "Upload Data",
    "DescriptionEn", "Uploads mission data.",
    "IconFile", "Upload_Data_Stratagem_Icon.png"
),
"Foco de iluminação", Map(
    "Category", "Missão",
    "Code", "Right, Right, Left, Left",
    "CodeDisplay", "→ → ← ←",
    "Description", "Sinalizadores de iluminação.",
    "NameEn", "Orbital Illumination Flare",
    "DescriptionEn", "Illumination flare signal.",
    "IconFile", "Orbital_Illumination_Flare_Stratagem_Icon_Background.png"
),
"Artilharia SEAF", Map(
    "Category", "Missão",
    "Code", "Right, Up, Up, Down",
    "CodeDisplay", "→ ↑ ↑ ↓",
    "Description", "Artilharia da frota SEAF.",
    "NameEn", "SEAF Artillery",
    "DescriptionEn", "SEAF fleet artillery strike.",
    "IconFile", "SEAF_Artillery_Stratagem_Icon.png"
),
"Bandeira da Super Terra", Map(
    "Category", "Missão",
    "Code", "Down, Up, Down, Up",
    "CodeDisplay", "↓ ↑ ↓ ↑",
    "Description", "Planta bandeira.",
    "NameEn", "Super Earth Flag",
    "DescriptionEn", "Plants the Super Earth flag.",
    "IconFile", "Super_Earth_Flag_Stratagem_Icon.png"
),
"Dark Fluid Vessel", Map(
    "Category", "Missão",
    "Code", "Up, Left, Right, Down, Up, Up",
    "CodeDisplay", "↑ ← → ↓ ↑ ↑",
    "Description", "Recipiente de fluido escuro.",
    "NameEn", "Dark Fluid Vessel",
    "DescriptionEn", "Dark Fluid containment vessel.",
    "IconFile", "Dark_Fluid_Vessel_Stratagem_Icon_Background.png"
),
"Broca Tectônica", Map(
    "Category", "Missão",
    "Code", "Up, Down, Up, Down, Up, Down",
    "CodeDisplay", "↑ ↓ ↑ ↓ ↑ ↓",
    "Description", "Broca tectônica.",
    "NameEn", "Tectonic Drill",
    "DescriptionEn", "Tectonic drill for missions.",
    "IconFile", "Drill_Stratagem_Icon.png"
),
"Broca Hive Breaker", Map(
    "Category", "Missão",
    "Code", "Left, Up, Down, Right, Down, Down",
    "CodeDisplay", "← ↑ ↓ → ↓ ↓",
    "Description", "Broca anti-colmeia.",
    "NameEn", "Hive Breaker Drill",
    "DescriptionEn", "Anti-hive drill.",
    "IconFile", "Drill_Stratagem_Icon.png"
),
"Broca de Prospecção", Map(
    "Category", "Missão",
    "Code", "Down, Down, Left, Right, Down, Down",
    "CodeDisplay", "↓ ↓ ← → ↓ ↓",
    "Description", "Broca de prospecção.",
    "NameEn", "Prospecting Drill",
    "DescriptionEn", "Prospecting drill.",
    "IconFile", "Drill_Stratagem_Icon.png"
),
"A/MG-43 Sentinela Mecânica", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Right, Up",
    "CodeDisplay", "↓ ↑ → → ↑",
    "Description", "Sentinela metralhadora.",
    "NameEn", "A/MG-43 Machine Gun Sentry",
    "DescriptionEn", "Automated machine gun sentry.",
    "IconFile", "Machine_Gun_Sentry_Stratagem_Icon.png"
),
"A/G-16 Sentinela Gatling", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Left",
    "CodeDisplay", "↓ ↑ → ←",
    "Description", "Sentinela gatling alto RPM.",
    "NameEn", "A/G-16 Gatling Sentry",
    "DescriptionEn", "High RPM gatling sentry.",
    "IconFile", "Gatling_Sentry_Stratagem_Icon.png"
),
"A/M-12 Sentinela de morteiro", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Right, Down",
    "CodeDisplay", "↓ ↑ → → ↓",
    "Description", "Morteiro de longo alcance.",
    "NameEn", "A/M-12 Mortar Sentry",
    "DescriptionEn", "Long-range mortar sentry.",
    "IconFile", "Mortar_Sentry_Stratagem_Icon.png"
),
"Sentinela de canhão automático A/AC-8", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Up, Left, Up",
    "CodeDisplay", "↓ ↑ → ↑ ← ↑",
    "Description", "Sentinela antitanque.",
    "NameEn", "A/AC-8 Autocannon Sentry",
    "DescriptionEn", "Anti-armor autocannon sentry.",
    "IconFile", "Autocannon_Sentry_Stratagem_Icon.png"
),
"A/MLS-4X Sentinela-foguete", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Right, Left",
    "CodeDisplay", "↓ ↑ → → ←",
    "Description", "Sentinela de foguetes.",
    "NameEn", "A/MLS-4X Rocket Sentry",
    "DescriptionEn", "Rocket launcher sentry.",
    "IconFile", "Rocket_Sentry_Stratagem_Icon.png"
),
"A/M-23 Sentinela EMS", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Down, Right",
    "CodeDisplay", "↓ ↑ → ↓ →",
    "Description", "Morteiro EMS atordoante.",
    "NameEn", "A/M-23 EMS Mortar Sentry",
    "DescriptionEn", "Stun mortar sentry.",
    "IconFile", "EMS_Mortar_Sentry_Stratagem_Icon.png"
),
"A/LAS-98 Sentinela Laser", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Down, Up, Right",
    "CodeDisplay", "↓ ↑ → ↓ ↑ →",
    "Description", "Sentinela laser.",
    "NameEn", "A/LAS-98 Laser Sentry",
    "DescriptionEn", "Laser sentry turret.",
    "IconFile", "Laser_Sentry_Stratagem_Icon.png"
),
"A/FLAM-40 Sentinela Chamas", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Down, Up, Up",
    "CodeDisplay", "↓ ↑ → ↓ ↑ ↑",
    "Description", "Sentinela lança-chamas.",
    "NameEn", "A/FLAM-40 Flame Sentry",
    "DescriptionEn", "Flamethrower sentry.",
    "IconFile", "Flame_Sentry_Stratagem_Icon.png"
),
"A/GM-17 Sentinela Gás", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Down, Left",
    "CodeDisplay", "↓ ↑ → ↓ ←",
    "Description", "Morteiro de gás.",
    "NameEn", "A/GM-17 Gas Mortar Sentry",
    "DescriptionEn", "Gas mortar sentry.",
    "IconFile", "Gas_Mortar_Sentry_Stratagem_Icon.png"
),
"A/ARC-3 Torre Tesla", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Up, Left, Right",
    "CodeDisplay", "↓ ↑ → ↑ ← →",
    "Description", "Torre de arco elétrico.",
    "NameEn", "A/ARC-3 Tesla Tower",
    "DescriptionEn", "Electrical arc tower.",
    "IconFile", "Tesla_Tower_Stratagem_Icon.png"
),
"Campo de minas antipessoal MD-6", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Up, Right",
    "CodeDisplay", "↓ ← ↑ →",
    "Description", "Minas antipessoal.",
    "NameEn", "MD-6 Anti-Personnel Minefield",
    "DescriptionEn", "Anti-personnel mines.",
    "IconFile", "Anti-Personnel_Minefield_Stratagem_Icon.png"
),
"Minas incendiárias MD-14", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Left, Down",
    "CodeDisplay", "↓ ← ← ↓",
    "Description", "Minas incendiárias.",
    "NameEn", "MD-I4 Incendiary Mines",
    "DescriptionEn", "Incendiary mines.",
    "IconFile", "Incendiary_Mines_Stratagem_Icon.png"
),
"Minas anti-tanque MD-17", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Up, Up",
    "CodeDisplay", "↓ ← ↑ ↑",
    "Description", "Minas anti-tanque.",
    "NameEn", "MD-17 Anti-Tank Mines",
    "DescriptionEn", "Anti-tank mines.",
    "IconFile", "Anti-Tank_Mines_Stratagem_Icon.png"
),
"Minas de gás MD-8", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Left, Right",
    "CodeDisplay", "↓ ← ← →",
    "Description", "Minas de gás.",
    "NameEn", "MD-8 Gas Mines",
    "DescriptionEn", "Gas mines.",
    "IconFile", "Gas_Mines_Stratagem_Icon.png"
),
"Relé do gerador de proteção FX-12", Map(
    "Category", "Ponte",
    "Code", "Down, Down, Left, Right, Left, Right",
    "CodeDisplay", "↓ ↓ ← → ← →",
    "Description", "Grande bolha de escudo.",
    "NameEn", "FX-12 Shield Generator Relay",
    "DescriptionEn", "Large shield bubble relay.",
    "IconFile", "Shield_Generator_Relay_Stratagem_Icon_Background.png"
),
"Colocação de E/MG-101 HMG", Map(
    "Category", "Ponte",
    "Code", "Down, Up, Left, Right, Right, Left",
    "CodeDisplay", "↓ ↑ ← → → ←",
    "Description", "Torre tripulada HMG.",
    "NameEn", "E/MG-101 HMG Emplacement",
    "DescriptionEn", "Manned HMG emplacement.",
    "IconFile", "HMG_Emplacement_Stratagem_Icon_Background.png"
),
"E/GL-21 Batalhão Granadeiro", Map(
    "Category", "Ponte",
    "Code", "Down, Right, Down, Left, Right",
    "CodeDisplay", "↓ → ↓ ← →",
    "Description", "Empacemento de granadas.",
    "NameEn", "E/GL-21 Grenadier Battlement",
    "DescriptionEn", "Grenade launcher emplacement.",
    "IconFile", "Grenadier_Battlement_Stratagem_Icon_Background.png"
),
"E/AT-12 Empacemento Anti-Tanque", Map(
    "Category", "Ponte",
    "Code", "Down, Up, Left, Right, Right, Right",
    "CodeDisplay", "↓ ↑ ← → → →",
    "Description", "Empacemento anti-tanque.",
    "NameEn", "E/AT-12 Anti-Tank Emplacement",
    "DescriptionEn", "Anti-tank emplacement.",
    "IconFile", "Anti-Tank_Emplacement_Stratagem_Icon_Background.png"
),
"Ataque de precisão orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Up",
    "CodeDisplay", "→ → ↑",
    "Description", "Disparo único de precisão.",
    "NameEn", "Orbital Precision Strike",
    "DescriptionEn", "Single precision orbital shot.",
    "IconFile", "Orbital_Precision_Strike_Stratagem_Icon.png"
),
"Barragem Gatling Orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Down, Left, Up, Up",
    "CodeDisplay", "→ ↓ ← ↑ ↑",
    "Description", "Tiros de alta rotação.",
    "NameEn", "Orbital Gatling Barrage",
    "DescriptionEn", "High rate-of-fire orbital barrage.",
    "IconFile", "Orbital_Gatling_Barrage_Stratagem_Icon.png"
),
"Ataque de gás orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Down, Right",
    "CodeDisplay", "→ → ↓ →",
    "Description", "Fumaça venenosa.",
    "NameEn", "Orbital Gas Strike",
    "DescriptionEn", "Poison gas strike.",
    "IconFile", "Orbital_Gas_Strike_Stratagem_Icon.png"
),
"Barragem Orbital HE 120mm", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Down, Left, Right, Down",
    "CodeDisplay", "→ → ↓ ← → ↓",
    "Description", "Salva pesada 120mm.",
    "NameEn", "Orbital 120mm HE Barrage",
    "DescriptionEn", "Heavy 120mm barrage.",
    "IconFile", "Orbital_120mm_HE_Barrage_Stratagem_Icon.png"
),
"Ataque de explosão aérea orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Right",
    "CodeDisplay", "→ → →",
    "Description", "Estilhaços letais AoE.",
    "NameEn", "Orbital Airburst Strike",
    "DescriptionEn", "Lethal shrapnel airburst.",
    "IconFile", "Orbital_Airburst_Strike_Stratagem_Icon.png"
),
"Ataque de fumaça orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Down, Up",
    "CodeDisplay", "→ → ↓ ↑",
    "Description", "Corta linha de visão.",
    "NameEn", "Orbital Smoke Strike",
    "DescriptionEn", "Smoke screen; blocks line of sight.",
    "IconFile", "Orbital_Smoke_Strike_Stratagem_Icon.png"
),
"Ataque EMS orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Left, Down",
    "CodeDisplay", "→ → ← ↓",
    "Description", "Nuvem estática atordoante.",
    "NameEn", "Orbital EMS Strike",
    "DescriptionEn", "Stunning static cloud.",
    "IconFile", "Orbital_EMS_Strike_Stratagem_Icon.png"
),
"Barragem Orbital HE 380mm", Map(
    "Category", "Ofensivas",
    "Code", "Right, Down, Up, Up, Left, Down, Down",
    "CodeDisplay", "→ ↓ ↑ ↑ ← ↓ ↓",
    "Description", "Salva pesada grande área.",
    "NameEn", "Orbital 380mm HE Barrage",
    "DescriptionEn", "Large-area heavy barrage.",
    "IconFile", "Orbital_380mm_HE_Barrage_Stratagem_Icon.png"
),
"Barragem de Caminhada Orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Down, Right, Down, Right, Down",
    "CodeDisplay", "→ ↓ → ↓ → ↓",
    "Description", "Salva que avança.",
    "NameEn", "Orbital Walking Barrage",
    "DescriptionEn", "Walking barrage pattern.",
    "IconFile", "Orbital_Walking_Barrage_Stratagem_Icon.png"
),
"Laser Orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Down, Up, Right, Down",
    "CodeDisplay", "→ ↓ ↑ → ↓",
    "Description", "Laser de alta potência.",
    "NameEn", "Orbital Laser",
    "DescriptionEn", "High-power orbital laser.",
    "IconFile", "Orbital_Laser_Stratagem_Icon.png"
),
"Barragem Napalm Orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Down, Left, Right, Up",
    "CodeDisplay", "→ → ↓ ← → ↑",
    "Description", "Barragem de napalm.",
    "NameEn", "Orbital Napalm Barrage",
    "DescriptionEn", "Napalm barrage.",
    "IconFile", "Orbital_Napalm_Barrage_Stratagem_Icon.png"
),
"Ataque de canhão de carril orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Up, Down, Down, Right",
    "CodeDisplay", "→ ↑ ↓ ↓ →",
    "Description", "Railcannon orbital.",
    "NameEn", "Orbital Railcannon Strike",
    "DescriptionEn", "Orbital railcannon strike.",
    "IconFile", "Orbital_Railcannon_Strike_Stratagem_Icon.png"
),
"Corrida de metralhadora da águia", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Right",
    "CodeDisplay", "↑ → →",
    "Description", "Disparo rápido contra alvos pequenos.",
    "NameEn", "Eagle Strafing Run",
    "DescriptionEn", "Quick strafing run against small targets.",
    "IconFile", "Eagle_Strafing_Run_Stratagem_Icon.png"
),
"Ataque Aéreo Águia", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Down, Right",
    "CodeDisplay", "↑ → ↓ →",
    "Description", "Barragem de bombas.",
    "NameEn", "Eagle Airstrike",
    "DescriptionEn", "Bombing run.",
    "IconFile", "Eagle_Airstrike_Stratagem_Icon.png"
),
"Bomba Cluster Águia", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Down, Down, Right",
    "CodeDisplay", "↑ → ↓ ↓ →",
    "Description", "Bombas coletivas.",
    "NameEn", "Eagle Cluster Bomb",
    "DescriptionEn", "Cluster bomb drop.",
    "IconFile", "Eagle_Cluster_Bomb_Stratagem_Icon.png"
),
"Ataque aéreo Eagle Napalm", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Down, Up",
    "CodeDisplay", "↑ → ↓ ↑",
    "Description", "Napalm horizontal.",
    "NameEn", "Eagle Napalm Airstrike",
    "DescriptionEn", "Horizontal napalm strike.",
    "IconFile", "Eagle_Napalm_Airstrike_Stratagem_Icon.png"
),
"Ataque de fumaça de águia", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Up, Down",
    "CodeDisplay", "↑ → ↑ ↓",
    "Description", "Nuvem de fumaça.",
    "NameEn", "Eagle Smoke Strike",
    "DescriptionEn", "Smoke cloud strike.",
    "IconFile", "Eagle_Smoke_Strike_Stratagem_Icon.png"
),
"Foguetes Eagle 110mm", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Up, Left",
    "CodeDisplay", "↑ → ↑ ←",
    "Description", "Foguetes concentrados.",
    "NameEn", "Eagle 110mm Rocket Pods",
    "DescriptionEn", "Concentrated rocket pods.",
    "IconFile", "Eagle_110mm_Rocket_Pods_Stratagem_Icon.png"
),
"Bomba Águia 500kg", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Down, Down, Down",
    "CodeDisplay", "↑ → ↓ ↓ ↓",
    "Description", "Bomba de dano extremo.",
    "NameEn", "Eagle 500kg Bomb",
    "DescriptionEn", "Extreme damage bomb.",
    "IconFile", "Eagle_500kg_Bomb_Stratagem_Icon.png"
),
"Mochila Gerador de Escudo", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Right, Left, Right",
    "CodeDisplay", "↓ ↑ ← → ← →",
    "Description", "Alias: SH-32 Shield Generator Pack.",
    "NameEn", "SH-32 Shield Generator Pack",
    "DescriptionEn", "Bubble shield over the Helldiver.",
    "IconFile", "Shield_Generator_Pack_Stratagem_Icon.png"
),
"Torre Tesla", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Up, Left, Right",
    "CodeDisplay", "↓ ↑ → ↑ ← →",
    "Description", "Alias: A/ARC-3 Torre Tesla.",
    "NameEn", "A/ARC-3 Tesla Tower",
    "DescriptionEn", "Electrical arc tower.",
    "IconFile", "Tesla_Tower_Stratagem_Icon.png"
),
"Ataque de Precisão Orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Up",
    "CodeDisplay", "→ → ↑",
    "Description", "Alias: Ataque de precisão orbital.",
    "NameEn", "Orbital Precision Strike",
    "DescriptionEn", "Single precision orbital shot.",
    "IconFile", "Orbital_Precision_Strike_Stratagem_Icon.png"
),
"Golpe de Fumaça Orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Down, Up",
    "CodeDisplay", "→ → ↓ ↑",
    "Description", "Alias: Ataque de fumaça orbital.",
    "NameEn", "Orbital Smoke Strike",
    "DescriptionEn", "Smoke screen; blocks line of sight.",
    "IconFile", "Orbital_Smoke_Strike_Stratagem_Icon.png"
),
"Localização HMG", Map(
    "Category", "Ponte",
    "Code", "Down, Up, Left, Right, Right, Left",
    "CodeDisplay", "↓ ↑ ← → → ←",
    "Description", "Alias: E/MG-101 HMG Emplacement.",
    "NameEn", "E/MG-101 HMG Emplacement",
    "DescriptionEn", "Manned HMG emplacement.",
    "IconFile", "HMG_Emplacement_Stratagem_Icon_Background.png"
),
"Relé Gerador de Blindagem", Map(
    "Category", "Ponte",
    "Code", "Down, Down, Left, Right, Left, Right",
    "CodeDisplay", "↓ ↓ ← → ← →",
    "Description", "Alias: FX-12 Shield Generator Relay.",
    "NameEn", "FX-12 Shield Generator Relay",
    "DescriptionEn", "Large shield bubble relay.",
    "IconFile", "Shield_Generator_Relay_Stratagem_Icon_Background.png"
),
"Sentinela Gatling", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Left",
    "CodeDisplay", "↓ ↑ → ←",
    "Description", "Alias: A/G-16 Sentinela Gatling.",
    "NameEn", "A/G-16 Gatling Sentry",
    "DescriptionEn", "High RPM gatling sentry.",
    "IconFile", "Gatling_Sentry_Stratagem_Icon.png"
),
"Sentinela de metralhadora", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Right, Up",
    "CodeDisplay", "↓ ↑ → → ↑",
    "Description", "Alias: A/MG-43 Sentinela Mecânica.",
    "NameEn", "A/MG-43 Machine Gun Sentry",
    "DescriptionEn", "Automated machine gun sentry.",
    "IconFile", "Machine_Gun_Sentry_Stratagem_Icon.png"
),
"Sentinela de Morteiro", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Right, Down",
    "CodeDisplay", "↓ ↑ → → ↓",
    "Description", "Alias: A/M-12 Sentinela de morteiro.",
    "NameEn", "A/M-12 Mortar Sentry",
    "DescriptionEn", "Long-range mortar sentry.",
    "IconFile", "Mortar_Sentry_Stratagem_Icon.png"
),
"Cão de guarda", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Up, Right, Down",
    "CodeDisplay", "↓ ↑ ← ↑ → ↓",
    "Description", "Alias: AX/AR-23 Cão de guarda.",
    "NameEn", "AX/AR-23 Guard Dog",
    "DescriptionEn", "Automaton drone with Liberator rifle.",
    "IconFile", "Guard_Dog_Stratagem_Icon_Background.png"
),
"Cão de guarda Rover", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Up, Right, Right",
    "CodeDisplay", "↓ ↑ ← ↑ → →",
    "Description", "Alias: AX/LAS-5 Rover.",
    "NameEn", "AX/LAS-5 Rover",
    "DescriptionEn", "Automaton drone with laser.",
    "IconFile", "Rover_Stratagem_Icon_Background.png"
),
"Pacote de suprimentos", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Up, Down",
    "CodeDisplay", "↓ ← ↓ ↑ ↑ ↓",
    "Description", "Alias: B-1 Supply Pack.",
    "NameEn", "B-1 Supply Pack",
    "DescriptionEn", "Backpack with ammo resupply bags.",
    "IconFile", "Supply_Pack_Stratagem_Icon_Background.png"
),
"Campo minado antipessoal", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Up, Right",
    "CodeDisplay", "↓ ← ↑ →",
    "Description", "Alias: MD-6 Anti-Personnel Minefield.",
    "NameEn", "MD-6 Anti-Personnel Minefield",
    "DescriptionEn", "Anti-personnel mines.",
    "IconFile", "Anti-Personnel_Minefield_Stratagem_Icon.png"
),
"Minas Incendiárias", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Left, Down",
    "CodeDisplay", "↓ ← ← ↓",
    "Description", "Alias: MD-I4 Incendiary Mines.",
    "NameEn", "MD-I4 Incendiary Mines",
    "DescriptionEn", "Incendiary mines.",
    "IconFile", "Incendiary_Mines_Stratagem_Icon.png"
),
"Lançador de granada", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Up, Left, Down",
    "CodeDisplay", "↓ ← ↑ ← ↓",
    "Description", "Alias: GL-21 Grenade Launcher.",
    "NameEn", "GL-21 Grenade Launcher",
    "DescriptionEn", "High-explosive grenade launcher.",
    "IconFile", "Grenade_Launcher_Stratagem_Icon.png"
),
"Canhão Laser", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Left",
    "CodeDisplay", "↓ ← ↓ ↑ ←",
    "Description", "Alias: LAS-98 Laser Cannon.",
    "NameEn", "LAS-98 Laser Cannon",
    "DescriptionEn", "Long-range laser; overheats with sustained fire.",
    "IconFile", "Laser_Cannon_Stratagem_Icon.png"
),
"Lançador de arco", Map(
    "Category", "Suprimentos",
    "Code", "Down, Right, Down, Up, Left, Left",
    "CodeDisplay", "↓ → ↓ ↑ ← ←",
    "Description", "Alias: ARC-3 Arc Thrower.",
    "NameEn", "ARC-3 Arc Thrower",
    "DescriptionEn", "Medium-to-long range electrical arc weapon.",
    "IconFile", "Arc_Thrower_Stratagem_Icon.png"
),
"Mochila Escudo Balístico", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Down, Up, Left",
    "CodeDisplay", "↓ ← ↓ ↓ ↑ ←",
    "Description", "Alias: SH-20 Ballistic Shield.",
    "NameEn", "SH-20 Ballistic Shield Backpack",
    "DescriptionEn", "One-handed ballistic shield.",
    "IconFile", "Ballistic_Shield_Backpack_Stratagem_Icon.png"
),
"Pacote Gerador de Escudo", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Right, Left, Right",
    "CodeDisplay", "↓ ↑ ← → ← →",
    "Description", "Alias: SH-32.",
    "NameEn", "SH-32 Shield Generator Pack",
    "DescriptionEn", "Bubble shield over the Helldiver.",
    "IconFile", "Shield_Generator_Pack_Stratagem_Icon.png"
),
"Sentinela de Canhão Automático", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Up, Left, Up",
    "CodeDisplay", "↓ ↑ → ↑ ← ↑",
    "Description", "Alias: A/AC-8 Autocannon Sentry.",
    "NameEn", "A/AC-8 Autocannon Sentry",
    "DescriptionEn", "Anti-armor autocannon sentry.",
    "IconFile", "Autocannon_Sentry_Stratagem_Icon.png"
),
"Sentinela de foguete", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Right, Left",
    "CodeDisplay", "↓ ↑ → → ←",
    "Description", "Alias: A/MLS-4X Rocket Sentry.",
    "NameEn", "A/MLS-4X Rocket Sentry",
    "DescriptionEn", "Rocket launcher sentry.",
    "IconFile", "Rocket_Sentry_Stratagem_Icon.png"
),
"Sentinela de morteiro EMS", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Down, Right",
    "CodeDisplay", "↓ ↑ → ↓ →",
    "Description", "Alias: A/M-23 EMS Mortar Sentry.",
    "NameEn", "A/M-23 EMS Mortar Sentry",
    "DescriptionEn", "Stun mortar sentry.",
    "IconFile", "EMS_Mortar_Sentry_Stratagem_Icon.png"
),
"Canhão elétrico ARC-12", Map(
    "Category", "Suprimentos",
    "Code", "Down, Right, Down, Up, Left, Right",
    "CodeDisplay", "↓ → ↓ ↑ ← →",
    "Description", "Alias legado: na verdade RS-422 Railgun.",
    "NameEn", "RS-422 Railgun",
    "DescriptionEn", "Experimental railgun; safe and unsafe firing modes.",
    "IconFile", "Railgun_Stratagem_Icon.png"
),
)

global stratAliasToCanonical := Map()

IsStratAlias(data) {
    d := data["Description"]
    return InStr(d, "Alias:") || InStr(d, "Alias legado")
}

BuildStratCanonicalIndex() {
    global STRATAGEM_DATA, stratAliasToCanonical
    codeToName := Map()

    for name, data in STRATAGEM_DATA {
        if IsStratAlias(data)
            continue
        code := data["Code"]
        if !codeToName.Has(code)
            codeToName[code] := name
    }

    stratAliasToCanonical := Map()
    for name, data in STRATAGEM_DATA {
        code := data["Code"]
        stratAliasToCanonical[name] := codeToName.Has(code) ? codeToName[code] : name
    }
}

ResolveStrat(name) {
    global stratAliasToCanonical
    return stratAliasToCanonical.Has(name) ? stratAliasToCanonical[name] : name
}

IsCanonicalStrat(name) {
    return ResolveStrat(name) = name
}
