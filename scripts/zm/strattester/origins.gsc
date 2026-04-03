#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zm_tomb_capture_zones;

pack_a_punch_think()
{
	pack_a_punch_enable();
}

watch_staff_usage()
{
    self notify( "watch_staff_usage" );
    self endon( "watch_staff_usage" );
    self endon( "disconnect" );
    self setclientfieldtoplayer( "player_staff_charge", 0 );

    while ( true )
    {
        self waittill( "weapon_change", weapon );
        has_upgraded_staff = 0;
        has_revive_staff = 0;
        weapon_is_upgraded_staff = is_weapon_upgraded_staff( weapon );
        str_upgraded_staff_weapon = undefined;
        a_str_weapons = self getweaponslist();

        foreach ( str_weapon in a_str_weapons )
        {
            if ( is_weapon_upgraded_staff( str_weapon ) )
            {
                has_upgraded_staff = 1;
                str_upgraded_staff_weapon = str_weapon;
            }

            if ( str_weapon == "staff_revive_zm" )
                has_revive_staff = 1;
        }

        if ( !has_revive_staff || !weapon_is_upgraded_staff && "none" != weapon && "none" != weaponaltweaponname( weapon ) )
            self setactionslot( 3, "altmode" );
        else
            self setactionslot( 3, "weapon", "staff_revive_zm" );

        if ( weapon_is_upgraded_staff )
            self thread staff_charge_watch_wrapper( weapon );
    }
}


tomb_give_equipment()
{
	flag_wait( "start_zombie_round_logic" );
	self.dig_vars[ "has_shovel" ] = 1;
    self.dig_vars["has_upgraded_shovel"] = 1;
    self.dig_vars["has_helmet"] = 1;
	n_player = self getentitynumber() + 1;
	level setclientfield( "shovel_player" + n_player, 2 );
    level setclientfield( "helmet_player" + n_player, 1 );
}

placeStaffsInChargers() 
{
    p = getPlayers()[0];
    for (i = 1; i <= 4; i++) {
        level notify("player_teleported", p, i);
        flag_set("charger_ready_" + i);
        wait 0.5;
    }
    foreach (staff in level.a_elemental_staffs) {        
        staff.charger.is_inserted = 1;
        maps\mp\zm_tomb_craftables::clear_player_staff( staff.weapname );
        staff.charge_trigger trigger_off();
        if ( isdefined( staff.charger.angles ) )
            staff.angles = staff.charger.angles;
        staff moveto( staff.charger.origin, 0.05 );
        staff waittill( "movedone" );
        staff setclientfield( "staff_charger", staff.enum );
        staff.charger.full = 0;
        staff show();
        staff playsound( "zmb_squest_charge_place_staff" );
        flag_set(staff.weapname + "_upgrade_unlocked");
        staff.charger.charges_received = 20;
    }
}


call_tank()
{
    str_loc = level.vh_tank.str_location_current;
    a_trigs = getentarray( "trig_tank_station_call", "targetname" );
    moving = level.vh_tank ent_flag( "tank_moving" );
    cooling = level.vh_tank ent_flag( "tank_cooldown" );

	foreach ( trig in a_trigs )
	{
		if ( moving )
		{
			trig setvisibletoall();
			trig sethintstring( &"ZM_TOMB_TNKM" );
			continue;
		}
		if ( cooling )
		{
			trig setvisibletoall();
			trig sethintstring( &"ZM_TOMB_TNKC" );
			continue;
		}
		trig setvisibletoall();
		trig sethintstring( &"ZM_TOMB_X2CT", 500 );
	}
	wait 0.1;
}

stomptracker()
{
	self endon("disconnect");
	level.stompkills = 0;
	level.stomp_hud = newclienthudelem(self);
	level.stomp_hud.alignx = "left";
	level.stomp_hud.aligny = "bottom";
	level.stomp_hud.horzalign = "user_left";
	level.stomp_hud.vertalign = "user_bottom";
	level.stomp_hud.x = 0;
	level.stomp_hud.y = -220;
	level.stomp_hud.fontscale = 1.6;
	level.stomp_hud.alpha = 0;
	level.stomp_hud.hidewheninmenu = 0;
	level.stomp_hud.hidden = 0;
	level.stomp_hud.label = &"^3Stomp: ^5";
	flag_wait("initial_blackscreen_passed");
	while(1)
	{
		level.stomp_hud setvalue(level.stompkills);
		wait(0.05);
	}
}

