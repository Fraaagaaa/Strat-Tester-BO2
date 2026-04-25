#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\strattester\fixes;
#include scripts\zm\strattester\commands;
#include scripts\zm\strattester\start;
#include scripts\zm\strattester\zone;
#include scripts\zm\strattester\timers;
#include scripts\zm\strattester\ismap;
#include scripts\zm\strattester\hud;

addCommands(commands)
{
    foreach(command in commands)
        level.StratTesterCommands[level.StratTesterCommands.size] = command;
}

readchat() 
{
    self endon("end_game");
	level.StratTesterCommands = [];
    addCommands(array("!a", "!endround", "!changeround", "!killhorde", "!tpc", "!tp", "!sph", "!power", "!boards", "!doors", "!round", "!delay", "!zone", "!remaining", "!weapons", "!perks", "!healthbar", "!timer", "!nuke", "!max", "!boxmove", "!fog", "!notarget", "!despawners", "!help"));

    if(isgreenrun())    addCommands(array("!denizen","!busoff","!depart","!busloc","!bustimer","!perma","!jug","!buson"));
    if(isorigins())     addCommands(array("!templars","!stomp","!tumble","!tank","!cherry","!shield","!wm","!staff","!gen","!unlockgens"));
    if(ismob())         addCommands(array("!shield", "!lives", "!traptimer"));
    if(isdierise())     addCommands(array("!perma", "!elevator"));
    if(isburied())      addCommands(array("!buried", "!sub", "!perma"));
    
    while (true) 
    {
        level waittill("say", message, player);
        msg = strtok(tolower(message), " ");
        if(msg[0][0] != "!")
            continue;
		if(!in_array(msg[0], level.StratTesterCommands) && (!in_array(msg[0], level.FragaCommands)) && (!in_array(msg[0], level.FragaCommandsAliases)))
		{
			strattesterprint("Unknown command ^1" + message, "Comando desconocido ^1" + message);
			continue;
		}
        level thread commands(msg, player);
    }
}

readconsole()
{
    self endon("end_game");
    while (true) 
    {
		wait 0.05;
		message = getDvar("chat");
		if(message == "xxxxxxxxxxxx")
			continue;
        msg = strtok(tolower(message), " ");
		if(!in_array(msg[0], level.StratTesterCommands) && (!in_array(msg[0], level.FragaCommands)))
		{
			strattesterprint("Unknown command ^1" + message, "Comando desconocido ^1" + message);
			continue;
		}
		if(!isdefined(player))
			player = level.players[0];
        level thread commands(msg, player);
		setDvar("chat", "xxxxxxxxxxxx");
    }
}

commands(msg, player)
{
    switch(msg[0])
    {
        case "!a": strattesterprint(player.origin + "    " + player.angles); break;
        case "!changeround": changeroundcase(msg[1]); break;
        case "!endround": endroundcase(); break;
        case "!killhorde": killhordecase(); break;
        case "!tpc": tpccase(player, msg[1], msg[3], msg[2]); break;
        case "!tp": tpcase(player, msg[1], msg[2]); break;
        case "!sph": setDvar("sph", !getDvarInt("st_sph")); break;
        case "!power": powercase(); break;
        case "!boards": boardscase(); break;
        case "!doors": doorscase(); break;
        case "!round": setDvar("round", msg[1]); break;
        case "!delay": setDvar("delay", msg[1]); break;
        case "!zone": setDvar("zone", !getDvarInt("zone")); break;
        case "!remaining": setDvar("remaining", !getDvarInt("st_remaining")); break;
        case "!weapons": weaponscase(); break;
        case "!perks": perkscase(); break;
        case "!healthbar": setDvar("healthbar", !getDvarInt("st_healthbar")); break;
        case "!timer": setDvar("timer", msg[1]); break;
        case "!nuke": level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("nuke", player.origin + (0, 0, 40)); break;
        case "!max": level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("full_ammo", player.origin + (0, 0, 40)); break;
        case "!boxmove": boxmove(msg[1]); break;
        case "!fog": fogcase(); break;
        case "!notarget": notargetcase(player); break;
        case "!despawners": despawnerscase(); break;
        case "!help": helpcase(); break;
        // TRANZIT
        case "!denizen": denizencase(); break;
        case "!busoff": case "!buson": busstatuscase(); break;
        case "!depart": departcase(msg[1]); break;
        case "!busloc": setDvar("busloc", !getDvarInt("st_busloc")); break;
        case "!bustimer": setDvar("bustimer", !getDvarInt("st_bustimer")); break;
        case "!perma": permacase(player); break;
        case "!jug": jugcase(); break;
        // DIE RISE
        case "!elevator": elevatorcase(); break;
        // ORIGINS
        case "!stomp": flipdvar("stomp"); break;
        case "!tumble": flipdvar("tumble"); break;
        case "!tank": flipdvar("tank"); break;
        case "!cherry": cherrycase(); break;
        case "!shield": shieldcase(); break;
        case "!wm": wmcase(); break;
        case "!staff": staffcase(); break;
        // MOB
        case "!shield": shieldcase(); break;
        case "!lives": livescase(); break;
        case "!traptimer": setDvar("st_traptimer", !getDvarInt("st_traptimer")); break;
        // BURIED
        case "!buried": buriedcase(); break;
        case "!sub": subcase(); break;
        default: break;
    }
    setDvar("chat", "xxxxxxxxxxxx");
}

