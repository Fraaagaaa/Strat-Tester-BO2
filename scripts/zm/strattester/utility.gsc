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
    level.players = getPlayers();
	return who == level.players[0];
}

isblue(who)
{
    level.players = getPlayers();
    if(!isdefined(level.players[1])) return false;
	return who == level.players[1];
}

isyellow(who)
{
    level.players = getPlayers();
    if(!isdefined(level.players[2])) return false;
	return who == level.players[2];
}

isgreen(who)
{
    level.players = getPlayers();
    if(!isdefined(level.players[3])) return false;
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

changeRound(rnd, w)
{
	if(!isdefined(w)) w = 0;
	wait w;
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
    zombies = getaiarray( level.zombie_team );

    foreach (nuked_zombie in zombies)
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

register_menu_handler( module_name, callback )
{
    if(!isdefined(level.st_menu_handlers))
		level.st_menu_handlers = [];

    level.st_menu_handlers[ module_name ] = callback;
}

response_value( value_string )
{
    if ( !isdefined( value_string ) ) return 0;
    if ( value_string == "1" ) return 1;
    return 0;
}


define(element, init)
{
	if(!isdefined(element))
		element = init;
}

localize_zone(zone)
{
	name = "^3";
	if(isorigins())
		switch (zone)
		{
			case "zone_start": name = &"ZONE_LOWER_LABORATORY"; break;
			case "zone_start_a": name = &"ZONE_UPPER_LABORATORY"; break;
			case "zone_start_b": name = &"ZONE_GENERATOR_1"; break;
			case "zone_bunker_1a": name = &"ZONE_GENERATOR_3_BUNKER_1"; break;
			case "zone_fire_stairs": name = &"ZONE_FIRE_TUNNEL"; break;
			case "zone_bunker_1": name = &"ZONE_GENERATOR_3_BUNKER_2"; break;
			case "zone_bunker_3a": name = &"ZONE_GENERATOR_3"; break;
			case "zone_bunker_3b": name = &"ZONE_GENERATOR_3_BUNKER_3"; break;
			case "zone_bunker_2a": name = &"ZONE_GENERATOR_2_BUNKER_1"; break;
			case "zone_bunker_2": name = &"ZONE_GENERATOR_2_BUNKER_2"; break;
			case "zone_bunker_4a": name = &"ZONE_GENERATOR_2"; break;
			case "zone_bunker_4b": name = &"ZONE_GENERATOR_2_BUNKER_3"; break;
			case "zone_bunker_4c": name = &"ZONE_TANK_STATION"; break;
			case "zone_bunker_4d": name = &"ZONE_ABOVE_TANK_STATION"; break;
			case "zone_bunker_tank_c": name = &"ZONE_GENERATOR_2_TANK_ROUTE_1"; break;
			case "zone_bunker_tank_c1": name = &"ZONE_GENERATOR_2_TANK_ROUTE_2"; break;
			case "zone_bunker_4e": name = &"ZONE_GENERATOR_2_TANK_ROUTE_3"; break;
			case "zone_bunker_tank_d": name = &"ZONE_GENERATOR_2_TANK_ROUTE_4"; break;
			case "zone_bunker_tank_d1": name = &"ZONE_GENERATOR_2_TANK_ROUTE_5"; break;
			case "zone_bunker_4f": name = &"ZONE_ZONE_BUNKER_4F"; break;
			case "zone_bunker_5a": name = &"ZONE_WORKSHOP_DOWNSTAIRS"; break;
			case "zone_bunker_5b": name = &"ZONE_WORKSHOP_UPSTAIRS"; break;
			case "zone_nml_2a": name = &"ZONE_NO_MANS_LAND_WALKWAY"; break;
			case "zone_nml_2": name = &"ZONE_NO_MANS_LAND_ENTRANCE"; break;
			case "zone_bunker_tank_e": name = &"ZONE_GENERATOR_5_TANK_ROUTE_1"; break;
			case "zone_bunker_tank_e1": name = &"ZONE_GENERATOR_5_TANK_ROUTE_2"; break;
			case "zone_bunker_tank_e2": name = &"ZONE_ZONE_BUNKER_TANK_E2"; break;
			case "zone_bunker_tank_f": name = &"ZONE_GENERATOR_5_TANK_ROUTE_3"; break;
			case "zone_nml_1": name = &"ZONE_GENERATOR_5_TANK_ROUTE_4"; break;
			case "zone_nml_4": name = &"ZONE_GENERATOR_5_TANK_ROUTE_5"; break;
			case "zone_nml_0": name = &"ZONE_GENERATOR_5_LEFT_FOOTSTEP"; break;
			case "zone_nml_5": name = &"ZONE_GENERATOR_5_RIGHT_FOOTSTEP_WALKWAY"; break;
			case "zone_nml_farm": name = &"ZONE_GENERATOR_5"; break;
			case "zone_nml_celllar": name = &"ZONE_GENERATOR_5_CELLAR"; break;
			case "zone_bolt_stairs": name = &"ZONE_LIGHTNING_TUNNEL"; break;
			case "zone_nml_3": name = &"ZONE_NO_MANS_LAND_1ST_RIGHT_FOOTSTEP"; break;
			case "zone_nml_2b": name = &"ZONE_NO_MANS_LAND_STAIRS"; break;
			case "zone_nml_6": name = &"ZONE_NO_MANS_LAND_LEFT_FOOTSTEP"; break;
			case "zone_nml_8": name = &"ZONE_NO_MANS_LAND_2ND_RIGHT_FOOTSTEP"; break;
			case "zone_nml_10a": name = &"ZONE_GENERATOR_4_TANK_ROUTE_1"; break;
			case "zone_nml_10": name = &"ZONE_GENERATOR_4_TANK_ROUTE_2"; break;
			case "zone_nml_7": name = &"ZONE_GENERATOR_4_TANK_ROUTE_3"; break;
			case "zone_bunker_tank_a": name = &"ZONE_GENERATOR_4_TANK_ROUTE_4"; break;
			case "zone_bunker_tank_a1": name = &"ZONE_GENERATOR_4_TANK_ROUTE_5"; break;
			case "zone_bunker_tank_a2": name = &"ZONE_ZONE_BUNKER_TANK_A2"; break;
			case "zone_bunker_tank_b": name = &"ZONE_GENERATOR_4_TANK_ROUTE_6"; break;
			case "zone_nml_9": name = &"ZONE_GENERATOR_4_LEFT_FOOTSTEP"; break;
			case "zone_air_stairs": name = &"ZONE_WIND_TUNNEL"; break;
			case "zone_nml_11": name = &"ZONE_GENERATOR_4"; break;
			case "zone_nml_12": name = &"ZONE_GENERATOR_4_RIGHT_FOOTSTEP"; break;
			case "zone_nml_16": name = &"ZONE_EXCAVATION_SITE_FRONT_PATH"; break;
			case "zone_nml_17": name = &"ZONE_EXCAVATION_SITE_BACK_PATH"; break;
			case "zone_nml_18": name = &"ZONE_EXCAVATION_SITE_LEVEL_3"; break;
			case "zone_nml_19": name = &"ZONE_EXCAVATION_SITE_LEVEL_2"; break;
			case "ug_bottom_zone": name = &"ZONE_EXCAVATION_SITE_LEVEL_1"; break;
			case "zone_nml_13": name = &"ZONE_GENERATOR_5_TO_GENERATOR_6_PATH"; break;
			case "zone_nml_14": name = &"ZONE_GENERATOR_4_TO_GENERATOR_6_PATH"; break;
			case "zone_nml_15": name = &"ZONE_GENERATOR_6_ENTRANCE"; break;
			case "zone_village_0": name = &"ZONE_GENERATOR_6_LEFT_FOOTSTEP"; break;
			case "zone_village_5": name = &"ZONE_GENERATOR_6_TANK_ROUTE_1"; break;
			case "zone_village_5a": name = &"ZONE_GENERATOR_6_TANK_ROUTE_2"; break;
			case "zone_village_5b": name = &"ZONE_GENERATOR_6_TANK_ROUTE_3"; break;
			case "zone_village_1": name = &"ZONE_GENERATOR_6_TANK_ROUTE_4"; break;
			case "zone_village_4b": name = &"ZONE_GENERATOR_6_TANK_ROUTE_5"; break;
			case "zone_village_4a": name = &"ZONE_GENERATOR_6_TANK_ROUTE_6"; break;
			case "zone_village_4": name = &"ZONE_GENERATOR_6_TANK_ROUTE_7"; break;
			case "zone_village_2": name = &"ZONE_CHURCH"; break;
			case "zone_village_3": name = &"ZONE_GENERATOR_6_RIGHT_FOOTSTEP"; break;
			case "zone_village_3a": name = &"ZONE_GENERATOR_6"; break;
			case "zone_ice_stairs": name = &"ZONE_ICE_TUNNEL"; break;
			case "zone_bunker_6": name = &"ZONE_ABOVE_GENERATOR_3_BUNKER"; break;
			case "zone_nml_20": name = &"ZONE_ABOVE_NO_MANS_LAND"; break;
			case "zone_village_6": name = &"ZONE_BEHIND_CHURCH"; break;
			case "zone_chamber_0": name = &"ZONE_THE_CRAZY_PLACE_LIGHTNING_CHAMBER"; break;
			case "zone_chamber_1": name = &"ZONE_THE_CRAZY_PLACE_LIGHTNING_ICE"; break;
			case "zone_chamber_2": name = &"ZONE_THE_CRAZY_PLACE_ICE_CHAMBER"; break;
			case "zone_chamber_3": name = &"ZONE_THE_CRAZY_PLACE_FIRE_LIGHTNING"; break;
			case "zone_chamber_4": name = &"ZONE_THE_CRAZY_PLACE_CENTER"; break;
			case "zone_chamber_5": name = &"ZONE_THE_CRAZY_PLACE_ICE_WIND"; break;
			case "zone_chamber_6": name = &"ZONE_THE_CRAZY_PLACE_FIRE_CHAMBER"; break;
			case "zone_chamber_7": name = &"ZONE_THE_CRAZY_PLACE_WIND_FIRE"; break;
			case "zone_chamber_8": name = &"ZONE_THE_CRAZY_PLACE_WIND_CHAMBER"; break;
			case "zone_robot_head": name = &"ZONE_ROBOTS_HEAD"; break;
		}
	else if(isburied())
		switch (zone)
		{
			case "zone_start": name = &"ZONE_PROCESSING"; break;
			case "zone_start_lower": name = &"ZONE_LOWER_PROCESSING"; break;
			case "zone_tunnels_center": name = &"ZONE_CENTER_TUNNELS"; break;
			case "zone_tunnels_north": name = &"ZONE_COURTHOUSE_TUNNELS_2"; break;
			case "zone_tunnels_north2": name = &"ZONE_COURTHOUSE_TUNNELS_1"; break;
			case "zone_tunnels_south": name = &"ZONE_SALOON_TUNNELS_3"; break;
			case "zone_tunnels_south2": name = &"ZONE_SALOON_TUNNELS_2"; break;
			case "zone_tunnels_south3": name = &"ZONE_SALOON_TUNNELS_1"; break;
			case "zone_street_lightwest": name = &"ZONE_OUTSIDE_GENERAL_STORE_BANK"; break;
			case "zone_street_lightwest_alley": name = &"ZONE_OUTSIDE_GENERAL_STORE_BANK_ALLEY"; break;
			case "zone_morgue_upstairs": name = &"ZONE_MORGUE"; break;
			case "zone_underground_jail": name = &"ZONE_JAIL_DOWNSTAIRS"; break;
			case "zone_underground_jail2": name = &"ZONE_JAIL_UPSTAIRS"; break;
			case "zone_general_store": name = &"ZONE_GENERAL_STORE"; break;
			case "zone_stables": name = &"ZONE_STABLES"; break;
			case "zone_street_darkwest": name = &"ZONE_OUTSIDE_GUNSMITH"; break;
			case "zone_street_darkwest_nook": name = &"ZONE_OUTSIDE_GUNSMITH_NOOK"; break;
			case "zone_gun_store": name = &"ZONE_GUNSMITH"; break;
			case "zone_bank": name = &"ZONE_BANK"; break;
			case "zone_tunnel_gun2stables": name = &"ZONE_STABLES_TO_GUNSMITH_TUNNEL_2"; break;
			case "zone_tunnel_gun2stables2": name = &"ZONE_STABLES_TO_GUNSMITH_TUNNEL"; break;
			case "zone_street_darkeast": name = &"ZONE_OUTSIDE_SALOON_TOY_STORE"; break;
			case "zone_street_darkeast_nook": name = &"ZONE_OUTSIDE_SALOON_TOY_STORE_NOOK"; break;
			case "zone_underground_bar": name = &"ZONE_SALOON"; break;
			case "zone_tunnel_gun2saloon": name = &"ZONE_SALOON_TO_GUNSMITH_TUNNEL"; break;
			case "zone_toy_store": name = &"ZONE_TOY_STORE_DOWNSTAIRS"; break;
			case "zone_toy_store_floor2": name = &"ZONE_TOY_STORE_UPSTAIRS"; break;
			case "zone_toy_store_tunnel": name = &"ZONE_TOY_STORE_TUNNEL"; break;
			case "zone_candy_store": name = &"ZONE_CANDY_STORE_DOWNSTAIRS"; break;
			case "zone_candy_store_floor2": name = &"ZONE_CANDY_STORE_UPSTAIRS"; break;
			case "zone_street_lighteast": name = &"ZONE_OUTSIDE_COURTHOUSE_CANDY_STORE"; break;
			case "zone_underground_courthouse": name = &"ZONE_COURTHOUSE_DOWNSTAIRS"; break;
			case "zone_underground_courthouse2": name = &"ZONE_COURTHOUSE_UPSTAIRS"; break;
			case "zone_street_fountain": name = &"ZONE_FOUNTAIN"; break;
			case "zone_church_graveyard": name = &"ZONE_GRAVEYARD"; break;
			case "zone_church_main": name = &"ZONE_CHURCH_DOWNSTAIRS"; break;
			case "zone_church_upstairs": name = &"ZONE_CHURCH_UPSTAIRS"; break;
			case "zone_mansion_lawn": name = &"ZONE_MANSION_LAWN"; break;
			case "zone_mansion": name = &"ZONE_MANSION"; break;
			case "zone_mansion_backyard": name = &"ZONE_MANSION_BACKYARD"; break;
			case "zone_maze": name = &"ZONE_MAZE"; break;
			case "zone_maze_staircase": name = &"ZONE_MAZE_STAIRCASE"; break;
		}
	else if(isdierise())
	switch (zone)
		{
			case "zone_green_start": name = &"ZONE_GREEN_HIGHRISE_LEVEL_3B"; break;
			case "zone_green_escape_pod": name = &"ZONE_ESCAPE_POD"; break;
			case "zone_green_escape_pod_ground": name = &"ZONE_ESCAPE_POD_SHAFT"; break;
			case "zone_green_level1": name = &"ZONE_GREEN_HIGHRISE_LEVEL_3A"; break;
			case "zone_green_level2a": name = &"ZONE_GREEN_HIGHRISE_LEVEL_2A"; break;
			case "zone_green_level2b": name = &"ZONE_GREEN_HIGHRISE_LEVEL_2B"; break;
			case "zone_green_level3a": name = &"ZONE_GREEN_HIGHRISE_RESTAURANT"; break;
			case "zone_green_level3b": name = &"ZONE_GREEN_HIGHRISE_LEVEL_1A"; break;
			case "zone_green_level3c": name = &"ZONE_GREEN_HIGHRISE_LEVEL_1B"; break;
			case "zone_green_level3d": name = &"ZONE_GREEN_HIGHRISE_BEHIND_RESTAURANT"; break;
			case "zone_orange_level1": name = &"ZONE_UPPER_ORANGE_HIGHRISE_LEVEL_2"; break;
			case "zone_orange_level2": name = &"ZONE_UPPER_ORANGE_HIGHRISE_LEVEL_1"; break;
			case "zone_orange_elevator_shaft_top": name = &"ZONE_ELEVATOR_SHAFT_LEVEL_3"; break;
			case "zone_orange_elevator_shaft_middle_1": name = &"ZONE_ELEVATOR_SHAFT_LEVEL_2"; break;
			case "zone_orange_elevator_shaft_middle_2": name = &"ZONE_ELEVATOR_SHAFT_LEVEL_1"; break;
			case "zone_orange_elevator_shaft_bottom": name = &"ZONE_ELEVATOR_SHAFT_BOTTOM"; break;
			case "zone_orange_level3a": name = &"ZONE_LOWER_ORANGE_HIGHRISE_LEVEL_1A"; break;
			case "zone_orange_level3b": name = &"ZONE_LOWER_ORANGE_HIGHRISE_LEVEL_1B"; break;
			case "zone_blue_level5": name = &"ZONE_LOWER_BLUE_HIGHRISE_LEVEL_1"; break;
			case "zone_blue_level4a": name = &"ZONE_LOWER_BLUE_HIGHRISE_LEVEL_2A"; break;
			case "zone_blue_level4b": name = &"ZONE_LOWER_BLUE_HIGHRISE_LEVEL_2B"; break;
			case "zone_blue_level4c": name = &"ZONE_LOWER_BLUE_HIGHRISE_LEVEL_2C"; break;
			case "zone_blue_level2a": name = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_1A"; break;
			case "zone_blue_level2b": name = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_1B"; break;
			case "zone_blue_level2c": name = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_1C"; break;
			case "zone_blue_level2d": name = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_1D"; break;
			case "zone_blue_level1a": name = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_2A"; break;
			case "zone_blue_level1b": name = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_2B"; break;
			case "zone_blue_level1c": name = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_2C"; break;
		}
	else if(isnuketown())
	{
		switch (zone)
		{
			case "culdesac_yellow_zone": name = &"ZONE_YELLOW_HOUSE_MIDDLE"; break;
			case "culdesac_green_zone": name = &"ZONE_GREEN_HOUSE_MIDDLE"; break;
			case "truck_zone": name = &"ZONE_TRUCK"; break;
			case "openhouse1_f1_zone": name = &"ZONE_GREEN_HOUSE_DOWNSTAIRS"; break;
			case "openhouse1_f2_zone": name = &"ZONE_GREEN_HOUSE_UPSTAIRS"; break;
			case "openhouse1_backyard_zone": name = &"ZONE_GREEN_HOUSE_BACKYARD"; break;
			case "openhouse2_f1_zone": name = &"ZONE_YELLOW_HOUSE_DOWNSTAIRS"; break;
			case "openhouse2_f2_zone": name = &"ZONE_YELLOW_HOUSE_UPSTAIRS"; break;
			case "openhouse2_backyard_zone": name = &"ZONE_YELLOW_HOUSE_BACKYARD"; break;
			case "ammo_door_zone": name = &"ZONE_YELLOW_HOUSE_BACKYARD_DOOR"; break;
		}
	}
	else if(ismob())
		switch (zone)
		{
			case "zone_start": name = &"ZONE_DBLOCK"; break;
			case "zone_library": name = &"ZONE_LIBRARY"; break;
			case "zone_cellblock_west": name = &"ZONE_CELLBLOCK_2ND_FLOOR"; break;
			case "zone_cellblock_west_gondola": name = &"ZONE_CELLBLOCK_3RD_FLOOR"; break;
			case "zone_cellblock_west_gondola_dock": name = &"ZONE_CELLBLOCK_GONDOLA"; break;
			case "zone_cellblock_west_barber": name = &"ZONE_MICHIGAN_AVENUE"; break;
			case "zone_cellblock_east": name = &"ZONE_TIMES_SQUARE"; break;
			case "zone_cafeteria": name = &"ZONE_CAFETERIA"; break;
			case "zone_cafeteria_end": name = &"ZONE_CAFETERIA_END"; break;
			case "zone_infirmary": name = &"ZONE_INFIRMARY_1"; break;
			case "zone_infirmary_roof": name = &"ZONE_INFIRMARY_2"; break;
			case "zone_roof_infirmary": name = &"ZONE_ROOF_1"; break;
			case "zone_roof": name = &"ZONE_ROOF_2"; break;
			case "zone_cellblock_west_warden": name = &"ZONE_SALLY_PORT"; break;
			case "zone_warden_office": name = &"ZONE_WARDENS_OFFICE"; break;
			case "cellblock_shower": name = &"ZONE_SHOWERS"; break;
			case "zone_citadel_shower": name = &"ZONE_CITADEL_TO_SHOWERS"; break;
			case "zone_citadel": name = &"ZONE_CITADEL"; break;
			case "zone_citadel_warden": name = &"ZONE_CITADEL_TO_WARDENS_OFFICE"; break;
			case "zone_citadel_stairs": name = &"ZONE_CITADEL_TUNNELS"; break;
			case "zone_citadel_basement": name = &"ZONE_CITADEL_BASEMENT"; break;
			case "zone_citadel_basement_building": name = &"ZONE_CHINA_ALLEY"; break;
			case "zone_studio": name = &"ZONE_BUILDING_64"; break;
			case "zone_dock": name = &"ZONE_DOCKS"; break;
			case "zone_dock_puzzle": name = &"ZONE_DOCKS_GATES"; break;
			case "zone_dock_gondola": name = &"ZONE_UPPER_DOCKS"; break;
			case "zone_golden_gate_bridge": name = &"ZONE_GOLDEN_GATE_BRIDGE"; break;
			case "zone_gondola_ride": name = &"ZONE_GONDOLA"; break;
			default: name = &"ZONE_UNKNOWN_ZONE"; break;
		}
	else if(istranzit() || isdepot() || istown() || isfarm())
		switch (zone)
		{
			case "zone_pri": name = &"ZONE_BUS_DEPOT"; break;
			case "zone_pri2": name = &"ZONE_BUS_DEPOT_HALLWAY"; break;
			case "zone_station_ext": name = &"ZONE_OUTSIDE_BUS_DEPOT"; break;
			case "zone_trans_2b": name = &"ZONE_FOG_AFTER_BUS_DEPOT"; break;
			case "zone_trans_2": name = &"ZONE_TUNNEL_ENTRANCE"; break;
			case "zone_amb_tunnel": name = &"ZONE_TUNNEL"; break;
			case "zone_trans_3": name = &"ZONE_TUNNEL_EXIT"; break;
			case "zone_roadside_west": name = &"ZONE_OUTSIDE_DINER"; break;
			case "zone_gas": name = &"ZONE_GAS_STATION"; break;
			case "zone_roadside_east": name = &"ZONE_OUTSIDE_GARAGE"; break;
			case "zone_trans_diner": name = &"ZONE_FOG_OUTSIDE_DINER"; break;
			case "zone_trans_diner2": name = &"ZONE_FOG_OUTSIDE_GARAGE"; break;
			case "zone_gar": name = &"ZONE_GARAGE"; break;
			case "zone_din": name = &"ZONE_DINER"; break;
			case "zone_diner_roof": name = &"ZONE_DINER_ROOF"; break;
			case "zone_trans_4": name = &"ZONE_FOG_AFTER_DINER"; break;
			case "zone_amb_forest": name = &"ZONE_FOREST"; break;
			case "zone_trans_10": name = &"ZONE_OUTSIDE_CHURCH"; break;
			case "zone_town_church": name = &"ZONE_CHURCH"; break;
			case "zone_trans_5": name = &"ZONE_FOG_BEFORE_FARM"; break;
			case "zone_far": name = &"ZONE_OUTSIDE_FARM"; break;
			case "zone_far_ext": name = &"ZONE_FARM"; break;
			case "zone_brn": name = &"ZONE_BARN"; break;
			case "zone_farm_house": name = &"ZONE_FARMHOUSE"; break;
			case "zone_trans_6": name = &"ZONE_FOG_AFTER_FARM"; break;
			case "zone_amb_cornfield": name = &"ZONE_CORNFIELD"; break;
			case "zone_cornfield_prototype": name = &"ZONE_NACHT"; break;
			case "zone_trans_7": name = &"ZONE_UPPER_FOG_BEFORE_POWER"; break;
			case "zone_pow_ext1": name = &"ZONE_ZONE_POW_EXT1"; break;
			case "zone_trans_pow_ext1": name = &"ZONE_FOG_BEFORE_POWER"; break;
			case "zone_pow": name = &"ZONE_OUTSIDE_POWER_STATION"; break;
			case "zone_prr": name = &"ZONE_POWER_STATION"; break;
			case "zone_pcr": name = &"ZONE_POWER_CONTROL_ROOM"; break;
			case "zone_pow_warehouse": name = &"ZONE_WAREHOUSE"; break;
			case "zone_trans_8": name = &"ZONE_FOG_AFTER_POWER"; break;
			case "zone_amb_power2town": name = &"ZONE_CABIN"; break;
			case "zone_trans_9": name = &"ZONE_FOG_BEFORE_TOWN"; break;
			case "zone_town_north": name = &"ZONE_NORTH_TOWN"; break;
			case "zone_tow": name = &"ZONE_CENTER_TOWN"; break;
			case "zone_town_east": name = &"ZONE_EAST_TOWN"; break;
			case "zone_town_west": name = &"ZONE_WEST_TOWN"; break;
			case "zone_town_west2": name = &"ZONE_WEST_TOWN2"; break;
			case "zone_town_south": name = &"ZONE_SOUTH_TOWN"; break;
			case "zone_bar": name = &"ZONE_BAR"; break;
			case "zone_town_barber": name = &"ZONE_BOOKSTORE"; break;
			case "zone_ban": name = &"ZONE_BANK"; break;
			case "zone_ban_vault": name = &"ZONE_BANK_VAULT"; break;
			case "zone_tbu": name = &"ZONE_BELOW_BANK"; break;
			case "zone_trans_11": name = &"ZONE_FOG_AFTER_TOWN"; break;
			case "zone_amb_bridge": name = &"ZONE_BRIDGE"; break;
			case "zone_trans_1": name = &"ZONE_FOG_BEFORE_BUS_DEPOT"; break;
			case "zone_bunker_4c": name = &"ZONE_TANK_STATION"; break;
			case "zone_bunker_4d": name = &"ZONE_ABOVE_TANK_STATION"; break;
		}
    return name;
}