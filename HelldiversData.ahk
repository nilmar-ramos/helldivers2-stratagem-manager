#Requires AutoHotkey v2.0

global STRATAGEM_DATA := Map(
; ═══════════════════════════════════════════════════════════════
; SUPRIMENTOS (Patriotic Administration Center)
; ═══════════════════════════════════════════════════════════════

"Pacote de salto LIFT-850", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Up, Down, Up",
    "CodeDisplay", "↓ ↑ ↑ ↓ ↑",
    "Description", "Ferramenta utilitária para saltar em áreas de difícil acesso sem sofrer danos de queda."
),

"B-1 Conjunto de fornecimento", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Up, Down",
    "CodeDisplay", "↓ ← ↓ ↑ ↑ ↓",
    "Description", "Uma mochila com quatro bolsas de munição."
),

"AX/LAS-5 Cão de guarda Rover", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Up, Right, Right",
    "CodeDisplay", "↓ ↑ ← ↑ → →",
    "Description", "Um drone que dispara um laser e segue o mergulhador."
),

"Mochila de proteção balística SH-20", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Down, Up, Left",
    "CodeDisplay", "↓ ← ↓ ↓ ↑ ←",
    "Description", "Um escudo de uso com uma mão para o mergulhador contra projéteis que se aproximam."
),

"AX/AR-23 Cão de guarda", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Up, Right, Down",
    "CodeDisplay", "↓ ↑ ← ↑ → ↓",
    "Description", "Um drone que dispara um Rifle de Assalto Liberator de penetração média."
),

"Metralhadora MG-43", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Right",
    "CodeDisplay", "↓ ← ↓ ↑ →",
    "Description", "Alto RPM, mas baixa velocidade de recarga MG."
),

"Espingarda anti-material APW-1", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Right, Up, Down",
    "CodeDisplay", "↓ ← → ↑ ↓",
    "Description", "Um poderoso Sniper que pode atirar em inimigos com armadura leve."
),

"M-105 Stalwart", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Up, Left",
    "CodeDisplay", "↓ ← ↓ ↑ ↑ ←",
    "Description", "Alto RPM e rápida cadência de tiro MG."
),

"EAST-17 Anti-Tanque Expendível", Map(
    "Category", "Suprimentos",
    "Code", "Down, Down, Left, Up, Right",
    "CodeDisplay", "↓ ↓ ← ↑ →",
    "Description", "Chama dois RPGs que podem ser usados uma vez antes de serem descartados."
),

"Carabina sem recuo GR-8", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Right, Right, Left",
    "CodeDisplay", "↓ ← → → ←",
    "Description", "Um RPG de altíssimo dano e velocidade de recarga lenta que vem com a arma e uma mochila."
),

"FLAM-40 Lança-chamas", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Up, Down, Up",
    "CodeDisplay", "↓ ← ↑ ↓ ↑",
    "Description", "Uma arma lança-chamas que é destrutiva contra insetos próximos."
),

"Canhão automático AC-8", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Up, Right",
    "CodeDisplay", "↓ ← ↓ ↑ ↑ →",
    "Description", "Canhão de ombro com alto dano e velocidade de recarga rápida, eficaz contra veículos leves, médios e pesados."
),

"Canhão elétrico ARC-12", Map(
    "Category", "Suprimentos",
    "Code", "Down, Right, Left, Down, Up, Left, Right",
    "CodeDisplay", "↓ → ← ↓ ↑ ← →",
    "Description", "Uma arma de alto dano que carrega um feixe poderoso para penetrar na blindagem mais espessa do veículo."
),

"Lança FAF-14", Map(
    "Category", "Suprimentos",
    "Code", "Down, Down, Up, Down, Down",
    "CodeDisplay", "↓ ↓ ↑ ↓ ↓",
    "Description", "Um RPG homing que é muito mais poderoso que um rifle sem recuo, mas igualmente lento para recarregar."
),

"Lançador de granadas GL-21", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Up, Left, Down",
    "CodeDisplay", "↓ ← ↑ ← ↓",
    "Description", "Uma granada de alta potência lançada com dois carregadores."
),

"Canhão laser LAS-98", Map(
    "Category", "Suprimentos",
    "Code", "Down, Left, Down, Up, Left",
    "CodeDisplay", "↓ ← ↓ ↑ ←",
    "Description", "Canhão Laser de longo alcance que aquece se usado por muito tempo."
),