flipDvar(dvar)
{
    setDvar(dvar, !getDvarInt(dvar));
}

boxmove(location)
{
	switch(location)
	{
		case "bunker": if(!isnuketown()) return; location = "start_chest1"; break;
		case "yellow": if(!isnuketown()) return; location = "start_chest2"; break;
		case "garden": if(!isnuketown()) return; location = "culdesac_chest"; break;
		case "green": if(!isnuketown()) return; location = "oh1_chest"; break;
		case "garage": if(!isnuketown()) return; location = "oh2_chest"; break;
		case "dt": if(!istranzit() && !istown() && !ismob()) return; if(istranzit() || istown()) location = "town_chest_2"; if(ismob()) location = "citadel_chest"; break;
		case "qr": if(!istranzit() && !istown()) return; location = "town_chest"; break;
		case "farm": if(!istranzit()) return; location = "farm_chest"; break;
		case "power": if(!istranzit()) return; location = "pow_chest"; break;
		case "diner": if(!istranzit()) return; location = "start_chest"; break;
		case "depot": if(!istranzit()) return; location = "depot_chest"; break;
		case "cafe": if(!ismob()) return; location = "cafe_chest"; break;
		case "roof": if(!ismob() && !isdierise()) return; if(!isdierise()) location = "roof_chest"; else location = "ob6_chest"; break;
		case "dock": if(!ismob()) return; location = "dock_chest"; break;
		case "office": if(!ismob()) return; location = "start_chest"; break;
		case "gen1": if(!isorigins()) return; location = "bunker_start_chest"; break;
		case "gen2": if(!isorigins()) return; location = "bunker_tank_chest"; break;
		case "gen3": if(!isorigins()) return; location = "bunker_cp_chest"; break;
		case "gen4": if(!isorigins()) return; location = "nml_open_chest"; break;
		case "gen5": if(!isorigins()) return; location = "nml_farm_chest"; break;
		case "gen6": if(!isorigins()) return; location = "village_church_chest"; break;
		case "m16": if(!isdierise()) return; location = "start_chest"; break;
		case "bar": if(!isdierise()) return; location = "gb1_chest"; break;
		default: break;
	}
    if(isDefined(level._zombiemode_custom_box_move_logic))
        kept_move_logic = level._zombiemode_custom_box_move_logic;

    level._zombiemode_custom_box_move_logic = ::force_next_location;

    foreach (chest in level.chests)
    {
        if (!chest.hidden && chest.script_noteworthy == location)
        {
            if (isDefined(kept_move_logic))
                level._zombiemode_custom_box_move_logic = kept_move_logic;
            return;
        }
        if (!chest.hidden)
        {
            level.chest_min_move_usage = 8;
            level.chest_name = location;

            flag_set("moving_chest_now");
            chest thread fast_chest_move();

            wait 0.05;
            level notify("weapon_fly_away_start");
            wait 0.05;
            level notify("weapon_fly_away_end");

            break;
        }
    }

    while (flag("moving_chest_now"))
        wait 0.05;

    if (isDefined(kept_move_logic))
        level._zombiemode_custom_box_move_logic = kept_move_logic;

    if (isDefined(level.chest_name) && isDefined(level.dig_magic_box_moved))
        level.dig_magic_box_moved = 0;

    level.chest_min_move_usage = 4;
}


