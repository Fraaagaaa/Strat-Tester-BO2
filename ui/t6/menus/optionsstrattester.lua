-- ==========================================================
-- STRAT TESTER BO2 - MENU PRINCIPAL
-- ==========================================================

local mapname, gametype, startlocation
local isDepot, isFarm, isTown, isTranzit, isNuketown, isDieRise, isMob, isBuried, isOrigins, isSurvival

CoD.StratTester = {}
CoD.StratTester.CurrentTabIndex = 1
CoD.StratTester.NeedVidRestart = false
CoD.StratTester.NeedPicmip = false
CoD.StratTester.NeedSndRestart = false

CoD.StratTester.StartPerkList = {
    "specialty_armorvest",
    "specialty_rof",
    "specialty_fastreload",
    "specialty_longersprint",
    "specialty_quickrevive",
    "specialty_additionalprimaryweapon",
    "specialty_finalstand",
    "specialty_grenadepulldeath",
    "specialty_flakjacket",
    "specialty_deadshot",
    "specialty_nomotionsensor"
}

CoD.StratTester.RefreshMapFlags = function ()
    mapname = UIExpression.DvarString( nil, "mapname" )
	gametype = UIExpression.DvarString( nil, "ui_gametype")
	startlocation = UIExpression.DvarString( nil, "ui_zm_mapstartlocation")

    isDepot    = (mapname == "zm_transit" and gametype == "zstandard" and startlocation == "transit")
    isFarm     =  startlocation == "farm"
    isTown     =  startlocation == "town"
    isTranzit  = (mapname == "zm_transit" and gametype == "zclassic")
    isNuketown = (mapname == "zm_nuked")
    isDieRise  = (mapname == "zm_highrise")
    isMob      = (mapname == "zm_prison")
    isBuried   = (mapname == "zm_buried")
    isOrigins  = (mapname == "zm_tomb")
    isSurvival = (isDepot or isFarm or isTown or isNuketown)
end


CoD.StratTester.Back = function ( element, event )
	element:goBack( event.controller )
end

CoD.StratTester.TabChanged = function ( Widget, SettingsTab )
	Widget.buttonList = Widget.tabManager.buttonList
	local NextFocusableTab = Widget.buttonList:getFirstChild()
	while NextFocusableTab and not NextFocusableTab.m_focusable do
		NextFocusableTab = NextFocusableTab:getNextSibling()
	end
	if NextFocusableTab ~= nil then
		NextFocusableTab:processEvent( { name = "gain_focus" } )
	end
	CoD.StratTester.CurrentTabIndex = SettingsTab.tabIndex
end

CoD.StratTester.OnDvarChanged = function ( choice, isUserRequest )
	if isUserRequest ~= true then
		return 
	end

	local dvarName = choice.parentSelectorButton.m_profileVarName
	local value = choice.value

	Engine.SetDvar( dvarName, value )
end

CoD.StratTester.OnToggleChanged = function ( choice, isUserRequest )
    if isUserRequest ~= true then return end

    local controller = choice.parentSelectorButton.m_currentController
    local dvarName = choice.parentSelectorButton.m_profileVarName
    local moduleName = choice.parentSelectorButton.m_stModule

    Engine.SetDvar( dvarName, choice.value )

    if moduleName ~= nil then
        CoD.StratTester.send_response( controller, moduleName, "set", { dvarName .. ":" .. tostring(choice.value) } )
    end
end

CoD.StratTester.AddChoices_OnOrOff = function ( selector, defaultVal, module )
    selector.m_stModule = module

    selector:addChoice(Engine.Localize("ST_MENU_OFF"), 0, nil, CoD.StratTester.OnToggleChanged )
    selector:addChoice(Engine.Localize("ST_MENU_ON"), 1, nil, CoD.StratTester.OnToggleChanged )

    local dvarName = selector.m_profileVarName
    local currentVal = UIExpression.DvarInt( nil, dvarName )

    if currentVal == nil or UIExpression.DvarString( nil, dvarName ) == "" then
        currentVal = defaultVal
        Engine.SetDvar( dvarName, currentVal )
    end

    selector:setChoice( currentVal )
end

CoD.StratTester.OnNotargetChanged = function ( choice, isUserRequest )
    if isUserRequest ~= true then return end
    local controller = choice.parentSelectorButton.m_currentController
    Engine.SendMenuResponse( controller, "restartgamepopup", "stnotarget+" .. tostring( choice.value ) )
    Engine.SetDvar( choice.parentSelectorButton.m_profileVarName, choice.value )
end


CoD.StratTester.SetPerkDvarPersistent = function ( controller, dvarName, value )
    Engine.SetDvar( dvarName, value )

    if controller == nil then
        controller = 0
    end

    Engine.Exec( controller, "seta " .. dvarName .. " " .. tostring( value ) )
end

CoD.StratTester.send_response = function ( controller, module, action, args )
    if Engine.SendMenuResponse == nil then return end

    local payload = "st+" .. module .. "+" .. action

    if args ~= nil then
        for _, a in ipairs( args ) do
            payload = payload .. "+" .. tostring( a )
        end
    end

    Engine.SendMenuResponse( controller, "restartgamepopup", payload )
