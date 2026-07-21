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
	level thread watermark();
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

    while(true)
    {
		self strattesterprint("Welcome to Strat Tester!", "Bienvenido a Strat Tester!");
		self strattesterprint("Source: github.com/Fraaagaaa/Strat-Tester-BO2", "Fuente: github.com/Fraaagaaa/Strat-Tester-BO2");
		self.score = 1000000;
        self thread perk_apply_loop();
		self thread loadouts_init();
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