force_next_location()
{
    for (i = 0; i < level.chests.size; i++)
        if (level.chests[i].script_noteworthy == level.chest_name)
            level.chest_index = i;
}


endRound(round)
{
	if(round) level.zombie_total = 0;
	
	location = level.players[0].origin;
	player_team = level.players[0].team;
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

fast_chest_move()
{
    if ( isdefined( self.zbarrier ) )
        self hide_chest( 1 );

    level.verify_chest = 0;

    if ( isdefined( level._zombiemode_custom_box_move_logic ) )
        [[ level._zombiemode_custom_box_move_logic ]]();
    else
        default_box_move_logic();

    if ( isdefined( level.chests[level.chest_index].box_hacks["summon_box"] ) )
        level.chests[level.chest_index] [[ level.chests[level.chest_index].box_hacks["summon_box"] ]]( 0 );

    playfx( level._effect["poltergeist"], level.chests[level.chest_index].zbarrier.origin );
    level.chests[level.chest_index] show_chest();
    flag_clear( "moving_chest_now" );
    self.zbarrier.chest_moving = 0;
}

zombie_can_drop_powerups(zombie)
{
    if ( is_tactical_grenade( zombie.damageweapon ) || !flag( "zombie_drop_powerups" ) )
        return false;

    if ( isdefined( zombie.no_powerups ) && zombie.no_powerups )
        return false;

    return !getDvarInt("st_remove_drops");
}

strattesterprint(message, mensaje)
{
	foreach(player in level.players)
	{
		if(getDvar("language") == "spanish" && isdefined(mensaje))
			player iprintln("^5[^6Strat Tester^5]^7 " + mensaje);
		else
			player iprintln("^5[^6Strat Tester^5]^7 " + message);
	}
}

endroundcase()
{
    endRound(true);
    strattesterprint("Ending current round", "Terminando la ronda actual");
}

killhordecase()
{
    endRound(false);
    strattesterprint("Killing current horde", "Matando horda actual");
}

tpccase(player, x, z, y)
{
    x = string_to_float(x);
    y = string_to_float(y);
    z = string_to_float(z);
    strattesterprint("Teleporting " + player.name + " to " + x + " " + y + " " + z, "Teletransportando " + player.name + " a " + x + " " + y + " " + z);
    player setOrigin((string_to_float(x), string_to_float(y), string_to_float(z)));
}

tpcase(player, location, who)
{
	if(istranzit())
		switch(location)
		{
			case "farm": pos = (6908, -5750, -62); ang = (0, 173, 0); if(getDvar("language") == "spanish") location = "granja"; else location = "farm"; break;
			case "town": pos = (1152, -717, -55); ang = (0, 45, 0); if(getDvar("language") == "spanish") location = "pueblo"; else location = "town"; break;
			case "depot": pos = (-7384, 4693, -63); ang = (0, 18, 0); if(getDvar("language") == "spanish") location = "estación"; else location = "bus depot"; break;
			case "tunel": pos = (-11814, -1903, 228); ang = (0, -60, 0); if(getDvar("language") == "spanish") location = "tunel"; else location = "tunel"; break;
			case "diner": pos = (-5012, -6694, -60); ang = (0, -127, 0); if(getDvar("language") == "spanish") location = "cafetería"; else location = "diner"; break;
			case "nacht": pos = (13840, -261, -188); ang = (0, -108, 0); if(getDvar("language") == "spanish") location = "natch"; else location = "natch"; break;
			case "power": pos = (12195, 8266, -751); ang = (0, -90, 0); if(getDvar("language") == "spanish") location = "estación de energía"; else location = "power station"; break;
			case "ak": pos = (11200, 7745, -564); ang = (0, -108, 0); if(getDvar("language") == "spanish") location = "ak74u"; else location = "ak74u"; break;
			case "ware": pos = (10600, 8272, -400); ang = (0, -108, 0); if(getDvar("language") == "spanish") location = "almacén"; else location = "warehouse"; break;
			case "bus": pos = level.the_bus.origin; ang = level.the_bus.angles; if(getDvar("language") == "spanish") location = "autobús"; else location = "bus"; break;
			default: return;
		}
	if(ismob())
		switch(location)
		{
			case "cafe": pos = (3309, 9329, 1336); ang = (0, 131, 0); if(getDvar("language") == "spanish") location = "cafetería"; else location = "cafeteria"; break;
			case "cage": pos = (-1771, 5401, -71); ang = (0, 0, 0); if(getDvar("language") == "spanish") location = "jaula"; else location = "cage"; break;
			case "fans": pos = (-1042, 9489, 1350); ang = (0, -43, 0); if(getDvar("language") == "spanish") location = "oficina del alcaide"; else location = "warden's office"; break;
			case "dt":   pos = (25, 8762, 1128); ang = (0, 0, 0); if(getDvar("language") == "spanish") location = "doble tiro"; else location = "double tap"; break;
			default: return;
		}
	if(isdierise())
		switch(location)
		{
			case "shaft": pos = (3805, 1920, 2197); ang = (0, -161, 0); if(getDvar("language") == "spanish") location = "zona de campeo"; else location = "shaft"; break;
			case "tramp": pos = (2159, 1161, 3070); ang = (0, 135, 0); if(getDvar("language") == "spanish") location = "vapor arrollador"; else location = "tramplesteam"; break;
			default: return;
		}
	if(isburied())
		switch(location)
		{
			case "saloon": pos = (553, -1214, 56); ang = (0, -50, 0); if(getDvar("language") == "spanish") location = "saloon"; else location = "saloon"; break;
			case "jug": pos = (-660, 1030, 8); ang = (0, -90, 0); if(getDvar("language") == "spanish") location = "titán"; else location = "jug"; break;
			case "tunel": pos = (-483, 293, 423); ang = (0, -40, 0); if(getDvar("language") == "spanish") location = "tunel"; else location = "tunel"; break;
			default: return;
		}
	if(isorigins())
		switch(location)
		{
			case "church": pos = (1878, -1358, 150); ang = (0, 140, 0); if(getDvar("language") == "spanish") location = "iglesia"; else location = "church"; break;
			case "tcp": pos = (10335, -7902, -411); ang = (0, 140, 0); if(getDvar("language") == "spanish") location = "the crazy place"; else location = "the crazy place"; break;
			case "gen1": pos = (2340, 4978, -303); ang = (0, -132, 0); if(getDvar("language") == "spanish") location = "generador 1"; else location = "generator 1"; break;
			case "gen2": pos = (469, 4788, -285); ang = (0, -134, 0); if(getDvar("language") == "spanish") location = "generador 2"; else location = "generator 2"; break;
			case "gen3": pos = (740, 2123, -125); ang = (0, 135, 0); if(getDvar("language") == "spanish") location = "generador 3"; else location = "generator 3"; break;
			case "gen4": pos = (2337, -170, 140); ang = (0, 90, 0); if(getDvar("language") == "spanish") location = "generador 4"; else location = "generator 4"; break;
			case "gen5": pos = (-2830, -21, 238); ang = (0, 40, 0); if(getDvar("language") == "spanish") location = "generador 5"; else location = "generator 5"; break;
			case "gen6": pos = (732, -3923, 300); ang = (0, 50, 0); if(getDvar("language") == "spanish") location = "generador 6"; else location = "generator 6"; break;
			case "tank": pos = level.vh_tank.origin + (0, 0, 50); ang = level.vh_tank.angles; if(getDvar("language") == "spanish") location = "tanque"; else location = "tank"; break;
			default: return;
		}

    if(isdefined(who))
    {
        foreach(zplayer in level.players)
            if(level.players.name == who)
                player = zplayer;
    }

	strattesterprint("Teleporting " + player.name + " to " + location, "Teletransportando " + player.name + " a " + location);
    player setOrigin(pos);
    player setPlayerAngles(ang);
}

powercase()
{
    setDvar("power", !getDvarInt("st_power"));
    if(getDvarInt("st_power"))
        strattesterprint("Power will be turned on at the start of the game", "La energía estará activada al principio de la partida");
    else
        strattesterprint("Power will not be turned on at the start of the game", "La energía estará desactivada al principio de la partida");
}

boardscase()
{
    setDvar("boards", !getDvarInt("st_boards"));
    if(getDvarInt("st_boards"))
        strattesterprint("Boards will be removed at the start of the game", "Las barreras de las ventanas serán quitadas al principio de la partida");
    else
        strattesterprint("Boards will not be removed at the start of the game", "Las barreras de las ventanas quedarán puestas al principio de la partida");
}

doorscase()
{
    setDvar("doors", !getDvarInt("doors"));
    if(getDvarInt("doors"))
        strattesterprint("Doors will be opened at the start of the game", "Las puertas estarán abiertas al principio de la partida");
    else
        strattesterprint("Doors will not be opened at the start of the game", "Las puertas estarán cerradas al principio de la partida");
}

weaponscase()
{
    setDvar("weapons", !getDvarInt("st_weapons"));
    if(getDvarInt("st_weapons"))
        strattesterprint("You will spawn with weapons", "Aparecerás con las armas necesarias");
    else
        strattesterprint("You will not spawn with weapons", "Aparecerás con la pistola del principio");
}

perkscase()
{
    setDvar("perks", !getDvarInt("st_perks"));
    if(getDvarInt("st_perks"))
        strattesterprint("You will spawn with perks", "Aparecerás con ventajas y se te devolverán al revivir");
    else
        strattesterprint("You will spawn without perks", "No recibiras ventajas al principio de la partida ni al morir");
}

dropscase()
{
    setDvar("remove_drops", !getDvarInt("st_remove_drops"));
    if(getDvarInt("st_remove_drops"))
        strattesterprint("Drops will no longer spawn", "Los Power-Ups no aparecerán");
    else
        strattesterprint("Drops will spawn", "Los Power-Ups aparecerán");
}

fogcase()
{
	setDvar("r_fog", !getDvarInt("r_fog"));
	if(!getDvarInt("r_fog"))
		strattesterprint("Removing fog", "Quitando niebla");
	else
		strattesterprint("Adding fog", "Añadiendo niebla");
}
notargetcase(player, who)
{
    if(isdefined(who))
    {
        foreach(zplayer in level.players)
            if(level.players.name == who)
                player = zplayer;
    }

	if(!isdefined(player.innotarget))
		player.innotarget = true;
	else
		player.innotarget = !player.innotarget;
	if(player.innotarget)
		strattesterprint(player.name + " will be ignored by zombies", player.name + " será ignorado por los zombis");
	else
		strattesterprint(player.name + " can be targeted by zombies", player.name + " atrará zombis");
}

in_array(data, array)
{
	foreach(element in array)
		if(element == data)
			return true;
	return false;
}

departcase(time)
{
    setDvar("depart", time);
    if(time >= 40 && time <= 180)
        strattesterprint("Next game, bus will stop for " + time + " seconds on farm.", "En la siguiente partida, el bus esperará " + time + " segundos en granja." );
    else
        strattesterprint("Bad input, try a number between 40 and 180", "Usa un número entre 40 y 180");
}

jugcase()
{
    setDvar("st_jug_setup", !getDvarInt("st_jug_setup"));
    if(getDvarInt("st_jug_setup"))
        strattesterprint("You will spawn with jug instead of speed cola", "Aparecerás con titán en vez de prestidigitación");
    else
        strattesterprint("You will spawn with speed cola instead of jug", "Aparecerás con prestidigitación en vez de titán");
}

istranzit()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "transit" && level.scr_zm_ui_gametype_group == "zclassic");
}


