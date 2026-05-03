#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\strattester\timers;
#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\hud;
#include scripts\zm\strattester\box;


addCommands(commands)
{
    foreach(command in commands)
        level.StratTesterCommands[level.StratTesterCommands.size] = command;
}

readchat() 
{
    self endon("end_game");
	level.StratTesterCommands = [];
    addCommands(array("!tpc", "!tp", "!nuke", "!max", "!x2", "!sale", "!blood", "!perk", "!insta"));

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
        switch(msg[0])
        {
            case "!tpc": tpccase(player, msg[1], msg[3], msg[2]); break;
            case "!tp": tpcase(player, msg[1], msg[2]); break;
            case "!nuke": level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("nuke", player.origin + (0, 0, 40)); break;
            case "!max": level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("full_ammo", player.origin + (0, 0, 40)); break;
            case "!x2": level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("double_points", player.origin + (0, 0, 40)); break;
            case "!sale": level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("fire_sale", player.origin + (0, 0, 40)); break;
            case "!blood": level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("zombie_blood", player.origin + (0, 0, 40)); break;
            case "!perk": level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("free_perk", player.origin + (0, 0, 40)); break;
            case "!insta": level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("insta_kill", player.origin + (0, 0, 40)); break;
            default: break;
        }
    }
}

zombie_can_drop_powerups(zombie)
{
    if ( is_tactical_grenade( zombie.damageweapon ) || !flag( "zombie_drop_powerups" ) )
        return false;

    if ( isdefined( zombie.no_powerups ) && zombie.no_powerups )
        return false;

    return !getDvarInt("st_remove_drops");
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

boxhitscase()
{
	setDvar("st_boxhits", !getDvarInt("st_boxhits"));
}

changeroundrework()
{
    flag_wait("initial_blackscreen_passed");

    last_requested = getDvarInt("round");
    setDvar("st_changeround", last_requested);

    while(true)
    {
        wait 0.1;

        requested_ui = getDvarInt("st_changeround");
        desired_rnd = requested_ui - 1;
        current_rnd = level.round_number;

        if(requested_ui == last_requested || desired_rnd == current_rnd)
            continue;

        last_requested = requested_ui;

        changeRound(desired_rnd);

        strattesterprint("Changing round to " + requested_ui, "Cambiado ronda a " + requested_ui);

        level waittill("start_of_round");
    }
}

killhorderework()
{
	flag_wait("initial_blackscreen_passed");
    setDvar("st_killhorde", 0);
    while(true)
    {
        while(getDvarInt("st_killhorde") == 0)
            wait 0.1;
        setDvar("st_killhorde", 0);
        killHorde();
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
        setDvar("st_endround", 0);
        endround();
        strattesterprint("Ending current round", "Terminando ronda actual");
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

boxmove( location )
{
    if ( isDefined( level._zombiemode_custom_box_move_logic ) )
        kept_move_logic = level._zombiemode_custom_box_move_logic;

    level._zombiemode_custom_box_move_logic = ::force_next_location;

    foreach ( chest in level.chests )
    {
        if ( !chest.hidden && chest.script_noteworthy == location )
        {
            if ( isDefined( kept_move_logic ) )
                level._zombiemode_custom_box_move_logic = kept_move_logic;
            return;
        }
        if ( !chest.hidden )
        {
            level.chest_min_move_usage = 8;
            level.chest_name = location;

            flag_set( "moving_chest_now" );
            chest thread fast_chest_move();

            wait 0.05;
            level notify( "weapon_fly_away_start" );
            wait 0.05;
            level notify( "weapon_fly_away_end" );

            break;
        }
    }

    while ( flag( "moving_chest_now" ) )
        wait 0.05;

    if ( isDefined( kept_move_logic ) )
        level._zombiemode_custom_box_move_logic = kept_move_logic;

    if ( isDefined( level.chest_name ) && isDefined( level.dig_magic_box_moved ) )
        level.dig_magic_box_moved = 0;

    level.chest_min_move_usage = 4;
}

force_next_location()
{
    for (i = 0; i < level.chests.size; i++)
        if (level.chests[i].script_noteworthy == level.chest_name)
            level.chest_index = i;
}

specialcommands()
{
    self thread unlockgensrework();
    self thread endroundrework();
    self thread killhorderework();
    self thread commandmenulistener();
    self thread changeroundrework();
}

commandmenulistener()
{
    self endon( "disconnect" );
    self notify( "commandmenulistener" );
    self endon( "commandmenulistener" );
    level endon( "game_ended" );

    while ( true )
    {
        self waittill( "menuresponse", menu, response );

        if ( !isdefined( menu ) || !isdefined( response ) )
            continue;

        if ( menu != "restartgamepopup" )
            continue;

        if ( issubstr( response, "sttp+" ) )
        {
            parts = strtok( response, "+" );
            if ( parts.size >= 2 )
                tpcase( self, parts[1], undefined );
            continue;
        }

        if ( issubstr( response, "stnotarget+" ) )
        {
            parts = strtok( response, "+" );
            if ( parts.size >= 2 )
            {
                self.ignoreme = ( parts[1] == "1" );
                if ( self.ignoreme )
                    strattesterprint( self.name + " will be ignored by zombies", self.name + " será ignorado por los zombis" );
                else
                    strattesterprint( self.name + " can be targeted by zombies", self.name + " atraerá zombis" );
            }
            continue;
        }

        if ( issubstr( response, "stboxmove+" ) )
        {
            parts = strtok( response, "+" );
            if ( parts.size >= 2 )
                level thread boxmove( parts[1] );
            continue;
        }
    }
}