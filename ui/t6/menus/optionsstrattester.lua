-- ==========================================================
-- STRAT TESTER BO2 - MENU PRINCIPAL
-- ==========================================================

-- arreglar lo de perkrng en nuketown

CoD.StratTester = {}
CoD.StratTester.CurrentTabIndex = 1
CoD.StratTester.NeedVidRestart = false
CoD.StratTester.NeedPicmip = false
CoD.StratTester.NeedSndRestart = false

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

CoD.StratTester.AddChoices_OnOrOff = function ( selector, defaultVal )
	selector:addChoice(Engine.Localize("ST_MENU_OFF"), 0, nil, CoD.StratTester.OnDvarChanged )
	selector:addChoice(Engine.Localize("ST_MENU_ON"), 1, nil, CoD.StratTester.OnDvarChanged )
	
	local dvarName = selector.m_profileVarName
	
	local currentVal = UIExpression.DvarInt( nil, dvarName )
	
	if currentVal == nil or UIExpression.DvarString( nil, dvarName ) == "" then
		currentVal = defaultVal
		Engine.SetDvar( dvarName, currentVal )
	end
	
	selector:setChoice( currentVal )
end


CoD.StratTester.OnNotargetChanged = function ( choice, isUserRequest )
	if isUserRequest ~= true then
		return 
	end

	Engine.Exec( choice.parentSelectorButton.m_currentController, "say !notarget")
	
	Engine.SetDvar( choice.parentSelectorButton.m_profileVarName, choice.value )
end