busstatuscase()
{
	if(!istranzit())
		return;

    setDvar("busstatus", !getDvarInt("st_busstatus"));
}

permacase(player)
{
    strattesterprint("Awarding perman perks to " + player.name, "Otorgando las ventajas a " + player.name);
    player thread award_permaperks_safe();
}

denizencase()
{
    if(!istranzit())
        return;
    setDvar("denizens", !getDvarInt("denizens"));
}

award_permaperks_safe()
{
	level endon("end_game");
	self endon("disconnect");

	while (!isalive(self))
		wait 0.05;

	wait 0.5;
    perks_to_process = [];
    
    perks_to_process[perks_to_process.size] = permaperk_array("revive");
    perks_to_process[perks_to_process.size] = permaperk_array("multikill_headshots");
    perks_to_process[perks_to_process.size] = permaperk_array("perk_lose");
    perks_to_process[perks_to_process.size] = permaperk_array("jugg", undefined, undefined, 15);
    perks_to_process[perks_to_process.size] = permaperk_array("flopper", array("zm_buried"));
    perks_to_process[perks_to_process.size] = permaperk_array("box_weapon", array("zm_highrise", "zm_buried"), array("zm_transit"));
    perks_to_process[perks_to_process.size] = permaperk_array("cash_back");
    perks_to_process[perks_to_process.size] = permaperk_array("sniper");
    perks_to_process[perks_to_process.size] = permaperk_array("insta_kill");
    perks_to_process[perks_to_process.size] = permaperk_array("pistol_points");
    perks_to_process[perks_to_process.size] = permaperk_array("double_points");

	foreach (perk in perks_to_process)
	{
		if( !(istranzit() && perk == permaperk_array("box_weapon", array("zm_highrise", "zm_buried"), array("zm_transit"))))
		self resolve_permaperk(perk);
		wait 0.05;
	}
	if(istranzit())
        level.pers_box_weapon_lose_round = 0;

	wait 0.5;
	self maps\mp\zombies\_zm_stats::uploadstatssoon();
}