end

CoD.StratTester.sync_perk_menu = function ( controller )
    local args = {}
    for _, perk in ipairs( CoD.StratTester.StartPerkList ) do
        local dvarName = "st_perk_" .. perk
        local value = UIExpression.DvarInt( nil, dvarName )
        if UIExpression.DvarString( nil, dvarName ) == "" then value = 0 end
        table.insert( args, perk .. ":" .. tostring(value) )
    end
    CoD.StratTester.send_response( controller, "perks", "sync", args )
end

CoD.StratTester.OnPerkChanged = function ( choice, isUserRequest )
    if isUserRequest ~= true then return end

    local controller = choice.parentSelectorButton.m_currentController
    local perkInternal = choice.parentSelectorButton.m_perkInternal
    local dvarName = choice.parentSelectorButton.m_profileVarName

    CoD.StratTester.SetPerkDvarPersistent( controller, dvarName, choice.value )
    CoD.StratTester.send_response( controller, "perks", "set", { perkInternal .. ":" .. tostring(choice.value) } )
end
-- ==========================================================
-- PESTAÑA 1: GAME (Mecánicas de Partida)
-- ==========================================================
CoD.StratTester.CreateGameTab = function ( Tab, LocalClientIndex )
    CoD.StratTester.RefreshMapFlags()
	local Container = LUI.UIContainer.new()
	local ButtonList = CoD.Options.CreateButtonList()

	Tab.buttonList = ButtonList
	Container:addElement( ButtonList )

	if UIExpression.DvarString( nil, "st_changeround") == "" then
		Engine.SetDvar("st_changeround", 100 )
	end
	
	local ChangeRoundSlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex, Engine.Localize("ST_CHANGE_ROUND"), "st_changeround", 1, 255, Engine.Localize("ST_CHANGE_ROUND_DESC"))
	ChangeRoundSlider:setNumericDisplayFormatString("%d")

	ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

	local KillHordeBtn = ButtonList:addButton(Engine.Localize("ST_KILL_HORDE"), Engine.Localize("ST_KILL_HORDE_DESC"))
	KillHordeBtn:registerEventHandler("button_action", function ( element, event )
		Engine.SetDvar( "st_killhorde", 1 )
	end )

	local EndRoundBtn = ButtonList:addButton(Engine.Localize("ST_END_ROUND"), Engine.Localize("ST_END_ROUND_DESC"))
	EndRoundBtn:registerEventHandler("button_action", function ( element, event )
		Engine.SetDvar( "st_endround", 1 )
	end )

	ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

	-- DESPAWNERS (Oculto en el menú principal)
	if UIExpression.IsInGame( LocalClientIndex ) == 1 then
		local DespawnChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_DESPAWNERS"), "st_despawners", Engine.Localize("ST_DESPAWNERS_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( DespawnChoice, 0 )
	end

    -- NOTARGET
    local NotargetChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_NOTARGET"), "dummy_notarget", Engine.Localize("ST_NOTARGET_DESC"))
    NotargetChoice:addChoice(Engine.Localize("ST_MENU_OFF"), 0, nil, CoD.StratTester.OnNotargetChanged )
    NotargetChoice:addChoice(Engine.Localize("ST_MENU_ON"), 1, nil, CoD.StratTester.OnNotargetChanged )

    local currentNotarget = UIExpression.DvarInt( nil, "dummy_notarget")
    if UIExpression.DvarString( nil, "dummy_notarget") == "" then
        currentNotarget = 0
        Engine.SetDvar("dummy_notarget", currentNotarget )
    end
    NotargetChoice:setChoice( currentNotarget )

    -- DROPS
    local DropsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_DROPS"), "st_enable_drops", Engine.Localize("ST_DROPS_DESC"))
    CoD.StratTester.AddChoices_OnOrOff( DropsChoice, 1)

    -- FOG
    local FogChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_FOG"), "r_fog", Engine.Localize("ST_FOG_DESC"))
    CoD.StratTester.AddChoices_OnOrOff( FogChoice, 1 )

    ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

    local isTpSupported = false
    local defaultTP = ""

    if isTranzit then
        isTpSupported = true
        defaultTP = "farm"
    elseif isDieRise then
        isTpSupported = true
        defaultTP = "shaft"
    elseif isMob then
        isTpSupported = true
        defaultTP = "cafe"
    elseif isBuried then
        isTpSupported = true
        defaultTP = "jug"
    elseif isOrigins then
        isTpSupported = true
        defaultTP = "church"
    end

    if isTpSupported then
        local tpDvar = "dummy_tp_" .. mapname

        local TeleportChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TP_DESTINATION"), tpDvar, Engine.Localize("ST_TP_DESTINATION_DESC"))

        if isTranzit then
            TeleportChoice:addChoice(Engine.Localize("ST_DEPOT"), "depot", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_TUNEL"), "tunel", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_DINER"), "diner", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_FARM"), "farm", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_NACHT"), "nacht", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_POWER_STATION"), "power", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_AK74U"), "ak", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_WAREHOUSE"), "ware", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_TOWN"), "town", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_BUS"), "bus", nil, CoD.StratTester.OnDvarChanged )

        elseif isDieRise then
            TeleportChoice:addChoice(Engine.Localize("ST_SHAFT"), "shaft", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_TRAMPLESTEAM"), "tramp", nil, CoD.StratTester.OnDvarChanged )

        elseif isBuried then
            TeleportChoice:addChoice(Engine.Localize("ST_JUG"), "jug", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_SALOON"), "saloon", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_TUNEL"), "tunel", nil, CoD.StratTester.OnDvarChanged )

        elseif isMob then
            TeleportChoice:addChoice(Engine.Localize("ST_CAFETERIA"), "cafe", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_WARDENS_OFFICE"), "fans", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_DOUBLE_TAP"), "dt", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_CAGE"), "cage", nil, CoD.StratTester.OnDvarChanged )

        elseif isOrigins then
            TeleportChoice:addChoice(Engine.Localize("ST_CHURCH"), "church", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_GENERATOR_1"), "gen1", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_GENERATOR_2"), "gen2", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_GENERATOR_3"), "gen3", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_GENERATOR_4"), "gen4", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_GENERATOR_5"), "gen5", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_GENERATOR_6"), "gen6", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_THE_CRAZY_PLACE"), "tcp", nil, CoD.StratTester.OnDvarChanged )
            TeleportChoice:addChoice(Engine.Localize("ST_TANK"), "tank", nil, CoD.StratTester.OnDvarChanged )
        end

        local currentTP = UIExpression.DvarString( nil, tpDvar )
        if currentTP == "" then
            currentTP = defaultTP
            Engine.SetDvar( tpDvar, currentTP )
        end
        TeleportChoice:setChoice( currentTP )

        local ExecuteTPBtn = ButtonList:addButton(Engine.Localize("ST_EXECUTE_TELEPORT"), Engine.Localize("ST_EXECUTE_TELEPORT_DESC"))

        ExecuteTPBtn:registerEventHandler("button_action", function ( element, event )
            local selectedDest = UIExpression.DvarString( event.controller, tpDvar )
            Engine.SendMenuResponse( event.controller, "restartgamepopup", "sttp+" .. selectedDest )
        end )
    end

    return Container
