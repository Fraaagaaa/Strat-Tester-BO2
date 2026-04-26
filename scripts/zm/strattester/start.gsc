#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

#include scripts\zm\strattester\utility;

openAllDoors()
{
	if(!getDvarInt("st_doors"))
		return;
    setdvar( "zombie_unlock_all", 1 );
    players = get_players();
    zombie_doors = getentarray( "zombie_door", "targetname" );
    foreach(door in zombie_doors)
    {
		wait 0.1;
		if(istown() && !getDvarInt("st_jug_setup") && door.origin == (625, -1222, 166))
			continue;
		if(istown() && getDvarInt("st_jug_setup") && door.origin == (1045, -28, 28))
			continue;
		if(istown() && getDvarInt("st_jug_setup") && door.origin == (1113, 469, 8))
			continue;
		if(istranzit() && door.origin[0] > 7000 && door.origin[0] < 8400)
			continue;
		if(ismob())
		{
			if(door.origin == (-149, 8679, 1166))
				continue;
			if(door.origin == (2281, 9484, 1564))
				continue;
			if(door.origin == (1601, 9223, 1482))
				continue;
			if(door.origin == (2138, 9210, 1375))
				continue;
		}
		if(isburied())
			if(door.origin == (453, -1188, 100) || door.origin == (-384, -628, 52))
				continue;

        if ( is_true( door.power_door_ignore_flag_wait ) )
            door notify( "power_on" );
			
        door notify( "trigger", players[0] );

        wait 0.05;
    }

    zombie_debris = getentarray( "zombie_debris", "targetname" );

    for ( i = 0; i < zombie_debris.size; i++ )
    {
		if(isburied())
			if(zombie_debris[i].origin == (-435, 498, 478))
				continue;
        zombie_debris[i] notify( "trigger", players[0] );
        wait 0.05;
    }
}

set_starting_round()
{
	level.round_number = getDvarInt( "st_round" );
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

zombie_spawn_wait()
{
	setDvar("ai_disableSpawn", 1);

	wait getDvarInt("st_delay");

	setDvar("ai_disableSpawn", 0);
}

round_pause_st()
{   
	if(ismob())
	flag_wait( "afterlife_start_over" );

	level.countdown_hud = create_simple_hud();
	level.countdown_hud.fontscale = 24;
	level.countdown_hud setshader( "hud_chalk_1", 64, 64 );
	level.countdown_hud FadeOverTime( 2.0 );
	level.countdown_hud SetValue(getDvarInt("st_delay"));
	level.countdown_hud.color = ( 0.21, 0, 0 );
	level.countdown_hud.alpha = 1;
	level.countdown_hud.hidewheninmenu = 1;
	level.countdown_hud.alignx = "center";
	level.countdown_hud.aligny = "center";
	level.countdown_hud.horzalign = "user_center";
	level.countdown_hud.vertalign = "user_center";
	wait 2;
	level thread zombie_spawn_wait();

	for(delay = getDvarInt("st_delay"); delay > 0; delay--)
	{
		wait 1;
		level.countdown_hud SetValue(delay);
	}

	level.countdown_hud FadeOverTime( 1.0 );
	level.countdown_hud.color = (1,1,1);
	level.countdown_hud.alpha = 0;
	wait( 1.0 );
	
	foreach(player in level.players)
		player.round_timer settimerup(0);
	level.countdown_hud destroy_hud();
}

remove_boards_from_windows()
{
	if(getDvarInt("st_boards"))
		return;

	flag_wait( "initial_blackscreen_passed" );

	maps\mp\zombies\_zm_blockers::open_all_zbarriers();
}

turn_on_power()
{
	if(!getDvarInt("st_power"))
		return;

	flag_wait( "initial_blackscreen_passed" );
	wait 5;
	trig = getEnt( "use_elec_switch", "targetname" );
	powerSwitch = getEnt( "elec_switch", "targetname" );
	powerSwitch notSolid();
	trig setHintString( &"ZOMBIE_ELECTRIC_SWITCH" );
	trig setVisibleToAll();
	trig notify( "trigger", self );
	trig setInvisibleToAll();
	powerSwitch rotateRoll( -90, 0, 3 );
	level thread maps\mp\zombies\_zm_perks::perk_unpause_all_perks();
	powerSwitch waittill( "rotatedone" );
	flag_set( "power_on" );
	level setClientField( "zombie_power_on", 1 ); 
}