-- ==========================================================
-- PESTAÑA 1: GAME (Mecánicas de Partida)
-- ==========================================================
CoD.StratTester.CreateGameTab = function ( Tab, LocalClientIndex )
	local Container = LUI.UIContainer.new()
	local ButtonList = CoD.Options.CreateButtonList()
	local mapname = UIExpression.DvarString( nil, "ui_mapname")
	local gametype = UIExpression.DvarString( nil, "ui_gametype")
	local startlocation = UIExpression.DvarString( nil, "ui_zm_mapstartlocation")

	Tab.buttonList = ButtonList
	Container:addElement( ButtonList )

	if UIExpression.DvarString( nil, "changeround_val") == "" then
		Engine.SetDvar("changeround_val", 100 )
	end
	
	local ChangeRoundSlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex, Engine.Localize("ST_CHANGE_ROUND"), "changeround_val", 1, 255, Engine.Localize("ST_CHANGE_ROUND_DESC"))
	ChangeRoundSlider:setNumericDisplayFormatString("%d")
	
	ChangeRoundSlider:registerEventHandler("button_action", function ( element, event )
		local rondaSeleccionada = UIExpression.DvarInt( event.controller, "changeround_val")
		
		Engine.Exec( event.controller, "say !changeround " .. rondaSeleccionada )
	end )

	ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )



	local KillHordeBtn = ButtonList:addButton(Engine.Localize("ST_KILL_HORDE"), Engine.Localize("ST_KILL_HORDE_DESC"))
	KillHordeBtn:registerEventHandler("button_action", function ( element, event )
		Engine.Exec( event.controller, "say !killhorde")
	end )

	local EndRoundBtn = ButtonList:addButton(Engine.Localize("ST_END_ROUND"), Engine.Localize("ST_END_ROUND_DESC"))
	EndRoundBtn:registerEventHandler("button_action", function ( element, event )
		Engine.Exec( event.controller, "say !endround")
	end )

	ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )


	-- DESPAWNERS
	local DespawnChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_DESPAWNERS"), "despawners", Engine.Localize("ST_DESPAWNERS_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( DespawnChoice, 0 )

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
	local BoardsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_DROPS"), "drops", Engine.Localize("ST_DROPS_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( BoardsChoice, 0)

	-- FOG
	local FogChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_FOG"), "r_fog", Engine.Localize("ST_FOG_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( FogChoice, 1 )

	ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

	local isTpSupported = false
	local defaultTP = ""

	if mapname == "zm_transit" and gametype == "zclassic" then
		isTpSupported = true
		defaultTP = "farm"
	elseif mapname == "zm_highrise" then
		isTpSupported = true
		defaultTP = "m16"
	elseif mapname == "zm_buried" then
		isTpSupported = true
		defaultTP = "jug"
	elseif mapname == "zm_prison" then
		isTpSupported = true
		defaultTP = "cafe"
	elseif mapname == "zm_tomb" then
		isTpSupported = true
		defaultTP = "church"
	end

	if isTpSupported then
		local tpDvar = "dummy_tp_" .. mapname
		
		local TeleportChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TP_DESTINATION"), tpDvar, Engine.Localize("ST_TP_DESTINATION_DESC"))

		if mapname == "zm_transit" then
			TeleportChoice:addChoice(Engine.Localize("ST_FARM"), "farm", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_TOWN"), "town", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_DINNER"), "dinner", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_TUNEL"), "tunel", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_DEPOT"), "depot", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_POWER_STATION"), "power", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_BUS"), "bus", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_NACHT"), "nacht", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_AK74U"), "ak", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_WAREHOUSE"), "ware", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_highrise" then
			TeleportChoice:addChoice(Engine.Localize("ST_SHAFT"), "shaft", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_TRAMPLESTEAM"), "tramp", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_buried" then
			TeleportChoice:addChoice(Engine.Localize("ST_JUG"), "jug", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_SALOON"), "saloon", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_TUNEL"), "tunel", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_prison" then
			TeleportChoice:addChoice(Engine.Localize("ST_CAFETERIA"), "cafe", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_WARDENS_OFFICE"), "fans", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_DOUBLE_TAP"), "dt", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice(Engine.Localize("ST_CAGE"), "cage", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_tomb" then
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
			
			Engine.Exec( event.controller, "say !tp " .. selectedDest )
		end )
	end

	return Container
end

-- ==========================================================
-- PESTAÑA 2: HUD (Visuales y Contadores)
-- ==========================================================
CoD.StratTester.CreateHUDTab = function ( Tab, LocalClientIndex )
	local Container = LUI.UIContainer.new()
	local ButtonList = CoD.Options.CreateButtonList()
	local mapname = UIExpression.DvarString( nil, "ui_mapname")
	Tab.buttonList = ButtonList
	Container:addElement( ButtonList )
	
	-- HEALTHBAR
	local HealthbarChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_HEALTHBAR"), "healthbar", Engine.Localize("ST_HEALTHBAR_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( HealthbarChoice, 0)

	-- ZOMBIE COUNTER
	local RemainingChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_ZOMBIE_COUNTER"), "remaining", Engine.Localize("ST_ZOMBIE_COUNTER_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( RemainingChoice, 1 )

	-- SPH METER
	local SPHChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_SPH_METER"), "sph", Engine.Localize("ST_SPH_METER_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( SPHChoice, 1 )

	-- ZONE NAME
	local ZoneChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_ZONE_NAME"), "zone", Engine.Localize("ST_ZONE_NAME_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( ZoneChoice, 1 )

	-- TIMER POSITION (Selector Múltiple)
	local TimerChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TIMER_POSITION"), "timer", Engine.Localize("ST_TIMER_POSITION_DESC"))
	TimerChoice:addChoice(Engine.Localize("ST_HIDDEN"), 0, nil, CoD.StratTester.OnDvarChanged )
	TimerChoice:addChoice(Engine.Localize("ST_TOP_LEFT"), 1, nil, CoD.StratTester.OnDvarChanged )
	TimerChoice:addChoice(Engine.Localize("ST_TOP_RIGHT"), 2, nil, CoD.StratTester.OnDvarChanged )
	TimerChoice:addChoice(Engine.Localize("ST_MIDDLE_LEFT"), 3, nil, CoD.StratTester.OnDvarChanged )
	TimerChoice:addChoice(Engine.Localize("ST_BOTTOM"), 4, nil, CoD.StratTester.OnDvarChanged )
	
	local currentTimerVal = UIExpression.DvarInt( nil, "timer")
	if UIExpression.DvarString( nil, "timer") == "" then
		currentTimerVal = 1
		Engine.SetDvar("timer", currentTimerVal )
	end
	
	TimerChoice:setChoice( currentTimerVal )


	if mapname == "zm_prison" then
		local TrapTimerChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TRAP_TIMER"), "traptimer", Engine.Localize("ST_TRAT_TIMER_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( TrapTimerChoice , 1 )
	end

	return Container
end

-- ==========================================================
-- PESTAÑA 3: MAP SETTINGS (Ajustes Específicos)
-- ==========================================================
CoD.StratTester.CreateMapTab = function ( Tab, LocalClientIndex )
	local Container = LUI.UIContainer.new()
	local ButtonList = CoD.Options.CreateButtonList()
	Tab.buttonList = ButtonList
	Container:addElement( ButtonList )

	local mapname = UIExpression.DvarString( nil, "ui_mapname")
	local gametype = UIExpression.DvarString( nil, "ui_gametype")
	local startlocation = UIExpression.DvarString( nil, "ui_zm_mapstartlocation")

	if mapname == "zm_transit" and gametype == "zclassic" then

		if UIExpression.DvarString( nil, "depart") == "" then
			Engine.SetDvar("depart", 40 )
		end

		local FarmSlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex,Engine.Localize("ST_FARM_DEPART"), "depart", 40, 240, Engine.Localize("ST_FARM_DEPART_DESC"))
		FarmSlider:setNumericDisplayFormatString("%d")

		local DenizenChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_DENIZENS"), "denizens", Engine.Localize("ST_DENIZENS_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( DenizenChoice  , 1 )

		local BusTimerChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BUS_TIMER"), "bustimer", Engine.Localize("ST_BUS_TIMER_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( BusTimerChoice , 1 )

		local BusLocChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BUS_LOCATION"), "busloc", Engine.Localize("ST_BUS_LOCATION_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( BusLocChoice , 1 )

		local BusStatusChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BUS_STATUS"), "busstatus", Engine.Localize("ST_BUS_STATUS_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( BusStatusChoice  , 1 )
	end

	if mapname == "zm_transit" and startlocation == "town" then
		local TownSetUpChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TOWN_DOORS"), "jug", Engine.Localize("ST_TOWN_DOORS_DESC"))
		TownSetUpChoice:addChoice(Engine.Localize("ST_JUG"), 1, nil, CoD.StratTester.OnDvarChanged )
		TownSetUpChoice:addChoice(Engine.Localize("ST_SPEED"), 0, nil, CoD.StratTester.OnDvarChanged )
		
		local currentJug = UIExpression.DvarInt( nil, "jug")
		if UIExpression.DvarString( nil, "jug") == "" then
			currentJug = 1
			Engine.SetDvar("jug", currentJug )
		end
		TownSetUpChoice:setChoice( currentJug )
	end

	if mapname == "zm_nuked" then
		local PapChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_FORCE_PAP"), "perkrng", Engine.Localize("ST_FORCE_PAP_DESC"))
		PapChoice:addChoice(Engine.Localize("ST_MENU_ON"), 0, nil, CoD.StratTester.OnDvarChanged )
		PapChoice:addChoice(Engine.Localize("ST_MENU_OFF"), 1, nil, CoD.StratTester.OnDvarChanged )
	end

	if mapname == "zm_highrise" then
		local ElevatorKillsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_ELEVATOR_KILLS"), "elevatorkills", Engine.Localize("ST_ELEVATOR_KILLS_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( ElevatorKillsChoice, 1 )
	end

	if mapname == "zm_buried" then
		local BuriedChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BUILDABLES"), "setupBuried", Engine.Localize("ST_BUILDABLES_DESC"))
		BuriedChoice:addChoice(Engine.Localize("ST_RESONATOR_JUG"), 0, nil, CoD.StratTester.OnDvarChanged)
		BuriedChoice:addChoice(Engine.Localize("ST_RESONATOR_SALOON"), 1, nil, CoD.StratTester.OnDvarChanged)
		BuriedChoice:addChoice(Engine.Localize("ST_MENU_NONE"), -1, nil, CoD.StratTester.OnDvarChanged)
		
		local currentsetup = UIExpression.DvarInt( nil, "setupBuried")
		if UIExpression.DvarString( nil, "setupBuried") == "" then
			currentsetup = 0
			Engine.SetDvar("setupBuried", currentsetup  )
		end
		BuriedChoice:setChoice( currentsetup )

		local SubwooferKillsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_SUBWOOFER"), "subwooferkills", Engine.Localize("ST_INFINITE_LIVES_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( SubwooferKillsChoice , 1 )
	end

	if mapname == "zm_prison" then
		local MotdLivesChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_INFINITE_LIVES"), "lives", Engine.Localize("ST_INFINITE_LIVES_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( MotdLivesChoice, 1 )

		local MotdShieldChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_SHIELD"), "shield", Engine.Localize("ST_SHIELD_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( MotdShieldChoice , 1 )
	end

	if mapname == "zm_tomb" then

		local StaffChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_SOLO_STAFF"), "staff", Engine.Localize("ST_SOLO_STAFF_DESC"))
		StaffChoice:addChoice(Engine.Localize("ST_ICE_STAFF"), 0, nil, CoD.StratTester.OnDvarChanged )
		StaffChoice:addChoice(Engine.Localize("ST_WIND_STAFF"), 1, nil, CoD.StratTester.OnDvarChanged )
		StaffChoice:addChoice(Engine.Localize("ST_FIRE_STAFF"), 2, nil, CoD.StratTester.OnDvarChanged )
		StaffChoice:addChoice(Engine.Localize("ST_LIGHTNING_STAFF"), 3, nil, CoD.StratTester.OnDvarChanged )
		local currentStaffVal = UIExpression.DvarInt( nil, "staff")
		if UIExpression.DvarString( nil, "staff") == "" then
			currentStaffVal = 0
			Engine.SetDvar("staff", currentStaffVal )
		end
		StaffChoice:setChoice( currentStaffVal )
		
		local OriginsShieldChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_SHIELD"), "shield", Engine.Localize("ST_SHIELD_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( OriginsShieldChoice , 1 )
		
		local OriginsCherryChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_ELECTRIC_CHERRY"), "cherry", Engine.Localize("ST_ELECTRIC_CHERRY_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( OriginsCherryChoice  , 0 )

		local OriginsWMChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_WAR_MACHINE"), "wm", Engine.Localize("ST_WAR_MACHINE_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( OriginsWMChoice  , 0 )
		
		ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

		local OriginsTankKillsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TANK_KILLS"), "tank", Engine.Localize("ST_TANK_KILLS_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( OriginsTankKillsChoice  , 0 )
		
		local OriginsStompKillsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_STOMP_KILLS"), "stomp", Engine.Localize("ST_STOMP_KILLS_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( OriginsStompKillsChoice   , 0 )
		
		local OriginsTumbleTrackerChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_TUMBLE_ANIM"), "tumble", Engine.Localize("ST_TUMBLE_ANIM_DESC"))
		CoD.StratTester.AddChoices_OnOrOff( OriginsTumbleTrackerChoice, 0 )

		ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

		local UnlockGensBtn = ButtonList:addButton(Engine.Localize("ST_UNLOCK_GENERATORS"), Engine.Localize("ST_UNLOCK_GENERATORS_DESC"))
		UnlockGensBtn:registerEventHandler("button_action", function ( element, event )
			Engine.Exec( event.controller, "say !unlockgens")
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


	if UIExpression.DvarString( nil, "round") == "" then
		Engine.SetDvar("round", 100 )
	end
	if UIExpression.DvarString( nil, "delay") == "" then
		Engine.SetDvar("delay", 60 )
	end

	local RoundSlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex,Engine.Localize("ST_INITIAL_ROUND"), "round", 1, 255, Engine.Localize("ST_INITIAL_ROUND_DESC"))
	RoundSlider:setNumericDisplayFormatString("%d")
	
	-- Delay
	local DelaySlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex,Engine.Localize("ST_INITIAL_DELAY"), "delay", 0, 300, Engine.Localize("ST_INITIAL_DELAY_DESC"))
	DelaySlider:setNumericDisplayFormatString("%d")
	
	-- BOARDS
	local BoardsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BOARDS"), "boards", Engine.Localize("ST_BOARDS_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( BoardsChoice, 1)

	-- POWER
	local PowerChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_POWER"), "power", Engine.Localize("ST_POWER_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( PowerChoice, 1 )

	-- DOORS
	local DoorsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_OPEN_DOORS"), "doors", Engine.Localize("ST_OPEN_DOORS_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( DoorsChoice, 1 )

	-- PERKS & WEAPONS ON SPAWN
	local PerksChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_PERKS"), "perks", Engine.Localize("ST_PERKS_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( PerksChoice, 1 )
	
	local WeaponsChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_WEAPONS"), "weapons", Engine.Localize("ST_WEAPONS_DESC"))
	CoD.StratTester.AddChoices_OnOrOff( WeaponsChoice, 1 )

	ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

	return Container