end

-- ==========================================================
-- PESTAÑA 2: HUD (Visuales y Contadores)
-- ==========================================================
CoD.StratTester.CreateHUDTab = function ( Tab, LocalClientIndex )
    CoD.StratTester.RefreshMapFlags()
    local Container = LUI.UIContainer.new()
    local ButtonList = CoD.Options.CreateButtonList()

    Tab.buttonList = ButtonList
    Container:addElement( ButtonList )

    -- TIMER POSITION (Selector Múltiple)
    local TimerChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TIMER_POSITION"), "st_timer", Engine.Localize("ST_TIMER_POSITION_DESC"))
    TimerChoice:addChoice(Engine.Localize("ST_HIDDEN"), 0, nil, CoD.StratTester.OnDvarChanged )
    TimerChoice:addChoice(Engine.Localize("ST_TOP_RIGHT"), 1, nil, CoD.StratTester.OnDvarChanged )
    TimerChoice:addChoice(Engine.Localize("ST_TOP_LEFT"), 2, nil, CoD.StratTester.OnDvarChanged )
    TimerChoice:addChoice(Engine.Localize("ST_MIDDLE_LEFT"), 3, nil, CoD.StratTester.OnDvarChanged )
    TimerChoice:addChoice(Engine.Localize("ST_BOTTOM"), 4, nil, CoD.StratTester.OnDvarChanged )

    local currentTimerVal = UIExpression.DvarInt( nil, "st_timer")
    if UIExpression.DvarString( nil, "st_timer") == "" then
        currentTimerVal = 1
        Engine.SetDvar("st_timer", currentTimerVal )
    end

    TimerChoice:setChoice( currentTimerVal )

    if isMob then
        local TrapTimerChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TRAP_TIMER"), "st_traptimer", Engine.Localize("ST_TRAT_TIMER_DESC"))
        CoD.StratTester.AddChoices_OnOrOff(TrapTimerChoice , 1 )
    end

    -- HEALTHBAR
    local HealthbarChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_HEALTHBAR"), "st_healthbar", Engine.Localize("ST_HEALTHBAR_DESC"))
    CoD.StratTester.AddChoices_OnOrOff(HealthbarChoice, 0, "hud")

    -- ZOMBIE COUNTER
    local RemainingChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_ZOMBIE_COUNTER"), "st_remaining", Engine.Localize("ST_ZOMBIE_COUNTER_DESC"))
    CoD.StratTester.AddChoices_OnOrOff(RemainingChoice, 1, "hud")

    -- DENIZENS
    if isTranzit then
        local DenizenCounterCoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_DENIZEN_COUNTER"), "st_remaining_denizens", Engine.Localize("ST_DENIZEN_COUNTER_DESC"))
        CoD.StratTester.AddChoices_OnOrOff(DenizenCounterCoice, 1, "hud")
    end

    -- SPH METER
    local SPHChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_SPH_METER"), "st_sph", Engine.Localize("ST_SPH_METER_DESC"))
    CoD.StratTester.AddChoices_OnOrOff( SPHChoice, 1, "hud")

    -- ZONE NAME
    local ZoneChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_ZONE_NAME"), "st_zone", Engine.Localize("ST_ZONE_NAME_DESC"))
    CoD.StratTester.AddChoices_OnOrOff( ZoneChoice, 1, "hud")

     -- BOX HITS
    if isSurvival then
        local BoxHitsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BOX_HITS_HUD"), "st_boxhits", Engine.Localize("ST_BOX_HITS_HUD_DESC"))
        CoD.StratTester.AddChoices_OnOrOff(BoxHitsChoice, 1, "hud")
    end

    if isTranzit then
        -- BUS TIMER
        local BusTimerChoice  = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BUS_TIMER"), "st_bustimer", Engine.Localize("ST_BUS_TIMER_DESC"))
        CoD.StratTester.AddChoices_OnOrOff(BusTimerChoice, 0, "hud")

        -- BUS LOC
        local BusLocChoice  = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BUS_LOCATION"), "st_busloc", Engine.Localize("ST_BUS_LOCATION_DESC"))
        CoD.StratTester.AddChoices_OnOrOff(BusLocChoice, 0, "hud")

    end

    if isDieRise then
        -- ELEVATOR KILLS
        local ElevatorChoice  = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_ELEVATOR_KILLS"), "st_elevatorkills", Engine.Localize("ST_ELEVATOR_KILLS_DESC"))
        CoD.StratTester.AddChoices_OnOrOff(ElevatorChoice, 0, "hud")
    end

    if isBuried then
        -- SUBWOOFER KILLS
        local SubwooferChoice  = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_SUBWOOFER"), "st_subwooferkills", Engine.Localize("ST_SUBWOOFER_DESC"))
        CoD.StratTester.AddChoices_OnOrOff(SubwooferChoice, 0, "hud")
    end

    if isOrigins then
        -- TANK
        local TankChoice  = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TANK_KILLS"), "st_tank", Engine.Localize("ST_TANK_KILLS_DESC"))
        CoD.StratTester.AddChoices_OnOrOff(TankChoice, 0, "hud")

        -- TUMBLE
        local TumbleChoice  = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TUMBLE_ANIM"), "st_tumble", Engine.Localize("ST_TUMBLE_ANIM_DESC"))
        CoD.StratTester.AddChoices_OnOrOff(TumbleChoice, 0, "hud")

        -- STOMP
        local StompChoice  = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_STOMP_KILLS"), "st_stomp", Engine.Localize("ST_STOMP_KILLS_DESC"))
        CoD.StratTester.AddChoices_OnOrOff(StompChoice, 0, "hud")
    end

    return Container
