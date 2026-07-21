#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\strattester\utility;

init_menu_system()
{
    level endon ("end_game");

    foreach ( player in getplayers() )
        player thread menu_dispatcher();

    while ( true )
    {
        level waittill( "connected", player );
        player thread menu_dispatcher();
    }
}

menu_dispatcher()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self notify( "st_menu_dispatcher" );
    self endon( "st_menu_dispatcher" );

	define(self.st_menu_settings, []); // por el momento está sin usar

    while ( true )
    {
        self waittill( "menuresponse", menu, response );

        if (!isdefined(menu) || !isdefined(response) || menu != "restartgamepopup")
            continue;

        if (!issubstr(response, "st+"))
            continue;

        self handle_menu_response(response);
    }
}

handle_menu_response(response)
{
    notification = strtok( response, "+" );

    if (!isdefined(notification) || notification.size < 3 || notification[0] != "st")
        return;

    module = notification[1];
    action = notification[2];

    args = [];
    for (i = 3; i < notification.size; i++)
        args[args.size] = notification[i];

    if (!isdefined(level.st_menu_handlers[module]))
        return;

    self thread [[level.st_menu_handlers[module]]](action, args);
}

menu_set(arg)
{
	entry = strtok( arg, ":" );
	if (!isdefined(entry) || entry.size < 2)
		return;

    self.st_menu_settings[entry[0]] = entry[1];
}