tanktracker()
{
	self endon("disconnect");
	level.tankkills = 0;
	level.tank_hud = newclienthudelem(self);
	level.tank_hud.alignx = "left";
	level.tank_hud.aligny = "bottom";
	level.tank_hud.horzalign = "user_left";
	level.tank_hud.vertalign = "user_bottom";
	level.tank_hud.x = level.tank_hud.x - 0;
	level.tank_hud.y = level.tank_hud.y - 180;
	level.tank_hud.fontscale = 1.6;
	level.tank_hud.alpha = 0;
	level.tank_hud.hidewheninmenu = 0;
	level.tank_hud.hidden = 0;
	level.tank_hud.label = &"^3Tank: ^5";
	flag_wait("initial_blackscreen_passed");
	while(1)
	{
		level.tank_hud setvalue(level.tankkills);
		wait(0.05);
	}
}

tumbletracker()
{
	self endon("disconnect");
	level.tumbles = 0;
	level.tumble_hud = newclienthudelem(self);
	level.tumble_hud.alignx = "left";
	level.tumble_hud.aligny = "bottom";
	level.tumble_hud.horzalign = "user_left";
	level.tumble_hud.vertalign = "user_bottom";
	level.tumble_hud.x = 0;
	level.tumble_hud.y = -200;
	level.tumble_hud.fontscale = 1.6;
	level.tumble_hud.alpha = 0;
	level.tumble_hud.hidewheninmenu = 0;
	level.tumble_hud.hidden = 0;
	level.tumble_hud.label = &"^3Tumble: ^5";
	flag_wait("initial_blackscreen_passed");
	while(1)
	{
		level.tumble_hud setvalue(level.tumbles);
		wait(0.05);
	}
}

custom_zombie_stomp_death(robot, a_zombies_to_kill)
{
	n_interval = 0;
	for(i = 0; i < a_zombies_to_kill.size; i++)
	{
		zombie = a_zombies_to_kill[i];
		if(isdefined(zombie) && isalive(zombie))
		{
			zombie dodamage(zombie.health, zombie.origin, robot);
			level.stompkills++;
			n_interval++;
			if(n_interval >= 4)
			{
				wait_network_frame();
				n_interval = 0;
			}
		}
	}
}

custom_knockdown_zombie_animate_state()
{
	level.tumbles++;
	self endon("death");
	self.is_knocked_down = 1;
	self waittill_any("damage", "back_up");
	self.is_knocked_down = 0;
}


enable_all_teleporters()
{
	flag_wait( "initial_blackscreen_passed" );
	flag_set( "activate_zone_chamber" );
	while(1)
	{
		if ( level.zones[ "zone_nml_18" ].is_enabled && !isDefined(gramo))
		{
			a_door_main = getentarray( "chamber_entrance", "targetname" );
			array_thread( a_door_main, ::open_gramophone_door );
			gramo = 1;
		}
		if( level.zones[ "zone_air_stairs" ].is_enabled && !isDefined(air))
		{
			maps\mp\zm_tomb_teleporter::stargate_teleport_enable( 2 );
			air = 1;
		}
		if( level.zones[ "zone_fire_stairs" ].is_enabled && !isDefined(fire))
		{
			maps\mp\zm_tomb_teleporter::stargate_teleport_enable( 1 );
			fire = 1;
		}
		if( level.zones[ "zone_nml_farm" ].is_enabled && !isDefined(light))
		{
			maps\mp\zm_tomb_teleporter::stargate_teleport_enable( 3 );
			light = 1;
		}
		if( level.zones[ "zone_ice_stairs" ].is_enabled && !isDefined(ice))
		{
			maps\mp\zm_tomb_teleporter::stargate_teleport_enable( 4 );
			ice = 1;
		}
		if( isDefined(air) && isDefined(fire) && isDefined(light) && isDefined(ice) && isDefined(gramo) )
		{
			break;
		}
		wait 1;
	}
}

