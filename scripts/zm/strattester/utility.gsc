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

iswhite(who)
{
	return who == level.players[0];
}

isblue(who)
{
	return who == level.players[1];
}

isyellow(who)
{
	return who == level.players[2];
}

isgreen(who)
{
	return who == level.players[3];
}


istown()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "town" && level.scr_zm_ui_gametype_group == "zsurvival");
}

isfarm()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "farm" && level.scr_zm_ui_gametype_group == "zsurvival");
}

isdepot()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "transit" && level.scr_zm_ui_gametype_group == "zsurvival");
}

istranzit()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "transit" && level.scr_zm_ui_gametype_group == "zclassic");
}

isnuketown()
{
	return (level.script == "zm_nuked");
}

isdierise()
{
	return (level.script == "zm_highrise");
}

ismob()
{
	return (level.script == "zm_prison");
}

isburied()
{
	return (level.script == "zm_buried");
}

isorigins()
{
	return (level.script == "zm_tomb");
}

is_round(round)
{
	return round <= level.round_number;
}

issurvivalmap()
{
	return (isnuketown() || istown() || isfarm() || isdepot());
}

isvictismap()
{
	return (istranzit() || isburied() || isdierise());
}

isgreenrun()
{
	return (istown() || istranzit() || isfarm() || isdepot());
}