end

-- ==========================================================
-- PESTAÑA 5: BOX
-- ==========================================================
CoD.StratTester.CreateBoxTab = function ( Tab, LocalClientIndex )
	local Container = LUI.UIContainer.new()
	local ButtonList = CoD.Options.CreateButtonList()
	local mapname = UIExpression.DvarString( nil, "ui_mapname")
	local gametype = UIExpression.DvarString( nil, "ui_gametype")
	local startlocation = UIExpression.DvarString( nil, "ui_zm_mapstartlocation")

	Tab.buttonList = ButtonList
	Container:addElement( ButtonList )

	local isBoxMoveSupported = false
	local defaultBox = ""

	if mapname == "zm_transit" and gametype == "zclassic" then
		isBoxMoveSupported = true
		defaultBox = "farm"
	elseif mapname == "zm_transit" and startlocation == "town" then
		isBoxMoveSupported = true
		defaultBox = "cage"
	elseif mapname == "zm_nuked" then
		isBoxMoveSupported = true
		defaultBox = "bunker"
	elseif mapname == "zm_highrise" then
		isBoxMoveSupported = true
		defaultBox = "shaft"
	elseif mapname == "zm_prison" then
		isBoxMoveSupported = true
		defaultBox = "cafe"
	elseif mapname == "zm_tomb" then
		isBoxMoveSupported = true
		defaultBox = "gen4"
	end

	if isBoxMoveSupported then
		local boxDvar = "dummy_box_" .. mapname
		
		local BoxChoice = ButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("ST_BOX_DESTINATION"), boxDvar, Engine.Localize("ST_BOX_DESTINATION_DESC"))

		if mapname == "zm_transit" and gametype == "zclassic" then

			BoxChoice:addChoice(Engine.Localize("ST_DOUBLE_TAP"), "dt", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_QUICK_REVIVE"), "qr", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_DINNER"), "diner", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_FARM"), "farm", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_POWER_STATION"), "power", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_DEPOT"), "depot", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_transit" and startlocation == "town" then

			BoxChoice:addChoice(Engine.Localize("ST_DOUBLE_TAP"), "dt", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_QUICK_REVIVE"), "qr", nil, CoD.StratTester.OnDvarChanged )

		elseif mapname == "zm_nuked" then
			BoxChoice:addChoice(Engine.Localize("ST_BUNKER"), "bunker", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_YELLOW_HOUSE"), "yellow", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_GARDEN"), "garden", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_GREEN_HOUSE"), "green", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_GARAGE"), "garage", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_highrise" then
			BoxChoice:addChoice(Engine.Localize("ST_ST_ROOF"), "roof", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_M16"), "m16", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_BAR"), "bar", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_prison" then
			BoxChoice:addChoice(Engine.Localize("ST_DOUBLE_TAP"), "dt", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_CAFETERIA"), "cafe", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_WARDENS_OFFICE"), "office", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_DOCK"), "dock", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_ROOF"), "roof", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_tomb" then
			BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_1"), "gen1", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_2"), "gen2", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_3"), "gen3", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_4"), "gen4", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_5"), "gen5", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice(Engine.Localize("ST_GENERATOR_6"), "gen6", nil, CoD.StratTester.OnDvarChanged )
		end

		local currentBox = UIExpression.DvarString( nil, boxDvar )
		if currentBox == "" then
			currentBox = defaultBox
			Engine.SetDvar( boxDvar, currentBox )
		end
		BoxChoice:setChoice( currentBox )

		local ExecuteBoxBtn = ButtonList:addButton(Engine.Localize("ST_MOVE_BOX"), Engine.Localize("ST_MOVE_BOX_DEC"))
		ExecuteBoxBtn:registerEventHandler("button_action", function ( element, event )
			local selectedDest = UIExpression.DvarString( event.controller, boxDvar )
			
			Engine.Exec( event.controller, "say !boxmove " .. selectedDest )
		end )
	else
		local UnsupportedBtn = ButtonList:addButton( Engine.Localize("ST_NOT_SUPPORTED"), Engine.Localize("ST_NOT_SUPPORTED_DESC") )
		UnsupportedBtn:registerEventHandler( "button_action", function ( element, event )
		end )
	end

	return Container