"ARC-3 Lançador de arco", Map(
    "Category", "Suprimentos",
    "Code", "Down, Right, Down, Up, Left, Left",
    "CodeDisplay", "↓ → ↓ ↑ ← ←",
    "Description", "Dispara um arco mortal em distâncias de médio a longo alcance."
),

"Canhão Quasar LAS-99", Map(
    "Category", "Suprimentos",
    "Code", "Down, Down, Up, Left, Right",
    "CodeDisplay", "↓ ↓ ↑ ← →",
    "Description", "Canhão laser de altíssimo dano com recarga lenta."
),

"EXO-45 Patriot Exosuit", Map(
    "Category", "Suprimentos",
    "Code", "Left, Down, Right, Up, Left, Down, Down",
    "CodeDisplay", "← ↓ → ↑ ← ↓ ↓",
    "Description", "Exoesqueleto blindado com metralhadora e lançador de foguetes."
),

"Mochila Gerador de Escudo", Map(
    "Category", "Suprimentos",
    "Code", "Down, Up, Left, Right, Left, Right",
    "CodeDisplay", "↓ ↑ ← → ← →",
    "Description", "Uma mochila que cria uma bolha de escudo sobre o mergulhador."
),

; ═══════════════════════════════════════════════════════════════
; MISSÃO (Mission Stratagems)
; ═══════════════════════════════════════════════════════════════

"Reforçar", Map(
    "Category", "Missão",
    "Code", "Up, Down, Right, Left, Up",
    "CodeDisplay", "↑ ↓ → ← ↑",
    "Description", "Chama de volta companheiros de equipe mortos para a ação em campo."
),

"Farol SOS", Map(
    "Category", "Missão",
    "Code", "Up, Down, Right, Left",
    "CodeDisplay", "↑ ↓ → ←",
    "Description", "Chama um farol que ajuda a preencher um elenco de quatro homens em seu time."
),

"Reabastecimento", Map(
    "Category", "Missão",
    "Code", "Down, Down, Up, Right",
    "CodeDisplay", "↓ ↓ ↑ →",
    "Description", "Traz uma cápsula de munição para mergulhadores."
),

"Bomba Infernal NUX-223", Map(
    "Category", "Missão",
    "Code", "Down, Up, Left, Down, Up, Right, Down, Up",
    "CodeDisplay", "↓ ↑ ← ↓ ↑ → ↓ ↑",
    "Description", "Chama um dispositivo explosivo Hellbomb para destruir estações desonestas."
),

"Entrega SSSD", Map(
    "Category", "Missão",
    "Code", "Down, Down, Down, Up, Up",
    "CodeDisplay", "↓ ↓ ↓ ↑ ↑",
    "Description", "Entrega especial de suprimentos."
),

"Sonda sísmica", Map(
    "Category", "Missão",
    "Code", "Up, Up, Left, Right, Down, Down",
    "CodeDisplay", "↑ ↑ ← → ↓ ↓",
    "Description", "Detecta atividade sísmica na área."
),

"Carregar dados", Map(
    "Category", "Missão",
    "Code", "Left, Right, Up, Up, Up",
    "CodeDisplay", "← → ↑ ↑ ↑",
    "Description", "Carrega dados da missão."
),

"Rearme da águia", Map(
    "Category", "Missão",
    "Code", "Up, Up, Left, Up, Right",
    "CodeDisplay", "↑ ↑ ← ↑ →",
    "Description", "Reabastece munição de estratagemas da Águia."
),

"Foco de iluminação", Map(
    "Category", "Missão",
    "Code", "Right, Right, Left, Left",
    "CodeDisplay", "→ → ← ←",
    "Description", "Ilumina a área com sinalizadores."
),

"Artilharia SEAF", Map(
    "Category", "Missão",
    "Code", "Right, Up, Up, Down",
    "CodeDisplay", "→ ↑ ↑ ↓",
    "Description", "Chama artilharia da frota SEAF."
),

"Bandeira da Super Terra", Map(
    "Category", "Missão",
    "Code", "Down, Up, Down, Up",
    "CodeDisplay", "↓ ↑ ↓ ↑",
    "Description", "Planta a bandeira da Super Terra."
),

; ═══════════════════════════════════════════════════════════════
; DEFENSIVAS (Defensive Stratagems)
; ═══════════════════════════════════════════════════════════════

"Colocação de E/MG-101 HMG", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Left, Right, Right, Left",
    "CodeDisplay", "↓ ↑ ← → → ←",
    "Description", "Uma torre tripulada eficaz contra veículos blindados leves e médios."
),