end

-- ==========================================================
-- PESTAÑA 3: MAP SETTINGS (Ajustes Específicos + BOX)
-- ==========================================================
CoD.StratTester.CreateMapTab = function ( Tab, LocalClientIndex )
    CoD.StratTester.RefreshMapFlags()
    local Container = LUI.UIContainer.new()
    local ButtonList = CoD.Options.CreateButtonList()
    local PartyCount = UIExpression.DvarInt(nil, "party_playerCount")
    Tab.buttonList = ButtonList
    Container:addElement( ButtonList )

    if isTranzit then

        if UIExpression.DvarString( nil, "st_depart") == "" then
            Engine.SetDvar("st_depart", 40 )
        end

        local FarmSlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex,Engine.Localize("ST_FARM_DEPART"), "st_depart", 40, 180, Engine.Localize("ST_FARM_DEPART_DESC"))
        FarmSlider:setNumericDisplayFormatString("%d")

        local DenizenChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_DENIZENS"), "st_denizens", Engine.Localize("ST_DENIZENS_DESC"))
        CoD.StratTester.AddChoices_OnOrOff( DenizenChoice, 1 )

        local DenizenSpawnersChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_DENIZEN_SPAWNS"), "st_showDenizenSpawners", Engine.Localize("ST_DENIZEN_SPAWNS_DESC"))
        CoD.StratTester.AddChoices_OnOrOff( DenizenSpawnersChoice, 0 )

        local BusStatusChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BUS_STATUS"), "st_busstatus", Engine.Localize("ST_BUS_STATUS_DESC"))
        CoD.StratTester.AddChoices_OnOrOff( BusStatusChoice, 1 )

        local BuildBusChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BUILD_BUS"), "st_buildbus", Engine.Localize("ST_BUILD_BUS_DESC"))
        CoD.StratTester.AddChoices_OnOrOff( BuildBusChoice, 0 )

        local BuildBuildablesTranzitChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BUILD_BUILDABLES_TRANZIT"), "st_buildbuildables", Engine.Localize("ST_BUILD_BUILDABLES_TRANZIT_DESC"))
        CoD.StratTester.AddChoices_OnOrOff( BuildBuildablesTranzitChoice, 1 )
    end

    if isTown then
        local TownSetUpChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TOWN_DOORS"), "st_jug_setup", Engine.Localize("ST_TOWN_DOORS_DESC"))
        TownSetUpChoice:addChoice(Engine.Localize("ST_JUG"), 1, nil, CoD.StratTester.OnDvarChanged )
        TownSetUpChoice:addChoice(Engine.Localize("ST_SPEED"), 0, nil, CoD.StratTester.OnDvarChanged )

        local currentJug = UIExpression.DvarInt( nil, "st_jug_setup")
        if UIExpression.DvarString( nil, "st_jug_setup") == "" then
            currentJug = 1
            Engine.SetDvar("st_jug_setup", currentJug )
        end
        TownSetUpChoice:setChoice( currentJug )
    end

    if isBuried then
        local BuriedChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BUILDABLES"), "st_setupBuried", Engine.Localize("ST_BUILDABLES_DESC"))
        BuriedChoice:addChoice(Engine.Localize("ST_RESONATOR_JUG"), 0, nil, CoD.StratTester.OnDvarChanged)
        BuriedChoice:addChoice(Engine.Localize("ST_RESONATOR_SALOON"), 1, nil, CoD.StratTester.OnDvarChanged)
        BuriedChoice:addChoice(Engine.Localize("ST_MENU_NONE"), -1, nil, CoD.StratTester.OnDvarChanged)

        local currentsetup = UIExpression.DvarInt( nil, "st_setupBuried")
        if UIExpression.DvarString( nil, "st_setupBuried") == "" then
            currentsetup = 0
            Engine.SetDvar("st_setupBuried", currentsetup )
        end
        BuriedChoice:setChoice( currentsetup )

        local BarricadesChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BARRICADES_BURIED"), "st_keepBarricades", Engine.Localize("ST_BARRICADES_BURIED_DESC"))
        CoD.StratTester.AddChoices_OnOrOff( BarricadesChoice, 0)
    end

    if isMob then
        local MotdLivesChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_INFINITE_LIVES"), "st_lives", Engine.Localize("ST_INFINITE_LIVES_DESC"))
        CoD.StratTester.AddChoices_OnOrOff( MotdLivesChoice, 1 )

        local MotdShieldChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_SHIELD"), "st_shield", Engine.Localize("ST_SHIELD_DESC"))
        CoD.StratTester.AddChoices_OnOrOff( MotdShieldChoice , 1 )
    end

    if isOrigins then

        if PartyCount == 1 then
            local StaffChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_SOLO_STAFF"), "st_staff", Engine.Localize("ST_SOLO_STAFF_DESC"))
            StaffChoice:addChoice(Engine.Localize("ST_ICE_STAFF"), 0, nil, CoD.StratTester.OnDvarChanged )
            StaffChoice:addChoice(Engine.Localize("ST_WIND_STAFF"), 1, nil, CoD.StratTester.OnDvarChanged )
            StaffChoice:addChoice(Engine.Localize("ST_FIRE_STAFF"), 2, nil, CoD.StratTester.OnDvarChanged )
            StaffChoice:addChoice(Engine.Localize("ST_LIGHTNING_STAFF"), 3, nil, CoD.StratTester.OnDvarChanged )
            local currentStaffVal = UIExpression.DvarInt( nil, "st_staff")
            if UIExpression.DvarString( nil, "st_staff") == "" then
                currentStaffVal = 0
                Engine.SetDvar("st_staff", currentStaffVal )
            end
            StaffChoice:setChoice( currentStaffVal )
        end

        local OriginsWallChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_MOOVING_WALLS"), "st_origins_walls_mooving", Engine.Localize("ST_MOOVING_WALLS_DESC"))
        CoD.StratTester.AddChoices_OnOrOff( OriginsWallChoice, 0 )

        local OriginsShieldChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_SHIELD"), "st_shield", Engine.Localize("ST_SHIELD_DESC"))
        CoD.StratTester.AddChoices_OnOrOff( OriginsShieldChoice , 1 )

        local OriginsWMChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_WAR_MACHINE"), "st_wm", Engine.Localize("ST_WAR_MACHINE_DESC"))
        CoD.StratTester.AddChoices_OnOrOff( OriginsWMChoice, 0 )

        ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

        local UnlockGensBtn = ButtonList:addButton(Engine.Localize("ST_UNLOCK_GENERATORS"), Engine.Localize("ST_UNLOCK_GENERATORS_DESC"))
        UnlockGensBtn:registerEventHandler("button_action", function ( element, event )
            Engine.SetDvar( "st_unlockgens", 1 )
        end )
    end

    -- BOX MOOVING
    ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

    local isBoxMoveSupported = false
    local defaultBox = ""

    if isTranzit then
        isBoxMoveSupported = true
        defaultBox = "farm"
    elseif isTown then
        isBoxMoveSupported = true
        defaultBox = "cage"
    elseif isNuketown then
        isBoxMoveSupported = true
        defaultBox = "bunker"
    elseif isDieRise then
        isBoxMoveSupported = true
        defaultBox = "shaft"
    elseif isMob then
        isBoxMoveSupported = true
        defaultBox = "cafe"
    elseif isOrigins then
        isBoxMoveSupported = true
        defaultBox = "gen2"
    end

    if isBoxMoveSupported then
        -- Dvar de UI ficticia que permite que el selector funcione correctamente sin interactuar aún con el GSC
        local boxDvarUI = "ui_dummy_box_" .. mapname

        local BoxChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BOX_DESTINATION"), boxDvarUI, Engine.Localize("ST_BOX_DESTINATION_DESC"))

        if isTranzit then
            BoxChoice:addChoice(Engine.Localize("ST_DOUBLE_TAP"), "town_chest_2", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_QUICK_REVIVE"), "town_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_DINER"), "start_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_FARM"), "farm_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_POWER_STATION"), "pow_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_DEPOT"), "depot_chest", nil, CoD.StratTester.OnDvarChanged )

        elseif isTown then
            BoxChoice:addChoice(Engine.Localize("ST_DOUBLE_TAP"), "town_chest_2", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_QUICK_REVIVE"), "town_chest", nil, CoD.StratTester.OnDvarChanged )

        elseif isNuketown then
            BoxChoice:addChoice(Engine.Localize("ST_BUNKER"), "start_chest1", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_YELLOW_HOUSE"), "start_chest2", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_GARDEN"), "culdesac_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_GREEN_HOUSE"), "oh1_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_GARAGE"), "oh2_chest", nil, CoD.StratTester.OnDvarChanged )

        elseif isDieRise then
            BoxChoice:addChoice(Engine.Localize("ST_ROOF"), "ob6_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_M16"), "start_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_BAR"), "gb1_chest", nil, CoD.StratTester.OnDvarChanged )

        elseif isMob then
            BoxChoice:addChoice(Engine.Localize("ST_DOUBLE_TAP"), "citadel_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_CAFETERIA"), "cafe_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_WARDENS_OFFICE"), "start_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_DOCK"), "dock_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_ROOF"), "roof_chest", nil, CoD.StratTester.OnDvarChanged )

        elseif isOrigins then
            BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_1"), "bunker_start_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_2"), "bunker_tank_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_3"), "bunker_cp_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_4"), "nml_open_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_5"), "nml_farm_chest", nil, CoD.StratTester.OnDvarChanged )
            BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_6"), "village_church_chest", nil, CoD.StratTester.OnDvarChanged )
        end

        local currentUIBox = UIExpression.DvarString( nil, boxDvarUI )
        if currentUIBox == "" then
            currentUIBox = defaultBox
            Engine.SetDvar( boxDvarUI, currentUIBox )
        end
        BoxChoice:setChoice( currentUIBox )

        local ExecuteBoxBtn = ButtonList:addButton(Engine.Localize("ST_MOVE_BOX"), Engine.Localize("ST_MOVE_BOX_DEC"))
        ExecuteBoxBtn:registerEventHandler("button_action", function ( element, event )
            local selectedDest = UIExpression.DvarString( event.controller, boxDvarUI )
            Engine.SendMenuResponse( event.controller, "restartgamepopup", "stboxmove+" .. selectedDest )
        end )
    end

    return Container