permaperk_array(code, maps_award, maps_take, to_round)
{
	if (!isDefined(maps_award))
		maps_award = array("zm_transit", "zm_highrise", "zm_buried");
	if (!isDefined(maps_take))
		maps_take = [];
	if (!isDefined(to_round))
		to_round = 255;

	permaperk = [];
	permaperk["code"] = code;
	permaperk["maps_award"] = maps_award;
	permaperk["maps_take"] = maps_take;
	permaperk["to_round"] = to_round;

	return permaperk;
}

resolve_permaperk(perk)
{
	wait 0.05;

	perk_code = perk["code"];

	if (isinarray(perk["maps_award"], level.script) && !self.pers_upgrades_awarded[perk_code])
	{
		for (j = 0; j < level.pers_upgrades[perk_code].stat_names.size; j++)
		{
			stat_name = level.pers_upgrades[perk_code].stat_names[j];
			stat_value = level.pers_upgrades[perk_code].stat_desired_values[j];

			self award_permaperk(stat_name, perk_code, stat_value);
		}
	}

	if (isinarray(perk["maps_take"], level.script) && self.pers_upgrades_awarded[perk_code])
		self remove_permaperk(perk_code);
}


award_permaperk(stat_name, perk_code, stat_value)
{
	flag_set("permaperks_were_set");
	self.stats_this_frame[stat_name] = 1;
	self maps\mp\zombies\_zm_stats::set_global_stat(stat_name, stat_value);
	self playsoundtoplayer("evt_player_upgrade", self);
}

