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

// createClientDvar(dvar, set)
// {
// 	if(self getClientDvar(dvar) == "")
// 		self setClientDvar(dvar, set);
// }

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

changeRound(rnd)
{
	setDvar("st_round", rnd);
	level.round_number = rnd;
	endRound();
	changeSpawnRate();
}

changeSpawnRate()
{
	level.zombie_vars[ "zombie_spawn_delay" ] = 2;
	timer = level.zombie_vars["zombie_spawn_delay"];

	for ( i = 1; i <= level.round_number; i++ )
        {
            timer = level.zombie_vars["zombie_spawn_delay"];

            if ( timer > 0.08 )
            {
                level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
                continue;
            }

            if ( timer < 0.08 )
			{
                level.zombie_vars["zombie_spawn_delay"] = 0.08;
				break;
			}
        }

	level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];
}

endRound()
{
	level.zombie_total = 0;
    killHorde();
}

killHorde()
{
	location = level.players[0].origin;
    zombies = getaiarray( level.zombie_team );
    zombies = arraysort( zombies, location );
    zombies_nuked = [];

    foreach(zombie in zombies)
    {
        if ( isdefined( zombie.ignore_nuke ) && zombie.ignore_nuke )
            continue;

        if ( isdefined( zombie.marked_for_death ) && zombie.marked_for_death )
            continue;

        if ( isdefined( zombie.nuke_damage_func ) )
        {
            zombie thread [[ zombie.nuke_damage_func ]]();
            continue;
        }

        if ( is_magic_bullet_shield_enabled( zombie ) )
            continue;

        zombie.marked_for_death = 1;
        zombie.nuked = 1;
        zombies_nuked[zombies_nuked.size] = zombie;
    }

    foreach (nuked_zombie in zombies_nuked)
    {
        if ( !isdefined( nuked_zombie ) )
            continue;

        if ( is_magic_bullet_shield_enabled( nuked_zombie ) )
            continue;
        nuked_zombie.health = 10000; // In case they have negative health like in die rise
        nuked_zombie dodamage( nuked_zombie.health + 666, nuked_zombie.origin );
    }
}

build_buildable( buildable )
{
    player = get_players()[0];

    for ( i = 0; i < level.buildable_stubs.size; i++ )
    {
        if ( !isdefined( buildable ) || level.buildable_stubs[i].equipname == buildable )
        {
            if ( !isdefined( buildable ) && is_true( level.buildable_stubs[i].ignore_open_sesame ) )
                continue;

            if ( isdefined( buildable ) || level.buildable_stubs[i].persistent != 3 )
                level.buildable_stubs[i] maps\mp\zombies\_zm_buildables::buildablestub_finish_build( player );
        }
    }
}