"Relé do gerador de proteção FX-12", Map(
    "Category", "Defensivas",
    "Code", "Down, Down, Left, Right, Left, Right",
    "CodeDisplay", "↓ ↓ ← → ← →",
    "Description", "Cria uma grande bolha de escudo que ricocheteia nos projéteis que chegam."
),

"A/ARC-3 Torre Tesla", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Up, Left, Right",
    "CodeDisplay", "↓ ↑ → ↑ ← →",
    "Description", "Uma torre estacionária que libera arco em um raio próximo."
),

"Campo de minas antipessoal MD-6", Map(
    "Category", "Defensivas",
    "Code", "Down, Left, Up, Right",
    "CodeDisplay", "↓ ← ↑ →",
    "Description", "Abrange uma área em minas."
),

"Minas incendiárias MD-14", Map(
    "Category", "Defensivas",
    "Code", "Down, Left, Left, Down",
    "CodeDisplay", "↓ ← ← ↓",
    "Description", "Abrange uma área em minas incendiárias."
),

"A/MG-43 Sentinela Mecânica", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Right, Up",
    "CodeDisplay", "↓ ↑ → → ↑",
    "Description", "Uma torre de disparo lento que pode matar facilmente alvos pequenos e médios."
),

"A/G-16 Sentinela Gatling", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Left",
    "CodeDisplay", "↓ ↑ → ←",
    "Description", "Uma torre de alto RPM que mata alvos mais rapidamente."
),

"A/M-12 Sentinela de morteiro", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Right, Down",
    "CodeDisplay", "↓ ↑ → → ↓",
    "Description", "Uma torre que dispara projéteis aéreos para destruir alvos de longo alcance."
),

"Sentinela de canhão automático A/AC-8", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Up, Left, Up",
    "CodeDisplay", "↓ ↑ → ↑ ← ↑",
    "Description", "Esta torre dispara projéteis antitanque, que são altamente eficazes contra veículos blindados médios a pesados."
),

"A/MLS-4X Sentinela-foguete", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Right, Left",
    "CodeDisplay", "↓ ↑ → → ←",
    "Description", "Uma torre que dispara a salva de foguetes contra os alvos."
),

"A/M-23 Sentinela EMS", Map(
    "Category", "Defensivas",
    "Code", "Down, Up, Right, Down, Right",
    "CodeDisplay", "↓ ↑ → ↓ →",
    "Description", "Uma torre de morteiro que dispara projéteis EMS que atordoam os inimigos."
),

; ═══════════════════════════════════════════════════════════════
; OFENSIVAS ORBITAIS (Orbital Cannons)
; ═══════════════════════════════════════════════════════════════

"Barragem Gatling Orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Down, Left, Up, Up",
    "CodeDisplay", "→ ↓ ← ↑ ↑",
    "Description", "O Destroyer dispara tiros de alta rotação."
),

"Ataque de explosão aérea orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Right",
    "CodeDisplay", "→ → →",
    "Description", "O Destroyer dispara projéteis de estilhaços mais letais que são úteis para danos AoE."
),

"Barragem Orbital HE de 120 mm", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Down, Left, Right, Down",
    "CodeDisplay", "→ → ↓ ← → ↓",
    "Description", "Salva pesada que aniquila uma pequena área."
),

"Barragem Orbital HE 380mm", Map(
    "Category", "Ofensivas",
    "Code", "Right, Down, Up, Up, Left, Down, Down",
    "CodeDisplay", "→ ↓ ↑ ↑ ← ↓ ↓",
    "Description", "O Destroyer dispara salvas pesadas sobre uma grande área."
),

"Barragem de Caminhada Orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Down, Left, Right, Down",
    "CodeDisplay", "→ → ↓ ← → ↓",
    "Description", "Salva pesada que continua avançando pela frente onde você lança o Estratégia."
),

"Laser Orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Down, Up, Right, Down",
    "CodeDisplay", "→ ↓ ↑ → ↓",
    "Description", "Um laser de alta potência disparado do Destruidor e usado melhor para AoE ou para derreter alvos maiores."
),

"Ataque de canhão de carril orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Up, Down, Down, Right",
    "CodeDisplay", "→ ↑ ↓ ↓ →",
    "Description", "O Destroyer dispara um Railcannon e aniquila o maior alvo na área."
),