remove_permaperk(perk_code)
{
	self.pers_upgrades_awarded[perk_code] = 0;
	self playsoundtoplayer("evt_player_downgrade", self);
}


shieldcase()
{
    setDvar("shield", !getDvarInt("st_shield"));
    if(getDvarInt("st_shield"))
        strattesterprint("Restart the match to spawn with shield", "Reinicia la partida para empezarla con un escudo");
    else
        strattesterprint("Restart the match to spawn without shield", "Reinicia la partida para quitar el escudo");
}

cherrycase()
{
    setDvar("st_cherry", !getDvarInt("st_cherry"));
    if(getDvarInt("st_cherry"))
        strattesterprint("You will spawn with electric cherry", "Reaparecerás con cherry");
    else
        strattesterprint("You will not spawn with electric cherry", "Reaparecerás sin cherry");
}

wmcase()
{
    setDvar("st_wm", !getDvarInt("st_wm"));
    if(getDvarInt("st_wm"))
        strattesterprint("You will spawn with war machine", "Aparecerás con la máquina de guerra");
    else
        strattesterprint("You will not spawn with war machine", "Aparecerás sin la máquina de guerra");
}

staffcase()
{
	setDvar("st_staff", !getDvarInt("st_staff"));
	if(getDvarInt("st_staff"))
		strattesterprint("You will spawn with the ice staff", "Aparecerás con el bastón de hielo");
	else
		strattesterprint("You can spawn with the wind staff", "Aparecerás con el bastón de viento");
}

livescase()
{
    setDvar("st_lives", !getDvarInt("st_lives"));
    if(getDvarInt("lives"))
        strattesterprint("Infinite lives deactivated", "Vidas infinitas desactivadas");
    else
        strattesterprint("Infinite lives activated", "Vidas infinitas activadas");
}

buriedcase()
{
	if(getDvarInt("st_setupBuried") == 0)
    {
		strattesterprint("Subwofer will be built at jug", "El resonador estará construido en Titán");
	    setDvar("st_setupBuried", 0);
    }
	else if (getDvarInt("st_setupBuried") == 1)
    {
		strattesterprint("Subwofer will be built at saloon", "El resonador estará construido en el saloon");
	    setDvar("st_setupBuried", 1);
    }
    else
    {
		strattesterprint("No buildables will be prebuilt", "Ningún construible aparecerá montado");
        setDvar("st_setupBuried", -1);
    }
}