open_gramophone_door()
{
	flag_init( self.targetname + "_opened" );
	trig_position = getstruct( self.targetname + "_position", "targetname" );
	trig_position.has_vinyl = 0;
	trig_position.gramophone_model = undefined;
	t_door = tomb_spawn_trigger_radius( trig_position.origin, 60, 1 );
	t_door set_unitrigger_hint_string( &"ZOMBIE_BUILD_PIECE_MORE" );
	trig_position.gramophone_model = spawn( "script_model", trig_position.origin );
	trig_position.gramophone_model.angles = trig_position.angles;
	trig_position.gramophone_model setmodel( "p6_zm_tm_gramophone" );
	flag_set( "gramophone_placed" );
	//level setclientfield( "piece_record_zm_player", 0 );
	t_door trigger_off();
	str_song = trig_position get_gramophone_song();
	playsoundatposition( str_song, self.origin );
	self playsound( "zmb_crypt_stairs" );
	wait 6;
	chamber_blocker();
	flag_set( self.targetname + "_opened" );
	if ( isDefined( trig_position.script_flag ) )
	{
		flag_set( trig_position.script_flag );
	}
	level setclientfield( "crypt_open_exploder", 1 );
	self movez( -260, 10, 1, 1 );
	self waittill( "movedone" );
	self connectpaths();
	self delete();
	t_door tomb_unitrigger_delete();
	trig_position.trigger = undefined;
}


readchat_origins() 
{
    self endon("end_game");
	level.StratTesterCommands[level.StratTesterCommands.size] = "!gen";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!unlockgens";
    while (true) 
    {
        level waittill("say", message, player);
        msg = strtok(message, " ");

        if(msg[0][0] != "!")
            continue;
		if(!in_array(msg[0], level.StratTesterCommands))
			continue;

        switch(msg[0])
        {
			case "!gen": changeGenStatus(msg[1]); break;
			case "!unlockgens": unlockgenscase(); break;
        }
    }
}

in_array(data, array)
{
	foreach(element in array)
		if(element == data)
			return true;
	return false;
}

changeGenStatus(generator)
{
	generator = string_to_float(generator);
	switch(generator)
	{
		case 1: name = "generator_start_bunker"; break;
		case 2: name = "generator_tank_trench"; break;
		case 3: name = "generator_mid_trench"; break;
		case 4: name = "generator_nml_right"; break;
		case 5: name = "generator_nml_left"; break;
		case 6: name = "generator_church"; break;
	}
	foreach (gen in getstructarray( "s_generator", "targetname" ))
	{
		if(gen.script_noteworthy == name)
		{
			if(gen.n_current_progress == 100)
			{
				gen.n_current_progress = 0;
				gen set_zombie_controlled_area();
				level setclientfield( gen.script_noteworthy, gen.n_current_progress / 100 );
				level setclientfield( "state_" + gen.script_noteworthy, 0 );
			}
			else
			{
				gen.n_current_progress = 100;
				gen players_capture_zone();
				level setclientfield( gen.script_noteworthy, gen.n_current_progress / 100 );
				level setclientfield( "state_" + gen.script_noteworthy, 2 );
			}
		}
	}
}

unlockgenscase()
{
	foreach (gen in getstructarray( "s_generator", "targetname" ))
		gen thread init_capture_zone();
	strattesterprint("All generators have been unlocked");
}

