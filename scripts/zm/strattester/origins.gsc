#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zm_tomb_capture_zones;
#include maps\mp\zm_tomb_tank;

#include scripts\zm\strattester\utility;

origins_trackers()
{
	self endon("disconnect");

    self.stomp_hud   = self createHudElem(&"^3Stomp: ^5", 0, -220, 1.6, 0, "left", "bottom");
    self.tank_hud  = self createHudElem(&"^3Tank: ^5", 0, -180, 1.6, 0, "left", "bottom");
    self.tumble_hud  = self createHudElem(&"^3Tumble: ^5", 0, -200, 1.6, 0, "left", "bottom");

	if(!isdefined(level.tumbles)) level.tumbles = 0;
	if(!isdefined(level.tankkills)) level.tankkills = 0;
	if(!isdefined(level.stompkills)) level.stompkills = 0;

	self thread alphatrackers();

	flag_wait("initial_blackscreen_passed");
	while(true)
	{
		self.stomp_hud setvalue(level.stompkills);
		self.tank_hud setvalue(level.tankkills);
		self.tumble_hud setvalue(level.tumbles);
		wait(0.05);
	}
}

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
	while(true)
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


replacefunctions()
{
	replacefunc(getfunction("maps/mp/zm_tomb_giant_robot", "zombie_stomp_death"), ::custom_zombie_stomp_death);
	replacefunc(getfunction("maps/mp/zm_tomb_tank", "flamethrower_damage_zombies"), ::custom_flamethrower_damage_zombies);
	replacefunc(getfunction("maps/mp/zombies/_zm_weap_one_inch_punch", "knockdown_zombie_animate_state"), ::custom_knockdown_zombie_animate_state);
	replacefunc(getfunction("maps/mp/zm_tomb_tank", "tank_drop_powerups"), ::tank_drop_powerups);
	replacefunc(getfunction("maps/mp/zm_tomb_capture_zones", "pack_a_punch_think"), ::pack_a_punch_think);
	replacefunc(getfunction("maps/mp/zm_tomb_utility", "watch_staff_usage"), ::watch_staff_usage);
    replaceFunc(getfunction("maps/mp/zm_tomb_tank", "tank_push_player_off_edge"), ::fixed_tank_push_player_off_edge);
	replacefunc(getfunction("maps/mp/zm_tomb_capture_zones", "recapture_round_tracker"), ::recapture_round_tracker);
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

alphatrackers()
{
	while(true)
	{
		wait 0.1;
		self.stomp_hud.alpha = getDvarInt("st_stomp");
		self.tumble_hud.alpha = getDvarInt("st_tumble");
		self.tank_hud.alpha = getDvarInt("st_tank");
	}
}

recapture_round_tracker()
{
    n_next_recapture_round = 10;

    while ( true )
    {
        level waittill_any( "between_round_over", "force_recapture_start" );
        if ( level.round_number >= n_next_recapture_round && !flag( "zone_capture_in_progress" ) && get_captured_zone_count() >= get_player_controlled_zone_count_for_recapture() )
        {
            n_next_recapture_round = level.round_number + randomintrange( 3, 6 );
            level thread recapture_round_start();
        }
		if(n_next_recapture_round > (level.round_number + 7))
		{
            n_next_recapture_round = level.round_number + randomintrange( 3, 6 );
		}
    }
}

fixPanzerRounds()
{
	while(true)
	{
		level waittill("between_round_over");
		if(level.next_mechz_round < level.round_number)
		{
            if ( isdefined( level.is_forever_solo_game ) && level.is_forever_solo_game )
                level.next_mechz_round = randomintrange( level.mechz_min_round_fq_solo, level.mechz_max_round_fq_solo );
            else
                level.next_mechz_round = randomintrange( level.mechz_min_round_fq, level.mechz_max_round_fq );
		}
        if ( isdefined( level.is_forever_solo_game ) && level.is_forever_solo_game )
		{
			if(level.next_mechz_round > (level.round_number + level.mechz_max_round_fq_solo))
			{
                level.next_mechz_round = randomintrange( level.mechz_min_round_fq_solo, level.mechz_max_round_fq_solo );
			}
		}
		else if(level.next_mechz_round > (level.round_number + level.mechz_max_round_fq))
		{
			if(level.next_mechz_round > (level.round_number + level.mechz_max_round_fq_solo))
			{
				level.players[0] IPrintLn("Fixing rounds, coop");
                level.next_mechz_round = randomintrange( level.mechz_min_round_fq, level.mechz_max_round_fq );
			}
		}
	}
}