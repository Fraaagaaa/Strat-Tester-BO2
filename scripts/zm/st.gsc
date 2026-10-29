#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\strattester\box;
#include scripts\zm\strattester\buildables;
#include scripts\zm\strattester\bus;
#include scripts\zm\strattester\commands;
#include scripts\zm\strattester\despawners;
#include scripts\zm\strattester\fixes;
#include scripts\zm\strattester\hud;
#include scripts\zm\strattester\menu; 
#include scripts\zm\strattester\perks;
#include scripts\zm\strattester\settings;
#include scripts\zm\strattester\start;
#include scripts\zm\strattester\timers;
#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\weapons;

main()
{
	replaceFunc(getfunction("maps/mp/zombies/_zm_spawner", "zombie_can_drop_powerups"), ::zombie_can_drop_powerups);
	replaceFunc(getfunction("maps/mp/zombies/_zm", "round_think"), ::round_think);
}

init()
{
	level.strat_tester = true;
	level thread enable_cheats();
	level thread init_box();
	level thread init_buildables();
	level thread init_despawners();
	level thread init_hud();
	level thread init_menu_system();
	level thread init_settings();
    level thread init_perks();
    level thread init_start();
	level thread readChat();
    level thread wait_for_players();
    level thread track_playinground();
	setDvar("player_reviveTriggerRadius", 64);
	setDvar("revive_trigger_radius", 75);
    
    if(!isDefined(level.total_chest_accessed))
        level.total_chest_accessed = 0;
	flag_wait("initial_blackscreen_passed");
	level thread openAllDoors();
    level thread round_pause_st();
}

wait_for_players()
{
    while(true)
    {
        level waittill("connected" , player);
        player thread connected_st();
    }
}

connected_st()
{
    self endon( "disconnect" );
	self waittill("spawned_player");

	self iprintln_loc("Welcome to Strat Tester!", "Bienvenido a Strat Tester!");
	self iprintln_loc("Source: github.com/Fraaagaaa/Strat-Tester-BO2", "Fuente: github.com/Fraaagaaa/Strat-Tester-BO2");
    while(true)
    {
		self.score = 1000000;
        self thread perk_apply_loop();
		self thread init_loadouts();
        self thread specialcommands();
		self waittill("spawned_player");
    }
}

enable_cheats()
{
    setDvar("sv_cheats", 1 );
	setdvar("cg_ufo_scaler", 6);

    if( level.player_out_of_playable_area_monitor && IsDefined( level.player_out_of_playable_area_monitor ) )
		self notify( "stop_player_out_of_playable_area_monitor" );
	level.player_out_of_playable_area_monitor = 0;
    level.player_too_many_players_check = 0;
}
round_think( restart )
{
    if ( !isdefined( restart ) )
        restart = 0;

    level endon( "end_round_think" );

    if ( !( isdefined( restart ) && restart ) )
    {
        if ( isdefined( level.initial_round_wait_func ) )
            [[ level.initial_round_wait_func ]]();

        if ( !( isdefined( level.host_ended_game ) && level.host_ended_game ) )
        {
            players = get_players();

            foreach ( player in players )
            {
                if ( !( isdefined( player.hostmigrationcontrolsfrozen ) && player.hostmigrationcontrolsfrozen ) )
                {
                    player freezecontrols( 0 );
                }

                player maps\mp\zombies\_zm_stats::set_global_stat( "rounds", level.round_number );
            }
        }
    }

    setroundsplayed( level.round_number );

    for (;;)
    {
        maxreward = 50 * level.round_number;

        if ( maxreward > 500 )
            maxreward = 500;

        level.zombie_vars["rebuild_barrier_cap_per_round"] = maxreward;
        level.pro_tips_start_time = gettime();
        level.zombie_last_run_time = gettime();

        if ( isdefined( level.zombie_round_change_custom ) )
            [[ level.zombie_round_change_custom ]]();
        else
        {
            level thread maps\mp\zombies\_zm_audio::change_zombie_music( "round_start" );
            round_one_up();
        }

        maps\mp\zombies\_zm_powerups::powerup_round_start();
        players = get_players();
        array_thread( players, maps\mp\zombies\_zm_blockers::rebuild_barrier_reward_reset );

        if ( !( isdefined( level.headshots_only ) && level.headshots_only ) && !restart )
            level thread award_grenades_for_survivors();

        bbprint( "zombie_rounds", "round %d player_count %d", level.round_number, players.size );
        level.round_start_time = gettime();

        while ( level.zombie_spawn_locations.size <= 0 )
            wait 0.1;

        level thread [[ level.round_spawn_func ]]();
        level notify( "start_of_round" );
        recordzombieroundstart();
        players = getplayers();

        for ( index = 0; index < players.size; index++ )
        {
            zonename = players[index] get_current_zone();

            if ( isdefined( zonename ) )
                players[index] recordzombiezone( "startingZone", zonename );
        }

        if ( isdefined( level.round_start_custom_func ) )
            [[ level.round_start_custom_func ]]();

        [[ level.round_wait_func ]]();
        level.first_round = 0;
        level notify( "end_of_round" );
        level thread maps\mp\zombies\_zm_audio::change_zombie_music( "round_end" );
        uploadstats();

        if ( isdefined( level.round_end_custom_logic ) )
            [[ level.round_end_custom_logic ]]();

        players = get_players();

        if ( isdefined( level.no_end_game_check ) && level.no_end_game_check )
        {
            level thread last_stand_revive();
            level thread spectators_respawn();
        }
        else if ( 1 != players.size )
            level thread spectators_respawn();

        players = get_players();
        array_thread( players, maps\mp\zombies\_zm_pers_upgrades_system::round_end );
        timer = level.zombie_vars["zombie_spawn_delay"];

        if ( timer > 0.08 )
            level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
        else if ( timer < 0.08 )
            level.zombie_vars["zombie_spawn_delay"] = 0.08;

        if ( level.gamedifficulty == 0 )
            level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier_easy"];
        else
            level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];

        level.round_number++;

        // if ( 255 < level.round_number )
        //     level.round_number = 255;

        setroundsplayed( level.round_number );
        matchutctime = getutc();
        players = get_players();

        foreach ( player in players )
        {
            if ( level.curr_gametype_affects_rank && level.round_number > 3 + level.start_round )
                player maps\mp\zombies\_zm_stats::add_client_stat( "weighted_rounds_played", level.round_number );

            player maps\mp\zombies\_zm_stats::set_global_stat( "rounds", level.round_number );
            player maps\mp\zombies\_zm_stats::update_playing_utc_time( matchutctime );
        }

        check_quickrevive_for_hotjoin();
        level round_over();
        level notify( "between_round_over" );
        restart = 0;
    }
}