end

-- ==========================================================
-- PESTAÑA 4: START SETTINGS
-- ==========================================================
CoD.StratTester.CreateStartTab = function ( Tab, LocalClientIndex )
    local Container = LUI.UIContainer.new()
    local ButtonList = CoD.Options.CreateButtonList()
    Tab.buttonList = ButtonList
    Container:addElement( ButtonList )

    if UIExpression.DvarString( nil, "st_round") == "" then
        Engine.SetDvar("st_round", 100 )
    end
    if UIExpression.DvarString( nil, "st_delay") == "" then
        Engine.SetDvar("st_delay", 60 )
    end

    local RoundSlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex,Engine.Localize("ST_INITIAL_ROUND"), "st_round", 1, 255, Engine.Localize("ST_INITIAL_ROUND_DESC"))
    RoundSlider:setNumericDisplayFormatString("%d")

    -- Delay
    local DelaySlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex,Engine.Localize("ST_INITIAL_DELAY"), "st_delay", 0, 300, Engine.Localize("ST_INITIAL_DELAY_DESC"))
    DelaySlider:setNumericDisplayFormatString("%d")

    -- BOARDS
    local BoardsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BOARDS"), "st_boards", Engine.Localize("ST_BOARDS_DESC"))
    CoD.StratTester.AddChoices_OnOrOff( BoardsChoice, 1)

    -- POWER
    local PowerChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_POWER"), "st_power", Engine.Localize("ST_POWER_DESC"))
    CoD.StratTester.AddChoices_OnOrOff( PowerChoice, 1 )

    -- DOORS
    local DoorsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_OPEN_DOORS"), "st_doors", Engine.Localize("ST_OPEN_DOORS_DESC"))
    CoD.StratTester.AddChoices_OnOrOff( DoorsChoice, 1 )

    local WeaponsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_WEAPONS"), "st_weapons", Engine.Localize("ST_WEAPONS_DESC"))
    CoD.StratTester.AddChoices_OnOrOff( WeaponsChoice, 1 )

    ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

    return Container