end

-- ==========================================================
-- CREACIÓN DEL MENÚ PRINCIPAL
-- ==========================================================
LUI.createMenu.StratTesterMenu = function ( LocalClientIndex )
	local menu = CoD.Menu.New("StratTesterMenu")
	menu:addTitle( Engine.Localize("ST_MENU_TITLE"), LUI.Alignment.Center ) -- Strat tester

	menu:addBackButton()
	menu:registerEventHandler("button_prompt_back", CoD.StratTester.Back )
	menu:addBackButton()
	menu:registerEventHandler("button_prompt_back", CoD.StratTester.Back )
	menu:registerEventHandler("tab_changed", CoD.StratTester.TabChanged )
	menu:setAlpha(1)

	local SettingsTabs = CoD.Options.SetupTabManager( menu, 500 )
	
	SettingsTabs:addTab( LocalClientIndex,Engine.Localize("ST_TAB_GAME"), CoD.StratTester.CreateGameTab )
	SettingsTabs:addTab( LocalClientIndex,Engine.Localize("ST_TAB_HUD"), CoD.StratTester.CreateHUDTab )
	SettingsTabs:addTab( LocalClientIndex,Engine.Localize("ST_TAB_MAP"), CoD.StratTester.CreateMapTab )
	SettingsTabs:addTab( LocalClientIndex,Engine.Localize("ST_TAB_START"), CoD.StratTester.CreateStartTab )
	SettingsTabs:addTab( LocalClientIndex,Engine.Localize("ST_TAB_BOX"), CoD.StratTester.CreateBoxTab )

	if CoD.StratTester.CurrentTabIndex then
		SettingsTabs:loadTab( LocalClientIndex, CoD.StratTester.CurrentTabIndex )
	else
		SettingsTabs:refreshTab( LocalClientIndex )
	end

	return menu
end