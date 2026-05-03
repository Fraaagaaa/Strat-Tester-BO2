#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\strattester\bus;
#include scripts\zm\strattester\fixes;
#include scripts\zm\strattester\commands;
#include scripts\zm\strattester\start;
#include scripts\zm\strattester\timers;
#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\hud;
#include scripts\zm\strattester\despawners;
#include scripts\zm\strattester\settings;
#include scripts\zm\strattester\perks;
#include scripts\zm\strattester\weapons;

#define VERSION "2.3.0"
main()
{
	replaceFunc(maps\mp\animscripts\zm_utility::wait_network_frame, ::base_game_network_frame);
	replaceFunc(maps\mp\zombies\_zm_utility::wait_network_frame, ::base_game_network_frame);
}

init()
{
	level.strat_tester = true;
	level thread enable_cheats();
	level thread settings_init();
	level thread despawners_init();
    level thread start_init();
	level thread readChat();
    level thread wait_for_players();
	level thread watermark();
    
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
		if(!isdefined(self.has_hud))
		{
			self iprintln("^6Strat Tester " + VERSION + " by BoneCrusher");
			if(self == level.players[0]) self strattesterprint("Source: github.com/Fraaagaaa/Strat-Tester-BO2", "Fuente: github.com/Fraaagaaa/Strat-Tester-BO2");
			self thread health_bar_hud();
			self thread zone_hud();
			self thread zombies_remaining();
			self thread st_sph();
            if(istranzit())
            {
			    self thread denizens_alive();
                self thread busloc();
            }
			if(!isdefined(self.has_hud))
				self.has_hud = true;
		}
		self.score = 1000000;
        self thread perk_init();
		self thread loadouts_init();
	    self thread timer();
	    self thread timerlocation();
	    self thread trap_timer();
        self thread specialcommands();
		self thread setPerkDvars();
        wait 0.05;
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

tpcase(player, location)
{
	if(istranzit())
		switch(location)
		{
			case "farm": pos = (6908, -5750, -62); ang = (0, 173, 0); break;
			case "town": pos = (1152, -717, -55); ang = (0, 45, 0); break;
			case "depot": pos = (-7384, 4693, -63); ang = (0, 18, 0); break;
			case "tunel": pos = (-11814, -1903, 228); ang = (0, -60, 0); break;
			case "diner": pos = (-5012, -6694, -60); ang = (0, -127, 0); break;
			case "nacht": pos = (13840, -261, -188); ang = (0, -108, 0); break;
			case "power": pos = (12195, 8266, -751); ang = (0, -90, 0); break;
			case "ak": pos = (11200, 7745, -564); ang = (0, -108, 0); break;
			case "ware": pos = (10600, 8272, -400); ang = (0, -108, 0); break;
			case "bus": pos = level.the_bus.origin; ang = level.the_bus.angles; break;
			default: return;
		}
	if(ismob())
		switch(location)
		{
			case "cafe": pos = (3309, 9329, 1336); ang = (0, 131, 0); break;
			case "cage": pos = (-1771, 5401, -71); ang = (0, 0, 0); break;
			case "fans": pos = (-1042, 9489, 1350); ang = (0, -43, 0); break;
			case "dt":   pos = (25, 8762, 1128); ang = (0, 0, 0); break;
			default: return;
		}
	if(isdierise())
		switch(location)
		{
			case "shaft": pos = (3805, 1920, 2197); ang = (0, -161, 0); break;
			case "tramp": pos = (2159, 1161, 3070); ang = (0, 135, 0); break;
			case "trample": pos = (2159, 1161, 3070); ang = (0, 135, 0); break;
			default: return;
		}
	if(isburied())
		switch(location)
		{
			case "saloon": pos = (553, -1214, 56); ang = (0, -50, 0); break;
			case "jug": pos = (-660, 1030, 8); ang = (0, -90, 0); break;
			case "tunel": pos = (-483, 293, 423); ang = (0, -40, 0); break;
			default: return;
		}
	if(isorigins())
		switch(location)
		{
			case "church": pos = (1878, -1358, 150); ang = (0, 140, 0); break;
			case "tcp": pos = (10335, -7902, -411); ang = (0, 140, 0); break;
			case "gen1": pos = (2340, 4978, -303); ang = (0, -132, 0); break;
			case "gen2": pos = (469, 4788, -285); ang = (0, -134, 0); break;
			case "gen3": pos = (740, 2123, -125); ang = (0, 135, 0); break;
			case "gen4": pos = (2337, -170, 140); ang = (0, 90, 0); break;
			case "gen5": pos = (-2830, -21, 238); ang = (0, 40, 0); break;
			case "gen6": pos = (732, -3923, 300); ang = (0, 50, 0); break;
			case "tank": pos = level.vh_tank.origin + (0, 0, 50); ang = level.vh_tank.angles; break;
			default: return;
		}

	strattesterprint("Teleporting " + player.name + " to " + location, "Teletransportando " + player.name + " a " + location);
    player setOrigin(pos);
    player setPlayerAngles(ang);
}

watermark()
{
	level.watermark.hidewheninmenu = true;
    level.watermark = createserverfontstring( "objective", 1.4 );
    level.watermark.alignx = "center";
    level.watermark.horzalign = "user_center";
    level.watermark.vertalign = "user_top";
    level.watermark.aligny = "top";
    level.watermark.alignx = "center";
    level.watermark.horzalign = "user_center";
    level.watermark.label = &"START TESTER 2.3";
    level.watermark.alpha = 0.2;

    r = 1;
    g = 0;
    b = 0;
    step = 0.02;

    while ( true )
    {
        for ( g = 0; g < 1; g += step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
        for ( r = 1; r > 0; r -= step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
        for ( b = 0; b < 1; b += step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
        for ( g = 1; g > 0; g -= step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
        for ( r = 0; r < 1; r += step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
        for ( b = 1; b > 0; b -= step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
    }
}