end

-- ==========================================================
-- PESTAÑA 5: PERKS
-- ==========================================================
CoD.StratTester.CreatePerksTab = function ( Tab, LocalClientIndex )
    CoD.StratTester.RefreshMapFlags()
    local Container = LUI.UIContainer.new()
    local ButtonList = CoD.Options.CreateButtonList()
    
    Tab.buttonList = ButtonList
    Container:addElement( ButtonList )
    CoD.StratTester.perk_choices = {}

    local function add_perk(perk_internal, localized_name_key)
        local perkDvar = "st_perk_" .. perk_internal

        local selector = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize(localized_name_key), perkDvar, "")

        selector.m_perkInternal = perk_internal
        selector.m_currentController = LocalClientIndex

        selector:addChoice(Engine.Localize("ST_MENU_OFF"), 0, nil, CoD.StratTester.OnPerkChanged )
        selector:addChoice(Engine.Localize("ST_MENU_ON"), 1, nil, CoD.StratTester.OnPerkChanged )

        local currentVal = UIExpression.DvarInt( nil, perkDvar )
        if UIExpression.DvarString( nil, perkDvar ) == "" then
            currentVal = 0
        end

        CoD.StratTester.SetPerkDvarPersistent( LocalClientIndex, perkDvar, currentVal )

        table.insert( CoD.StratTester.perk_choices, { perk = perk_internal, dvar = perkDvar } )
        selector:setChoice( currentVal )
    end

    if isDepot then
        add_perk("specialty_quickrevive", "ST_PERK_REVIVE")

    elseif isFarm then
        add_perk("specialty_armorvest", "ST_PERK_JUG")
        add_perk("specialty_rof", "ST_PERK_DOUBLETAP")
        add_perk("specialty_fastreload", "ST_PERK_SPEED")
        add_perk("specialty_quickrevive", "ST_PERK_REVIVE")

    elseif isTown or isTranzit then
        add_perk("specialty_armorvest", "ST_PERK_JUG")
        add_perk("specialty_rof", "ST_PERK_DOUBLETAP")
        add_perk("specialty_longersprint", "ST_PERK_STAMINUP")
        add_perk("specialty_fastreload", "ST_PERK_SPEED")
        add_perk("specialty_quickrevive", "ST_PERK_REVIVE")

    elseif isNuketown then
        add_perk("specialty_armorvest", "ST_PERK_JUG")
        add_perk("specialty_rof", "ST_PERK_DOUBLETAP")
        add_perk("specialty_fastreload", "ST_PERK_SPEED")
        add_perk("specialty_quickrevive", "ST_PERK_REVIVE")

    elseif isDieRise then
        add_perk("specialty_armorvest", "ST_PERK_JUG")
        add_perk("specialty_rof", "ST_PERK_DOUBLETAP")
        add_perk("specialty_fastreload", "ST_PERK_SPEED")
        add_perk("specialty_additionalprimaryweapon", "ST_PERK_MULEKICK")
        add_perk("specialty_quickrevive", "ST_PERK_REVIVE")
        add_perk("specialty_finalstand", "ST_PERK_WHOISWHO")

    elseif isMob then
        add_perk("specialty_armorvest", "ST_PERK_JUG")
        add_perk("specialty_rof", "ST_PERK_DOUBLETAP")
        add_perk("specialty_fastreload", "ST_PERK_SPEED")
        add_perk("specialty_grenadepulldeath", "ST_PERK_CHERRY")
        add_perk("specialty_deadshot", "ST_PERK_DEADSHOT")

    elseif isBuried then
        add_perk("specialty_nomotionsensor", "ST_PERK_VULTURE")
        add_perk("specialty_armorvest", "ST_PERK_JUG")
        add_perk("specialty_rof", "ST_PERK_DOUBLETAP")
        add_perk("specialty_longersprint", "ST_PERK_STAMINUP")
        add_perk("specialty_fastreload", "ST_PERK_SPEED")
        add_perk("specialty_additionalprimaryweapon", "ST_PERK_MULEKICK")
        add_perk("specialty_quickrevive", "ST_PERK_REVIVE")

    elseif isOrigins then
        add_perk("specialty_armorvest", "ST_PERK_JUG")
        add_perk("specialty_rof", "ST_PERK_DOUBLETAP")
        add_perk("specialty_longersprint", "ST_PERK_STAMINUP")
        add_perk("specialty_fastreload", "ST_PERK_SPEED")
        add_perk("specialty_additionalprimaryweapon", "ST_PERK_MULEKICK")
        add_perk("specialty_quickrevive", "ST_PERK_REVIVE")
        add_perk("specialty_grenadepulldeath", "ST_PERK_CHERRY")
        add_perk("specialty_flakjacket", "ST_PERK_PHD")
        add_perk("specialty_deadshot", "ST_PERK_DEADSHOT")
    else
        ButtonList:addButton( Engine.Localize("ST_NOT_SUPPORTED"), "" )
    end

    -- sync al abrir la pestaña eliminado: puede sobreescribir dvars persistentes
    -- con valores obsoletos antes de que el GSC los haya aplicado.
    -- El sync ya lo hace StratTesterPerkSync al cargar la partida.

    return Container
