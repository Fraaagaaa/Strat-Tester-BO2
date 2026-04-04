-- ==========================================================
-- STRAT TESTER BO2 - MENU PRINCIPAL
-- ==========================================================


-- la caja da error en mapas en las que no esta diseñada para que se mueva

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
	selector:addChoice( "OFF", 0, nil, CoD.StratTester.OnDvarChanged )
	selector:addChoice( "ON", 1, nil, CoD.StratTester.OnDvarChanged )
	
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

	Engine.Exec( choice.parentSelectorButton.m_currentController, "say !notarget" )
	
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

	if UIExpression.DvarString( nil, "changeround_val" ) == "" then
		Engine.SetDvar( "changeround_val", 100 )
	end
	
	local ChangeRoundSlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex, "CHANGE ROUND", "changeround_val", 1, 255, "Selecciona la ronda y pulsa para viajar a ella." )
	ChangeRoundSlider:setNumericDisplayFormatString( "%d" )
	
	ChangeRoundSlider:registerEventHandler( "button_action", function ( element, event )
		local rondaSeleccionada = UIExpression.DvarInt( event.controller, "changeround_val" )
		
		Engine.Exec( event.controller, "say !changeround " .. rondaSeleccionada )
	end )

	ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )



	local KillHordeBtn = ButtonList:addButton( "KILL HORDE", "Mata a la horda actual instantáneamente." )
	KillHordeBtn:registerEventHandler( "button_action", function ( element, event )
		Engine.Exec( event.controller, "say !killhorde" )
	end )

	local EndRoundBtn = ButtonList:addButton( "END ROUND", "Termina la ronda actual." )
	EndRoundBtn:registerEventHandler( "button_action", function ( element, event )
		Engine.Exec( event.controller, "say !endround" )
	end )

	ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )


	-- DESPAWNERS
	local DespawnChoice = ButtonList:addHardwareProfileLeftRightSelector( "DESPAWNERS", "despawners", "Rastreador de despawns." )
	CoD.StratTester.AddChoices_OnOrOff( DespawnChoice, 0 )

	-- NOTARGET
	local NotargetChoice = ButtonList:addHardwareProfileLeftRightSelector( "NOTARGET", "dummy_notarget", "Ser ignorado por los zombies" )
	NotargetChoice:addChoice( "OFF", 0, nil, CoD.StratTester.OnNotargetChanged )
	NotargetChoice:addChoice( "ON", 1, nil, CoD.StratTester.OnNotargetChanged )
	
	local currentNotarget = UIExpression.DvarInt( nil, "dummy_notarget" )
	if UIExpression.DvarString( nil, "dummy_notarget" ) == "" then
		currentNotarget = 0
		Engine.SetDvar( "dummy_notarget", currentNotarget )
	end
	NotargetChoice:setChoice( currentNotarget )

	-- DROPS
	local BoardsChoice = ButtonList:addHardwareProfileLeftRightSelector( "DROPS", "drops", "Quita las bonificaciones" )
	CoD.StratTester.AddChoices_OnOrOff( BoardsChoice, 0)

	-- FOG
	local FogChoice = ButtonList:addHardwareProfileLeftRightSelector( "FOG", "r_fog", "Activa o desactiva la niebla" )
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
		
		local TeleportChoice = ButtonList:addHardwareProfileLeftRightSelector( "TP DESTINATION", tpDvar, "Elige la zona a la que quieres viajar." )

		if mapname == "zm_transit" then
			TeleportChoice:addChoice( "FARM", "farm", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "TOWN", "town", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "DINNER", "dinner", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "TUNEL", "tunel", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "DEPOT", "depot", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "POWER", "power", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "BUS", "bus", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "NACHT", "nacht", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "AK74U", "ak", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "WAREHOUSE", "ware", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_highrise" then
			TeleportChoice:addChoice( "SHAFT", "shaft", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "TRAMPLESTEAM", "tramp", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_buried" then
			TeleportChoice:addChoice( "JUG", "jug", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "SALOON", "saloon", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "TUNEL", "tunel", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_prison" then
			TeleportChoice:addChoice( "CAFETERIA", "cafe", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "WARDEN'S OFFICE", "fans", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "DOUBLE TAP", "dt", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "CAGE", "cage", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_tomb" then
			TeleportChoice:addChoice( "CHURCH", "church", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "GENERATOR 1", "gen1", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "GENERATOR 2", "gen2", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "GENERATOR 3", "gen3", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "GENERATOR 4", "gen4", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "GENERATOR 5", "gen5", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "GENERATOR 6", "gen6", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "THE CRAZY PLACE", "tcp", nil, CoD.StratTester.OnDvarChanged )
			TeleportChoice:addChoice( "TANK", "tank", nil, CoD.StratTester.OnDvarChanged )
		end

		local currentTP = UIExpression.DvarString( nil, tpDvar )
		if currentTP == "" then
			currentTP = defaultTP
			Engine.SetDvar( tpDvar, currentTP )
		end
		TeleportChoice:setChoice( currentTP )

		local ExecuteTPBtn = ButtonList:addButton( "EXECUTE TELEPORT", "Teletransporte a la zona seleccionada." )
		ExecuteTPBtn:registerEventHandler( "button_action", function ( element, event )
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
	local HealthbarChoice = ButtonList:addHardwareProfileLeftRightSelector( "HEALTHBAR", "healthbar", "Muestra u oculta la barra de vida del jugador." )
	CoD.StratTester.AddChoices_OnOrOff( HealthbarChoice, 0)

	-- ZOMBIE COUNTER
	local RemainingChoice = ButtonList:addHardwareProfileLeftRightSelector( "ZOMBIE COUNTER", "remaining", "Muestra el contador de zombis restantes." )
	CoD.StratTester.AddChoices_OnOrOff( RemainingChoice, 1 )

	-- SPH METER
	local SPHChoice = ButtonList:addHardwareProfileLeftRightSelector( "SPH METER", "sph", "Segundos por horda." )
	CoD.StratTester.AddChoices_OnOrOff( SPHChoice, 1 )

	-- ZONE NAME
	local ZoneChoice = ButtonList:addHardwareProfileLeftRightSelector( "ZONE NAME", "zone", "Muestra el nombre de la zona actual." )
	CoD.StratTester.AddChoices_OnOrOff( ZoneChoice, 1 )

	-- TIMER POSITION (Selector Múltiple)
	local TimerChoice = ButtonList:addHardwareProfileLeftRightSelector( "TIMER POSITION", "timer", "Posición del temporizador." )
	TimerChoice:addChoice( "HIDDEN", 0, nil, CoD.StratTester.OnDvarChanged )
	TimerChoice:addChoice( "TOP LEFT", 1, nil, CoD.StratTester.OnDvarChanged )
	TimerChoice:addChoice( "TOP RIGHT", 2, nil, CoD.StratTester.OnDvarChanged )
	TimerChoice:addChoice( "MIDDLE LEFT", 3, nil, CoD.StratTester.OnDvarChanged )
	TimerChoice:addChoice( "BOTTOM", 4, nil, CoD.StratTester.OnDvarChanged )
	
	local currentTimerVal = UIExpression.DvarInt( nil, "timer" )
	if UIExpression.DvarString( nil, "timer" ) == "" then
		currentTimerVal = 1
		Engine.SetDvar( "timer", currentTimerVal )
	end
	
	TimerChoice:setChoice( currentTimerVal )


	if mapname == "zm_prison" then
		local TrapTimerChoice = ButtonList:addHardwareProfileLeftRightSelector( "TRAP TIMER", "traptimer", "Temporizador de trampa" )
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

		if UIExpression.DvarString( nil, "depart" ) == "" then
			Engine.SetDvar( "depart", 40 )
		end

		local FarmSlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex, "FARM DEPART TIME", "depart", 40, 240, "Ajusta el tiempo de salida en Farm." )
		FarmSlider:setNumericDisplayFormatString( "%d" )

		local DenizenChoice = ButtonList:addHardwareProfileLeftRightSelector( "DENIZENS", "denizens", "Activa los denizens." )
		CoD.StratTester.AddChoices_OnOrOff( DenizenChoice  , 1 )

		local BusTimerChoice = ButtonList:addHardwareProfileLeftRightSelector( "BUS TIMER", "bustimer", "Temporizador de ciclos de bus." )
		CoD.StratTester.AddChoices_OnOrOff( BusTimerChoice , 1 )

		local BusLocChoice = ButtonList:addHardwareProfileLeftRightSelector( "BUS LOCATION", "busloc", "Mostrar la posición del bus." )
		CoD.StratTester.AddChoices_OnOrOff( BusLocChoice , 1 )

		local BusStatusChoice = ButtonList:addHardwareProfileLeftRightSelector( "BUS STATUS", "busstatus", "Para o arranca el bus." )
		CoD.StratTester.AddChoices_OnOrOff( BusStatusChoice  , 1 )
	end

	if mapname == "zm_transit" and startlocation == "town" then
		local TownSetUpChoice = ButtonList:addHardwareProfileLeftRightSelector( "OPEN DOOR", "jug", "Decide si abrir JUG o SPEEDCOLA" )
		TownSetUpChoice:addChoice( "JUG", 1, nil, CoD.StratTester.OnDvarChanged )
		TownSetUpChoice:addChoice( "SPEED", 0, nil, CoD.StratTester.OnDvarChanged )
		
		local currentJug = UIExpression.DvarInt( nil, "jug" )
		if UIExpression.DvarString( nil, "jug" ) == "" then
			currentJug = 1
			Engine.SetDvar( "jug", currentJug )
		end
		TownSetUpChoice:setChoice( currentJug )
	end

	if mapname == "zm_nuked" then
		local PapChoice = ButtonList:addHardwareProfileLeftRightSelector( "FORCE PAP ON GARDEN", "perkrng", "Reinicia la partida hasta que el pap esté en el jardín de la casa azul." )
		CoD.StratTester.AddChoices_OnOrOff( PapChoice, 1 )
	end

	if mapname == "zm_highrise" then
		local ElevatorKillsChoice = ButtonList:addHardwareProfileLeftRightSelector( "DISPLAY ELEVATOR KILLS", "elevatorkills", "Mostrar las muertes de zombies por el ascesor." )
		CoD.StratTester.AddChoices_OnOrOff( ElevatorKillsChoice, 1 )
	end

	if mapname == "zm_buried" then
		local BuriedChoice = ButtonList:addHardwareProfileLeftRightSelector( "BUILDABLES", "setupBuried", "Configuración de los construibles." )
		BuriedChoice:addChoice( "RESONATOR JUG", 0, nil, CoD.StratTester.OnDvarChanged)
		BuriedChoice:addChoice( "RESONATOR SALOON", 1, nil, CoD.StratTester.OnDvarChanged)
		BuriedChoice:addChoice( "NONE", -1, nil, CoD.StratTester.OnDvarChanged)
		
		local currentsetup = UIExpression.DvarInt( nil, "setupBuried")
		if UIExpression.DvarString( nil, "setupBuried" ) == "" then
			currentsetup = 0
			Engine.SetDvar( "setupBuried", currentsetup  )
		end
		BuriedChoice:setChoice( currentsetup )

		local SubwooferKillsChoice = ButtonList:addHardwareProfileLeftRightSelector( "DISPLAY SUBWOOFER KILLS", "subwooferkills", "Muestra los zombis que mueren en cada disparo de resonador." )
		CoD.StratTester.AddChoices_OnOrOff( SubwooferKillsChoice , 1 )
	end

	if mapname == "zm_prison" then
		local MotdLivesChoice = ButtonList:addHardwareProfileLeftRightSelector( "INFINITE LIVES", "lives", "Vidas infinitas de Afterlife." )
		CoD.StratTester.AddChoices_OnOrOff( MotdLivesChoice, 1 )

		local MotdShieldChoice = ButtonList:addHardwareProfileLeftRightSelector( "SHIELD", "shield", "Empezar la partida con el escudo." )
		CoD.StratTester.AddChoices_OnOrOff( MotdShieldChoice , 1 )
	end

	if mapname == "zm_tomb" then

		local StaffChoice = ButtonList:addHardwareProfileLeftRightSelector( "SOLO STAFF", "staff", "Elige el bastón para jugar en Solo." )
		StaffChoice:addChoice( "ICE STAFF", 0, nil, CoD.StratTester.OnDvarChanged )
		StaffChoice:addChoice( "WIND STAFF", 1, nil, CoD.StratTester.OnDvarChanged )
		StaffChoice:addChoice( "FIRE STAFF", 2, nil, CoD.StratTester.OnDvarChanged )
		StaffChoice:addChoice( "LIGHTNING STAFF", 3, nil, CoD.StratTester.OnDvarChanged )
		local currentStaffVal = UIExpression.DvarInt( nil, "staff" )
		if UIExpression.DvarString( nil, "staff" ) == "" then
			currentStaffVal = 0
			Engine.SetDvar( "staff", currentStaffVal )
		end
		StaffChoice:setChoice( currentStaffVal )
		
		local OriginsShieldChoice = ButtonList:addHardwareProfileLeftRightSelector( "SHIELD", "shield", "Empezar la partida con el escudo." )
		CoD.StratTester.AddChoices_OnOrOff( OriginsShieldChoice , 1 )
		
		local OriginsCherryChoice = ButtonList:addHardwareProfileLeftRightSelector( "ELECTRIC CHERRY", "cherry", "Recibir cherry al empezar la partida." )
		CoD.StratTester.AddChoices_OnOrOff( OriginsCherryChoice  , 0 )

		local OriginsWMChoice = ButtonList:addHardwareProfileLeftRightSelector( "WAR MACHINE", "wm", "Recibir el arma de guerra el principio de la partida." )
		CoD.StratTester.AddChoices_OnOrOff( OriginsWMChoice  , 0 )
		
		ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

		local OriginsTankKillsChoice = ButtonList:addHardwareProfileLeftRightSelector( "TANK KILLS", "tank", "Tracker para los zombies que han muerto por el tanque." )
		CoD.StratTester.AddChoices_OnOrOff( OriginsTankKillsChoice  , 0 )
		
		local OriginsStompKillsChoice = ButtonList:addHardwareProfileLeftRightSelector( "STOMP KILLS", "stomp", "Tracker para los zombis que han sido pisados." )
		CoD.StratTester.AddChoices_OnOrOff( OriginsStompKillsChoice   , 0 )
		
		local OriginsTumbleTrackerChoice = ButtonList:addHardwareProfileLeftRightSelector( "TUMBLE ANIM", "tumble", "Tracker para las animaciones de los zombies." )
		CoD.StratTester.AddChoices_OnOrOff( OriginsTumbleTrackerChoice, 0 )

		ButtonList:addSpacer( CoD.CoD9Button.Height / 2 )

		local UnlockGensBtn = ButtonList:addButton( "UNLOCK GENERATORS", "Arregla los generadores." )
		UnlockGensBtn:registerEventHandler( "button_action", function ( element, event )
			Engine.Exec( event.controller, "say !unlockgens" )
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


	if UIExpression.DvarString( nil, "round" ) == "" then
		Engine.SetDvar( "round", 100 )
	end
	if UIExpression.DvarString( nil, "delay" ) == "" then
		Engine.SetDvar( "delay", 60 )
	end

	local RoundSlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex, "INITIAL ROUND", "round", 1, 255, "Ronda inicial de la partida." )
	RoundSlider:setNumericDisplayFormatString( "%d" )
	
	-- Delay
	local DelaySlider = CoD.OptionsSettings.AddDvarLeftRightSlider( ButtonList, LocalClientIndex, "INITIAL DELAY", "delay", 0, 300, "Espera inicial de la partida." )
	DelaySlider:setNumericDisplayFormatString( "%d" )
	
	-- BOARDS
	local BoardsChoice = ButtonList:addHardwareProfileLeftRightSelector( "BOARDS", "boards", "Quita las barreras de las ventanas" )
	CoD.StratTester.AddChoices_OnOrOff( BoardsChoice, 1)

	-- POWER
	local PowerChoice = ButtonList:addHardwareProfileLeftRightSelector( "POWER", "power", "Enciende o apaga la electricidad." )
	CoD.StratTester.AddChoices_OnOrOff( PowerChoice, 1 )

	-- DOORS
	local DoorsChoice = ButtonList:addHardwareProfileLeftRightSelector( "OPEN DOORS", "doors", "Abre todas las puertas automáticamente." )
	CoD.StratTester.AddChoices_OnOrOff( DoorsChoice, 1 )

	-- PERKS & WEAPONS ON SPAWN
	local PerksChoice = ButtonList:addHardwareProfileLeftRightSelector( "PERKS", "perks", "Apareces con los perks necesarios." )
	CoD.StratTester.AddChoices_OnOrOff( PerksChoice, 1 )
	
	local WeaponsChoice = ButtonList:addHardwareProfileLeftRightSelector( "WEAPONS", "weapons", "Apareces con armas predefinidas." )
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
		
		local BoxChoice = ButtonList:addHardwareProfileLeftRightSelector( "BOX DESTINATION", boxDvar, "Elige la zona a la que mover la caja." )

		if mapname == "zm_transit" and gametype == "zclassic" then

			BoxChoice:addChoice( "DOUBLE TAP", "dt", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "QUICK REVIVE", "qr", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "DINNER", "diner", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "FARM", "farm", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "POWER", "power", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "DEPOT", "depot", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_transit" and startlocation == "town" then

			BoxChoice:addChoice( "DOUBLE TAP", "dt", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "QUICK REVIVE", "qr", nil, CoD.StratTester.OnDvarChanged )

		elseif mapname == "zm_nuked" then
			BoxChoice:addChoice( "BUNKER", "bunker", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "YELLOW HOUSE", "yellow", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "GARDEN", "garden", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "GREEN HOUSE", "green", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "GARAGE", "garage", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_highrise" then
			BoxChoice:addChoice( "ROOF", "roof", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "M16", "m16", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "BAR", "bar", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_prison" then
			BoxChoice:addChoice( "DOUBLE TAP", "dt", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "CAFETERIA", "cafe", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "WARDEN'S OFFICE", "office", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "DOCK", "dock", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "ROOF", "roof", nil, CoD.StratTester.OnDvarChanged )
			
		elseif mapname == "zm_tomb" then
			BoxChoice:addChoice( "GENERATOR 1", "gen1", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "GENERATOR 2", "gen2", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "GENERATOR 3", "gen3", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "GENERATOR 4", "gen4", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "GENERATOR 5", "gen5", nil, CoD.StratTester.OnDvarChanged )
			BoxChoice:addChoice( "GENERATOR 6", "gen6", nil, CoD.StratTester.OnDvarChanged )
		end

		local currentBox = UIExpression.DvarString( nil, boxDvar )
		if currentBox == "" then
			currentBox = defaultBox
			Engine.SetDvar( boxDvar, currentBox )
		end
		BoxChoice:setChoice( currentBox )

		local ExecuteTPBtn = ButtonList:addButton( "MOVE BOX", "Mover la caja a la zona seleccionada." )
		ExecuteTPBtn:registerEventHandler( "button_action", function ( element, event )
			local selectedDest = UIExpression.DvarString( event.controller, boxDvar )
			
			Engine.Exec( event.controller, "say !boxmove " .. selectedDest )
		end )
	end

	return Container
end



-- ==========================================================
-- CREACIÓN DEL MENÚ PRINCIPAL
-- ==========================================================
LUI.createMenu.StratTesterMenu = function ( LocalClientIndex )
	local menu = CoD.Menu.New( "StratTesterMenu" )
	menu:addTitle( "STRAT TESTER", LUI.Alignment.Center )
	
	menu:addBackButton()
	menu:registerEventHandler( "button_prompt_back", CoD.StratTester.Back )
	menu:registerEventHandler( "tab_changed", CoD.StratTester.TabChanged )

	local SettingsTabs = CoD.Options.SetupTabManager( menu, 500 )
	
	SettingsTabs:addTab( LocalClientIndex, "GAME", CoD.StratTester.CreateGameTab )
	SettingsTabs:addTab( LocalClientIndex, "HUD", CoD.StratTester.CreateHUDTab )
	SettingsTabs:addTab( LocalClientIndex, "MAP", CoD.StratTester.CreateMapTab )
	SettingsTabs:addTab( LocalClientIndex, "START", CoD.StratTester.CreateStartTab )
	SettingsTabs:addTab( LocalClientIndex, "BOX", CoD.StratTester.CreateBoxTab )

	if CoD.StratTester.CurrentTabIndex then
		SettingsTabs:loadTab( LocalClientIndex, CoD.StratTester.CurrentTabIndex )
	else
		SettingsTabs:refreshTab( LocalClientIndex )
	end

	return menu
end