boxhitscase()
{
	setDvar("st_boxhits", !getDvarInt("st_boxhits"));
}

elevatorcase()
{
    setDvar("st_elevatorkills", !getDvarInt("st_elevatorkills"));
}

despawnerscase()
{
    setDvar("st_despawners", !getDvarInt("st_despawners"));
}

subcase()
{
    setDvar("st_subwooferkills", !getDvarInt("st_subwooferkills"));
}

changeroundcase(round)
{
    rnd = string_to_float(round);

    level.round_number = rnd - 1;
    endround(true);
    strattesterprint("Changing round to " + round, "Cambiado ronda a " + round);
}

helpcase()
{
	i = 0;
	while (i < level.StratTesterCommands)
	{
		text = "";

		for (j = 0; j < 10; j++)
		{
			if (!isdefined(level.StratTesterCommands[i + j]))
				break;

			if (j > 0)
				text += "  ";

			text += level.StratTesterCommands[i + j];
		}

		if (text != "")
			strattesterprint(text);

		i += 10;
		wait 0.1;
	}
}


changeroundrework()
{
//     flag_wait("initial_blackscreen_passed");

//     last_requested = getDvarInt("round");
//     setDvar("changeround", last_requested);

//     while(true)
//     {
//         wait 0.1;

//         requested_ui = getDvarInt("changeround");
//         desired_rnd = requested_ui - 1;
//         current_rnd = level.round_number;

//         if(requested_ui == last_requested || desired_rnd == current_rnd)
//             continue;

//         last_requested = requested_ui;

//         level.round_number = desired_rnd;
//         endround(true);

//         strattesterprint("Changing round to " + requested_ui, "Cambiado ronda a " + requested_ui);

//         level waittill("start_of_round");
//     }
}

killhorderework()
{
	flag_wait("initial_blackscreen_passed");
    setDvar("st_killhorde", 0);
    while(true)
    {
        while(getDvarInt("st_killhorde") == 0)
            wait 0.1;
        setDvar("killhorde", 0);
        endround(false);
        strattesterprint("Killing current horde", "Matando horda actual");
    }
}

endroundrework()
{
	flag_wait("initial_blackscreen_passed");
    while(true)
    {
        wait 0.1;
        if(getDvarInt("st_endround") == 0)
            continue;
        desired_rnd = getDvarInt("st_endround");
        setDvar("endround", 0);
        endround(true);
        strattesterprint("Changing round to " + desired_rnd, "Cambiado ronda a " + desired_rnd);
    }
}

unlockgensrework()
{
    setDvar("st_unlockgens", 0);
    while(true)
    {
        while(getDvarInt("st_unlockgens") == 0)
            wait 0.1;
        setDvar("st_unclockgens", 0);

	    foreach (gen in getstructarray( "s_generator", "targetname" ))
		    gen thread [[getfunction("maps\mp\zm_tomb_capture_zones", "init_capture_zone")]]();
	    strattesterprint("All generators have been unlocked", "Todos los generadores han sido desbloqueados");
    }
}

notargetrework()
{
    setDvar("st_notarget" + self.name, 0);
    while(true)
    {
        while(getDvarInt("st_notarget" + self.name) == 0)
            wait 0.1;
        setDvar("st_notarget" + self.name, 0);

        if(!isdefined(self.innotarget))
            self.innotarget = true;
        else
            self.innotarget = !self.innotarget;

	    if(self.innotarget)
		    strattesterprint(self.name + " will be ignored by zombies", self.name + " será ignorado por los zombis");
	    else
		    strattesterprint(self.name + " can be targeted by zombies", self.name + " atrará zombis");
    }
}

boxmoverework()
{
    while(true)
    {
        wait 0.1;
        location = getDvar("st_boxmove");
        if(location == "none")
            continue;
            
        setDvar("st_boxmove", "none");
        boxmove(location);
    }
}

tprework()
{
    while(true)
    {
        wait 0.1;
        destination = getDvar("st_tp" + self.name);
        if(destination == "none")
            continue;
        setDvar("st_tp" + self.name, "none");
        tpcase(self, destination, self);
    }
}

specialcommands()
{
    self thread tprework();
    self thread boxmoverework();
    self thread notargetrework();
    self thread unlockgensrework();
    self thread endroundrework();
    self thread killhorderework();
    self thread changeroundrework();
}