"Ataque de precisão orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Up",
    "CodeDisplay", "→ → ↑",
    "Description", "Único disparo de salva do Destruidor."
),

"Ataque de gás orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Down, Right",
    "CodeDisplay", "→ → ↓ →",
    "Description", "Envolve uma área com fumaça venenosa."
),

"Ataque EMS orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Left, Down",
    "CodeDisplay", "→ → ← ↓",
    "Description", "Libera cargas de nuvem estática para atordoar os inimigos."
),

"Ataque de fumaça orbital", Map(
    "Category", "Ofensivas",
    "Code", "Right, Right, Down, Up",
    "CodeDisplay", "→ → ↓ ↑",
    "Description", "Quebra a linha de visão inimiga, envolvendo a área em fumaça."
),

; ═══════════════════════════════════════════════════════════════
; HANGAR (Eagle Stratagems)
; ═══════════════════════════════════════════════════════════════

"Corrida de metralhadora da águia", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Right",
    "CodeDisplay", "↑ → →",
    "Description", "Um disparo rápido para eliminar alvos pequenos."
),

"Ataque Aéreo Águia", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Down, Right",
    "CodeDisplay", "↑ → ↓ →",
    "Description", "Chove uma barragem de bombas sobre uma grande área."
),

"Bomba Cluster Águia", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Down, Down, Right",
    "CodeDisplay", "↑ → ↓ ↓ →",
    "Description", "Dispara pequenas bombas coletivas para destruir alvos pequenos e médios."
),

"Ataque aéreo Eagle Napalm", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Down, Up",
    "CodeDisplay", "↑ → ↓ ↑",
    "Description", "Cobre o chão com fogo horizontal e impede que os inimigos o atravessem."
),

"Ataque de fumaça de águia", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Up, Down",
    "CodeDisplay", "↑ → ↑ ↓",
    "Description", "Envolve a área na nuvem de fumaça para cegar os inimigos."
),

"Foguetes Eagle 110mm", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Up, Left",
    "CodeDisplay", "↑ → ↑ ←",
    "Description", "Bombas-foguete concentradas em uma pequena área."
),

"Bomba Águia 500kg", Map(
    "Category", "Hangar",
    "Code", "Up, Right, Down, Down, Down",
    "CodeDisplay", "↑ → ↓ ↓ ↓",
    "Description", "Uma bomba de dano muito alto que pode até mesmo disparar um Titã Bile."
),

; ═══════════════════════════════════════════════════════════════
; PONTE (Bridge Stratagems)
; ═══════════════════════════════════════════════════════════════

"Ataque de Precisão Orbital", Map(
    "Category", "Ponte",
    "Code", "Right, Right, Up",
    "CodeDisplay", "→ → ↑",
    "Description", "Único disparo de salva do Destruidor."
),

"Ataque de gás orbital", Map(
    "Category", "Ponte",
    "Code", "Right, Right, Down, Right",
    "CodeDisplay", "→ → ↓ →",
    "Description", "Envolve uma área com fumaça venenosa."
),

"Ataque EMS orbital", Map(
    "Category", "Ponte",
    "Code", "Right, Right, Left, Down",
    "CodeDisplay", "→ → ← ↓",
    "Description", "Libera cargas de nuvem estática para atordoar os inimigos."
),

"Golpe de Fumaça Orbital", Map(
    "Category", "Ponte",
    "Code", "Right, Right, Down, Up",
    "CodeDisplay", "→ → ↓ ↑",
    "Description", "Quebra a linha de visão inimiga, envolvendo a área em fumaça."
),

"Localização HMG", Map(
    "Category", "Ponte",
    "Code", "Down, Up, Left, Right, Right, Left",
    "CodeDisplay", "↓ ↑ ← → → ←",
    "Description", "Uma torre tripulada eficaz contra veículos blindados leves e médios."
),

"Relé Gerador de Blindagem", Map(
    "Category", "Ponte",
    "Code", "Down, Up, Left, Down, Right, Right",
    "CodeDisplay", "↓ ↑ ← ↓ → →",
    "Description", "Cria uma grande bolha de escudo que ricocheteia nos projéteis que chegam."
),

"Torre Tesla", Map(
    "Category", "Ponte",
    "Code", "Down, Up, Right, Up, Left, Right",
    "CodeDisplay", "↓ ↑ → ↑ ← →",
    "Description", "Uma torre estacionária que libera arco em um raio próximo."
),