end

CoD.StratTester.PerkSyncPulse = function ( menu, event )
    if menu.syncCount == nil then
        menu.syncCount = 0
    end

    menu.syncCount = menu.syncCount + 1
    CoD.StratTester.sync_perk_menu( event.controller or menu.controller or 0 )

    if menu.syncCount >= 5 then
        menu:close()
    end
end

LUI.createMenu.StratTesterPerkSync = function ( LocalClientIndex )
    local menu = CoD.Menu.New( "StratTesterPerkSync" )
    menu.controller = LocalClientIndex
    menu:setAlpha( 0 )

    CoD.StratTester.sync_perk_menu( LocalClientIndex )

    menu:registerEventHandler( "perk_sync_pulse", CoD.StratTester.PerkSyncPulse )
    menu:addElement( LUI.UITimer.new( 100, "perk_sync_pulse", false, menu ) )

    return menu
end

-- ==========================================================
-- CREACIÓN DEL MENÚ PRINCIPAL
-- ==========================================================
LUI.createMenu.StratTesterMenu = function ( LocalClientIndex )
    local menu = CoD.Menu.New("StratTesterMenu")
    menu:addTitle( Engine.Localize("ST_MENU_TITLE"), LUI.Alignment.Center )

    menu:addBackButton()
    menu:registerEventHandler("button_prompt_back", CoD.StratTester.Back )
    menu:registerEventHandler("tab_changed", CoD.StratTester.TabChanged )
    menu:setAlpha(1)

    local SettingsTabs = CoD.Options.SetupTabManager( menu, 500 )
    
    -- Verificamos si el jugador está en partida
    local isInGame = UIExpression.IsInGame( LocalClientIndex ) == 1

    -- Pestaña "Game" visible solo en partida
    if isInGame then
        SettingsTabs:addTab( LocalClientIndex, Engine.Localize("ST_TAB_GAME"), CoD.StratTester.CreateGameTab )
    end

    -- Pestaña "HUD" siempre visible

    if CoD.isPartyHost() then
        SettingsTabs:addTab( LocalClientIndex, Engine.Localize("ST_TAB_HUD"), CoD.StratTester.CreateHUDTab )
    end

    -- Pestaña "Map" visible solo en partida
    if isInGame then
        SettingsTabs:addTab( LocalClientIndex, Engine.Localize("ST_TAB_MAP"), CoD.StratTester.CreateMapTab )
    end

    -- Pestaña "Start" siempre visible
    SettingsTabs:addTab( LocalClientIndex, Engine.Localize("ST_TAB_START"), CoD.StratTester.CreateStartTab )

    -- Pestaña "Perks" visible solo en partida
    if isInGame then
        SettingsTabs:addTab( LocalClientIndex, Engine.Localize("ST_TAB_PERKS"), CoD.StratTester.CreatePerksTab )
    end

    -- Protección: Previene errores si el índice guardado es mayor al número de pestañas disponibles
    local maxTabs = 2 -- Ajustado a 2 (HUD y Start) para el menú principal
    if isInGame then
        maxTabs = 5
    end

    if CoD.StratTester.CurrentTabIndex and CoD.StratTester.CurrentTabIndex <= maxTabs then
        SettingsTabs:loadTab( LocalClientIndex, CoD.StratTester.CurrentTabIndex )
    else
        CoD.StratTester.CurrentTabIndex = 1
        if SettingsTabs.loadTab then
            SettingsTabs:loadTab( LocalClientIndex, 1 )
        else
            SettingsTabs:refreshTab( LocalClientIndex )
        end
    end

    return menu
