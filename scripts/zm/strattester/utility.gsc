#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;


strattesterprint(message, mensaje)
{
	foreach(player in level.players)
	{
		if(getDvar("language") == "spanish")
			player iprintln("^5[^6Strat Tester^5]^7 " + mensaje);
		else
			player iprintln("^5[^6Strat Tester^5]^7 " + message);
	}
}

createDvar(dvar, set)
{
	if(getDvar(dvar) == "")
		setDvar(dvar, set);
}

in_array(data, array)
{
	foreach(element in array)
		if(element == data)
			return true;
	return false;
}

createHudElem(label, x, y, scale, alpha, alignx, aligny)
{
	if(!isdefined(scale))
		scale = 1;
	if(!isdefined(x))
		x = 0;
	if(!isdefined(y))
		y = 0;
	if(!isdefined(label))
		label = &"NO LABEL";

	if(!isdefined(alignx))
		alignx = "left";
	if(!isdefined(aligny))
		aligny = "top";

    hud = newClientHudElem(self);

    hud.fontscale = scale;
    hud.hidewheninmenu = 1;

    hud.x = x;
    hud.y = y;

    hud.alpha = alpha;
    hud.label = label;

    hud.alignx = alignx;
    hud.aligny = aligny;
    hud.horzalign = "user_" + alignx;
    hud.vertalign = "user_" + aligny;
    return hud;
}