; ═══════════════════════════════════════════════════════════════
; ENGENHARIA (Engineering Bay)
; ═══════════════════════════════════════════════════════════════

"Campo minado antipessoal", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Up, Right",
    "CodeDisplay", "↓ ← ↑ →",
    "Description", "Abrange uma área em minas."
),

"Pacote de suprimentos", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Down, Up, Up, Down",
    "CodeDisplay", "↓ ← ↓ ↑ ↑ ↓",
    "Description", "Uma mochila com quatro bolsas de munição."
),

"Lançador de granada", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Up, Left, Down",
    "CodeDisplay", "↓ ← ↑ ← ↓",
    "Description", "Uma granada de alta potência lançada com dois carregadores."
),

"Canhão Laser", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Down, Up, Left",
    "CodeDisplay", "↓ ← ↓ ↑ ←",
    "Description", "Canhão Laser de longo alcance que aquece se usado por muito tempo."
),

"Minas Incendiárias", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Left, Down",
    "CodeDisplay", "↓ ← ← ↓",
    "Description", "Abrange uma área em minas incendiárias."
),

"Cão de guarda Rover", Map(
    "Category", "Engenharia",
    "Code", "Down, Up, Left, Up, Right, Right",
    "CodeDisplay", "↓ ↑ ← ↑ → →",
    "Description", "Um drone que dispara um laser e segue o mergulhador."
),

"Mochila Escudo Balístico", Map(
    "Category", "Engenharia",
    "Code", "Down, Left, Up, Up, Right",
    "CodeDisplay", "↓ ← ↑ ↑ →",
    "Description", "Um escudo de uso com uma mão para o mergulhador contra projéteis que se aproximam."
),

"Lançador de arco", Map(
    "Category", "Engenharia",
    "Code", "Down, Right, Up, Left, Down",
    "CodeDisplay", "↓ → ↑ ← ↓",
    "Description", "Dispara um arco mortal em distâncias de médio a longo alcance."
),

"Pacote Gerador de Escudo", Map(
    "Category", "Engenharia",
    "Code", "Down, Up, Left, Right, Left, Right",
    "CodeDisplay", "↓ ↑ ← → ← →",
    "Description", "Uma mochila que cria uma bolha de escudo sobre o mergulhador."
),

; ═══════════════════════════════════════════════════════════════
; OFICINA ROBÓTICA (Robotics Workshop)
; ═══════════════════════════════════════════════════════════════

"Sentinela de metralhadora", Map(
    "Category", "Oficina",
    "Code", "Down, Up, Right, Right, Up",
    "CodeDisplay", "↓ ↑ → → ↑",
    "Description", "Uma torre de disparo lento que pode matar facilmente alvos pequenos e médios."
),

"Sentinela Gatling", Map(
    "Category", "Oficina",
    "Code", "Down, Up, Right, Left",
    "CodeDisplay", "↓ ↑ → ←",
    "Description", "Uma torre de alto RPM que mata alvos mais rapidamente."
),

"Sentinela de Morteiro", Map(
    "Category", "Oficina",
    "Code", "Down, Up, Right, Right, Down",
    "CodeDisplay", "↓ ↑ → → ↓",
    "Description", "Uma torre que dispara projéteis aéreos para destruir alvos de longo alcance."
),

"Cão de guarda", Map(
    "Category", "Oficina",
    "Code", "Down, Up, Left, Up, Right, Down",
    "CodeDisplay", "↓ ↑ ← ↑ → ↓",
    "Description", "Um drone que dispara um Rifle de Assalto Liberator de penetração média."
),

"Sentinela de Canhão Automático", Map(
    "Category", "Oficina",
    "Code", "Down, Up, Right, Up, Left, Up",
    "CodeDisplay", "↓ ↑ → ↑ ← ↑",
    "Description", "Esta torre dispara projéteis antitanque, que são altamente eficazes contra veículos blindados médios a pesados."
),

"Sentinela de foguete", Map(
    "Category", "Oficina",
    "Code", "Down, Up, Right, Right, Left",
    "CodeDisplay", "↓ ↑ → → ←",
    "Description", "Uma torre que dispara a salva de foguetes contra os alvos."
),

"Sentinela de morteiro EMS", Map(
    "Category", "Oficina",
    "Code", "Down, Down, Up, Up, Left",
    "CodeDisplay", "↓ ↓ ↑ ↑ ←",
    "Description", "Uma torre de morteiro que dispara projéteis EMS que atordoam os inimigos."
)
)