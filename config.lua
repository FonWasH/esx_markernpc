Config = {}

Config.Peds = {
    {
        --[[ Default NPC Config

        name = 'Contact',
        id = 133,
        pos = vector3(-573.52, 293.19, 78.3),
        h = 225.05,
        color = 2,
        scale = 0.8,
        model = 's_m_y_dealer_01', -- model of the npc
        animation = 'WORLD_HUMAN_DRINKING', -- animation
        resource = 'changeme', -- name of the resource linked
        onEnter = 'changeme', -- name of trigger event when player interact with the npc
        onEnterText = "changeme", -- notification when player is close to the npc
        onExit = 'changeme', -- name of trigger event when player leave npc (if not necessary delete this line)
        serverSide = false, -- trigger server-side or client-side event
        policeLock = false -- lock for police

        ]]--
    },
    {
        name = 'Mac à Dames',
        id = 279,
        pos = vector3(1465.32, 6349.36, 22.86),
        h = 8.4,
        color = 1,
        scale = 0.8,
        model = 's_f_y_hooker_01',
        animation = 'WORLD_HUMAN_SMOKING',
        resource = 'esx_procurer',
        onEnter = 'startWorking',
        onEnterText = "Appuyez sur ~INPUT_CONTEXT~ pour ~y~parler~w~ avec la prostitué.",
        serverSide = false,
        policeLock = true
    },
    {
        name = "Bookmaker",
        id = 229,
        pos = vector3(130.12,-1324.99,28.2),
        h = 306.24,
        color = 6,
        scale = 0.8,
        model = "g_m_m_armboss_01",
        animation = "WORLD_HUMAN_SMOKING",
        resource = "esx_streetfight",
        onEnter = "openMenu",
        onEnterText = "Appuyez sur ~INPUT_CONTEXT~ pour ~g~parier~w~ ou pour ~y~combattre~w~.",
        onExit = 'closeMenu',
        serverSide = false,
        policeLock = true
    }
}