origins_pap_camo(weapon)
{
	if ( !isdefined( self.pack_a_punch_weapon_options ) )
		self.pack_a_punch_weapon_options = [];

	if ( !is_weapon_upgraded( weapon ) )
		return self calcweaponoptions( 0, 0, 0, 0, 0 );

	if ( isdefined( self.pack_a_punch_weapon_options[weapon] ) )
		return self.pack_a_punch_weapon_options[weapon];

	smiley_face_reticle_index = 1;
	base = get_base_name( weapon );
	camo_index = 39;

	if ( "zm_prison" == level.script )
		camo_index = 40;
	else if ( "zm_tomb" == level.script )
		camo_index = 45;

	lens_index = randomintrange( 0, 6 );
	reticle_index = randomintrange( 0, 16 );
	reticle_color_index = randomintrange( 0, 6 );
	plain_reticle_index = 16;
	r = randomint( 10 );
	use_plain = r < 3;

	if ( "saritch_upgraded_zm" == base )
		reticle_index = smiley_face_reticle_index;
	else if ( use_plain )
		reticle_index = plain_reticle_index;
	scary_eyes_reticle_index = 8;
	purple_reticle_color_index = 3;

	if ( reticle_index == scary_eyes_reticle_index )
		reticle_color_index = purple_reticle_color_index;

	letter_a_reticle_index = 2;
	pink_reticle_color_index = 6;

	if ( reticle_index == letter_a_reticle_index )
		reticle_color_index = pink_reticle_color_index;

	letter_e_reticle_index = 7;
	green_reticle_color_index = 1;

	if ( reticle_index == letter_e_reticle_index )
		reticle_color_index = green_reticle_color_index;

	self.pack_a_punch_weapon_options[weapon] = self calcweaponoptions( camo_index, lens_index, reticle_index, reticle_color_index );
	return self.pack_a_punch_weapon_options[weapon];
}

replacefunctions()
{
	replacefunc(maps\mp\zm_tomb_giant_robot::zombie_stomp_death, ::custom_zombie_stomp_death);
	replacefunc(maps\mp\zm_tomb_tank::flamethrower_damage_zombies, ::custom_flamethrower_damage_zombies);
	replacefunc(maps\mp\zombies\_zm_weap_one_inch_punch::knockdown_zombie_animate_state, ::custom_knockdown_zombie_animate_state);
	replacefunc(maps\mp\zm_tomb_tank::tank_drop_powerups, ::tank_drop_powerups);
	replacefunc(maps\mp\zm_tomb_capture_zones::pack_a_punch_think, ::pack_a_punch_think);
	replacefunc(maps\mp\zm_tomb_utility::watch_staff_usage, ::watch_staff_usage);
    replaceFunc(maps\mp\zm_tomb_tank::tank_push_player_off_edge, ::fixed_tank_push_player_off_edge);
	replacefunc(maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options, ::origins_pap_camo);
    replaceFunc(maps\mp\zm_tomb_distance_tracking::delete_zombie_noone_looking, ::delete_zombie_noone_looking);
}

custom_flamethrower_damage_zombies(n_flamethrower_id, str_tag)
{
	self endon("flamethrower_stop_" + n_flamethrower_id);
	while(1)
	{
		a_targets = tank_flamethrower_get_targets(str_tag, n_flamethrower_id);
		foreach(ai_zombie in a_targets)
		{
			if(isalive(ai_zombie))
			{
				a_players = get_players_on_tank(1);
				if(a_players.size > 0)
				{
					level notify("vo_tank_flame_zombie");
				}
				if(str_tag == "tag_flash")
				{
					level.tankkills++;
					ai_zombie do_damage_network_safe(self, ai_zombie.health, "zm_tank_flamethrower", "MOD_BURNED");
					ai_zombie thread zombie_gib_guts();
				}
				else
				{
					ai_zombie thread maps\mp\zombies\_zm_weap_staff_fire::flame_damage_fx("zm_tank_flamethrower", self);
				}
				wait(0.05);
			}
		}
		wait_network_frame();
	}
}

tank_drop_powerups()
{
    flag_wait( "start_zombie_round_logic" );
    a_drop_nodes = [];

    for ( i = 0; i < 3; i++ )
    {
        drop_num = i + 1;
        a_drop_nodes[i] = getvehiclenode( "tank_powerup_drop_" + drop_num, "script_noteworthy" );
        a_drop_nodes[i].next_drop_round = 0;
        s_drop = getstruct( "tank_powerup_drop_" + drop_num, "targetname" );
        a_drop_nodes[i].drop_pos = s_drop.origin;
    }

    a_possible_powerups = array( "nuke", "full_ammo", "zombie_blood", "insta_kill", "fire_sale", "double_points" );

    while ( true )
    {
        self ent_flag_wait( "tank_moving" );

        foreach ( node in a_drop_nodes )
        {
            dist_sq = distance2dsquared( node.origin, self.origin );

            if ( dist_sq < 250000 )
            {
                a_players = get_players_on_tank( 1 );

                if ( a_players.size > 0 )
                {
                    if (level.round_number >= node.next_drop_round )
                    {
                        str_powerup = random( a_possible_powerups );
                        level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop( str_powerup, node.drop_pos );
                        node.next_drop_round = level.round_number + randomintrange( 8, 12 );
                        continue;
                    }

                    level notify( "sam_clue_tank", self );
                }
            }
        }

        wait 2.0;
    }
}

