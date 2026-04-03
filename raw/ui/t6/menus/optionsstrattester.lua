-- Inicializamos el espacio de nombres para tu menú
CoD.StratTester = {}

-- Función para manejar el botón de "Atrás" (ESC / B / Círculo)
CoD.StratTester.Back = function ( element, event )
	element:goBack( event.controller )
end

-- Esta es la función principal que el juego llama cuando haces openMenu("StratTesterMenu")
LUI.createMenu.StratTesterMenu = function ( LocalClientIndex )
	-- Creamos la base del menú
	local menu = CoD.Menu.New( "StratTesterMenu" )
	
	-- Le ponemos un título
	menu:addTitle( "STRAT TESTER", LUI.Alignment.Center )
	
	-- Fondo oscuro estándar de los menús
	if CoD.isSinglePlayer == false then
		menu:addLargePopupBackground()
	end

	-- Controles básicos (botón de atrás)
	menu:addBackButton()
	menu:registerEventHandler( "button_prompt_back", CoD.StratTester.Back )

	-- Creamos la lista donde irán tus botones y opciones
	local ButtonList = CoD.ButtonList.new()
	ButtonList:setLeftRight( true, false, 0, CoD.ButtonList.DefaultWidth )
	ButtonList:setTopBottom( true, true, CoD.Menu.TitleHeight + 50, 0 )
	menu:addElement( ButtonList )

	-- [AQUÍ AÑADIREMOS TUS OPCIONES MÁS ADELANTE]
	-- Botón de ejemplo:
	local BotonEjemplo = ButtonList:addButton( "OPCION DE PRUEBA" )
	BotonEjemplo.hintText = "Esta es una descripción de prueba."
	
	return menu
end