end

CoD.StratTester.sync_hud_menu = function ( controller )
    local elements = {
        { "st_healthbar",          0 },
        { "st_remaining",          1 },
        { "st_remaining_denizens", 1 },
        { "st_sph",                1 },
        { "st_zone",               1 },
        { "st_boxhits",            1 },
        { "st_bustimer",           0 },
        { "st_busloc",             0 },
        { "st_elevatorkills",      0 },
        { "st_subwooferkills",     0 },
        { "st_stomp",              0 },
        { "st_tumble",             0 },
        { "st_tank",               0 },
    }

    local args = {}
    for _, e in ipairs( elements ) do
        local dvarName = e[1]
        local value = e[2]
        if UIExpression.DvarString( nil, dvarName ) ~= "" then
            value = UIExpression.DvarInt( nil, dvarName )
        end
        table.insert( args, e[1] .. ":" .. tostring(value) )
    end

    CoD.StratTester.send_response( controller, "hud", "sync", args )
end

CoD.StratTester.PerkSyncPulse = function ( menu, event )
    if menu.syncCount == nil then
        menu.syncCount = 0
    end

    menu.syncCount = menu.syncCount + 1
    CoD.StratTester.sync_perk_menu( event.controller or menu.controller or 0 )
    CoD.StratTester.sync_hud_menu( event.controller or menu.controller or 0 )

    if menu.syncCount >= 5 then
        menu:close()
    end
end

LUI.createMenu.StratTesterPerkSync = function ( LocalClientIndex )
    local menu = CoD.Menu.New( "StratTesterPerkSync" )
    menu.controller = LocalClientIndex
    menu:setAlpha( 0 )

    CoD.StratTester.sync_perk_menu( LocalClientIndex )
    CoD.StratTester.sync_hud_menu( LocalClientIndex )

    menu:registerEventHandler( "perk_sync_pulse", CoD.StratTester.PerkSyncPulse )
    menu:addElement( LUI.UITimer.new( 100, "perk_sync_pulse", false, menu ) )

    return menu
end