fixed_tank_push_player_off_edge()
{
    return;
}

delete_zombie_noone_looking( how_close, how_high )
{
    self endon( "death" );

    if ( !isdefined( how_close ) )
        how_close = 1500;

    if ( !isdefined( how_high ) )
        how_high = 600;

    distance_squared_check = how_close * how_close;
    too_far_dist = distance_squared_check * 3;

    if ( isdefined( level.zombie_tracking_too_far_dist ) )
        too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;

    self.inview = 0;
    self.player_close = 0;
    n_distance_squared = 0;
    n_height_difference = 0;
    players = get_players();

    for ( i = 0; i < players.size; i++ )
    {
        if ( players[i].sessionstate == "spectator" )
            continue;

        if ( isdefined( level.only_track_targeted_players ) )
        {
            if ( !isdefined( self.favoriteenemy ) || self.favoriteenemy != players[i] )
                continue;
        }

        can_be_seen = self player_can_see_me( players[i] );

        if ( can_be_seen && distancesquared( self.origin, players[i].origin ) < too_far_dist )
            self.inview++;

        n_modifier = 1.0;

        if ( isdefined( players[i].b_in_tunnels ) && players[i].b_in_tunnels )
            n_modifier = 2.25;

        n_distance_squared = distancesquared( self.origin, players[i].origin );
        n_height_difference = abs( self.origin[2] - players[i].origin[2] );

        if ( n_distance_squared < distance_squared_check * n_modifier && n_height_difference < how_high )
            self.player_close++;
    }

    if ( self.inview == 0 && self.player_close == 0 )
    {
        if ( !isdefined( self.animname ) || self.animname != "zombie" && self.animname != "mechz_zombie" )
            return;

        if ( isdefined( self.electrified ) && self.electrified == 1 )
            return;

        if ( isdefined( self.in_the_ground ) && self.in_the_ground == 1 )
            return;

        zombies = getaiarray( "axis" );

        if ( ( !isdefined( self.damagemod ) || self.damagemod == "MOD_UNKNOWN" ) && self.health < self.maxhealth )
        {
            if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
            {
                level.zombie_total++;
                level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
            }
        }
        else if ( zombies.size + level.zombie_total > 24 || zombies.size + level.zombie_total <= 24 && self.health >= self.maxhealth )
        {
            if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
            {
                level.zombie_total++;

                if ( self.health < level.zombie_health )
                    level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
            }
        }

        self maps\mp\zombies\_zm_spawner::reset_attack_spot();
        self notify( "zombie_delete" );

        if ( isdefined( self.is_mechz ) && self.is_mechz )
        {
            self notify( "mechz_cleanup" );
            level.mechz_left_to_spawn++;
            wait_network_frame();
            level notify( "spawn_mechz" );
        }

        if(getDvarInt("despawners"))
        {
            strattesterprint("Zombie despawned");
            level.despawners++;
        }
        self delete();
        recalc_zombie_array();
    }
}

strattesterprint(message)
{
	foreach(player in level.players)
		player iprintln("^5[^6Strat Tester^5]^7 " + message);
}

give_max_ammo_reward()
{
	foreach(player in level.players)
			for(i = 0; i < 6; i++)
				player maps\mp\zombies\_zm_challenges::increment_stat( "zc_zone_captures" );
}

turn_gens_on()
{
	foreach (gen in getstructarray( "s_generator", "targetname" ))
	{
		if(gen.script_noteworthy == "generator_nml_right")
			continue;
		gen.n_current_progress = 100;
		gen players_capture_zone();
		level setclientfield( gen.script_noteworthy, gen.n_current_progress / 100 );
    	level setclientfield( "state_" + gen.script_noteworthy, 2 );
	}
}